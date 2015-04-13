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
    var clients: [Client] {
        return linkingObjectsOfClass("Client", forProperty: "projects") as [Client]
    }
    dynamic var tasks = RLMArray(objectClassName: Task.className())
    
    class func addProject(title:String, fullDescription:String, client:Client){
        var projectObject = Project()
        projectObject.title = title
        projectObject.fullDescription = fullDescription
        RealmManager.updateObject({
            client.projects.addObject(projectObject)
        })
    }
}

