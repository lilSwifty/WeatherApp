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

protocol showPussyProtocol {
    func showTheHotPocket(city : WeatherDataModel)
}

class ViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate, showPussyProtocol{
    
    
    
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "1dd1e0b08f4e193eabfb665c83a7d60c"
    
    var cityListArray : [WeatherDataModel] = []
    var favoriteCities : [WeatherDataModel] = []
    
    var newHomeScreenModel : WeatherDataModel?
    
    let locationManager = CLLocationManager()
    
//    let defaults = UserDefaults.standard

    
    @IBOutlet weak var weatherLogo: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var humidityStatus: UILabel!
    @IBOutlet weak var pressureStatus: UILabel!
    @IBOutlet weak var tipsLabel: UILabel!
    
    
    
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

    @IBAction func addCityToList(_ sender: Any) {
        
        let favoriteCity = cityListArray.last
        if cityListArray.count < 1 {
            print("list empty")
        } else {
            favoriteCities.append(favoriteCity!)
//            self.defaults.set(self.favoriteCities, forKey: "FavoriteCities")
        }
        
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
            
            let newCityAdd = WeatherDataModel()
            
            newCityAdd.temperatue = Int(tempResult - 273.15)
            
            newCityAdd.city = json["name"].stringValue
            
            newCityAdd.condition = json["weather"][0]["id"].intValue
            
            newCityAdd.humidity = json["main"]["humidity"].intValue
            
            newCityAdd.pressure = json["main"]["pressure"].intValue
            
            newCityAdd.weatherIconName = newCityAdd.updateWeatherIcon(condition: newCityAdd.condition)
            
            newCityAdd.tips = newCityAdd.giveGoodTips(condition: newCityAdd.condition)
            
            cityListArray.append(newCityAdd)
            
            updateUIWithWeatherData(city : newCityAdd)
                        
        } else {
            cityName.text = "Weather Unavailable"
        }
    }
    

    
    func updateUIWithWeatherData(city : WeatherDataModel) {
        cityName.text = city.city
        temp.text = String("\(city.temperatue)℃")
        weatherLogo.image = UIImage(named: city.weatherIconName)
        humidityStatus.text = String("Humidity: \(city.humidity)")
        pressureStatus.text = String("Pressure: \(city.pressure)")
        tipsLabel.text = city.tips
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
    
    func userEnteredANewCityName(city: String) {
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchCity" {
            let destinationVC = segue.destination as! NewCityViewController
            destinationVC.delegate = self
        } else if segue.identifier == "addAndShow" || segue.identifier == "justShow"{
//            if let cities = defaults.array(forKey: "FavoriteCities") as? [WeatherDataModel] {
//                favoriteCities = cities
//            }
            let destionationVC = segue.destination as! secondViewController
            destionationVC.cityListArray = favoriteCities
            destionationVC.weatherDelegate = self
            
        }
    }
    func showTheHotPocket(city : WeatherDataModel) {
        print("drip drop din jävla fitta")
        updateUIWithWeatherData(city: city)
        
    }
    
    
    
    
    
}


