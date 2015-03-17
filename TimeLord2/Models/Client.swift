//
//  Customer.swift
//  Time Lord 2
//
//  Created by Claudia Grilli on 23/01/15.
//  Copyright (c) 2015 Claudia Grilli. All rights reserved.
//

import Foundation
import Realm

class Client: RLMObject {
    dynamic var name = ""
    dynamic var projects = RLMArray(objectClassName: Project.className())
    
}

