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
        return Client.allObjects()
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




    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Add client
    @IBAction func doAddClient(sender: UIBarButtonItem) {
        // Initialize all the strings
        let alertTitle = NSLocalizedString("Add client",comment:"Title in add client alert")
        let alertMessage = NSLocalizedString("Insert a new client",comment:"Message in add client alert")
        let cancelTitle = NSLocalizedString("Cancel action",comment:"Cancel in add client alert")
        let addTitle = NSLocalizedString("Add action",comment:"Add in add client alert")
        
        // Instantiate UIAlertController
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle:.Alert)
        
        // Create action
        let cancelAction = UIAlertAction(title:cancelTitle, style: .Cancel) {(_) in}
        let addAction = UIAlertAction(title: addTitle, style: .Default) { (action) -> Void in
            let clientName = alertController.textFields![0] as UITextField
            var clientObject = Client()
            clientObject.name = clientName.text
            RealmManager.addObject(clientObject)

        }
        
        // Add action is enabled only if textField is not empty
        addAction.enabled = false
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = NSLocalizedString("Client add placeholder",comment:"Client placeholder in add client alert")
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
