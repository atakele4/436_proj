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
import Charts

class HealthVC: UIViewController {
    
    @IBOutlet weak var titleBar: UINavigationItem!
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var stepGoalLabel: UILabel!
    @IBOutlet weak var sleepGoalLabel: UILabel!
    @IBOutlet weak var stepPBar: UIProgressView!
    @IBOutlet weak var barChartView: BarChartView!
    
    private var stepGoal = 1
    private var bcDataEntry: [BarChartDataEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load data upn loading the view
        loadData()
    }
    
    func loadData(){
        print("Loading Data: \(Date())")
        let firstTime = UserDefaults.standard.bool(forKey: "firstTime")
        
        //if its the firsttime setup
        if !firstTime {
            performSegue(withIdentifier: "profileSegID", sender: nil)
            UserDefaults.standard.set(true, forKey: "firstTime")
        }
        
        //get the users name
        let userName = UserDefaults.standard.string(forKey: "healthUserName")
        
        //set the titles of everything based on if they exist or not
        titleBar.title = (userName == nil ? "Setup your user profile ->" : userName)
        
        welcomeLabel.text = (userName == nil ? "  Welcome!" : " Welcome \(userName!)!")
        
        //update the step goal if it exists
        self.stepGoal = Int(UserDefaults.standard.string(forKey: "healthStepGoal") ?? "1") ?? -1
        
        //set profile button to male or female depending on the what is known in health kit
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
        
        //set the data source to the array of data entries
        let bcDataSet = BarChartDataSet(values: self.bcDataEntry , label: "Steps Taken")
        bcDataSet.colors = [UIColor.red]
        let barChartData = BarChartData(dataSet: bcDataSet)
        
        //set grindlines to nothing
        barChartView.leftAxis.drawAxisLineEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = false
        
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawAxisLineEnabled = false
        
        //no zoom
        barChartView.isUserInteractionEnabled = false
        
        //make numbers ints
        self.barChartView.noDataText = "You haven't walked this week :/"
        self.barChartView.data = barChartData
        self.barChartView.xAxis.granularity = 1
        
        //make sure to update the progressbar
        HKDataManager.getSteps(completion:  { (steps) in
            DispatchQueue.main.async {
                
                self.stepGoalLabel.text = "Daily Step Goal: \(Int(steps))/\(self.stepGoal)"
                self.stepPBar.progress = Float(steps/(self.stepGoal != 0 ? Double(self.stepGoal) : 1))
                self.stepPBar.layer.borderColor  = UIColor.blue.cgColor
                self.stepPBar.layer.borderWidth = 0.3
                
            }
        })
        
        //import the data into the graph
        //we can send the view into the param but thats
        //the model accessing the view which is bad
        importStepsHistoryOneWeek()
    }
    
    //loads one week of data into the view
    //Source: https://stackoverflow.com/questions/50620547/how-to-get-apple-health-data-by-date-wise
    func importStepsHistoryOneWeek() {
        let healthStore = HKHealthStore()
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        //get a week's worth of data
        let now = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        
        //set the interval to a 1 day interval
        var interval = DateComponents()
        interval.day = 1
        
        //get the other parts of the date
        var anchorComponents = Calendar.current.dateComponents([.day, .month, .year], from: now)
        anchorComponents.hour = 0
        let anchorDate = Calendar.current.date(from: anchorComponents)!
        
        //create a query for health kit
        let query = HKStatisticsCollectionQuery(quantityType: stepsQuantityType, quantitySamplePredicate: nil, options: [.cumulativeSum], anchorDate: anchorDate, intervalComponents: interval)
        
        //get the initial results from the callback
        query.initialResultsHandler = { _, results, error in
            guard let results = results else {
                print("ERROR")
                return
            }
            var day = 1
            
            //go through all of the data
            results.enumerateStatistics(from: startDate, to: now) { statistics, _ in
                
                //get the steps from the data
                if let sum = statistics.sumQuantity() {
                    
                    //add the data to the graph
                    let steps = sum.doubleValue(for: HKUnit.count())
                    self.bcDataEntry.append(BarChartDataEntry(x: Double(day), y: steps))
                    
                    //  print("Amount of steps: \(steps), date: \(statistics.startDate)")
                    day = day + 1
                }
            }
        }
        
        //execute the query
        healthStore.execute(query)
    }

    //reload on closing so that it so fresh when it comes back
    override func viewWillDisappear(_ animated: Bool) {
        loadData()
    }
    
    //when the view is to the front the data]
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    
}
