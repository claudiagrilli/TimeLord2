//
//  Timesheet.swift
//  Time Lord 2
//
//  Created by Claudia Grilli on 23/01/15.
//  Copyright (c) 2015 Claudia Grilli. All rights reserved.
//

import Foundation
import Realm

class TimeTrack: RLMObject {
    dynamic var startDate = NSDate()
    dynamic var endDate : NSDate?
    var tasks: [Task] {
        return linkingObjectsOfClass("Task", forProperty: "timesheets") as! [Task]
    }
    
//    class func addTimeTrack(task:Task) {
//        RealmManager.updateObject({
//            var timeObject = TimeTrack()
//            timeObject.startDate = NSDate()
//            task.timesheet.addObject(timeObject)
//        })
//    }
    class func timeTrackStartingNow() -> TimeTrack {
        var timeObject = TimeTrack()
        timeObject.startDate = NSDate()
        return timeObject
    }
}