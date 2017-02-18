//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/18/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit

class WeatherData : WeatherDataInterface {
    
    private var parser : WeatherParserInterface
    private let session = URLSession(configuration: .default)
    
    init(parser: WeatherParserInterface) {
        self.parser = parser
    }
    
    private func getWeatherData(url: URL, completionHandler: @escaping (_ data: Data) -> Void ) {
        let dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completionHandler(data!)
                }
            }
        })
        dataTask.resume()
        
    }
    
    func getCurrentWeatherFor(latitude: Double, longitude: Double, completionHandler: @escaping (_ conditions: WeatherCondition) -> Void ) {
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&mode=xml&APPID=ba22ef4840c7fcb08a7a7b92bf80d1fc")
        getWeatherData(url: url!) { (data) in
            completionHandler(self.parser.getWeatherConditionsFor(data: data))
        }
        
    }
    
}

