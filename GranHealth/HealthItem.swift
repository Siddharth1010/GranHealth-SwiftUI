
import SwiftUI

// Style and view for each item in main carousel
struct HealthItem: View {
    
    var health:Health
    
    @Binding var show:Bool
    
    var body: some View {
        
        // Image name based on index of array of Health
        VStack(alignment: .leading, spacing: 16.0) {
            Image(health.imageName)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 170)
                .cornerRadius(10)
                .shadow(radius: 10)
            
            // Service name based on index of array of Health
            VStack(alignment: .leading, spacing: 5.0) {
                Text(health.name)
                    .foregroundColor(Color("Color"))
                    .font(.headline)
                
                // Description based on index of array of Health
                Text(health.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(height: 40)
                
            }
        }
        
        
        
        
    }
}

