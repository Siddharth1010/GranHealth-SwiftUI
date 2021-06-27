
import Foundation
import MapKit

// Create LocationManager class conforming to ObservableObject
class LocationManager: NSObject, ObservableObject {
    
    private let locationManager = CLLocationManager()
    
    // Published var to ensure reflection in changes
    @Published var location: CLLocation? = nil
    
    // Override to provide the same initializer that the parent class already has
    // Get best accuracy, Background location updates and Start updating location
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.startUpdatingLocation()
    }
}

// Extension of LocationManager conforming to CLLocationManagerDelegate
extension LocationManager : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Get the last location and initialise self.location with the corresponding location
        guard let location = locations.last else{
            return
        }
        
            self.location = location
        
        
        
    }
}
