//
//  Interfaces.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/18/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit

struct WeatherCondition {
    
    var sunrise : String = ""
    var sunset : String = ""
    var temperature : Double?
    var humidity: Int?
    var pressure: Double?
    var windSpeed : Double?
    var windName : String = ""
    var windDirection : String = ""
    var clouds : String = ""
    var weather : String = ""
    var weatherIcon : UIImage?
    
}

enum Day: String {
    case Monday = "Monday"
    case Thusday = "Thusday"
    case Wednesday = "Wednesday"
    case Thursday = "Thursday"
    case Friday = "Friday"
    case Saturday = "Saturday"
    case Sunday = "Sunday"
}

protocol WeatherParserInterface {
    func getWeatherConditionsFor(data : Data) -> WeatherCondition
}

protocol WeatherDataInterface {
    func getCurrentWeatherFor(latitude: Double, longitude: Double, completionHandler: @escaping (_ conditions: WeatherCondition) -> Void )
}
