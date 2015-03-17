import Foundation
import UIKit
import Realm

// Implementation of an ArrayDataSource in swift.
// Modified from http://www.objc.io/issue-1/lighter-view-controllers.html.

class RealmArrayDataSource: NSObject, UITableViewDataSource {
    
    let dataSource: RLMResults
    let configureCell: (objectFromRow: RLMObject,indexPath:NSIndexPath) -> UITableViewCell
    
    init(dataSource: RLMResults, configureCell: (objectFromRow: RLMObject,indexPath:NSIndexPath) -> UITableViewCell) {
        self.dataSource = dataSource
        self.configureCell = configureCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(dataSource.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let objectFromRow = dataSource[UInt(indexPath.row)] as RLMObject
        return configureCell(objectFromRow: objectFromRow, indexPath: indexPath)
    }
}