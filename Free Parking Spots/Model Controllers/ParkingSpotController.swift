//
//  ParkingSpotController.swift
//  FreeParkingSpots
//
//  Created by Ilgar Ilyasov on 12/13/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ParkingSpotController {
    
    static var shared = ParkingSpotController()
    private init() {}
    
    var parkingSpots = [ParkingSpot]()
    
    func createParkingSpot(name: String, images: [UIImage], detail: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, addedBy: User = User()) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let newParkingSpot = ParkingSpot(name: name, images: images, detail: detail, location: coordinate, addedBy: addedBy)
        parkingSpots.append(newParkingSpot)
    }
}
