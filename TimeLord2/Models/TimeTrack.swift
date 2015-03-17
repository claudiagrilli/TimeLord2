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
    dynamic var task : Task?
}