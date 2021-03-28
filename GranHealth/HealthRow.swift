
import SwiftUI

struct HealthRow: View {
    
    var categoryName:String
    var healthCats:[Health]
    
    @Binding var show:Bool
    @Binding var isActive:Bool
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            Text(self.categoryName)
                .font(.title)
        
            ScrollView(.horizontal,showsIndicators: false) {
            
            HStack(alignment: .top) {
                
                
            ForEach (healthCats, id: \.self) { health in
                
                NavigationLink(destination: HealthDetail(health: health, show: self.$show, isActive: self.$isActive)){
                    
                HealthItem(health: health, show: self.$show)
                .frame(width: 300)
                .padding(.trailing, 30)
                    
        
                    
                }
                .simultaneousGesture(TapGesture().onEnded{
//                    self.isActive = true
//                    self.isActive.toggle()
                    print(self.isActive)
                    
                })
                
                    
            }
                
            }
            
        }
            
        }
        
        
        
        
    }
}

//struct HealthRow_Previews: PreviewProvider {
//    static var previews: some View {
//        HealthRow(categoryName: "HEART AND MOTION", healthCats: healthData)
//    }
//}
