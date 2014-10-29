//
//  AppDelegate.swift
//  BeaconMap
//
//  Created by Johannes Heck on 29.10.14.
//  Copyright (c) 2014 Johannes Heck. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)   -> Bool {
        
        let uuidString = "f7826da6-4fa2-4e98-8024-bc5b71e0893e"
        let beaconIdentifier = "Kontakt"
        let beaconUUID = NSUUID(UUIDString: uuidString)
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: beaconIdentifier)
        
        locationManager = CLLocationManager()
        if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager!.requestAlwaysAuthorization()
        }
        
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        locationManager!.startMonitoringForRegion(beaconRegion)
        locationManager!.startRangingBeaconsInRegion(beaconRegion)
        locationManager!.startUpdatingLocation()
        
        if(application.respondsToSelector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,
                    categories: nil
                )
            )
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

extension AppDelegate: CLLocationManagerDelegate {
    func sendLocalNotificationWithMessage(message: String!) {
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertBody = message
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        NSLog("didRangeBeacons");
        let viewController:ViewController = window!.rootViewController as ViewController
        viewController.beacons = beacons as [CLBeacon]?
        viewController.tableView!.reloadData()
        
        var message:String = ""
        if(beacons.count > 0) {
            let nearestBeacon:CLBeacon = beacons[0] as CLBeacon
            
            if(nearestBeacon.proximity == lastProximity || nearestBeacon.proximity == CLProximity.Unknown) {
                return
            }
            lastProximity = nearestBeacon.proximity
            
            switch nearestBeacon.proximity {
            case CLProximity.Far:
                message = "You are far away from the beacon"
            case CLProximity.Near:
                message = "You are near the beacon"
            case CLProximity.Immediate:
                message = "You are in the immediate proximity of the beacon"
            case CLProximity.Unknown:
                return
            }
        } else {
            if(lastProximity == CLProximity.Unknown) {
                return
            }
            message = "No beacons nearby"
        }
        
        NSLog("Latitude: %@", locationManager!.location.coordinate.latitude.description)
        NSLog("Longitude: %@", locationManager!.location.coordinate.longitude.description)
        NSLog("Altitude: %@", locationManager!.location.altitude.description)
        NSLog("%@", message)
        sendLocalNotificationWithMessage(message)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
        manager.startUpdatingLocation()
        NSLog("You entered the region")
        sendLocalNotificationWithMessage("You entered the Region")
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
        manager.stopUpdatingLocation()
        
        NSLog("You exited the region")
        sendLocalNotificationWithMessage("You exited the region")
    }
}