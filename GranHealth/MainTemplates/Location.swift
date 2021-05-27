
import MapKit
import SwiftUI
import Firebase
import Contacts

struct Location: View {
    
    @State private var directions: [String] = []
    @State private var showDirections = false
    
    
    let db = Firestore.firestore()
    var body: some View {
        VStack{
            MapView(directions: $directions)
            
            Button(action: {
                
                self.showDirections.toggle()
                
            }, label: {
                Text("Show Directions")
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 50)
            })
                .disabled(directions.isEmpty)
//                .padding()
//                .padding()
            .background(Color("Color"))
            .cornerRadius(10)
        }
        .padding(.top, -50)
        .sheet(isPresented: $showDirections, content: {
            VStack{
                Text("Directions")
                    .font(.largeTitle)
                .bold()
                .padding()
                
                Divider().background(Color.blue)
                
                List{
                    ForEach(0..<self.directions.count, id: \.self) { i in
                        
                        Text(self.directions[i])
                        .padding()
                    }
                }
            }
        })
    }
    
}

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    @ObservedObject private var locationManager = LocationManager()
    @Binding var directions: [String]
    @State var elderLatitude: CLLocationDegrees = 0
    @State var elderLongitude: CLLocationDegrees = 0
    let db = Firestore.firestore()
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 13.0827, longitude: 80.2707), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        
        
        if let user = Auth.auth().currentUser?.email {

                    self.db.collection(user).addSnapshotListener { (querySnapshot, error) in
                        if let e = error {
                            print("Elder location values could not be retreived from firestore: \(e)")
                        } else {
                            if let snapshotDocs = querySnapshot?.documents {
                                for doc in snapshotDocs {
                                    if doc.documentID == "LocationCoordinates"{
                                
                                        self.elderLatitude = doc.data()["latitude"]! as! CLLocationDegrees
                                        self.elderLongitude = doc.data()["longitude"]! as! CLLocationDegrees
                                        
                                        
                                        print("Inside Firestore Block: Latitude of elderly: \(self.elderLatitude), Longitude of elderly : \(self.elderLongitude)")
                                    
                                    
                                    }
                                }
                            }
                        }
                    }
                }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
           // Code you want to be delayed
            let coordinateUser = self.locationManager.location != nil ? self.locationManager.location!.coordinate : CLLocationCoordinate2D()
            print("Latitude of elderly: \(self.elderLatitude), Longitude of elderly : \(self.elderLongitude)")
            
            print("Latitude of user: \(coordinateUser.latitude), Longitude of user : \(coordinateUser.longitude)")
            let coordinateElder = CLLocationCoordinate2D(latitude: self.elderLatitude, longitude: self.elderLongitude)
            
            
            let elderloc = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.elderLatitude, longitude: self.elderLongitude))
            
            let elderloc1 = MapPin(title:"Elder", locationName: "Device Location", coordinate: coordinateElder)
            let userloc1 = MapPin(title:"You", locationName: "Device Location", coordinate: coordinateUser)
            
            
//            addressDictionary: [String(CNPostalAddressStreetKey): "Elder", String(CNPostalAddress): ""]
//            let userloc = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 13.0837, longitude: 80.1750))
            let userloc = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: coordinateUser.latitude, longitude: coordinateUser.longitude))
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userloc)
            request.source?.name = "User"
            request.destination = MKMapItem(placemark: elderloc)
            request.destination?.name = "Elder"
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            directions.calculate{ response, error in
                guard let route = response?.routes.first else { return }
                mapView.addAnnotations([userloc1, elderloc1])
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
                self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty}
            }
            
        }
        
        
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    class MapViewCoordinator : NSObject, MKMapViewDelegate {
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
    
    
}

class MapPin: NSObject, MKAnnotation {
   let title: String?
   let locationName: String
   let coordinate: CLLocationCoordinate2D
init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
      self.title = title
      self.locationName = locationName
      self.coordinate = coordinate
   }
}
