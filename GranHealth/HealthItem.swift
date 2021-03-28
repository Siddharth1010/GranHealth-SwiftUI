
import SwiftUI

struct HealthItem: View {
    
    var health:Health
    
    @Binding var show:Bool
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16.0) {
        Image(health.imageName)
        .resizable()
        .renderingMode(.original)
        .aspectRatio(contentMode: .fill)
        .frame(width: 300, height: 170)
        .cornerRadius(10)
        .shadow(radius: 10)
            
            VStack(alignment: .leading, spacing: 5.0) {
            Text(health.name)
            .foregroundColor(Color("Color"))
            .font(.headline)
            
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

//struct HealthItem_Previews: PreviewProvider {
//    static var previews: some View {
//        HealthItem(health: healthData[0])
//    }
//}
