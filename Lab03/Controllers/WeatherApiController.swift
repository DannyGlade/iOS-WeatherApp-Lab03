//
//  WeatherApiController.swift
//  Lab03
//
//  Created by Darshan Nariya on 3/15/24.
//

import Foundation

public class WeatherApiController {
    
    static let shared = WeatherApiController()
    
    static var weather: WeatherModel = WeatherModel()
    
    let weatherUrl = "https://api.weatherapi.com/v1/current.json?key=99256c83312d475ebdb43132241503&q="
    
    func getWeatherWithCoordinates(lat: Double, lon: Double, completion: @escaping (WeatherModel) -> Void) {
        
        let url = URL(string: "\(weatherUrl)\(lat),\(lon)")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
                    WeatherApiController.weather = weather
                    completion(weather)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }
        
        task.resume()
        
        
    }
    
    func getWeatherWithCity(city: String, completion: @escaping (WeatherModel) -> Void) {
        
        let url = URL(string: "\(weatherUrl)\(city)")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
                    completion(weather)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }
        
        task.resume()
        
        
    }
    
    
    
}
