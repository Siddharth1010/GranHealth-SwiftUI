

import SwiftUI
import Firebase
import SwiftUICharts

struct HRModal: View {
    
    let db = Firestore.firestore()
    @State var HRValues: [Double] = [0]
    @State var HRDates: [Date] = [Date()]
    @State var elements: [(String, Double)] = []
    @State var data: [ABHRvals] = []
    @State var selected = -1
    var colors  = [Color("Color2"),Color("Color")]
    var body: some View {
        
        
        
        VStack(alignment: .leading, spacing: 15){

            Text("Abnormal Heart Rate")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            .padding(.leading, 28)
            
            Text("Recently recorded abnormal heart rates")
                .font(.subheadline)
                            .foregroundColor(.primary)
                        .padding(.leading, 28)
                
            
            HStack(spacing: 15){
                
                ForEach(self.data){ abhrdata in
                    VStack{
                        VStack{
                            Spacer(minLength: 0)
                            
                            if self.selected == abhrdata.id{
                            Text(String(format: "%.0f", abhrdata.hrval))
                            .foregroundColor(Color("Color"))
                            .padding(.bottom, 5)
                            .font(.callout)
                            }
                            else{
                                Text(String(format: "%.0f", abhrdata.hrval))
                                .foregroundColor(.primary)
                                .padding(.bottom, 5)
                                .font(.callout)
                            }
                            
                            RoundedShape()
                                .fill(LinearGradient(gradient: .init(colors: self.selected == abhrdata.id ? self.colors : self.colors),startPoint: .top, endPoint: .bottom))
                                .frame(height: abhrdata.hrval)
                            
                        }
                        .frame(height: 220)
                        .onTapGesture {
                            withAnimation(.easeOut){
                                self.selected = abhrdata.id
                            }
                        }
                        
                        Text(abhrdata.hrdate.components(separatedBy: " ")[0])
                            .font(Font.system(size: 10))
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                            .foregroundColor(.primary)
                    }
                }
            
            }
            .padding()
            .background(Color.primary.opacity(0.05))
            .shadow(color: Color.primary.opacity(0.15), radius: 10, x: 10, y: 10)
            .frame(height: 300)
            .cornerRadius(10)
            .padding()
            
            VStack{
                Text("Statistics")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.leading, 20)
                    .padding(.bottom, 8)
            }
            
            VStack{
                
                HStack(alignment: .top){
                                
                    Text("Average Abnormal:")
                        .foregroundColor(.white)
                        .padding(.vertical,3)
                    //                .frame(width: UIScreen.main.bounds.width - 50)
                    Spacer()
                    
                    Text(String(format: "%.2f", self.HRValues.reduce(0, +) / Double(self.HRValues.count) ) + " BPM")
                        .foregroundColor(.white)
                        .padding(.vertical,3)
                    //                .frame(width: UIScreen.main.bounds.width - 50)
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width - 10)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.bottom, 30)
                
                
                HStack(alignment: .top){
                                
                    Text("Highest Abnormal:")
                        .foregroundColor(.white)
                        .padding(.vertical,3)
                    //                .frame(width: UIScreen.main.bounds.width - 50)
                    Spacer()
                    
                    Text(String(format: "%.2f", self.HRValues.max()!) + " BPM")
                        .foregroundColor(.white)
                        .padding(.vertical,3)
                    //                .frame(width: UIScreen.main.bounds.width - 50)
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width - 10)
                .background(Color.blue)
                .cornerRadius(10)
                
                Text("Recorded on: \(self.HRDates[self.HRValues.firstIndex(of: self.HRValues.max()!)!])")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 40)
                .padding()

                
                
                
            }
        .padding()
            
        
        }.onAppear(){
            self.getHRValues()
        }
        
        
        
            }
    
    func getHRValues(){
        
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
                                var tempdates: [Date] = []
                                for time in timestamp{
                                    tempdates.append(time.dateValue())
                                }
                                print(tempdates)
                                let tempvalues: [Double] = doc.data()["HeartRateValues"]! as! [Double]
                                let dateFormator = DateFormatter()
                                dateFormator.dateFormat = "dd/MM/yyyy hh:mm s"
//                                let StartDate = dateFormator.string(from: data.startDate)
                                var values: [Double] = []
                                var dates: [Date] = []
                                var elements2: [(String, Double)] = []
                                for i in 0 ..< tempvalues.count
                                {
                                    if(tempvalues[i] > 89.0){
                                        values.append(tempvalues[i])
                                        dates.append(tempdates[i])
//                                        let tempcurval: Double = Double(String(format: "%.2f", tempvalues[i]))!
                                        let curval: CGFloat = CGFloat(tempvalues[i])
                                        let curdate: String = dateFormator.string(from: tempdates[i])
                                        elements2.append((dateFormator.string(from: tempdates[i]), tempvalues[i]))
                                        self.data.append(ABHRvals(id: i, hrval: curval, hrdate: curdate))
                                    }
                                }
                                self.HRValues = values
                                self.HRDates = dates
                                self.elements = elements2
                            }
                        }
                    }
                }
            }
        }

        
    }
}

struct ABHRvals : Identifiable{
    
    var id: Int
    var hrval: CGFloat
    var hrdate: String
}

struct RoundedShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5, height: 5))
        
        return Path(path.cgPath)
    }
}
