//
//  HomescreenRecipient.swift
//  GranHealth
//
//  Created by MANI NAIR on 19/02/21.
//  Copyright © 2021 com.siddharthnair. All rights reserved.
//

import SwiftUI
import Firebase
import HealthKit

struct HomescreenRecipient: View {
    
    @State var email: String
    
    let healthStore = HKHealthStore()
    let db = Firestore.firestore()
    
    var body: some View {
        
        VStack{
            
            Text("Welcome to the Recipient page")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black.opacity(0.7))
            
            Text(self.email)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color.black.opacity(0.7))
            .padding(.top,5)
            
            Button(action: {
                
                try! Auth.auth().signOut()
                withAnimation{
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
                
            }) {
                
                Text("Log out")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color("Color"))
            .cornerRadius(10)
            .padding(.top, 25)
            
            
            Button(action: {
                
                self.authorizeHealthKit()
    
                
            }) {
                
                Text("Get data")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color("Color"))
            .cornerRadius(10)
            .padding(.top, 20)
            
            
        }
    }

    func authorizeHealthKit(){
        
        var read = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        var share = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        healthStore.requestAuthorization(toShare: share, read: read) { (chk,error) in
            if(chk){
                print("permission granted - Heart Rate")
                self.latestHeartRate()
            }
        }
            
        read = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        share = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        healthStore.requestAuthorization(toShare: share, read: read) { (chk,error) in
            if(chk){
                print("permission granted - Step Count")
                self.latestSteps()
            }
            }
            
            
        
    }
    
    func latestSteps(){
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            
            guard error == nil else{
                return
            }
            
//            let data = result
//            print(data)
            
            var tempsteps: [Double] = []
            var tempdates: [Date] = []
            var tempdatesString: [String] = []
            let data = result!
            let unit = HKUnit(from: "count")
            let dateFormator = DateFormatter()
            dateFormator.dateFormat = "dd/MM/yyyy"
            
            for index in data{
                
                let dataval = index as! HKQuantitySample
                let hr2 = dataval.quantity.doubleValue(for: unit)
                tempsteps.append(hr2)
                let startdate = dataval.startDate
                let calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: startdate)
                tempdatesString.append("\(calendarDate.day!)/\(calendarDate.month!)/\(calendarDate.year!)")
                tempdates.append(startdate)
                
            }
            
            tempsteps.reverse()
            tempdates.reverse()
            tempdatesString.reverse()
            print(tempsteps)
            print(tempdates)
            print(tempdatesString)
            
            var steps: [Double] = []
            var dates: [Date] = []
            
            var sum: Double = 0
            var date = Date()
            for i in 0..<tempsteps.count {
                if i != tempsteps.count-1 {
                if tempdatesString[i] == tempdatesString[i+1] {
                    sum+=tempsteps[i]
                    date = tempdates[i]
                }
                else{
                    sum+=tempsteps[i]
                    date = tempdates[i]
                    steps.append(sum)
                    dates.append(date)
                    sum = 0
                    date = Date()
                }
                }
                else{
                    if tempdatesString[i] == tempdatesString[i-1] {
                        sum+=tempsteps[i]
                        date = tempdates[i]
                        steps.append(sum)
                        dates.append(date)
                        sum = 0
                        date = Date()
                    }
                    else{
                        sum = tempsteps[i]
                        date = tempdates[i]
                        steps.append(sum)
                        dates.append(date)
                        sum = 0
                        date = Date()
                    }
                
                }
            }
            
            print(steps)
            print(dates)
            
            if let user = Auth.auth().currentUser?.email {
                
                
                self.db.collection(user).document("StepCount").setData([
                    "StepCountValues": steps,
                    "StepCountDates": dates
                ]) { err in
                    if let err = err{
                        print("Issue saving StepCount data to Firestore: \(err)")
                    } else {
                        print("Successfully saved StepCount data to Firestore")
                    }
                    
                }
            }
            
            
            
           
            
        }
        
        healthStore.execute(query)
    }
    
    
    
    func latestHeartRate(){
        
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else{
            return
        }
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            guard error == nil else{
                return
            }
            
//            let data = result![0] as! HKQuantitySample
//            let unit = HKUnit(from: "count/min")
//            let latestHr = data.quantity.doubleValue(for: unit)
//            print("latest Heart rate: \(latestHr) BPM")
            
            var heartRateValues: [Double] = []
            var heartRateDates: [Date] = []
            let data = result!
            let unit = HKUnit(from: "count/min")
            let dateFormator = DateFormatter()
            dateFormator.dateFormat = "dd/MM/yyyy hh:mm s"
            
            for index in data{
                
                let dataval = index as! HKQuantitySample
                let hr2 = dataval.quantity.doubleValue(for: unit)
                heartRateValues.append(hr2)
//                let startdate = dateFormator.string(from: dataval.startDate)
                let startdate = dataval.startDate
                heartRateDates.append(startdate)
                
            }
            heartRateValues.reverse()
            heartRateDates.reverse()
            print(heartRateValues)
            print(heartRateDates)
            
            if let user = Auth.auth().currentUser?.email {
                
                
//                self.db.collection(user).addDocument(data: [
//                    "HeartRateValues": heartRateValues,
//                    "HeartRateDates": heartRateDates
//                ]) { (error) in
//
//                    if let e = error {
//
//                        print("Issue saving HeartRate data to Firestore: \(e)")
//                    } else {
//                        print("Successfully saved HeartRate data to Firestore")
//                    }
//                }
                self.db.collection(user).document("HeartRate").setData([
                    "HeartRateValues": heartRateValues,
                    "HeartRateDates": heartRateDates
                ]) { err in
                    if let err = err{
                        print("Issue saving HeartRate data to Firestore: \(err)")
                    } else {
                        print("Successfully saved HeartRate data to Firestore")
                    }
                    
                }
            }
            
//            let dateFormator = DateFormatter()
//            dateFormator.dateFormat = "dd/MM/yyyy hh:mm s"
//            let StartDate = dateFormator.string(from: data.startDate)
            //            let EndDate = dateFormator.string(from: data.endDate)
            
//            print("Last Updated on: \(StartDate)")
            
            
        }
        
        healthStore.execute(query)
        return
    }
}


