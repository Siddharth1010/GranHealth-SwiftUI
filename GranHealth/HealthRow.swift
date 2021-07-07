
import SwiftUI

// View for each category of Carousel
struct HealthRow: View {
    
    var categoryName:String
    // Array of Health structure for all carousel categories and details
    var healthCats:[Health]
    
    @Binding var show:Bool
    @Binding var isActive:Bool
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            // Display the category
            Text(self.categoryName)
                .font(.title)
            // Horizontal Scrolling Carousel
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack(alignment: .top) {
                    
                    // Loop through each Carousel category
                    ForEach (healthCats, id: \.self) { health in
                        
                        // Navigation Link to detail view for each feature
                        NavigationLink(destination: HealthDetail(health: health, show: self.$show, isActive: self.$isActive)){
                            
                            // Display each feature (item) through HealthItem view
                            HealthItem(health: health, show: self.$show)
                                .frame(width: 300)
                                .padding(.trailing, 30)
                            
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            
                            // Print view active status for debug purposes
                            print(self.isActive)
                            
                        })
                        
                        
                    }
                    
                }
                
            }
            
        }
        
        
        
        
    }
}

