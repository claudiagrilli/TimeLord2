//
//  TLClientsTVC.swift
//  TimeLord2
//
//  Created by Claudia Grilli on 23/01/15.
//  Copyright (c) 2015 Claudia Grilli. All rights reserved.
//

import UIKit
import Realm

class TLClientsTVC: UITableViewController {
    
    @IBOutlet weak var addClient: UIBarButtonItem!

    lazy var clients : RLMResults = {
        return self.refreshClients()
    }()
    
    lazy var dataSource : RealmArrayDataSource = {
        
        return RealmArrayDataSource(dataSource: self.clients, configureCell: { (objectFromRow,indexPath) -> UITableViewCell in
        
            let cell = self.tableView.dequeueReusableCellWithIdentifier("clientCellID", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = (objectFromRow as Client).name
        
            return cell
        })
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self.dataSource
        
        if(self.clients.count == 0){
            self.doAddClient(self.addClient)
        }
    }



    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("goToProjects", sender: self)
    }
    


    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier=="goToProjects" {
            if let selectedPath = self.tableView.indexPathForSelectedRow() {
                let currentClient = self.clients.objectAtIndex(UInt(selectedPath.row)) as Client
                var projectsTVC = segue.destinationViewController as TLProjectsTVC
                projectsTVC.currentClient = currentClient
            }
        }
    }
    
    
    func refreshClients()-> RLMResults{
        return Client.allObjects()
    }
    
    func refresh(){
        self.clients = refreshClients()
        self.tableView.reloadData()
    }
    
    // MARK: - Add client
    @IBAction func doAddClient(sender: UIBarButtonItem) {
        // Initialize all the strings
        let alertTitle = NSLocalizedString("Add client",comment:"Title in add client alert")
        let alertMessage = NSLocalizedString("Insert a new client",comment:"Message in add client alert")
        let cancelTitle = NSLocalizedString("Cancel",comment:"Cancel in add client alert")
        let addTitle = NSLocalizedString("Add",comment:"Add in add client alert")
        
        // Instantiate UIAlertController
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle:.Alert)
        
        // Create action
        let cancelAction = UIAlertAction(title:cancelTitle, style: .Cancel) {(_) in}
        let addAction = UIAlertAction(title: addTitle, style: .Default) { (action) -> Void in
            let clientName = alertController.textFields![0] as UITextField

            Client.addClientWithName(clientName.text)
            
            self.refresh()
        }
        
        // Add action is enabled only if textField is not empty
        addAction.enabled = false
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = NSLocalizedString("Client name",comment:"Client placeholder in add client alert")
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                addAction.enabled = textField.text != ""
            }
            
        }
        
        // Add actions
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        // Show alertController
        self.presentViewController(alertController, animated: true, completion:  {(_) in})
        
    }
}
