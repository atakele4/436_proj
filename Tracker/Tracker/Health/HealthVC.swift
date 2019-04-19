//
//  Health.swift
//  Tracker
//
//  Created by Rushad Antia on 4/12/19.
//  Copyright © 2019 Harshil Patel. All rights reserved.
//
import UIKit
import Foundation
import HealthKit

class HealthVC: UIViewController {
    
    @IBOutlet weak var titleBar: UINavigationItem!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var stepGoalLabel: UILabel!
    @IBOutlet weak var stepPBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    func loadData(){
        
        let firstTime = UserDefaults.standard.bool(forKey: "firstTime")
        
        //if its the firsttime setup
        if !firstTime {
            performSegue(withIdentifier: "profileSegID", sender: nil)
            UserDefaults.standard.set(true, forKey: "firstTime")
        }
        
        let userName = UserDefaults.standard.string(forKey: "healthUserName")
        
        titleBar.title = (userName == nil ? "Setup your user profile ->" : userName)
        
        welcomeLabel.text = (userName == nil ? "  Welcome!" : " Welcome \(userName!)!")
        
        do {
            let userAgeSexAndBloodType = try HKDataManager.getAgeSexBloodType()
         
            switch userAgeSexAndBloodType.bioSex {
            case .female: self.profileButton.title = "👩🏻"
            case .male: self.profileButton.title = "👨🏼"
            default: self.profileButton.title = "Edit"
                
            }
            
        } catch let error {
            print("err: \(error.localizedDescription)")
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    
}
