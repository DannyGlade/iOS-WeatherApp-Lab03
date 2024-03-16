//
//  WeatherConditionsModal.swift
//  Lab03
//
//  Created by Darshan Nariya on 3/15/24.
//

import Foundation

//dummy data
//[
//    {
//        "code" : 1000,
//        "day" : "Sunny",
//        "night" : "Clear",
//        "day_icon" : "sun.max.fill",
//        "night_icon" : "moon.stars.fill"
//    },
//    {
//        "code" : 1003,
//        "day" : "Partly cloudy",
//        "night" : "Partly cloudy",
//        "day_icon" : "cloud.sun.fill",
//        "night_icon" : "cloud.moon.fill"
//    },
//]


class WeatherConditions: Decodable {
    
    struct Condition: Decodable {
        let code: Int
        let day: String
        let night: String
        let day_icon: String
        let night_icon: String
    }

    struct ResponseType: Decodable {
        var conditions: [Condition]
    }
    
    var conditions: [ResponseType] = [];
    
    var path = Bundle.main.url(forResource: "weather_conditions", withExtension: "json")
    
    init() {
        do {
            let data = try Data(contentsOf: path!)
            
            let weatherConditions = try JSONDecoder().decode(ResponseType.self, from: data)
            
            conditions.append(weatherConditions)
            
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    public func getWeatherIcon(code: Int, isDay: Bool) -> String {
        for condition in conditions[0].conditions {
            if condition.code == code {
                return isDay ? condition.day_icon : condition.night_icon
            }
        }
        return ""
    }
    
}

