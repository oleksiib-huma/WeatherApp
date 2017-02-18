//
//  XmlWeatherParser.swift
//  WeatherApp
//
//  Created by Oleksiy Bilyi on 2/18/17.
//  Copyright © 2017 Oleksiy Bilyi. All rights reserved.
//

import UIKit

class XmlWeatherParser: NSObject, WeatherParserInterface {
    
    fileprivate var conditions = WeatherCondition()
    
    func getWeatherConditionsFor(data : Data) -> WeatherCondition {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return conditions
    }
    
}

extension XmlWeatherParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "temperature":
            if let temperature = attributeDict["value"], let temperatureDouble = Double(temperature)  {
                conditions.temperature = temperatureDouble
            }
        default:
            break
        }
    }
    
}
