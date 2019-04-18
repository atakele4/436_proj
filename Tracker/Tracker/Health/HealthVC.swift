//
//  Health.swift
//  Tracker
//
//  Created by Rushad Antia on 4/12/19.
//  Copyright © 2019 Harshil Patel. All rights reserved.
//
import UIKit
import Foundation

class HealthVC: UIViewController {

    @IBOutlet weak var label: UILabel!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HealthKitSetupManager.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                
                if let err = error {
                    print("\(err.localizedDescription)")
                }
                return
            }
            
            print("HK Successfully Auth")
        }
        
    }
  
}
