//
//  DateTransformInteger.swift
//  GoogleMapsDirections
//
//  Created by varun.polanki
//  Copyright varun.polanki. All rights reserved.
//

import Foundation
import ObjectMapper

class DateTransformInteger: TransformType {
    typealias Object = Date
    typealias JSON = Int
    
    init() {}
    
    func transformFromJSON(_ value: Any?) -> Date? {
        if let timeInt = value as? Int {
            return Date(timeIntervalSince1970: TimeInterval(timeInt))
        }
        
        if let timeStr = value as? String {
            return Date(timeIntervalSince1970: TimeInterval(atof(timeStr)))
        }
        
        return nil
    }
    
    func transformToJSON(_ value: Date?) -> Int? {
        if let date = value {
            return Int(date.timeIntervalSince1970)
        }
        return nil
    }
}
