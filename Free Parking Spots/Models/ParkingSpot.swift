//
//  ParkingSpot.swift
//  FreeParkingSpots
//
//  Created by Ilgar Ilyasov on 12/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import CoreLocation

struct ParkingSpot {
    
    let name: String
    let image: UIImage
    let detail: String
    let location: CLLocationCoordinate2D
    let timestamp: Date
    let addedBy: User
}
