
import SwiftUI
import Firebase
import SwiftUICharts

struct Steps: View {
    
    let db = Firestore.firestore()
    @State var StepValues: [Double] = [0]
    @State var StepDates: [Date] = [Date()]
    @State var StepDatesString: [String] = [""]
    @State var todaysDate: String = ""
    @State var elements: [(String, Double)] = []
    @State var data: [Stepvals] = []
    @State var selected = -1
    var colors  = [Color("Color2"),Color("Color")]
    var body: some View {
        
        
        
        VStack(alignment: .leading, spacing: 15){

            Text("Step Count")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            .padding(.leading, 28)
            
            Text("The number of steps recorded per day")
                .font(.subheadline)
                .foregroundColor(.primary)
            .padding(.leading, 28)
            
                
            
            HStack(spacing: 15){
                
                ForEach(self.data){ stepdata in
                    VStack{
                        VStack{
                            Spacer(minLength: 0)
                            
                            if self.selected == stepdata.id{
                            Text(String(format: "%.0f", stepdata.stepcountval))
                            .foregroundColor(Color("Color"))
                            .padding(.bottom, 5)
                            .font(.callout)
                            }
                            else{
                                Text(String(format: "%.0f", stepdata.stepcountval))
                                .foregroundColor(.primary)
                                .padding(.bottom, 5)
                                .font(.callout)
                            }
                            
                            RoundedShape()
                                .fill(LinearGradient(gradient: .init(colors: self.selected == stepdata.id ? self.colors : self.colors),startPoint: .top, endPoint: .bottom))
                                .frame(height: stepdata.stepcountval)
                            
                        }
                        .frame(height: 220)
                        .onTapGesture {
                            withAnimation(.easeOut){
                                self.selected = stepdata.id
                            }
                        }
                        
                        Text(stepdata.stepdate.components(separatedBy: " ")[0])
                            .font(Font.system(size: 10))
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                            .foregroundColor(.primary)
                    }
                }
            
            }
            .padding()
            .background(Color.primary.opacity(0.08))
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
//                    .padding(.bottom, 8)
            }
            
            VStack{
                
                
                HStack(alignment: .top){
                                
                    Text("Today's Step Count:")
                        .foregroundColor(.white)
                        .padding(.vertical,3)
                    //                .frame(width: UIScreen.main.bounds.width - 50)
                    Spacer()
                    
                    

                    if self.StepDatesString[self.StepDatesString.count-1].components(separatedBy: " ")[0] == self.todaysDate.components(separatedBy: " ")[0] {
                        
                        Text(String(format: "%.0f", self.StepValues[self.StepValues.count-1]) + " steps")
                        .foregroundColor(.white)
                        .padding(.vertical,3)
                        
                    }
                    else{
                        Text("0 steps")
                        .foregroundColor(.white)
                        .padding(.vertical,3)
                        
                    }
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width - 10)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.bottom, 30)
                
                
                
                
                HStack(alignment: .top){
                                
                    Text("Average Step Count:")
                        .foregroundColor(.white)
                        .padding(.vertical,3)
                    //                .frame(width: UIScreen.main.bounds.width - 50)
                    Spacer()
                    
                    Text(String(format: "%.2f", self.StepValues.reduce(0, +) / Double(self.StepValues.count) ) + " steps")
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
                                
                    Text("Highest Step Count:")
                        .foregroundColor(.white)
                        .padding(.vertical,3)
                    //                .frame(width: UIScreen.main.bounds.width - 50)
                    Spacer()
                    
                    Text(String(format: "%.2f", self.StepValues.max()!) + " steps")
                        .foregroundColor(.white)
                        .padding(.vertical,3)
                    //                .frame(width: UIScreen.main.bounds.width - 50)
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width - 10)
                .background(Color.blue)
                .cornerRadius(10)
                
                Text("Recorded on: \(self.StepDates[self.StepValues.firstIndex(of: self.StepValues.max()!)!])")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 40)
                .padding()

                
                
                
            }
        .padding()
            
        
        }.onAppear(){
            self.getStepValues()
        }
        
        
        
            }
    
    func getStepValues(){
        
        if let user = Auth.auth().currentUser?.email {

            self.db.collection(user).addSnapshotListener { (querySnapshot, error) in
                if let e = error {
                    print("Step values could not be retreived from firestore: \(e)")
                } else {
                    self.data = []
                    if let snapshotDocs = querySnapshot?.documents {
                        for doc in snapshotDocs {
                            if doc.documentID == "StepCount"{
                                print(doc.data()["StepCountValues"]! as! [Double])
                                let timestamp: [Timestamp] = doc.data()["StepCountDates"]! as! [Timestamp]
                                var tempdates: [Date] = []
                                for time in timestamp{
                                    tempdates.append(time.dateValue())
                                }
                                print(tempdates)
                                let tempvalues: [Double] = doc.data()["StepCountValues"]! as! [Double]
                                let dateFormator = DateFormatter()
                                dateFormator.dateFormat = "dd/MM/yyyy hh:mm s"
//                                let StartDate = dateFormator.string(from: data.startDate)
                                var values: [Double] = []
                                var dates: [Date] = []
                                var elements2: [(String, Double)] = []
                                var datesString: [String] = []
                                for i in 0 ..< tempvalues.count
                                {
                            
                                        values.append(tempvalues[i])
                                        dates.append(tempdates[i])
//                                        let tempcurval: Double = Double(String(format: "%.2f", tempvalues[i]))!
                                        let curval: CGFloat = CGFloat(tempvalues[i])
                                        let curdate: String = dateFormator.string(from: tempdates[i])
                                        elements2.append((dateFormator.string(from: tempdates[i]), tempvalues[i]))
                                        self.data.append(Stepvals(id: i, stepcountval: curval, stepdate: curdate))
                                        datesString.append(dateFormator.string(from: tempdates[i]))
                                    
                                }
                                self.StepValues = values
                                self.StepDates = dates
                                self.elements = elements2
                                self.StepDatesString = datesString
                                self.todaysDate = dateFormator.string(from: Date())
                            }
                        }
                    }
                }
            }
        }

        
    }
}

struct Stepvals : Identifiable{
    
    var id: Int
    var stepcountval: CGFloat
    var stepdate: String
}


// DECLARED IN HRModal.swift

//struct RoundedShape : Shape {
//
//    func path(in rect: CGRect) -> Path {
//
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5, height: 5))
//
//        return Path(path.cgPath)
//    }
//}
