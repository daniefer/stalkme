//
//  Profile.swift
//  RouteBasedAlerts
//
//  Created by Daniel Ferguson on 8/5/16.
//  Copyright © 2016 Daniel Ferguson. All rights reserved.
//

import Foundation
import CoreLocation

class Profile {
    var locationHistory: [CLLocationCoordinate2D!];
    
    
    
    init() {
        self.locationHistory = [];
    }
    
    func addLocation(location: CLLocationCoordinate2D) -> Void {
        self.locationHistory.append(location);
        //print(self.locationHistory.debugDescription);
    }
    
    var isStationary: Bool {
        get {
            return false;
        }
    }
    
    
}