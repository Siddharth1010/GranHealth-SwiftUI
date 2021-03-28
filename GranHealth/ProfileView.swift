
import SwiftUI
import Firebase

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
                    .foregroundColor(Color.black.opacity(1))
                    .padding(.leading,10)
                    
                    Divider()
                    .background(Color.gray)
                    .padding(.top, -5)
                    .padding(.bottom, 20)
                    
                    
                    
                    
                                        Text("ELDER")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.black.opacity(1))
                                        .padding(.leading,10)
                                        .padding(.bottom, 5)
                    
                                        HStack(alignment: .center){
                                        Text("Step Goal")
                                            .font(.system(size: 20))
                                        .foregroundColor(Color.white)
                    
                                            Spacer()
                    
                                        TextField("Value", text: self.$stepGoalLocal, onCommit: {
                    
                                            print("New step goal value: \(self.stepGoalLocal)")
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
                    
                    HStack(alignment: .center){
                            Text("Height")
                                .font(.system(size: 20))
                                .foregroundColor(Color.white)
                    
                                Spacer()
                        
                        if(self.height == ""){
                                Text("No data")
                                .font(.system(size: 20))
                                .foregroundColor(Color.white)
                                    .padding(.top, 5)
                                    .padding(.bottom, 5)
                        
                                }
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
                    
                    HStack(alignment: .center){
                            Text("Weight")
                                .font(.system(size: 20))
                                .foregroundColor(Color.white)
                    
                                Spacer()
                        
                        if(self.weight == ""){
                                Text("No data")
                                .font(.system(size: 20))
                                .foregroundColor(Color.white)
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                        
                                }
                        else{
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
                    
                    
                    Text("USER")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black.opacity(1))
                    .padding(.leading,10)
                    .padding(.bottom, 20)
                    
                    HStack(alignment: .center){
                            Text("Email")
                                .font(.system(size: 20))
                                .foregroundColor(Color.white)
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                    
                                Spacer()
                        
                        
                        
                        Text(self.email!)
                            .font(.system(size: 16))
                            .foregroundColor(Color.white)
                        
                           
                        
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width - 10)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.bottom, 55)
                    
                    
                    
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
                            .frame(width: UIScreen.main.bounds.width - 10)
                    }
                    .background(Color("Color"))
                    .cornerRadius(10)
                    .padding(.top, 25)
                }
                .padding(.horizontal, 50)
                .onAppear{
                    self.getHeightAndWeight()
                }
                
            }
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
    func getHeightAndWeight(){
    
            if let user = Auth.auth().currentUser?.email {
    
                self.db.collection(user).addSnapshotListener { (querySnapshot, error) in
                    if let e = error {
                        print("Height and Weight values could not be retreived from firestore: \(e)")
                    } else {
                        if let snapshotDocs = querySnapshot?.documents {
                            for doc in snapshotDocs {
                                if doc.documentID == "Height"{
                                    print(doc.data()["Height"]! as! Double)
                                    let tempvar = doc.data()["Height"]! as! Double
                                    self.height = String(tempvar)
//                                    let tempvar = String(format: "%.0f", self.height)
//                                    self.height = Double(tempvar)
                                    print("The height is"+self.height)
    
                                }
                                if doc.documentID == "Weight"{
//                                    print(doc.data()["Weight"]! as! Double)
                                    let tempvar = doc.data()["Weight"]! as! Double
                                    self.weight = String(tempvar)
                                    print("The weight is"+self.weight)
    
                                }
                            }
                        }
                    }
                }
            }
        }
    
}



//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
