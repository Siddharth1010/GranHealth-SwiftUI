//
//  HeartRate.swift
//  GranHealth
//
//  Created by MANI NAIR on 19/02/21.
//  Copyright © 2021 com.siddharthnair. All rights reserved.
//

import SwiftUI
import Firebase

struct HeartRate: View {
    
    @State var HRValues: [Double] = []
    @State var HRDates: [Date] = []
    let db = Firestore.firestore()
    
    
//    init(_ HRValues: [Double]) {
//
//        self.HRValues = [1,2,3]
//    }
    
    var body : some View{
          
        VStack{
            
            Text("This is the heart rate page")
            HStack{
            Text("\(self.HRValues)" as String)
            }
            Text("\(self.HRDates)" as String)
            
        }.onAppear(){
            
            if let user = Auth.auth().currentUser?.email {

                self.db.collection(user).getDocuments { (querySnapshot, error) in
                    if let e = error {
                        print("Heart Rate values could not be retreived from firestore: \(e)")
                    } else {
                        if let snapshotDocs = querySnapshot?.documents {
                            for doc in snapshotDocs {
                                if doc.documentID == "HeartRate"{
                                    print(doc.data()["HeartRateValues"]! as! [Double])
                                    let timestamp: [Timestamp] = doc.data()["HeartRateDates"]! as! [Timestamp]
                                    var dates: [Date] = []
                                    for time in timestamp{
                                        dates.append(time.dateValue())
                                    }
                                    print(dates)
                                    self.HRValues = doc.data()["HeartRateValues"]! as! [Double]
                                    self.HRDates = dates
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
    
//    func getHRValues() {
//
//
//        if let user = Auth.auth().currentUser?.email {
//
//            self.db.collection(user).getDocuments { (querySnapshot, error) in
//                if let e = error {
//                    print("Heart Rate values could not be retreived from firestore: \(e)")
//                } else {
//                    if let snapshotDocs = querySnapshot?.documents {
//                        for doc in snapshotDocs {
//                            if doc.documentID == "HeartRate"{
//                                print(doc.data()["HeartRateValues"]! as! [Double])
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//    }
}
