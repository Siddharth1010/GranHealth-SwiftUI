
import MapKit
import SwiftUI
import Firebase
import HealthKit
import CoreLocation

// View which appears on the elder's iPhone
struct HomescreenRecipient: View {
    // Observe location manager for changes in the location
    @ObservedObject var locationManager = LocationManager()
    
    @State var email: String
    @State var latitude: CLLocationDegrees = 0
    @State var longitude: CLLocationDegrees = 0
    let healthStore = HKHealthStore()
    let db = Firestore.firestore()
    
    
    var body: some View {
        
        // Access the current location of the elderly individual
        let coordinate = locationManager.location != nil ? locationManager.location!.coordinate : CLLocationCoordinate2D()
        print("Access Location")
        
        return VStack{
            
            Text("Welcome to the Recipient page")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black.opacity(0.7))
            
            Text(self.email)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.black.opacity(0.7))
                .padding(.top,5)
            
            // Button for Elder to log out of the application
            Button(action: {
                
                try! Auth.auth().signOut()
                withAnimation{
                    // Set user defaults to false ro remember login status
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
            
            // Button to manually send Health and Location information to caretakers iPhone
            Button(action: {
                
                self.authorizeHealthKit()
                
            }) {
                
                Text("Send data")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color("Color"))
            .cornerRadius(10)
            .padding(.top, 20)
            
            
        }
    }
    
    // Function to authorize HealthKit initially
    // and send health / location data to caretakers iPhone
    func authorizeHealthKit(){
        
        // Request authorization to read and share elder's Heart Rate values
        var read = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        var share = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        healthStore.requestAuthorization(toShare: share, read: read) { (chk,error) in
            if(chk){
                print("permission granted - Heart Rate")
                self.latestHeartRate()
            }
        }
        
        // Request authorization to read and share elder's Step Count values
        read = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        share = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
        healthStore.requestAuthorization(toShare: share, read: read) { (chk,error) in
            if(chk){
                print("permission granted - Step Count")
                self.latestSteps()
            }
        }
        
        // Call function to get the latest location of the elder
        self.latestLocation()
        
        // Request authorization to read and share elder's Height values
        read = Set([HKObjectType.quantityType(forIdentifier: .height)!])
        share = Set([HKObjectType.quantityType(forIdentifier: .height)!])
        healthStore.requestAuthorization(toShare: share, read: read) { (chk,error) in
            if(chk){
                print("permission granted - Height")
                self.getHeight()
            }
        }
        
        // Request authorization to read and share elder's Weight values
        read = Set([HKObjectType.quantityType(forIdentifier: .bodyMass)!])
        share = Set([HKObjectType.quantityType(forIdentifier: .bodyMass)!])
        healthStore.requestAuthorization(toShare: share, read: read) { (chk,error) in
            if(chk){
                print("permission granted - Weight")
                self.getWeight()
            }
        }
    }
    
    // Function to get the elder's latest location
    func latestLocation(){
        // Extract coordiantes from the location manager
        let coordinate2 = locationManager.location != nil ? locationManager.location!.coordinate : CLLocationCoordinate2D()
        
        self.latitude = coordinate2.latitude
        self.longitude = coordinate2.longitude
        
        print(self.latitude)
        print(self.longitude)
        
        // Securely save Location Coordinates to Firestore
        if let user = Auth.auth().currentUser?.email {
            
            print(self.latitude)
            print(self.longitude)
            // Storing into document LocationCoordinates
            self.db.collection(user).document("LocationCoordinates").setData([
                "latitude": Double(self.latitude),
                "longitude": Double(self.longitude)
            ]) { err in
                if let err = err{
                    print("Issue saving Location data to Firestore: \(err)")
                } else {
                    print("Successfully saved Location data to Firestore")
                }
                
            }
        }
        
    }
    
    
    // Function to store latest location in the background through background fetch
    func latestLocationBackground(coordinate: CLLocationCoordinate2D){
        
        if let user = Auth.auth().currentUser?.email {
            // Storing into document LocationCoordinates
            self.db.collection(user).document("LocationCoordinates").setData([
                "latitude": Double(coordinate.latitude),
                "longitude": Double(coordinate.longitude)
            ]) { err in
                if let err = err{
                    print("Issue saving background Location data to Firestore: \(err)")
                } else {
                    print("Successfully saved background Location data to Firestore")
                }
                
            }
        }
        
    }
    
    // Function to extract the elder's weight from HealthKit and store into Firestore
    func getWeight() {
        
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .bodyMass) else {
            return
        }
        // Get weight values. Enter start date and declare sort descriptor
        let startDate = Calendar.current.date(byAdding: .year, value: -2, to: Date())
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        var wval: Double = 0.0
        
        //  Query to extract the stored samples from HealthKit
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            
            guard error == nil else{
                
                return
            }
            // Extract values from the sample through HKUnit lb
            var weightvals: [Double] = []
            let data = result!
            let unit = HKUnit(from: "lb")
            let dateFormator = DateFormatter()
            dateFormator.dateFormat = "dd/MM/yyyy"
            
            print(data)
            
            // If there is no weight data store  0.0 into Firestore
            // Check while dispalying to user
            if data.isEmpty{
                wval = 0.0
            }
            // If data is available append the values into a list
            else{
                for index in data{
                    
                    let dataval = index as! HKQuantitySample
                    let hr2 = dataval.quantity.doubleValue(for: unit)
                    weightvals.append(hr2)
                }
                
                // Format the weight values to 1 decimal place and store most recent record in the variable
                print("The weight values are: \(weightvals)")
                wval = weightvals[weightvals.count-1]
                let wvalString: String = String(format: "%.1f", wval)
                print(Double(wvalString)!)
                wval = Double(wvalString)!
                
            }
            
            // Store the weight value in Firestore
            if let user = Auth.auth().currentUser?.email {
                
                // Search for document Weight and store the value
                self.db.collection(user).document("Weight").setData([
                    "Weight": wval
                ]) { err in
                    if let err = err{
                        print("Issue saving Weight data to Firestore: \(err)")
                    } else {
                        print("Successfully saved Weight data to Firestore")
                    }
                    
                }
            }
            
            
        }
        // Execute the query
        healthStore.execute(query)
    }
    
    // Function to extract the elder's height if available
    func getHeight(){
        
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .height) else {
            return
        }
        
        let startDate = Calendar.current.date(byAdding: .year, value: -2, to: Date())
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        var hval: Double = 0.0
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            
            guard error == nil else{
                
                return
            }
            
            var heightvals: [Double] = []
            let data = result!
            let unit = HKUnit(from: "ft")
            let dateFormator = DateFormatter()
            dateFormator.dateFormat = "dd/MM/yyyy"
            
            print(data)
            if data.isEmpty{
                hval = 0.0
            }
            
            else{
                for index in data{
                    
                    let dataval = index as! HKQuantitySample
                    let hr2 = dataval.quantity.doubleValue(for: unit)
                    heightvals.append(hr2)
                    
                    
                    
                }
                print("The height values are: \(heightvals)")
                hval = heightvals[heightvals.count-1]
                let hvalString: String = String(format: "%.3f", hval)
                print(Double(hvalString)!)
                hval = Double(hvalString)!
            }
            
            if let user = Auth.auth().currentUser?.email {
                
                
                self.db.collection(user).document("Height").setData([
                    "Height": hval
                ]) { err in
                    if let err = err{
                        print("Issue saving Height data to Firestore: \(err)")
                    } else {
                        print("Successfully saved Height data to Firestore")
                    }
                    
                }
            }
            
            
            
            
        }
        healthStore.execute(query)
        
        
        
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
            
        }
        
        healthStore.execute(query)
        return
    }
}


