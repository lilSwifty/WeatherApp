//
//  CompareViewController.swift
//  Mani Weather
//
//  Created by Mani Sedighi on 2018-04-06.
//  Copyright © 2018 Mani Sedighi. All rights reserved.
//

import UIKit
import GraphKit
import Alamofire
import SwiftyJSON

class CompareViewController: UIViewController,GKBarGraphDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var myGraph: GKBarGraph!
    @IBOutlet weak var myPicker: UIPickerView!
    @IBOutlet weak var dynamicImg: UIImageView!
    
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "1dd1e0b08f4e193eabfb665c83a7d60c"
    var citiesToCompare : [WeatherDataModel] = []
    
    var loadedCities : [String] = []
    var city1 = ""
    var city2 = ""
    
    var dynamicAnimator : UIDynamicAnimator!
    var gravity : UIGravityBehavior!
    var collision : UICollisionBehavior!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadedCities = UserDefaults.standard.stringArray(forKey: "FavoriteCities") ?? [String]()
        print(loadedCities)
        
        myGraph.dataSource = self
        myPicker.dataSource = self
        myPicker.delegate = self
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        // Do any additional setup after loading the view.
    }
    
    //    var dynamicAnimator : UIDynamicAnimator!
    //    var gravity : UIGravityBehavior!
    //    var collision : UICollisionBehavior!
    //        dynamicAnimator = UIDynamicAnimator(referenceView: view)
    //        gravity = UIGravityBehavior(items: [weatherLogo])
    //        collision = UICollisionBehavior(items: [weatherLogo])
    //        collision.translatesReferenceBoundsIntoBoundary = false
    //
    //        dynamicAnimator.addBehavior(collision)
    //        dynamicAnimator.addBehavior(gravity)
    
    
    @IBAction func compareButton(_ sender: Any) {
        city1 = loadedCities[myPicker.selectedRow(inComponent: 0)]
        city2 = loadedCities[myPicker.selectedRow(inComponent: 1)]
        
        let params1 : [String : String] = ["q" : city1, "appid" : APP_ID]
        let params2 : [String : String] = ["q" : city2, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params1)
        getWeatherData(url: WEATHER_URL, parameters: params2)
        
        print(city1)
        print(city2)
        
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [dynamicImg])
        collision = UICollisionBehavior(items: [dynamicImg])
        collision.translatesReferenceBoundsIntoBoundary = false
        
        dynamicAnimator.addBehavior(collision)
        dynamicAnimator.addBehavior(gravity)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func titleForBar(at index: Int) -> String! {
        return "℃"
    }
    
    func numberOfBars() -> Int {
        return 2
    }
    
    func valueForBar(at index: Int) -> NSNumber! {
        return citiesToCompare[index].temperatue * 3 as NSNumber
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return loadedCities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return loadedCities[row]
    }
    
    func updateWeatherData(json: JSON){
        
        if let tempResult = json["main"]["temp"].double{
            
            let newCityAdd = WeatherDataModel()
            
            newCityAdd.temperatue = Int(tempResult - 273.15)
            
            newCityAdd.city = json["name"].stringValue
            
            newCityAdd.condition = json["weather"][0]["id"].intValue
            
            newCityAdd.humidity = json["main"]["humidity"].intValue
            
            newCityAdd.pressure = json["wind"]["speed"].intValue
            
            newCityAdd.weatherIconName = newCityAdd.updateWeatherIcon(condition: newCityAdd.condition)
            
            newCityAdd.tips = newCityAdd.giveGoodTips(condition: newCityAdd.condition)
            
            newCityAdd.save = true
            
            citiesToCompare.append(newCityAdd)
            
            if citiesToCompare.count > 1 {
                updateUIWithData(city: newCityAdd)
            }
  
            
        } else {
            print("Weather Unavailable")
        }
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
                //self.cityName.text = "MainVC: Connection Issues"
            }
        }
    }
    
    func updateUIWithData(city: WeatherDataModel) {
        myGraph.draw()
        citiesToCompare = []
    }
    

}
