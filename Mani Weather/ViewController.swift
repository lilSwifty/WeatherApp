//
//  ViewController.swift
//  Mani Weather
//
//  Created by Mani Sedighi on 2018-03-24.
//  Copyright © 2018 Mani Sedighi. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "1dd1e0b08f4e193eabfb665c83a7d60c"
    
    let weatherDataModel = WeatherDataModel()
    let locationManager = CLLocationManager()

    @IBOutlet weak var weatherLogo: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var humidityStatus: UILabel!
    @IBOutlet weak var pressureStatus: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.weatherLogo.alpha = 0.0
        self.cityName.alpha = 0.0
        self.temp.alpha = 0.0
        showAllViews()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAllViews() {
        UIView.animateKeyframes(withDuration: 2.5, delay: 0.4, animations: {
            self.weatherLogo.alpha = 1.0
            self.temp.alpha = 1.0
        })
        UIView.animateKeyframes(withDuration: 2.5, delay: 0.1, animations: {
            self.cityName.alpha = 1.0
            })
    }
    
    func getWeatherData(url: String, parameters: [String: String]){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                print("Success! Got the weather data")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                print("Error \(String(describing: response.result.error))")
                self.cityName.text = "Connection Issues"
            }
        }
    }
    
    func updateWeatherData(json: JSON){
        
        if let tempResult = json["main"]["temp"].double{
            
            weatherDataModel.temperatue = Int(tempResult - 273.15)
            
            weatherDataModel.city = json["name"].stringValue
            
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            
            weatherDataModel.humidity = json["main"]["humidity"].intValue
            
            weatherDataModel.pressure = json["main"]["pressure"].intValue
            
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
            
        } else {
            cityName.text = "Weather Unavailable"
        }
    }
    
    func updateUIWithWeatherData() {
        cityName.text = weatherDataModel.city
        temp.text = String("\(weatherDataModel.temperatue)℃")
        weatherLogo.image = UIImage(named: weatherDataModel.weatherIconName)
        humidityStatus.text = String("\(weatherDataModel.humidity)")
        pressureStatus.text = String("\(weatherDataModel.pressure)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude,
                                              "lon" : longitude,
                                              "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityName.text = "Location unavailable"
    }
    
    
}


