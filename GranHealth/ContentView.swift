
import SwiftUI
import Firebase
import MapKit
import HealthKit

// Redirect to Home View on startup
struct ContentView: View {
    var body: some View {
        Home()
    }
}

// Show Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Declaration of Home View
struct Home : View {
    
    // Variable to toggle the sign up view between active and inactive
    @State var show = false
    
    // UserDefaults for logged in status
    // Prevents having to login / register each time the app is run
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    // Flag value which determines user access (caretaker or elder)
    @State var flag = UserDefaults.standard.value(forKey: "flag") as? Int ?? 0
    
    // Local Email ID
    @State var email: String = ""
    
    //UserDefaults to access Email ID in other parts of the script
    @State var globalEmail = UserDefaults.standard.value(forKey: "globalEmail") as? String ?? ""
    
    // UserDefaults to access the current step goal set by caretaker
    @State var stepGoal: String = UserDefaults.standard.value(forKey: "stepGoal") as? String ?? "50"
    
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                // If logged in and flag =1 user Home Screen View for the caretaker is called
                if self.status && self.flag == 1{
                    
                    HomescreenUser(email: self.email)
                }
                
                // If logged in and flag =2 user Home Screen View for the elder is called
                else if self.status && self.flag == 2{
                    
                    HomescreenRecipient(email: self.email)
                }
                else{
                    
                    ZStack{
                        
                        // NavigationLink to sign up View
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                            
                            Text("")
                        }
                        .hidden()
                        
                        // Call the Login View
                        Login(show: self.$show, email: self.$email)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
            //Adds an entry to the notification center to receive notifications that passed to the provided block
            .onAppear {
                
                // Set default value of status as false
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    
                }
                
                // Set default value of flag as 0
                NotificationCenter.default.addObserver(forName: NSNotification.Name("flag"), object: nil, queue: .main) { (_) in
                    
                    self.flag = UserDefaults.standard.value(forKey: "flag") as? Int ?? 0
                }
                
                // Set default value of globalEmail as ""
                NotificationCenter.default.addObserver(forName: NSNotification.Name("globalEmail"), object: nil, queue: .main) { (_) in
                    
                    self.globalEmail = UserDefaults.standard.value(forKey: "globalEmail") as? String ?? ""
                }
                
                // Set default value of stepGoal as 50
                NotificationCenter.default.addObserver(forName: NSNotification.Name("stepGoal"), object: nil, queue: .main) { (_) in
                    
                    self.stepGoal = UserDefaults.standard.value(forKey: "stepGoal") as? String ?? "50"
                }
                
                if UserDefaults.standard.value(forKey: "stepGoal") as? String == nil {
                    UserDefaults.standard.set("50", forKey: "stepGoal")
                }
                
                
            }
        }
    }
}

// View for the Home screen of the caretaker
struct HomescreenUser : View {
    
    @State var show = false
    @State var email: String
    
    var body: some View{
        
        
        NavigationView{
            
            VStack{
                
                ZStack{
                    
                    // Navigation link to the Profile View on the caretakers device
                    NavigationLink(destination: ProfileView(show: self.$show,stepGoalLocal: UserDefaults.standard.value(forKey: "stepGoal") as? String ?? "50" ), isActive: self.$show){
                        
                        Text("")
                    }
                    .hidden()
                    
                    // Load the MainView of the caretakers
                    MainView(show: self.$show)
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
        }
        
    }
}

// Main Home Screen View for the caretakers device
struct MainView : View {
    
    // Variable to show and toggle the status of the Health Item
    @Binding var show : Bool
    @State var isActive = false
    
    // Grouping the various carousel items in an array of dictionaries
    // Category : Items in Category
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
                        
                        // Lists the different categories available
                        List(self.categories.keys.sorted(), id: \String.self) { key in
                            
                            // Displays the carousel row view with the required subcategories
                            // passed as a paramter
                            HealthRow(categoryName: "\(key)".uppercased(), healthCats: self.categories[key]!, show: self.$show, isActive: self.$isActive)
                                .frame(height: 320)
                                .padding(.top)
                                .padding(.bottom)
                            
                        }
                        
                        .navigationBarTitle(Text("GRANHEALTH"))
                        
                    }
                    .accentColor(Color("Color"))
                    
                    
                    
                    
                } // Geometry Reader ends
                
                // Button to toggle binding var show which toggles profile view
                Button(action: {
                    withAnimation{
                        self.show.toggle()
                    }
                    
                }) {
                    
                    // Standard user icon as button
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                        .foregroundColor(Color("Color"))
                }
                .padding()
                
            }
        }
        
        
    }
}

// View to log in to the application
struct Login : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var pass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
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
                            .padding(.top, 25)
                        
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
                            
                            Text("Log In as User")
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
                            
                            Text("Log In as Elder")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                            
                        }
                        .background(Color("Color"))
                        .cornerRadius(10)
                        .padding(.top, 15)
                        
                        
                    }  // Main Vertical Stack ends
                    .padding(.horizontal, 25)
                    //        .padding(.vertical, 40)
                    
                    
                    
                    
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
                
                //                self.flag = 1
                UserDefaults.standard.set(1,forKey: "flag")
                NotificationCenter.default.post(name: NSNotification.Name("flag"), object: nil)
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                UserDefaults.standard.set(self.email, forKey: "globalEmail")
                NotificationCenter.default.post(name: NSNotification.Name("globalEmail"), object: nil)
                
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
                
                //                self.flag = 2
                UserDefaults.standard.set(2,forKey: "flag")
                NotificationCenter.default.post(name: NSNotification.Name("flag"), object: nil)
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                UserDefaults.standard.set(self.email, forKey: "globalEmail")
                NotificationCenter.default.post(name: NSNotification.Name("globalEmail"), object: nil)
                
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
