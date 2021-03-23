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
        
    }
    
    
    
//    func registerBackgroundTasks(){
//        let backgroundAppRefreshTaskScheduleIdentifier = "com.granhealth.fooBackgroundAppRefreshIdentifier"
//        let backgroundProcessingTaskScheduleIdentifier = "com.granhealth.fooBackgroundProcessingIdentifier"
//
//        BGTaskScheduler.shared.register(
//                    forTaskWithIdentifier: backgroundAppRefreshTaskScheduleIdentifier, using: nil) { (task) in
//                        print("Background refresh task scheduler is being executed now")
//                        print("Background time remaining: \(UIApplication.shared.backgroundTimeRemaining)s")
//
//                        task.expirationHandler = {
//                            task.setTaskCompleted(success: false)
//                        }
//
//                        if (UserDefaults.standard.value(forKey: "flag") as? Int == 2){
//
//                            let elder = HomescreenRecipient(email: "siddharthmani2000@gmail.com")
//                            elder.authorizeHealthKit()
//                            print("Done in background")
//
//                        }
//
//                        task.setTaskCompleted(success: true)
//
//
//
//
//                }
//    }
    
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        submitBackgroundTasks()
//    }
//
//    func submitBackgroundTasks(){
//
//        let backgroundAppRefreshTaskScheduleIdentifier = "com.granhealth.fooBackgroundAppRefreshIdentifier"
//        let timeDelay = 10.0
//
//        do{
//            let backgroundAppRefreshTaskRequest = BGAppRefreshTaskRequest(identifier: backgroundAppRefreshTaskScheduleIdentifier)
//
//            backgroundAppRefreshTaskRequest.earliestBeginDate = Date(timeIntervalSinceNow: timeDelay)
//            try BGTaskScheduler.shared.submit(backgroundAppRefreshTaskRequest)
//            print("Submitted task request")
//        } catch{
//            print("Failed to submit BGTask")
//        }
//    }

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

