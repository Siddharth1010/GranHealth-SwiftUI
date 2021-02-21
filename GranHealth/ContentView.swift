//
//  ContentView.swift
//  GranHealth
//
//  Created by MANI NAIR on 17/02/21.
//  Copyright © 2021 com.siddharthnair. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Home : View {
    
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    @State var flag: Int = 0
    @State var email: String = ""
    
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                if self.status && self.flag == 1{
                    
                    HomescreenUser(email: self.email)
                }
                    
                else if self.status && self.flag == 2{
                        
                    HomescreenRecipient(email: self.email)
                    }
                else{
                    
                    ZStack{
                        
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                            
                            Text("")
                        }
                        .hidden()
                        
                        Login(show: self.$show, flag: self.$flag, email: self.$email)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
//            .edgesIgnoringSafeArea([.top, .bottom])
            .onAppear {

                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in

                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false

                }
            }
        }
    }
}


struct HomescreenUser : View {
    
    @State var show = false
    @State var email: String
    
    var body: some View{
        
        
        NavigationView{
            
            VStack{
                
                ZStack{
                    
                    NavigationLink(destination: ProfileView(show: self.$show), isActive: self.$show){
                        
                        Text("")
                    }
                .hidden()
                    
                    MainView(show: self.$show)
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)

        }
        
    }
}


struct MainView : View {
    
    @Binding var show : Bool
    @State var isActive = false
    
    
    
    var categories:[String:[Health]] {
        .init(
            grouping: healthData, by: {$0.category}
        )
    }
    
    var body: some View {
        
        ZStack{
        
        ZStack (alignment: .topTrailing) {
            
        GeometryReader{_ in
            
            NavigationView{
                
                List(self.categories.keys.sorted(), id: \String.self) { key in
                    
                    HealthRow(categoryName: "\(key)".uppercased(), healthCats: self.categories[key]!, show: self.$show, isActive: self.$isActive)
                        .frame(height: 320)
                        .padding(.top)
                        .padding(.bottom)
                    
                }
                
            .navigationBarTitle(Text("GRANHEALTH"))
                
            }
            .accentColor(Color("Color"))
            
            
            
            
            } // Geometry Reader ends
            
            Button(action: {
                    withAnimation{
                    self.show.toggle()
                    }
                    
                }) {
                    
                    Image(systemName: "person.circle.fill")
                    .font(.title)
                    .foregroundColor(Color("Color"))
                }
            .padding()
            
            }
        }
            
            
    }
}

struct Login : View {
    
    @State var color = Color.black.opacity(0.7)
//    @State var email = ""
    
    @State var pass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    @Binding var flag: Int
    @Binding var email: String
    
    var body: some View{
        
        ZStack{
        
        ZStack (alignment: .topTrailing) {
            
        GeometryReader{_ in
        
        VStack{
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Text("Log in to your account")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(self.color)
                .padding(.top, 35)
            
            TextField("Email", text: self.$email)
                .autocapitalization(.none)
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color, lineWidth: 2))
                .padding(.top, 25)
            
            HStack(spacing: 15){
                
                VStack{
                    
                    if self.visible{
                        
                        TextField("Password", text: self.$pass)
                            .autocapitalization(.none)
                    }
                    else{
                        SecureField("Password", text: self.$pass)
                            .autocapitalization(.none)
                    }
                }
                
                Button(action: {
                    self.visible.toggle()
                    
                }) {
                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(self.color)
                }
                
                
            }
        .padding()
        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : self.color, lineWidth: 2))
        .padding(.top, 25)
            
            HStack{
                
                Spacer()
                Button(action: {
                    
                    self.reset()
                    
                }) {
                    
                    Text("Forgot Password")
                        .fontWeight(.bold)
                    .foregroundColor(Color("Color"))
                }
            }
            .padding(.top, 20)
            
            Button(action: {
                
                self.verify()
                
            }) {
                
                Text("Log In As User")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
                    
            }
            .background(Color("Color"))
            .cornerRadius(10)
            .padding(.top, 25)
            
            
            Button(action: {
                
                self.verify2()
                
            }) {
                
                Text("Log In As Recipient")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
                    
            }
            .background(Color("Color"))
            .cornerRadius(10)
            .padding(.top, 15)
            
            
        }  // Main Vertical Stack ends
            .padding(.horizontal, 25)
            
            
            
            } //Geometry Reader Ends here
        
            Button(action: {
                withAnimation{
                self.show.toggle()
                }
                
            }) {
                
                Text("Register")
                    .fontWeight(.bold)
                    .foregroundColor(Color("Color"))
            }
        .padding()
            
        
        }  // Inner ZStack Ends
            
            if self.alert{
                withAnimation{
                ErrorView(alert: self.$alert, error: self.$error)
                }
            }
            
        } //Main ZStack ends
        
        
        
    }
    
    func verify() {
        
        if self.email != "" && self.pass != "" {
            
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                print("Sucessfully logged in")
                
                self.flag = 1
                
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
            }
        }
        else{
            self.error = "Please fill the required fields"
            self.alert.toggle()
        }
    }
    
    
    func verify2() {
        
        if self.email != "" && self.pass != "" {
            
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                print("Sucessfully logged in")
                
                self.flag = 2
                
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
            }
        }
        else{
            self.error = "Please fill the required fields"
            self.alert.toggle()
        }
    }
    
    
    func reset(){
        
        if self.email != ""{
            
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                
                if err != nil{
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                    
                }
                
                self.error = "Password Reset"
                self.alert.toggle()
                
            }
        }
        
        else{
            self.error = "Email field is Empty"
            self.alert.toggle()
        }
    }
    
    
}



struct SignUp : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var repass = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View{
        
        ZStack{
            
            ZStack(alignment: .topLeading) {
                
                GeometryReader{_ in
                    
                    
                    VStack{
                        
                        Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
//                        .padding(.top, 80)
                        
                        Text("Register your account")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)
                        
                        HStack(spacing: 15){
                        
                        TextField("Email", text: self.$email)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        
                    }
                        
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.visible{
                                    
                                    TextField("Password", text: self.$pass)
                                    .autocapitalization(.none)
                                }
                                else{
                                    
                                    SecureField("Password", text: self.$pass)
                                    .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                
                                self.visible.toggle()
                                
                            }) {
                                
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.revisible{
                                    
                                    TextField("Re-enter", text: self.$repass)
                                    .autocapitalization(.none)
                                }
                                else{
                                    
                                    SecureField("Re-enter", text: self.$repass)
                                    .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                
                                self.revisible.toggle()
                                
                            }) {
                                
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.repass != "" ? Color("Color") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        
                        Button(action: {
                            
                            self.register()
                        }) {
                            
                            Text("Register")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color("Color"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                        
                    }
                    .padding(.horizontal, 25)
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
            
            if self.alert{
                
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("")
    }
    
    func register(){
        
        if self.email != ""{
            
            if self.pass == self.repass{
                
                Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
                    
                    if err != nil{
                        
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    print("Successfully registered")
                    
//                    UserDefaults.standard.set(true, forKey: "status")
//                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    
                    self.error = "Register Confirmed"
                    self.alert.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                       // Code you want to be delayed
                        self.show.toggle()
                    }
                    
                    
                    
                }
            }
            else{
                
                self.error = "Passwords do not match"
                self.alert.toggle()
            }
        }
        else{
            
            self.error = "Please fill the required fields"
            self.alert.toggle()
        }
    }
}
