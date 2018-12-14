//
//  ParkingSpot.swift
//  FreeParkingSpots
//
//  Created by Ilgar Ilyasov on 12/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ParkingSpot: NSObject, MKAnnotation {
    
    let name: String
    let images: [UIImage]
    let detail: String
    let location: CLLocationCoordinate2D
    let timestamp: Date
    let addedBy: User
    
    init(name: String, images: [UIImage], detail: String, location: CLLocationCoordinate2D, timestamp: Date = Date(), addedBy: User) {
        self.name = name
        self.images = images
        self.detail = detail
        self.location = location
        self.timestamp = timestamp
        self.addedBy = addedBy
    }
    
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(name: "New", images: [UIImage](), detail: "No Detail", location: coordinate, addedBy: User())
    }
    
    var coordinate: CLLocationCoordinate2D {
        return self.location
    }
    
    var title: String? {
        return self.name
    }
}
