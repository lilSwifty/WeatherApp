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



class ViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate, sendBack{
    
    

    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "1dd1e0b08f4e193eabfb665c83a7d60c"
    let newCityAdd = WeatherDataModel()
    var favoriteCities : [WeatherDataModel] = []
    
    var cityListArray : [WeatherDataModel] = []
    var newHomeScreenModel : WeatherDataModel?
    let locationManager = CLLocationManager()
    var cityListFav : [String] = []
    let defaults = UserDefaults.standard
    let key = "FavoriteCities"
    
    
//    var dynamicAnimator : UIDynamicAnimator!
//    var gravity : UIGravityBehavior!
//    var collision : UICollisionBehavior!

    
    @IBOutlet weak var weatherLogo: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var humidityStatus: UILabel!
    @IBOutlet weak var pressureStatus: UILabel!
    @IBOutlet weak var tipsImage: UIImageView!
    @IBOutlet weak var launchImage: UIImageView!
    @IBOutlet weak var background2: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.weatherLogo.alpha = 0.0
        self.cityName.alpha = 0.0
        self.temp.alpha = 0.0
        showAllViews()
        
//        dynamicAnimator = UIDynamicAnimator(referenceView: view)
//        gravity = UIGravityBehavior(items: [weatherLogo])
//        collision = UICollisionBehavior(items: [weatherLogo])
//        collision.translatesReferenceBoundsIntoBoundary = false
//        dynamicAnimator.addBehavior(collision)
//        dynamicAnimator.addBehavior(gravity)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getSaved()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        print("MainVC cityListCount: \(cityListFav.count)")
        print ("MainVC cityList: \(cityListFav)")
    }

    @IBAction func addCityToList(_ sender: Any) {
    
        let favoriteCity = cityName.text
        
        cityListArray.append(newCityAdd)
        cityListFav.append(favoriteCity!)
        defaults.set(cityListFav, forKey: key)

//        if cityListArray.count < 1 {
//            print("MainVC addButton: list empty")
//        } else {
//            cityListFav.append(favoriteCity!)
//        }
        
    }
    
    func getSaved(){
        cityListFav = defaults.stringArray(forKey: key) ?? [String]()
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
        UIView.animate(withDuration: 1.0, delay: 0.1, animations: {
            self.launchImage.alpha = 0.0
        })
    }
    
    func getWeatherData(url: String, parameters: [String: String]){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                print("MainVC: Success! Got the weather data")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                print("MainVC: Error \(String(describing: response.result.error))")
                self.cityName.text = "MainVC: Connection Issues"
            }
        }
    }
    
    func updateWeatherData(json: JSON){
        
        if let tempResult = json["main"]["temp"].double{

            newCityAdd.temperatue = Int(tempResult - 273.15)
            
            newCityAdd.city = json["name"].stringValue
            
            newCityAdd.condition = json["weather"][0]["id"].intValue
            
            newCityAdd.humidity = json["main"]["humidity"].intValue
            
            newCityAdd.pressure = json["wind"]["speed"].intValue
            
            newCityAdd.weatherIconName = newCityAdd.updateWeatherIcon(condition: newCityAdd.condition)
            
            newCityAdd.tips = newCityAdd.giveGoodTips(condition: newCityAdd.condition)
            
            newCityAdd.save = true
            
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
        humidityStatus.text = String("Humidity: \(city.humidity)%")
        pressureStatus.text = String("Wind speed: \(city.pressure)m/s")
        tipsImage.image = UIImage(named: city.tips)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            print("MainVC: longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude,
                                              "lon" : longitude,
                                              "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("MainVC: \(error)")
        cityName.text = "Location unavailable"
    }
    
    func userEnteredANewCityName(city: String) {

        let params : [String : String] = ["q" : city, "appid" : APP_ID]

        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    func updateUIWithData(city: String) {
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchCity" {
            let destinationVC = segue.destination as! NewCityViewController
            destinationVC.delegate = self
        } else if segue.identifier == "addAndShow" || segue.identifier == "justShow"{

            let destionationVC = segue.destination as! secondViewController
            
            destionationVC.backDelegate = self
            destionationVC.loadedCities = cityListFav
            
            destionationVC.cityListArray = favoriteCities
            //destionationVC.recievedCity = cityName.text!
        }
    }
    func showTheWeather(city : WeatherDataModel) {
        print("MainVC showTheWeather: drip drop motherfucker")
        updateUIWithWeatherData(city: city)
        
    }
    
}


