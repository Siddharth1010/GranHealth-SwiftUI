
import SwiftUI
import Firebase

// Detail view based on the option selected from the carousel
struct HealthDetail: View {
    
    var health:Health
    
    @Binding var show:Bool
    @Binding var isActive:Bool
    let db = Firestore.firestore()
    var body: some View {
        
        
        VStack{
            // Check if user selected Heart Rate and call view accordingly
            if self.health.name == "Heart-Rate"{
                
                HeartRate()
            }
            // Check if user selected Steps and call view accordingly
            else if self.health.name == "Steps"{
                
                Steps()
            }
            // Check if user selected Walking / Running Distance and call view accordingly
            else if self.health.name == "Walking / Running Distance"{
                
                Distance()
            }
            // Check if user selected Flights Climbed and call view accordingly
            else if self.health.name == "Flights Climbed"{
                
                Flights()
            }
            // Check if user selected Step Length and call view accordingly
            else if self.health.name == "Step Length"{
                
                StepLength()
            }
            // Check if user selected Walking Speed and call view accordingly
            else if self.health.name == "Walking Speed"{
                
                WalkingSpeed()
            }
            // Check if user selected Location and call view accordingly
            else if self.health.name == "Location"{
                
                Location()
            }
            
            
        }
        
        
        
    }
    
    
}





