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
    
    // MARK: - Parameters
    var pointCoordinates : CLLocationCoordinate2D!
    let animation = CATransition()
    
    // MARK: - IBOutlets
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    // MARK: - IBAction
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut )
        animation.type = kCATransitionPush
        animation.duration = 1.5
        let geocoder = CLGeocoder()
        
        let weatherData = WeatherData(parser: XmlWeatherParser())
        
        weatherData.getCurrentWeatherFor(latitude: pointCoordinates.latitude, longitude: pointCoordinates.longitude) { (conditions) in
            DispatchQueue.main.async {
                self.temperatureLabel.text = String(format: "%g°C", conditions.temperature!)
            }
        }
        
        geocoder.reverseGeocodeLocation(CLLocation(latitude: pointCoordinates.latitude, longitude: pointCoordinates.longitude), completionHandler: { (data, error) in
            if let error = error {
                print("geocode error: \(error.localizedDescription)")
            } else{
                DispatchQueue.main.async {
                    self.cityLabel.layer.add(self.animation, forKey: "changeTextTransition")
                    self.countryLabel.layer.add(self.animation, forKey: "changeTextTransition")
                    if let pointData = data {
                        self.countryLabel.text = pointData[0].country ?? "-//-"
                        self.cityLabel.text = pointData[0].administrativeArea ?? "-//-"
                    }
                }
            }
        })
        
    }
    
}
