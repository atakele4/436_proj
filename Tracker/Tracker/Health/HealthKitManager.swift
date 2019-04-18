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
        
        
        guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
            let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
            let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
            let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
            let height = HKObjectType.quantityType(forIdentifier: .height),
            let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
                
                completion(false, HealthkitSetupError.dataTypeNotAvailable)
                return
        }
        
        
        let hkTypesToWrite: Set<HKSampleType> = [bodyMassIndex, activeEnergy, HKObjectType.workoutType()]
        
        let hkTypeToRead: Set<HKObjectType> = [dateOfBirth, bloodType, biologicalSex, bodyMassIndex, height, bodyMass, HKObjectType.workoutType()]
        
        HKHealthStore().requestAuthorization(toShare: hkTypesToWrite, read: hkTypeToRead, completion: {(success, error) in completion(success, error)})
    }

    
}
