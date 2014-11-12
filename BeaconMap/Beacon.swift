//
//  Beacon.swift
//  BeaconMap
//
//  Created by Johannes Heck on 12.11.14.
//  Copyright (c) 2014 Johannes Heck. All rights reserved.
//

import Foundation

class Beacon: NSObject {
    
    var uuid: NSString
    var lat: NSString?
    var lng: NSString?
    var localName: NSString?
    var txPowerLever: NSString?
    var rssi: NSString?
    var manufacturerData: NSString?
 
    init(uuid: NSString) {
        self.uuid = uuid
    }
    
}