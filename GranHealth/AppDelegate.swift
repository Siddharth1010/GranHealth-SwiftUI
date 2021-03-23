//
//  AppDelegate.swift
//  GranHealth
//
//  Created by MANI NAIR on 17/02/21.
//  Copyright © 2021 com.siddharthnair. All rights reserved.
//

import UIKit
import Firebase
import BackgroundTasks
import MapKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        print(db)
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if (UserDefaults.standard.value(forKey: "flag") as? Int == 2){
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (_, _) in
                
            }
            
            let email = UserDefaults.standard.value(forKey: "globalEmail") as? String
        
        let elder = HomescreenRecipient(email: email!)
        elder.latestHeartRate()
        elder.latestSteps()
        let locationManager = LocationManager()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let coordinate = locationManager.location != nil ? locationManager.location!.coordinate : CLLocationCoordinate2D()
            print(coordinate.latitude)
            print(coordinate.longitude)
            elder.latestLocationBackground(coordinate: coordinate)
            print("Done in background")
            
            // PUSH NOTIFICATION
            let content = UNMutableNotificationContent()
                content.title = "GranHealth"
                content.body = "Health data refreshed and transmitted to cloud successfully"
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
            
            }
        }
        
        if (UserDefaults.standard.value(forKey: "flag") as? Int == 1){
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (_, _) in
                
            }
            

            let db = Firestore.firestore()
            var recentHRVal: Double = 0.0
            var recentHRDate: Date = Date()
            
            // LATEST HEART RATE
            if let user = Auth.auth().currentUser?.email {

                db.collection(user).addSnapshotListener { (querySnapshot, error) in
                    if let e = error {
                        print("Heart Rate values could not be retreived from firestore: \(e)")
                    } else {
                        if let snapshotDocs = querySnapshot?.documents {
                            for doc in snapshotDocs {
                                if doc.documentID == "HeartRate"{
                                    print(doc.data()["HeartRateValues"]! as! [Double])
                                    let timestamp: [Timestamp] = doc.data()["HeartRateDates"]! as! [Timestamp]
                                    var dates: [Date] = []
                                    var hrvalues: [Double] = []
                                    for time in timestamp{
                                        dates.append(time.dateValue())
                                    }
                                    
                                    hrvalues = doc.data()["HeartRateValues"]! as! [Double]
                                    recentHRVal = hrvalues[hrvalues.count-1]
                                    recentHRDate = dates[dates.count-1]
                                    
                                }
                            }
                        }
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            
            print("Dictionary marks")
                            print(recentHRVal)
                            print(recentHRDate)

                
                if recentHRVal > 90.0 {
                    
                    let content = UNMutableNotificationContent()
                    content.title = "GranHealth"
                    content.body = "ALERT! Abnormal Heart Rate (\(recentHRVal)) BPM has been detected on \(recentHRDate)"
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
                }
                else{
                    print("Heart Rate Normal")
                }
            }
                
                
            
            
            
            
        }
        
    }
    

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

