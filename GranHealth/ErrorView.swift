
import SwiftUI
import Firebase

// View to reveal errors in Logging-in / Registering  or status updates
struct ErrorView : View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert: Bool
    @Binding var error: String
    
    var body: some View{
        
        GeometryReader{_ in
            
            VStack{
                
                HStack{
                    
                    // Check if it is an error or status/mesage update and display accordingly
                    if self.error != "Register Confirmed"{
                    
                    Text(self.error == "Password Reset" ? "Message" : "Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    }
                    else{
                        
                        Text("Message")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                        
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                if self.error != "Register Confirmed"{
                
                    // Send link for password reset along with prompt
                Text(self.error == "Password Reset" ? "Password reset link has been sent successfully" : self.error)
                    .foregroundColor(self.color)
                    .padding(.top)
                    .padding(.horizontal, 25)
                    
                }
                // Provide status update in View - Successfully Registered
                else{
                    Text("Registered Successfully. Please log in as a user")
                    .foregroundColor(self.color)
                    .padding(.top)
                    .padding(.horizontal, 25)
                    
                }
                
                // Button to close the view once user reads message
                Button(action: {
                    
                    self.alert.toggle()
                }) {
                    
                    Text(self.error == "Password Reset" ? "OK" : "Cancel")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
            .background(Color("Color"))
            .cornerRadius(10)
            .padding(.top, 25)
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
        }

        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
        
    }
}

