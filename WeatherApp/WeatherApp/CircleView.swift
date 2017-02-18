//
//  CircleView.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/16/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit

@IBDesignable class TCircleView: UIView {
    
    let NoOfGlasses = 8
    let π:CGFloat = CGFloat(M_PI)
    let shapeLayer = CAShapeLayer()
    
    var counter: Int = 5
    var outlineColor: UIColor = UIColor.blue
    var counterColor: UIColor = UIColor.red
    
    override func draw(_ rect: CGRect) {
        
        let center = CGPoint(x:18, y: 75)
        let startAngle: CGFloat = 7 * π / 4
        let endAngle: CGFloat = 5 * π / 4
        
        let path = UIBezierPath(roundedRect: CGRect(x: 10, y: 10, width:16, height: 75), cornerRadius: 8)
        UIColor.black.setStroke()
        path.lineWidth = 2
        path.stroke()
        
        let path2 = UIBezierPath(arcCenter: center,
                                 radius: 12,
                                 startAngle: startAngle,
                                 endAngle: endAngle,
                                 clockwise: true)
        UIColor.black.setStroke()
        path2.lineWidth = 2
        path2.stroke()
        
        let path4 = UIBezierPath(arcCenter: center,
                                 radius: 11,
                                 startAngle: startAngle,
                                 endAngle: endAngle,
                                 clockwise: true)

        path4.move(to: center)
        path4.lineWidth = 24
        #colorLiteral(red: 0.9090855013, green: 0.02552536813, blue: 0, alpha: 1).setFill()
        path4.fill()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: { ()  in
            
        
            let path3 = UIBezierPath()
            path3.move(to: CGPoint(x: 18, y: 75))
            path3.addLine(to: CGPoint(x: 18, y: 20))
            UIColor.red.setStroke()
            path3.lineWidth = 21
            path3.stroke()
            self.shapeLayer.path = path3.cgPath
            self.shapeLayer.bounds = self.layer.bounds
            self.shapeLayer.strokeColor = #colorLiteral(red: 0.9090855013, green: 0.02552536813, blue: 0, alpha: 1).cgColor
            self.shapeLayer.lineWidth = 15
            self.shapeLayer.lineCap = kCALineJoinRound
            self.shapeLayer.position = CGPoint(x: 75, y:75)
            self.shapeLayer.fillColor = nil
            self.layer.addSublayer(self.shapeLayer)
            
            
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.duration = 2
            animation.fromValue = 0
            animation.toValue = 0.6
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            self.shapeLayer.add(animation, forKey: "strokeEnd")
            
        })
    }
    
    
    
    
}

