//
//  MapViewController.swift
//  FreeParkingSpots
//
//  Created by Ilgar Ilyasov on 12/11/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var parkingLotMapView: MKMapView!
    
    let locationManager = CLLocationManager()
    private var userTrackingButton: MKUserTrackingButton!
    private let regionInMeters = 15000.0
//    var parkingSpotController = ParkingSpotController()
    
    var parkingSpots = [ParkingSpot]() {
        didSet {
            let oldPS = Set(oldValue)
            let newPS = Set(parkingSpots)

            let addedPS = Array(newPS.subtracting(oldPS))
            let removedPS = Array(oldPS.subtracting(newPS))

            DispatchQueue.main.async {
                self.parkingLotMapView.removeAnnotations(removedPS)
                self.parkingLotMapView.addAnnotations(addedPS)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        parkingLotMapView.delegate = self
        parkingLotMapView.showsUserLocation = true
        
        checkLocationServices()
        setupUserTrackinButton()
        
        parkingLotMapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ParkingSpotAnnotationView")
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handlePress(gesture:)))
        longPressRecognizer.delegate = self
        longPressRecognizer.minimumPressDuration = 1.5
        parkingLotMapView.isUserInteractionEnabled = true
        parkingLotMapView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func handlePress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let coordinatePoint = gesture.location(in: parkingLotMapView)
            let coordinate = parkingLotMapView.convert(coordinatePoint, toCoordinateFrom: parkingLotMapView)
            parkingLotMapView.setCenter(coordinate, animated: true)
            
            let annotation = ParkingSpot(coordinate: coordinate)
            parkingLotMapView.addAnnotation(annotation)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        parkingSpots = ParkingSpotController.shared.parkingSpots
//        parkingLotMapView.addAnnotations(ParkingSpotController.shared.parkingSpots)
    }
    
    func checkLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
            parkingLotMapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        } else {
            
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            centerViewOnUserLocation()
            parkingLotMapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        }
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            parkingLotMapView.setRegion(region, animated: true)
        }
    }
    
    func setupUserTrackinButton() {
        userTrackingButton = MKUserTrackingButton(mapView: parkingLotMapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        parkingLotMapView.addSubview(userTrackingButton)
        userTrackingButton.leftAnchor.constraint(equalTo: parkingLotMapView.leftAnchor, constant: 15).isActive = true
        userTrackingButton.bottomAnchor.constraint(equalTo: parkingLotMapView.bottomAnchor, constant: -15).isActive = true
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let parkingSpot = annotation as? ParkingSpot else { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ParkingSpotAnnotationView", for: parkingSpot) as! MKMarkerAnnotationView
        
        annotationView.glyphTintColor = .white
        annotationView.glyphImage = UIImage(named: "parkingSign-32")
        annotationView.canShowCallout = true
        
        return annotationView
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}


extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        parkingLotMapView.setRegion(region, animated: true)
    }
}
