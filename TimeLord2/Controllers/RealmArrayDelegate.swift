//
//  RealmArrayDelegate.swift
//  TimeLord2
//
//  Created by Claudia Grilli on 21/04/15.
//  Copyright (c) 2015 Claudia Grilli. All rights reserved.
//

import Foundation
import UIKit
import Realm

class RealmArrayDelegate: NSObject, UITableViewDelegate {
    
    let dataSource: RLMCollection
    let configureRowActions: (objectFromRow: RLMObject,indexPath:NSIndexPath) -> [UITableViewRowAction]

    
    init(dataSource: RLMCollection, configureRowActions: (objectFromRow: RLMObject,indexPath:NSIndexPath) -> [UITableViewRowAction]) {
        self.dataSource = dataSource
        self.configureRowActions = configureRowActions
    }
    
    
    //MARK: ROW ACTIONS
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let objectFromRow = dataSource[UInt(indexPath.row)] as! RLMObject
        return self.configureRowActions(objectFromRow: objectFromRow, indexPath: indexPath)
    }
    
}