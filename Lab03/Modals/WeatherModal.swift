//
//  WeatherModal.swift
//  Lab03
//
//  Created by Darshan Nariya on 3/15/24.
//

import Foundation


struct WeatherModel: Codable {
    
    init(){
        location = Location(name: "", region: "", country: "", lat: 0.0, lon: 0.0, tz_id: "", localtime_epoch: 0, localtime: "" )
        current = Current(temp_c: 0.0, temp_f: 0.0, feelslike_c: 0.0, feelslike_f: 0.0, is_day: 1,
                          condition: Current.Condition(text: "", icon: "", code: 0))
    }
    
    init(location: Location, current: Current) {
        self.location = location
        self.current = current
    }
    
    let location: Location
    let current: Current
    
    struct Location: Codable {
        let name: String
        let region: String
        let country: String
        let lat: Double
        let lon: Double
        let tz_id: String
        let localtime_epoch: Int
        let localtime: String
    }
    
    struct Current: Codable {
        let temp_c: Double
        let temp_f: Double
        let feelslike_c: Double
        let feelslike_f: Double
        let is_day: Int
        let condition: Condition
        
        struct Condition: Codable {
            let text: String
            let icon: String
            let code: Int
        }
    }
}
