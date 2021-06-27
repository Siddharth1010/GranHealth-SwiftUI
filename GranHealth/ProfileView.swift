
import SwiftUI
import Firebase

// Profile view on caretakers iPhone
struct ProfileView : View {
    
    @Binding var show : Bool
    @State var stepGoalLocal: String
    @State var color = Color.black.opacity(0.7)
    @State var height: String = ""
    @State var weight: String = ""
    @State var email = UserDefaults.standard.value(forKey: "globalEmail") as? String
    let db = Firestore.firestore()
    
    
    var body: some View {
        
        ZStack{
            
            ZStack(alignment: .topLeading) {
                
                GeometryReader{_ in
                    
                    VStack(alignment: .leading){
                        
                        Text("PROFILE")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.primary)
                            .padding(.leading,10)
                        
                        Divider()
                            .background(Color.gray)
                            .padding(.top, -5)
                            .padding(.bottom, 20)
                        
                        // Detils of the elderly individual
                        Text("ELDER")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.primary)
                            .padding(.leading,10)
                            .padding(.bottom, 5)
                        
                        // Elder's step goal for the day
                        HStack(alignment: .center){
                            Text("Step Goal")
                                .font(.system(size: 20))
                                .foregroundColor(Color.white)
                            
                            Spacer()
                            
                            // Enter a new step goal for the elder through TextField and get
                            // notified on completion
                            TextField("Value", text: self.$stepGoalLocal, onCommit: {
                                
                                print("New step goal value: \(self.stepGoalLocal)")
                                // Set step goal as user default for notifications
                                UserDefaults.standard.set(self.stepGoalLocal, forKey: "stepGoal")
                                NotificationCenter.default.post(name: NSNotification.Name("stepGoal"), object: nil)
                                print(UserDefaults.standard.value(forKey: "stepGoal") as! String)
                                
                                
                            })
                            .frame(width: 45, height: 5)
                            .keyboardType(.numberPad)
                            .foregroundColor(.white)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.stepGoalLocal != "" ? Color.white : self.color, lineWidth: 2))
                            .multilineTextAlignment(.center)
                            
                            
                            
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 10)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.bottom, 15)
                        
                        // Height of Elderly individual
                        HStack(alignment: .center){
                            Text("Height")
                                .font(.system(size: 20))
                                .foregroundColor(Color.white)
                            
                            Spacer()
                            
                            // If height is not available on the elders health application set to No data
                            if(self.height == ""){
                                Text("No data")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.white)
                                    .padding(.top, 5)
                                    .padding(.bottom, 5)
                                
                            }
                            // If height is available display it
                            else{
                                Text("\(self.height)"+" ft")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.white)
                                    .padding(.top, 5)
                                    .padding(.bottom, 5)
                                
                            }
                            
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 10)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.bottom, 25)
                        
                        // Weight of Elderly individual
                        HStack(alignment: .center){
                            Text("Weight")
                                .font(.system(size: 20))
                                .foregroundColor(Color.white)
                            
                            Spacer()
                            
                            // If weight is not available on the elders health application set to No data
                            if(self.weight == ""){
                                Text("No data")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.white)
                                    .padding(.top, 5)
                                    .padding(.bottom, 5)
                                
                            }
                            else{
                                // If weight is available display it
                                Text("\(self.weight)"+" lbs")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.white)
                                    .padding(.top, 5)
                                    .padding(.bottom, 5)
                                
                            }
                            
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 10)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.bottom, 40)
                        
                        // Details of the Caretaker / User
                        Text("USER")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.primary)
                            .padding(.leading,10)
                            .padding(.bottom, 20)
                        
                        // Email ID of the Caretaker / User
                        HStack(alignment: .center){
                            Text("Email")
                                .font(.system(size: 20))
                                .foregroundColor(Color.white)
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                            
                            Spacer()
                            
                            // Display Email ID
                            Text(self.email!)
                                .font(.system(size: 16))
                                .foregroundColor(Color.white)
                            
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 10)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.bottom, 55)
                        
                        
                        // Button to log out of the application
                        Button(action: {
                            
                            try! Auth.auth().signOut()
                            withAnimation{
                                // Set user default status key to false - Takes user back to login page
                                UserDefaults.standard.set(false, forKey: "status")
                                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                            }
                            
                        }) {
                            
                            Text("Log out")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 10)
                        }
                        .background(Color("Color"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                    }
                    .padding(.horizontal, 50)
                    .onAppear{
                        // On appear get the height and weight values from Firestore
                        self.getHeightAndWeight()
                    }
                    
                }
                // Navigate back to home page
                Button (action: {
                    
                    self.show.toggle()
                    
                }) {
                    
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(Color("Color"))
                }
                .padding()
                
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
            
            
            
        }
        
    }
    // Function to extract Elder's height and weight values from Firestore
    func getHeightAndWeight(){
        
        if let user = Auth.auth().currentUser?.email {
            
            self.db.collection(user).addSnapshotListener { (querySnapshot, error) in
                // Handle errors in data retrieval
                if let e = error {
                    print("Height and Weight values could not be retreived from firestore: \(e)")
                } else {
                    if let snapshotDocs = querySnapshot?.documents {
                        // Get height and weight from their respective documents
                        for doc in snapshotDocs {
                            if doc.documentID == "Height"{
                                print(doc.data()["Height"]! as! Double)
                                let tempvar = doc.data()["Height"]! as! Double
                                self.height = String(tempvar)
                                // Print height for debugging purposes
                                print("The height is"+self.height)
                                
                            }
                            if doc.documentID == "Weight"{
                                let tempvar = doc.data()["Weight"]! as! Double
                                self.weight = String(tempvar)
                                // Print weight for debugging purposes
                                print("The weight is"+self.weight)
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
}



