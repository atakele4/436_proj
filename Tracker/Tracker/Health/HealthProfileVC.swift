//
//  HealthProfileVC.swift
//  Tracker
//
//  Created by Rushad Antia on 4/18/19.
//  Copyright © 2019 Harshil Patel. All rights reserved.
//

import Foundation
import UIKit

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
    
}
