//
//  MapViewController.swift
//  iBeaconTutorial
//
//  Created by Piera Marchesini on 09/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var beacon3 = Point(position: (x: 9, y: 0), distance: 0, txPowerMoving: -64, txPowerStatic: -60)
    var beacon2 = Point(position: (x: 0, y: 0), distance: 0, txPowerMoving: -66, txPowerStatic: -64)
    var beacon1 = Point(position: (x: 0, y: 20), distance: 0, txPowerMoving: -69, txPowerStatic: -66)

    var previousDisB1: Double = 0
    var previousDisB2: Double = 0
    var previousDisB3: Double = 0
    var first = true
    //var beacon1 = Point(position: (x: 4.5, y: 19.5), distance: 0, txPowerMoving: -58, txPowerStatic: 0)
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var localizacao: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        startScanning()
        
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 30969, minor: 18337, identifier: "Beacon1")
        let beaconRegion2 = CLBeaconRegion(proximityUUID: uuid, major: 33119, minor: 33895, identifier: "Beacon2")
        let beaconRegion3 = CLBeaconRegion(proximityUUID: uuid, major: 35079, minor: 46811, identifier: "Beacon3")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        
        locationManager.startMonitoring(for: beaconRegion2)
        locationManager.startRangingBeacons(in: beaconRegion2)
        
        locationManager.startMonitoring(for: beaconRegion3)
        locationManager.startRangingBeacons(in: beaconRegion3)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let dis = beacons[0].accuracy
            //Verifica se não está unknown
            if  dis > 0 {
                if first {
                    switch beacons[0].major {
                    case 30969:
                        beacon1.distance = calculateRealDistance(txCalibratedPower: beacon1.txPowerMoving, rssi: beacons[0].rssi)
                        previousDisB1 = beacon1.distance
                    case 33119:
                        beacon2.distance = calculateRealDistance(txCalibratedPower: beacon2.txPowerMoving, rssi: beacons[0].rssi)
                        previousDisB2 = beacon2.distance
                    case 35079:
                        beacon3.distance = calculateRealDistance(txCalibratedPower: beacon3.txPowerMoving, rssi: beacons[0].rssi)
                        previousDisB3 = beacon3.distance
                    default:
                        print("Erro")
                    }
                    first = false
                }
                else {
                    switch beacons[0].major {
                    case 30969:
                        let realDistance = calculateRealDistance(txCalibratedPower: beacon1.txPowerMoving, rssi: beacons[0].rssi)
                        if abs(realDistance - previousDisB1) < 3 {
                            beacon1.distance = realDistance
                            previousDisB1 = beacon1.distance
                        }
                    case 33119:
                        let realDistance = calculateRealDistance(txCalibratedPower: beacon2.txPowerMoving, rssi: beacons[0].rssi)
                        if abs(realDistance - previousDisB2) < 3 {
                            beacon2.distance = realDistance
                            previousDisB2 = beacon2.distance
                        }
                    case 35079:
                        let realDistance = calculateRealDistance(txCalibratedPower: beacon3.txPowerMoving, rssi: beacons[0].rssi)
                        if abs(realDistance - previousDisB3) < 3 {
                            beacon3.distance = realDistance
                            previousDisB3 = beacon3.distance
                        }
                    default:
                        print("Erro")
                    }
                }
                
            }
            self.localizacao.text = IndoorLocalization.trilateration(point1: beacon1, point2: beacon2, point3: beacon3)
        }
    }
    
    func calculateRealDistance(txCalibratedPower: Int, rssi: Int) -> Double{
        let ratioDB = txCalibratedPower - rssi
        let rationLinear = pow(10.0, Double(ratioDB)/20)
        print("\n\n\n  txPower: \(txCalibratedPower) rssi: \(rssi)    distancia: \(rationLinear)")
        return rationLinear
    }
}
