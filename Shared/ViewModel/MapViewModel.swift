//
//  MapViewModel.swift.swift
//  Beliski
//
//  Created by Losd wind on 2021/11/25.
//

import MapKit
import SwiftUI
import Firebase
import GeoFireUtils
class MapViewModel:NSObject,ObservableObject, CLLocationManagerDelegate{
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:89.417222 , longitude: 43.075), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    
    @Published var currentLocation:CLLocation?
    
    
    // SearchText...
    @Published var searchTxt = ""
    
    // Searched Places...
    @Published var places : [MKPlacemark] = [MKPlacemark]()
    
    
    @Published var alertMessage:String?
    
    var locationManager:CLLocationManager?
    
    
    func checkIfLocationServiceEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager = CLLocationManager()
            locationManager?.delegate = self
        } else {
            self.alertMessage = "Location service was diabled, please go to enbale in the settings"
            locationManager?.requestAlwaysAuthorization()
        }
    }
    
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.region = MKCoordinateRegion(center: locationManager?.location?.coordinate ?? CLLocationCoordinate2D(latitude: 43.075, longitude: 89.417222), span:MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            locationManager?.startUpdatingLocation()
            //            locationManager?.allowsBackgroundLocationUpdates = true
        case .notDetermined, .restricted, .denied:
            locationManager?.requestAlwaysAuthorization()
        @unknown default:
            fatalError()
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.currentLocation = locations.last
    }
    
    
    func reverseGeoCoding(location:CLLocation, completion: @escaping (_ placemark: CLPlacemark?) -> ()) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            guard let placemark = placemarks?.first else {
                completion(nil)
                return}
            //            completion("\(String(describing: placemark.locality)),\(String(describing: placemark.administrativeArea)), \(placemark.country)")
            completion(placemark)
            return
            
            
        }
    }
    
    
    func getOneTimeLocation(completion: @escaping (_ placeName: String) -> ()){
        switch locationManager?.authorizationStatus {
            
        case .none:
            locationManager?.requestLocation()
            
        case .some(_):
            break
        }
        
        
        
    }
    
    
    func searchQuery(completion: @escaping (_ placemarks:[MKPlacemark]) -> ()){
        
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchTxt
        
        // Fetch...
        MKLocalSearch(request: request).start { (response, _) in
            
            guard let result = response else{return}
            
            completion(result.mapItems.compactMap{$0.placemark})
        }
    }
    
    
    
    func geohash(location:CLLocation) -> String {
        return GFUtils.geoHash(forLocation: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
    }
    
    
    // send location log to firebase
    func extractPlace(location: CLLocation,completion: @escaping (_ place:Place) -> () ) {
        // Add the hash and the lat/lng to the document. We will use the hash
        // for queries and the lat/lng for distance comparisons.
        reverseGeoCoding(location: location){
            placemark in
            if let placemark = placemark {
                
                let hash = self.geohash(location: location)
                
                completion(Place(geohash: hash, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, locality: placemark.locality ?? "", administrationArea: placemark.administrativeArea ?? "", country: placemark.country ?? ""))
                
            }
        }
        
        
        
        
    }
    
    
    
}
