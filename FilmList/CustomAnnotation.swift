//
//  StPetersburgAnnotation.swift
//  InMarket
//
//  Created by Kurt on 17.05.16.
//  Copyright © 2016 Evgeny Koshkin. All rights reserved.
//

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var phone: String!
    var name: String!
    var address: String!
    var image: UIImage!
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}