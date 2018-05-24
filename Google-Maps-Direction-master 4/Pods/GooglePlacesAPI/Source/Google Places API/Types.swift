//
//  Types.swift
//  GooglePlaces
//
//  Created by varun.polanki
//  Copyright varun.polanki. All rights reserved.
//

import Foundation

public extension GooglePlaces {
    public enum PlaceType: String {        
        case geocode = "geocode"
        case address = "address"
        case establishment = "establishment"
        case regions = "(regions)"
        case cities = "(cities)"
    }
}
