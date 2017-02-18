//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/16/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    var pointTemperature : String!
    var pointCoordinates : CLLocationCoordinate2D!
    let animation = CATransition()
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var blur: UIVisualEffectView!
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut )
        animation.type = kCATransitionPush
        animation.duration = 1.5
        let geocoder = CLGeocoder()
        temperatureLabel.text = pointTemperature
        geocoder.reverseGeocodeLocation(CLLocation(latitude: pointCoordinates.latitude, longitude: pointCoordinates.longitude), completionHandler: { (data, error) in
            if let error = error {
                print("geocode error: \(error.localizedDescription)")
            } else{
                DispatchQueue.main.async {
                    self.cityLabel.layer.add(self.animation, forKey: "changeTextTransition")
                    self.countryLabel.layer.add(self.animation, forKey: "changeTextTransition")
                    self.countryLabel.text = data?[0].country!
                    self.cityLabel.text = data?[0].administrativeArea!
                }
            }
        })
        
    }
    
}
