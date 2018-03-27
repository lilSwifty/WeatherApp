//
//  ViewCityViewController.swift
//  Mani Weather
//
//  Created by Mani Sedighi on 2018-03-26.
//  Copyright © 2018 Mani Sedighi. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

class ViewCityViewController: UIViewController{
    
    var cityListArray : [WeatherDataModel] = []
    
    var data = ""
    
    let weatherDataModel = WeatherDataModel()
    //let locationManager = CLLocationManager()
    
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "1dd1e0b08f4e193eabfb665c83a7d60c"


    
    
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherLogo: UIImageView!
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityName.text = data
        userEnteredANewCityName(city: data)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
    

    
    func userEnteredANewCityName(city: String) {
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
}
