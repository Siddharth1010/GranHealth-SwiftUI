
import SwiftUI
import Firebase

struct HealthDetail: View {
    
    var health:Health
    
    @Binding var show:Bool
    @Binding var isActive:Bool
    let db = Firestore.firestore()
    var body: some View {
        
        
        VStack{
            
            if self.health.name == "Heart-Rate"{
                
                HeartRate()
            }
            else if self.health.name == "Steps"{
                
                Steps()
            }
            
            else if self.health.name == "Walking / Running Distance"{
                
                Distance()
            }
            
            else if self.health.name == "Flights Climbed"{
                
                Flights()
            }
            
            else if self.health.name == "Step Length"{
                
                StepLength()
            }
            
            else if self.health.name == "Walking Speed"{
                
                WalkingSpeed()
            }
            
            else if self.health.name == "Location"{
                
                Location()
            }
            
            
        }
        
        
//        List {
//        ZStack(alignment: .bottom){
//        Image(health.imageName)
//        .resizable()
//        .aspectRatio(contentMode: .fit)
//
//        Rectangle()
//            .frame(height: 80)
//            .opacity(0.25)
//            .blur(radius: 10)
//
//            HStack{
//                VStack(alignment: .leading, spacing: 8){
//                    Text(health.name)
//                    .foregroundColor(Color("Color"))
//                        .font(.largeTitle)
//                }
//                .padding(.leading)
//                .padding(.bottom)
//                Spacer()
//            }
//
//        }
//        .listRowInsets(EdgeInsets())
//
//            VStack(alignment: .leading){
//            Text(health.description)
//                .foregroundColor(.primary)
//                .font(.body)
//                .lineLimit(nil)
//                .lineSpacing(12)
//
//
//                HStack{
//
//                    Spacer()
//
//                    Button(action: {}) {
//
//                        Text("View details")
//                    }
//                    .frame(width: 200, height: 50)
//                    .background(Color("Color"))
//                    .foregroundColor(.white)
//                    .font(.headline)
//                    .cornerRadius(10)
//
//                    Spacer()
//                }
//                .padding(.top, 50)
//
//            }
//            .padding(.top)
//            .padding(.bottom)
//
//
//        }

//    .offset(y: -50)
//    .navigationBarHidden(true)
        
    }
    
    
    //DELETE THIS
    
//     func getHRValues() {
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
//                                self.HRValues = doc.data()["HeartRateValues"]! as! [Double]
//                                print(self.HRValues)
//                                break
//                            }
//                        }
//
//                    }
//                }
//            }
//        }
//
//    }
    
    
    
    
    
}

//        .edgesIgnoringSafeArea(.top)


//struct HealthDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        HealthDetail(health: healthData[3])
//    }
//}



