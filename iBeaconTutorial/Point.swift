//
//  Point.swift
//  iBeaconTutorial
//
//  Created by Piera Marchesini on 10/05/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import Foundation

public class Point {
    let position: (x: Double, y: Double)
    var distance: Double
    let txPowerMoving: Int
    let txPowerStatic: Int
    
    init(position: (x: Double, y: Double), distance: Double, txPowerMoving: Int, txPowerStatic: Int) {
        self.position = position
        self.distance = distance
        self.txPowerMoving = txPowerMoving
        self.txPowerStatic = txPowerStatic
    }
}

class IndoorLocalization {
    
    public static func trilateration(point1: Point, point2: Point, point3: Point) -> String{
        
        let x1 = point1.position.x
        let y1 = point1.position.y
        
        let x2 = point2.position.x
        let y2 = point2.position.y
        
        let x3 = point3.position.x
        let y3 = point3.position.y
        
        
        var P1 = [x1, y1]
        var P2 = [x2, y2]
        var P3 = [x3, y3]
        
        let DistA = point1.distance
        let DistB = point2.distance
        let DistC = point3.distance
        
        var ex: [Double] = []
        var tmp: Double = 0
        var P3P1: [Double] = []
        var ival: Double = 0
        var ey: [Double] = []
        var P3P1i: Double = 0
        var ez: [Double] = []
        var ezx: Double = 0
        var ezy: Double = 0
        var ezz: Double = 0
        
        // ex = (P2 - P1)/||P2-P1||
        for i in 0 ..< P1.count {
            let t1 = P2[i]
            let t2 = P1[i]
            let t:Double = t1-t2
            tmp += (t*t)
        }
        
        for i in 0 ..< P1.count {
            let t1 = P2[i]
            let t2 = P1[i]
            let exx: Double = (t1-t2)/sqrt(tmp)
            ex.append(exx)
        }
        
        // i = ex(P3 - P1)
        for i in 0 ..< P3.count {
            let t1 = P3[i]
            let t2 = P1[i]
            let t3 = t1-t2
            P3P1.append(t3)
        }
        
        for i in 0 ..< ex.count {
            let t1 = ex[i]
            let t2 = P3P1[i]
            ival += (t1*t2)
        }
        //ey = (P3 - P1 - i · ex) / ‖P3 - P1 - i · ex‖
        for i in 0 ..< P3.count {
            let t1 = P3[i]
            let t2 = P1[i]
            let t3 = ex[i] * ival
            let t = t1 - t2 - t3
            P3P1i += (t*t)
        }
        
        
        for i in 0 ..< P3.count {
            let t1 = P3[i]
            let t2 = P1[i]
            let t3 = ex[i] * ival
            let eyy = (t1 - t2 - t3)/sqrt(P3P1i)
            ey.append(eyy)
        }
        
        if P1.count == 3 {
            ezx = ex[1]*ey[2] - ex[2]*ey[1]
            ezy = ex[2]*ey[0] - ex[0]*ey[2]
            ezz = ex[0]*ey[1] - ex[1]*ey[0]
        }
        
        ez.append(ezx)
        ez.append(ezy)
        ez.append(ezz)
        
        //d = ‖P2 - P1‖
        let d:Double = sqrt(tmp)
        var j:Double = 0
        
        //j = ey(P3 - P1)
        for i in 0 ..< ey.count {
            let t1 = ey[i]
            let t2 = P3P1[i]
            j += (t1*t2)
        }
        //x = (r12 - r22 + d2) / 2d
        let x = (pow(DistA,2) - pow(DistB,2) + pow(d,2))/(2*d)
        //y = (r12 - r32 + i2 + j2) / 2j - ix / j
        let y = ((pow(DistA,2) - pow(DistC,2) + pow(ival,2) + pow(j,2))/(2*j)) - ((ival/j)*x)
        
        var z: Double = 0
        print(x)
        print(y)
        if P1.count == 3 {
            z = sqrt(pow(DistA,2) - pow(x,2) - pow(y,2))
        }
        
        var unknowPoint:[Double] = []
        
        for i in 0 ..< P1.count {
            let t1 = P1[i]
            let t2 = ex[i] * x
            let t3 = ey[i] * y
            let t4 = ez[i] * z
            let unknownPointCoord = t1 + t2 + t3 + t4
            unknowPoint.append(unknownPointCoord)
        }

        print(unknowPoint)
        
        return String(format:"%.2f", unknowPoint[0]) + ", " + String(format:"%.2f", unknowPoint[1])
    }
}
