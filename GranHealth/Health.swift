
import SwiftUI

struct Health: Hashable, Codable, Identifiable {
    
    var id:Int
    var name:String
    var imageName:String
    var category:String
    var description:String
    
//    enum Category: String, CodingKey {
//        case mobility = "Mobility"
//        case location = "Location"
//        case heart = "Heart"
//    }
}
