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
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var presureLabel: UILabel!
    @IBOutlet weak var temperatureView: ThermometerView!
    
    // MARK: - IBAction
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // animation for geocoding
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut )
        animation.type = kCATransitionPush
        animation.duration = 1.5
        
        let weatherData = WeatherData(parser: XmlWeatherParser())
        weatherData.getCurrentWeatherFor(latitude: pointCoordinates.latitude, longitude: pointCoordinates.longitude) { (conditions) in
            
            conditions.iconDownloadCompletion = { (image) in
                DispatchQueue.main.async {
                    self.weatherImageView.image = image
                }
            }
            
            DispatchQueue.main.async {
                self.temperatureView.animateTemperature(value: conditions.temperature!)
                self.temperatureLabel.text = String(format: "%g°C", conditions.temperature!)
                self.humidityLabel.text = self.humidityLabel.text! + String(format: "%d%%", conditions.humidity!)
                self.presureLabel.text = self.presureLabel.text! + conditions.pressure
                self.windLabel.text = self.windLabel.text! + String(format: "%@, %g m/s, %@", conditions.windName, conditions.windSpeed!, conditions.windDirection)
            }
        }
        geocodeLocation()
    }
    
    // MARK: - Extra functions
    func geocodeLocation() {
        let geocoder = CLGeocoder()
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
