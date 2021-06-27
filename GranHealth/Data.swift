
import Foundation

// Load contents of JSON file (Carousel)
let healthData:[Health] = load("health.json")

// Function to load JSON file contents and handle errors
func load<T: Decodable>(_ filename:String, as type:T.Type = T.self) -> T {
    
    let data:Data
    // Search for file in main bundle
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else{
            fatalError("Couldnt find \(filename) in main bundle")
    }
    // Extract contents of JSON file
    do{
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldnt load \(filename) from main bundle:\n\(error)")
    }
    
    // Decode JSON and return to array of Health
    do{
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldnt pass \(filename) as \(T.self):\n\(error)")
    }
    
}
