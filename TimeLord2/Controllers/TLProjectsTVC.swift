//
//  TLProjectsTVC.swift
//  TimeLord2
//
//  Created by Claudia Grilli on 17/03/15.
//  Copyright (c) 2015 Claudia Grilli. All rights reserved.
//

import Foundation

import UIKit
import Realm

class TLProjectsTVC: UITableViewController {
    
    @IBOutlet weak var addProject: UIBarButtonItem!
    
    var currentClient: Client!
    
    lazy var projects : RLMArray = {
        return self.refreshProjects()
        }()
    
    lazy var dataSource : RealmArrayDataSource = {
        
        return RealmArrayDataSource(dataSource: self.projects, configureCell: { (objectFromRow,indexPath) -> UITableViewCell in
            
            let cell = self.tableView.dequeueReusableCellWithIdentifier("projectCellID", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = (objectFromRow as Project).title
            
            return cell
        })
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self.dataSource
        
        if(self.projects.count == 0){
            self.doAddProject(self.addProject)
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("goToTasks", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="goToTasks" {
            if let selectedPath = self.tableView.indexPathForSelectedRow() {
                let currentProject = self.projects.objectAtIndex(UInt(selectedPath.row)) as Project
                var tasksTVC = segue.destinationViewController as TLTasksTVC
                tasksTVC.currentProject = currentProject
            }
        }
    }

    func refreshProjects()-> RLMArray{
        let clients = Client.objectsWhere("name = %@", currentClient.name)
        let client = clients.firstObject() as Client
        return client.projects
        
    }

    func refresh(){
        self.projects = self.refreshProjects()
        self.tableView.reloadData()
    }
    
    // MARK: - Add project
    // TO DO: Substitute alert with a nicer form
    @IBAction func doAddProject(sender: UIBarButtonItem) {
        // Initialize all the strings
        let alertTitle = NSLocalizedString("Add project",comment:"Title in add project alert")
        let alertMessage = NSLocalizedString("Insert a new project",comment:"Message in add project alert")
        let cancelTitle = NSLocalizedString("Cancel",comment:"Cancel in add project alert")
        let addTitle = NSLocalizedString("Add",comment:"Add in add project alert")
        
        // Instantiate UIAlertController
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle:.Alert)
        
        // Create action
        let cancelAction = UIAlertAction(title:cancelTitle, style: .Cancel) {(_) in}
        let addAction = UIAlertAction(title: addTitle, style: .Default) { (action) -> Void in
            let projectTitle = alertController.textFields![0] as UITextField
            let projectDescription = alertController.textFields![1] as UITextField
            Project.addProject(projectTitle.text, fullDescription: projectDescription.text, client: self.currentClient)
            
            self.refresh()
        }
        
        // Add action is enabled only if textField is not empty
        addAction.enabled = false
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = NSLocalizedString("Project title",comment:"Project title placeholder in add project alert")
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                addAction.enabled = textField.text != ""
            }
            
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = NSLocalizedString("Project description",comment:"Project description placeholder in add project alert")
        }
        // Add actions
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        // Show alertController
        self.presentViewController(alertController, animated: true, completion:  {(_) in})
        
    }
}
