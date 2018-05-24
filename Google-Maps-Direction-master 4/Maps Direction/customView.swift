//
//  customView.swift
//  Alamofire
//
//  Created by varun.polanki
//  Copyright varun.polanki. All rights reserved.
//

import UIKit

class customView: UIView {
    override func draw(_ rect: CGRect) {
       
        self.makeTheView()
        
    }
func makeTheView(){
    let bezierPath = UIBezierPath()
    bezierPath.move(to: CGPoint(x: 0, y: 0.5))
    bezierPath.addLine(to: CGPoint(x: 0, y: 729.5))
    bezierPath.addLine(to: CGPoint(x: 190.88, y: 729.5))
    bezierPath.addLine(to: CGPoint(x: 190.88, y: 430.42))
    bezierPath.addLine(to: CGPoint(x: 300, y: 430.42))
    bezierPath.addLine(to: CGPoint(x: 300, y: 290.23))
    bezierPath.addLine(to: CGPoint(x: 190.88, y: 290.23))
    bezierPath.addLine(to: CGPoint(x: 190.88, y: 0.5))
    bezierPath.addLine(to: CGPoint(x: 0, y: 0.5))
    bezierPath.close()
    UIColor.lightGray.setFill()
    bezierPath.fill()
    UIColor.clear.setStroke()
    bezierPath.stroke()
    }
    
    
}
