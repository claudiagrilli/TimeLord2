//
//  TimeManager.swift
//  TimeLord2
//
//  Created by Claudia Grilli on 03/04/15.
//  Copyright (c) 2015 Claudia Grilli. All rights reserved.
//

import Foundation

// TODO: TBD if singleton
private let _privateSharedInstance = TimeManager()
class TimeManager: NSObject {
    class var sharedInstance : TimeManager{
        return _privateSharedInstance
    }
    
    lazy var activeTasks : [Task] = {
       return [Task]()
    }()
    
    func startTask(task: Task){
        //Update task status
        RealmManager.updateObject({
            task.isRunning = true
        })
        //Add task to active tasks
        self.activeTasks.append(task)
        //Add timeTrack with current date
        task.addTimeTrack()
    }
    
    func stopTask(task: Task){
        
    }

    func timerTicked(){
        
    }
}