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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
// Using generic dataSource rowActions don't work!!
//self.tableView.dataSource = self.dataSource
        
        if(self.tasks.count == 0){
            self.doAddTask(self.addTask)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.tasks.count)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "taskCellID"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell
        let task : Task = self.tasks[UInt(indexPath.row)] as! Task
            
        cell.textLabel?.text = task.title
        
        return cell
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
        let project = projects.firstObject() as! Project
        return project.tasks
        
    }
    func refresh(){
        self.tasks = self.refreshTasks()
        self.tableView.reloadData()
    }
    
    // MARK: - Add task
    // TO DO: Substitute alert with a nicer form
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
            let taskTitle = alertController.textFields![0] as! UITextField
            let taskDescription = alertController.textFields![1] as! UITextField

            Task.addTask(taskTitle.text, fullDescription: taskDescription.text, project: self.currentProject)
            
            self.refresh()
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
    
    //MARK: ROW ACTIONS
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        // Execute/Stop task or mark as favourite to show inside the main tab
        let task : Task = self.tasks.objectAtIndex(UInt(indexPath.row)) as! Task
        let execAction = execActionForTask(task)
        let favouriteAction = favouriteActionForTask(task)
        let editAction = editActionForTask(task)
        
        return [execAction,favouriteAction,editAction]
    }
    // Start and stop row action
    func execActionForTask(task : Task) -> UITableViewRowAction {
        let execActionTitle = task.isRunning ? NSLocalizedString("Stop", comment: "Stop action in swipe cell") : NSLocalizedString("Start", comment: "Start action in swipe cell")
        
        var execAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: execActionTitle) { (action, indexPath) -> Void in
            if(task.isRunning){
                task.stop()
            }else{
                task.start()
            }
        }
        // TODO: Select colors for start and stop
        execAction.backgroundColor = task.isRunning ? UIColor.redColor() : UIColor.greenColor()
        
        return execAction;
    }
    //Favourite row action
    func favouriteActionForTask(task : Task) -> UITableViewRowAction {
        let favActionTitle = task.isFavourite ? NSLocalizedString("Hide", comment: "Don't show this task in the main page") : NSLocalizedString("Show", comment: "Show this task in the main page")
        
        var favAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: favActionTitle) { (action, indexPath) -> Void in
            RealmManager.updateObject({
                task.isFavourite = !task.isFavourite
            })
        }
        // TODO: Select colors for favourite/not
        favAction.backgroundColor = task.isFavourite ? UIColor.darkGrayColor() : UIColor.lightGrayColor()
        
        return favAction;
    }
    
    //Edit row action
    func editActionForTask(task : Task) -> UITableViewRowAction{
        let editActionTitle = NSLocalizedString("Edit",comment:"Edit action")
        var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: editActionTitle) { (action, indexPath) -> Void in
            //Edit
        }
        // TODO: Select color for editing
        editAction.backgroundColor = UIColor.cyanColor()
        return editAction
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //needed for rowactions
    }


}
