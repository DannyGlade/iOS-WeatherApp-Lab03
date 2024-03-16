//
//  ViewController.swift
//  Lab03
//
//  Created by Darshan Nariya on 3/14/24.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var ScreenBG: UIView!
    
    @IBOutlet weak var CelFarenToggle: UISwitch!
    @IBOutlet weak var LocationOn: UIImageView!
    @IBOutlet weak var SearchOn: UIImageView!
    @IBOutlet weak var searchField: UITextField!
    
    
    @IBOutlet weak var MainWeatherString: UILabel!
    @IBOutlet weak var MainWeatherImage: UIImageView!
    @IBOutlet weak var tempWeatherString: UILabel!
    @IBOutlet weak var FCToggleLabel: UILabel!
    
    var thisWeather = WeatherModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
//        locationOnTapped(UITapGestureRecognizer())
        
        
        //        turning LocationOnImage to Button
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.locationOnTapped(_:)))
        LocationOn.addGestureRecognizer(tap)
        LocationOn.isUserInteractionEnabled = true
        
        //        turning SearchOnImage to Button
        let tapSearch = UITapGestureRecognizer(target: self, action: #selector(self.searchOnTapped(_:)))
        SearchOn.addGestureRecognizer(tapSearch)
        SearchOn.isUserInteractionEnabled = true
        
        
    }
    
    @objc func locationOnTapped(_ sender: UITapGestureRecognizer) {
        
        //        giving visual feedback to the user
        UIView.animate(withDuration: 0.2, animations: {
            self.LocationOn.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (success) in
            UIView.animate(withDuration: 0.2, animations: {
                self.LocationOn.transform = CGAffineTransform.identity
            })
        }
        
        print("LocationOn Tapped")
        
        //        getting Location
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            let location = locationManager.location
            
            //            print(location?.coordinate ?? "No Location")
            
            WeatherApiController().getWeatherWithCoordinates(lat: location?.coordinate.latitude ?? 0.0, lon: location?.coordinate.longitude ?? 0.0, completion: { (weather) in
                
                self.showTheWeather(weather: weather)
            })
            
            
            //            print("Location is ON")
        } else {
            print("Location is OFF")
        }
        
    }
    
    func showTheWeather(weather: WeatherModel) {
        //        print(weather)
        thisWeather = weather
        
        let weatherCondition = weather.current.condition.text
        let location = weather.location.name
        let province = weather.location.region
        
        let temp_c = weather.current.temp_c
        let feelslike_c = weather.current.feelslike_c
        
        let temp_f = weather.current.temp_f
        let feelslike_f = weather.current.feelslike_f
        
        let isDay = weather.current.is_day == 1 ? true : false
        
        DispatchQueue.main.async {
            self.MainWeatherString.text = "It's \(weatherCondition) in \(location), \(province)"
            
            if self.CelFarenToggle.isOn {
                self.tempWeatherString.text = "\(temp_c)°C, Feels like \(feelslike_c)°C"
            } else {
                self.tempWeatherString.text = "\(temp_f)°F, Feels like \(feelslike_f)°F"
            }
            
            if isDay {
                self.ScreenBG.backgroundColor = UIColor(named: "SkyBlue")
                
                self.LocationOn.tintColor = UIColor.black
                self.SearchOn.tintColor = UIColor.black
                
                //               making text color black if background is light
                self.MainWeatherString.textColor = UIColor.black
                self.tempWeatherString.textColor = UIColor.black
                self.FCToggleLabel.textColor = UIColor.black
                
            } else {
                self.ScreenBG.backgroundColor = UIColor(named: "NightSkyBlue")
                
                self.LocationOn.tintColor = UIColor.white
                self.SearchOn.tintColor = UIColor.white
                
                //                making text color white if background is dark
                self.MainWeatherString.textColor = UIColor.white
                self.tempWeatherString.textColor = UIColor.white
                self.FCToggleLabel.textColor = UIColor.white
            }
            
            
        }
        
        setTheWeatherImg(conditionCode: weather.current.condition.code, isDay: isDay)
        
        
    }
    
    func setTheWeatherImg(conditionCode: Int, isDay: Bool = true) {
        
        let image = WeatherConditions().getWeatherIcon(code: conditionCode, isDay: isDay)
        
        DispatchQueue.main.async {
            self.MainWeatherImage.image = UIImage(named: image)
            if isDay {
                self.MainWeatherImage.tintColor = UIColor.black
            } else {
                self.MainWeatherImage.tintColor = UIColor.white
            }
        }
        
        
    }
    
    
    @objc func searchOnTapped(_ sender: UITapGestureRecognizer) {
        
        //        giving visual feedback to the user
        UIView.animate(withDuration: 0.2, animations: {
            self.SearchOn.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (success) in
            UIView.animate(withDuration: 0.2, animations: {
                self.SearchOn.transform = CGAffineTransform.identity
            })
        }
        
        let search = searchField.text
        
        WeatherApiController().getWeatherWithCity(city: search ?? "") { (weather) in
            self.showTheWeather(weather: weather)
        }
        
        //        print("SearchOn Tapped")
    }
    
    @IBAction func searchFieldReturnPressed(_ sender: UITextField) {
        
        searchOnTapped(UITapGestureRecognizer())
        //        hiding keyboard
        //        searchField.resignFirstResponder()
    }
    
    @IBAction func FCToggleTriggered(_ sender: Any) {
        
        let temp_c = thisWeather.current.temp_c
        let feelslike_c = thisWeather.current.feelslike_c
        
        let temp_f = thisWeather.current.temp_f
        let feelslike_f = thisWeather.current.feelslike_f
        
        if CelFarenToggle.isOn {
            tempWeatherString.text = "\(temp_c)°C, Feels like \(feelslike_c)°C"
        } else {
            tempWeatherString.text = "\(temp_f)°F, Feels like \(feelslike_f)°F"
        }
    }
    
}

