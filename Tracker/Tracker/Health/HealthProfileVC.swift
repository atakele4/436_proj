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
    
    @IBOutlet weak var hkBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
        HealthKitSetupManager.authorizeHealthKit { (authorized, error) in
            if authorized {
                DispatchQueue.main.async {
                    self.hkBTN.setTitle("HealthKit Authorized", for: .normal)
                    self.hkBTN.isEnabled = false
                }
                
            }else {
                DispatchQueue.main.async {
                    self.hkBTN.setTitle("HealthKit Unauthorized Enable in Settings", for: .normal)
                    self.hkBTN.layer.borderColor = UIColor.red.cgColor
                    self.hkBTN.layer.borderWidth = 3
                    self.hkBTN.layer.cornerRadius = 3
                    self.hkBTN.isEnabled = false
                }
            }
        }
    }
    
    func setupScreen(){
        //sets what the backbutton does
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "<- Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(HealthProfileVC.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        nameTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        let un = UserDefaults.standard.string(forKey: "healthUserName")
        
        if un != nil || un != "" {
            nameTF.text = un
        }
        
        hkBTN.layer.borderColor = UIColor.blue.cgColor
        hkBTN.layer.borderWidth = 3
        hkBTN.layer.cornerRadius = 3
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboardByTappingOutside))
        
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func hideKeyboardByTappingOutside() {
        if nameTF.text != nil && nameTF.text != "" {
            goodTF()
        } else {
            errorTF()
        }
        
        resignFirstResponder()
    }
    
    @objc func textFieldDidChange(){
        goodTF()
    }
    
    //checks the fields
    @objc func back(sender: UIBarButtonItem) {
        if nameTF.text != nil && nameTF.text != "" {
            UserDefaults.standard.set(nameTF.text , forKey: "healthUserName")
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
        nameTF.layer.borderWidth = 3
        nameTF.layer.cornerRadius = 3
        nameTF.placeholder = "THIS FIELD IS REQUIRED"
    }
    
}
