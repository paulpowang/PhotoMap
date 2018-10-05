//
//  PinAnnotation.swift
//  Photo Map
//
//  Created by paul on 10/5/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import MapKit
import AddressBook

class PinAnnotation: NSObject, MKAnnotation {
    
    let title : String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
}
