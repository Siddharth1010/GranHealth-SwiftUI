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
    
    var body: some View {
        
        ZStack{
        
        ZStack(alignment: .topLeading) {
            
            GeometryReader{_ in
                
                VStack{
                    
                    Text("Welcome to the profile page")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.black.opacity(0.7))
                    
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
