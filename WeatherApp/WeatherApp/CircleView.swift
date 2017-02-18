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
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        let arcWidth: CGFloat = 15
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = π * 2
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: { ()  in
            
            let path = UIBezierPath(arcCenter: center,
                                    radius: radius/2 - arcWidth/2,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: true)
            
            path.lineWidth = arcWidth
            
            path.stroke()
            
            
            self.shapeLayer.path = path.cgPath
            self.shapeLayer.bounds = self.layer.bounds
            self.shapeLayer.strokeColor = self.counterColor.cgColor
            self.shapeLayer.lineWidth = arcWidth
            self.shapeLayer.position = CGPoint(x: 75, y:75)
            self.shapeLayer.fillColor = nil
            self.layer.addSublayer(self.shapeLayer)
            let gradient = CAGradientLayer()
            gradient.frame = path.bounds
            gradient.bounds = self.layer.bounds
            
            gradient.position = CGPoint(x: 75, y:75)
            gradient.colors = [UIColor.purple.cgColor,UIColor.blue.cgColor, #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1).cgColor , UIColor.white.cgColor, UIColor.yellow.cgColor,UIColor.orange.cgColor, UIColor.red.cgColor]
            
            gradient.mask = self.shapeLayer
            
            self.layer.addSublayer(gradient)
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.duration = 3
            animation.fromValue = 0
            animation.toValue = 1
            self.shapeLayer.add(animation, forKey: "strokeEnd")
            
        })
    }
    
    
    
    
}

