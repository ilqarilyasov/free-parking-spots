//
//  User.swift
//  FreeParkingSpots
//
//  Created by Ilgar Ilyasov on 12/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation

struct User {
    
    let name: String
    let email: String
    let password: String
    let parkingSpots: [ParkingSpot]
    
    init(name: String = "Tim", email: String = "tim@apple.com", password: String = "password", parkingSpots: [ParkingSpot] = []) {
        self.name = name
        self.email = email
        self.password = password
        self.parkingSpots = parkingSpots
    }
}
