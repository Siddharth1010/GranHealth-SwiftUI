
import SwiftUI
import Firebase
import SwiftUICharts

struct HeartRate: View {
    
    @State var HRValues: [Double] = [0]
    @State var HRDates: [Date] = [Date()]
    @State private var show_modal: Bool = false
    let db = Firestore.firestore()
    
    
//LineView(data: self.HRValues, title: "Heart Rate (BPM)", legend: "The heart rate values recorded in the last month")
    
    
    var body : some View{
        
        ZStack (alignment: .topTrailing) {
            
        GeometryReader{_ in
          
        VStack(alignment: .leading){
            VStack{
//            HStack{
            LineView(data: self.HRValues, title: "Heart Rate (BPM)", legend: "The heart rate values recorded in the last month")
            .frame(height: 300)
//            }
            .padding()
            .padding(.bottom, 0)
            
            VStack{
            
            HStack(alignment: .top){
                
            Text("Average Heart Rate:")
                .foregroundColor(.white)
                .padding(.vertical,3)
//                .frame(width: UIScreen.main.bounds.width - 50)
        Spacer()
//                Text("\((self.HRValues.reduce(0, +)) / Double(self.HRValues.count)) BPM")
            Text(String(format: "%.2f", self.HRValues.reduce(0, +) / Double(self.HRValues.count) ) + " BPM")
                .foregroundColor(.white)
                .padding(.vertical,3)
//                .frame(width: UIScreen.main.bounds.width - 50)
            }
            .padding()
            .background(Color.blue)
            .frame(width: UIScreen.main.bounds.width - 10)
            .cornerRadius(10)
            .padding(.bottom, 30)
            
            HStack(alignment: .top){
                            
                        Text("Latest Heart Rate:")
                            .foregroundColor(.white)
                            .padding(.vertical,3)
                    Spacer()
//                Text("\(self.HRValues[self.HRValues.count-1]) BPM")
                Text(String(format: "%.2f", self.HRValues[self.HRValues.count-1]) + " BPM")
                            .foregroundColor(.white)
                            .padding(.vertical,3)
            //                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .padding()
                        .frame(width: UIScreen.main.bounds.width - 10)
                        .background(Color.blue)
                        .cornerRadius(10)
                Text("Last recorded on: \(self.HRDates[self.HRDates.count - 1])")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 40)
                .padding()
                
                Button(action: {
                    self.show_modal = true
                }) {
                    Text("Abnormal Heart Rates")
                        .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 35)
                .sheet(isPresented: self.$show_modal) {
                    HRModal()
                }
            }
//            .offset(y: -200)
                .padding(.top, 70)
                
            }
        }
        .padding(.top, -160)
        .onAppear(){
            self.getHRValues()
        }
            }
        }
        

                
               
            
    }
    
    func getHRValues() {
        if let user = Auth.auth().currentUser?.email {

            self.db.collection(user).addSnapshotListener { (querySnapshot, error) in
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
    
    func backgroundHRValues() -> [Double: Date] {
        
        var returnval: [Double: Date] = [:]
        
        if let user = Auth.auth().currentUser?.email {

            self.db.collection(user).addSnapshotListener { (querySnapshot, error) in
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
                                returnval[hrvalues[hrvalues.count-1]] = dates[dates.count-1]
                                print("Dict data in function: \(returnval)")
                                
                            }
                        }
                    }
                }
            }
        }
        
        return returnval
    
    }
    

}



