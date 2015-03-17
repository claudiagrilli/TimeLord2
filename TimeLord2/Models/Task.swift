//
//  Task.swift
//  Time Lord 2
//
//  Created by Claudia Grilli on 23/01/15.
//  Copyright (c) 2015 Claudia Grilli. All rights reserved.
//

import Foundation
import Realm

class Task: RLMObject {
    dynamic var title = ""
    dynamic var fullDescription = ""
    dynamic var stopAction = 0
    dynamic var project : Project?
    dynamic var timesheet = RLMArray(objectClassName: TimeTrack.className())
}

