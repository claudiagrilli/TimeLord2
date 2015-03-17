//
//  Project.swift
//  Time Lord 2
//
//  Created by Claudia Grilli on 23/01/15.
//  Copyright (c) 2015 Claudia Grilli. All rights reserved.
//

import Foundation
import Realm

class Project: RLMObject {
    dynamic var title = ""
    dynamic var fullDescription = ""
    dynamic var client : Client?
    dynamic var tasks = RLMArray(objectClassName: Task.className())
}