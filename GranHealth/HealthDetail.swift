
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
        

        
    }
    
    
}





