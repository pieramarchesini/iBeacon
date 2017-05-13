//
//  ViewController.swift
//  iBeaconTutorial
//
//  Created by Piera Marchesini on 09/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var beacon1: UIView!
    @IBOutlet weak var beacon2: UIView!
    @IBOutlet weak var beacon3: UIView!
    
    @IBOutlet weak var distance1: UILabel!
    @IBOutlet weak var distance2: UILabel!
    @IBOutlet weak var distance3: UILabel!
    
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Verificar se a autorização foi alterada
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
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
            switch beacons[0].major {
            case 30969:
                //vai pro update distance de um beacon
                updateDistanceBeacon(beacons[0].proximity, beacons[0].major, beacons[0].accuracy)
            case 33119:
                updateDistanceBeacon(beacons[0].proximity, beacons[0].major, beacons[0].accuracy)
            case 35079:
                updateDistanceBeacon(beacons[0].proximity, beacons[0].major, beacons[0].accuracy)
            default:
                print("What")
            }
        } else {
            //updateDistanceBeacon1(.unknown)
        }
    }
    
    func updateDistanceBeacon(_ distance: CLProximity, _ major: NSNumber, _ m: Double) {
        UIView.animate(withDuration: 0.8) {
            switch major {
            case 30969:
                self.distance1.text = "\(m)"
            case 33119:
                self.distance2.text = "\(m)"
            case 35079:
                self.distance3.text = "\(m)"
            default:
                print("")
            }
            switch distance {
            case .unknown:
                /*
                 switch major {
                 case 30969:
                 self.beacon1.backgroundColor = UIColor.gray
                 case 33119:
                 self.beacon2.backgroundColor = UIColor.gray
                 case 35079:
                 self.beacon3.backgroundColor = UIColor.gray
                 default:
                 */
                print("")
            case .far:
                switch major {
                case 30969:
                    self.beacon1.backgroundColor = UIColor.blue
                case 33119:
                    
                    self.beacon2.backgroundColor = UIColor.blue
                case 35079:
                    self.beacon3.backgroundColor = UIColor.blue
                default:
                    print("")
                }
            case .near:
                switch major {
                case 30969:
                    self.beacon1.backgroundColor = UIColor.yellow
                case 33119:
                    self.beacon2.backgroundColor = UIColor.yellow
                case 35079:
                    self.beacon3.backgroundColor = UIColor.yellow
                default:
                    print("")
                }
                
            case .immediate:
                switch major {
                case 30969:
                    self.beacon1.backgroundColor = UIColor.red
                case 33119:
                    self.beacon2.backgroundColor = UIColor.red
                case 35079:
                    self.beacon3.backgroundColor = UIColor.red
                default:
                    print("")
                }
            }
        }
    }
    @IBAction func goToMap(_ sender: Any) {
        self.performSegue(withIdentifier: "toMap", sender: self)
    }
    
}

