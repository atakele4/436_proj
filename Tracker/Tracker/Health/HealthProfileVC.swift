//
//  HealthProfileVC.swift
//  Tracker
//
//  Created by Rushad Antia on 4/18/19.
//  Copyright © 2019 Harshil Patel. All rights reserved.
//

import Foundation
import UIKit
import Charts
import HealthKit

class HealthProfileVC: UIViewController {
    
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var stepGoalTF: UITextField!
    
    @IBOutlet weak var hkBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup the UI elements
        setupScreen()
        
        //auth the hk
        HealthKitSetupManager.authorizeHealthKit { (authorized, error) in
            
            if authorized {
                DispatchQueue.main.async {
                    self.hkBTN.setTitle("HealthKit Authorized", for: .normal)
                    self.hkBTN.isEnabled = false
                    self.hkBTN.layer.borderColor = UIColor.blue.cgColor
                    self.hkBTN.layer.borderWidth = 1
                    self.hkBTN.layer.cornerRadius = 3
                    
                    
                }
                
            }
            else {
                DispatchQueue.main.async {
                    self.hkBTN.setTitle("Enable in Health App", for: .normal)
                    self.hkBTN.layer.borderColor = UIColor.red.cgColor
                    self.hkBTN.layer.borderWidth = 2
                    self.hkBTN.layer.cornerRadius = 3
                }
            }
        }
        
    }
    
    func setupScreen(){
        //sets what the backbutton does
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "<- Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(HealthProfileVC.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        //add an observer for the tf change
        nameTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        if let un = UserDefaults.standard.string(forKey: "healthUserName"){
            nameTF.text = un
            goodTF()
        }
        
        if let stepsGoal = UserDefaults.standard.string(forKey: "healthStepGoal"){
            stepGoalTF.text = stepsGoal
        }
        
        //setup a tap recognizer to resign first responder
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardByTappingOutside))
        
        self.view.addGestureRecognizer(tap)
        
    }
    
    //resign first responder and change the color of it
    @objc func hideKeyboardByTappingOutside() {
        print("BRO YOU TAPPED?")
        if nameTF.text != nil && nameTF.text != "" {
            goodTF()
        } else {
            errorTF()
        }
       
        resignFirstResponder()
        self.view.endEditing(true)
    }
    
    //#selector func for tf change
    @objc func textFieldDidChange(){
        goodTF()
    }
    
    //checks the fields
    @objc func back(sender: UIBarButtonItem) {
        if nameTF.text != nil && nameTF.text != "" {
            UserDefaults.standard.set(nameTF.text , forKey: "healthUserName")
            
            if stepGoalTF.text != nil && stepGoalTF.text != "" {
                UserDefaults.standard.set(stepGoalTF.text , forKey: "healthStepGoal")
            }
            
            self.navigationController?.popViewController(animated: true)
        }else{
            errorTF()
        }
    }
    
    //makes a nice blue border around the textfield
    func goodTF(){
        nameTF.layer.borderColor = UIColor.blue.cgColor
        nameTF.layer.borderWidth = 1
        nameTF.layer.cornerRadius = 3
    }
    
    //makes a red border around the textfield
    func errorTF (){
        nameTF.layer.borderColor = UIColor.red.cgColor
        nameTF.layer.borderWidth = 2
        nameTF.layer.cornerRadius = 3
        nameTF.placeholder = "THIS FIELD IS REQUIRED"
    }
    
    class func importStepsHistoryOneWeek() {
        let healthStore = HKHealthStore()
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        
        var interval = DateComponents()
        interval.day = 1
        
        var anchorComponents = Calendar.current.dateComponents([.day, .month, .year], from: now)
        anchorComponents.hour = 0
        let anchorDate = Calendar.current.date(from: anchorComponents)!
        
        let query = HKStatisticsCollectionQuery(quantityType: stepsQuantityType,
                                                quantitySamplePredicate: nil,
                                                options: [.cumulativeSum],
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        query.initialResultsHandler = { _, results, error in
            guard let results = results else {
                print("ERROR")
                return
            }
            
            results.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                if let sum = statistics.sumQuantity() {
                    let steps = sum.doubleValue(for: HKUnit.count())
                    print("Amount of steps: \(steps), date: \(statistics.startDate)")
                }
            }
        }
        
        healthStore.execute(query)
    }
}
