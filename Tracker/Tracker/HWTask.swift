//
//  HWTask.swift
//  Tracker
//
//  Created by Harshil Patel on 4/20/19.
//  Copyright © 2019 Harshil Patel. All rights reserved.
//

import Foundation

class HWTask {
    
    var taskName : String
    var isDone : Bool
    
    init(name: String, isDone: Bool){
        self.taskName = name
        self.isDone = false
    }
}
