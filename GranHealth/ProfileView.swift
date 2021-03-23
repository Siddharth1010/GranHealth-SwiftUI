//
//  ProfileView.swift
//  GranHealth
//
//  Created by MANI NAIR on 18/02/21.
//  Copyright © 2021 com.siddharthnair. All rights reserved.
//

import SwiftUI
import Firebase

struct ProfileView : View {
    
    @Binding var show : Bool
    @State var stepGoalLocal: String
    @State var color = Color.black.opacity(0.7)
    
    

    
    var body: some View {
                
         ZStack{
        
            ZStack(alignment: .topLeading) {
            
            GeometryReader{_ in
                
                VStack{
                    
                    Text("Profile")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black.opacity(0.7))
                    
                                
                    
                    
                    Text("Elder's Step Goal")
                    TextField("Number of steps", text: self.$stepGoalLocal, onCommit: {
                        
                        print("New step goal value: \(self.stepGoalLocal)")
                        UserDefaults.standard.set(self.stepGoalLocal, forKey: "stepGoal")
                        NotificationCenter.default.post(name: NSNotification.Name("stepGoal"), object: nil)
                        print(UserDefaults.standard.value(forKey: "stepGoal") as! String)
                        
                        
                    })
                    .keyboardType(.numberPad)
                    .autocapitalization(.none)
                    .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.stepGoalLocal != "" ? Color("Color") : self.color, lineWidth: 2))
                    .padding(.top, 25)
                    
                    
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
                            .frame(width: UIScreen.main.bounds.width - 50)
                    }
                    .background(Color("Color"))
                    .cornerRadius(10)
                    .padding(.top, 25)
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
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
