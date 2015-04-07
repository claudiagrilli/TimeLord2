//
//  TLTasksTVC.swift
//  TimeLord2
//
//  Created by Claudia Grilli on 02/04/15.
//  Copyright (c) 2015 Claudia Grilli. All rights reserved.
//

import Foundation

import UIKit
import Realm

class TLTasksTVC: UITableViewController {
    
    @IBOutlet weak var addTask: UIBarButtonItem!
    
    var currentProject: Project!
    
    lazy var tasks : RLMArray = {
        return self.refreshTasks()
        }()
    
    lazy var dataSource : RealmArrayDataSource = {
        
        return RealmArrayDataSource(dataSource: self.tasks, configureCell: { (objectFromRow,indexPath) -> UITableViewCell in
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier("taskCellID", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = (objectFromRow as Task).title
            
            return cell
        })
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self.dataSource
        
        if(self.tasks.count == 0){
            self.doAddTask(self.addTask)
        }
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    func refreshTasks()-> RLMArray{
        let projects = Project.objectsWhere("title = %@", currentProject.title)
        let project = projects.firstObject() as Project
        return project.tasks
        
    }
    
    // MARK: - Add task
    @IBAction func doAddTask(sender: UIBarButtonItem) {
        // Initialize all the strings
        let alertTitle = NSLocalizedString("Add task",comment:"Title in add task alert")
        let alertMessage = NSLocalizedString("Insert a new task",comment:"Message in add task alert")
        let cancelTitle = NSLocalizedString("Cancel",comment:"Cancel in add task alert")
        let addTitle = NSLocalizedString("Add",comment:"Add in add task alert")
        
        // Instantiate UIAlertController
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle:.Alert)
        
        // Create action
        let cancelAction = UIAlertAction(title:cancelTitle, style: .Cancel) {(_) in}
        let addAction = UIAlertAction(title: addTitle, style: .Default) { (action) -> Void in
            let taskTitle = alertController.textFields![0] as UITextField
            let taskDescription = alertController.textFields![1] as UITextField
            //TODO: Extract task object creation
            var taskObject = Task()
            taskObject.title = taskTitle.text
            taskObject.fullDescription = taskDescription.text
            
            RLMRealm.defaultRealm().beginWriteTransaction()
            self.currentProject.tasks.addObject(taskObject)
            RLMRealm.defaultRealm().commitWriteTransaction()
            
            self.tasks = self.refreshTasks()
            self.tableView.reloadData()
        }
        
        // Add action is enabled only if textField is not empty
        addAction.enabled = false
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = NSLocalizedString("Task title",comment:"Task title placeholder in add project alert")
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                addAction.enabled = textField.text != ""
            }
            
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = NSLocalizedString("Task description",comment:"Task description placeholder in add project alert")
        }
        // Add actions
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        // Show alertController
        self.presentViewController(alertController, animated: true, completion:  {(_) in})
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {

        let task : Task = self.tasks.objectAtIndex(UInt(indexPath.row)) as Task
        let execAction = execActionForTask(task)
        let favouriteAction = favouriteActionForTask(task)
        
        return [execAction,favouriteAction]
    }
    
    func execActionForTask(task : Task) -> UITableViewRowAction {
        let execActionTitle = task.isRunning ? NSLocalizedString("Stop", comment: "Stop action in swipe cell") : NSLocalizedString("Start", comment: "Start action in swipe cell")
        
        var execAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: execActionTitle) { (action, indexPath) -> Void in
            if(task.isRunning){
                TimeManager.sharedInstance.stopTask(task)
            }else{
                TimeManager.sharedInstance.startTask(task)
            }
        }
        execAction.backgroundColor = task.isRunning ? UIColor.redColor() : UIColor.greenColor()
        
        return execAction;
    }
    func favouriteActionForTask(task : Task) -> UITableViewRowAction {
        let favActionTitle = task.isFavourite ? NSLocalizedString("Hide", comment: "Don't show this task in the main page") : NSLocalizedString("Show", comment: "Show this task in the main page")
        
        var favAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: favActionTitle) { (action, indexPath) -> Void in
            RealmManager.updateObject({
                task.isFavourite = !task.isFavourite
            })
        }
        favAction.backgroundColor = task.isFavourite ? UIColor.orangeColor() : UIColor.yellowColor()
        
        return favAction;
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //neede for rowactions
    }

    
}
