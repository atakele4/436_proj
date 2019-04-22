//
//  HWData.swift
//  Tracker
//
//  Created by Harshil Patel on 4/20/19.
//  Copyright © 2019 Harshil Patel. All rights reserved.
//

import Foundation

class HWData {
    
    var tasks = [[HWTask](), [HWTask]()]
    
    // add tasks
    func add(_ task: HWTask, at index: Int, isDone:Bool = false){
        
        
        let section = isDone ? 1 : 0
        
        tasks[section].insert(task, at: index)
    }
    
    //remove tasks
    
    func remove(at index: Int, isDone:Bool = false)-> HWTask{
        
        
        let section = isDone ? 1 : 0
        
        return tasks[section].remove(at: index)
    }
    
}
