//
//  HealthKitSetup.swift
//  Tracker
//
//  Created by Rushad Antia on 4/16/19.
//  Copyright © 2019 Harshil Patel. All rights reserved.
//

import Foundation
import HealthKit


//HK setup found at https://www.raywenderlich.com/459-healthkit-tutorial-with-swift-getting-started
class HealthKitSetupManager{
    
    private enum HealthkitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthkitSetupError.notAvailableOnDevice)
            return
        }
        
        guard let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let stepsCount = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
            else {
                
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
        }
        
        let hkTypesToWrite: Set<HKSampleType> = []
        
        let hkTypeToRead: Set<HKObjectType> = [bloodType, biologicalSex, height, bodyMass, HKObjectType.workoutType(), stepsCount]
        
        HKHealthStore().requestAuthorization(toShare: hkTypesToWrite, read: hkTypeToRead, completion: {(success, error) in completion(success, error)})
    }
    
    
}
