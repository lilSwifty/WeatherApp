//
//  secondViewController.swift
//  Mani Weather
//
//  Created by Mani Sedighi on 2018-03-25.
//  Copyright © 2018 Mani Sedighi. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class secondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let weatherDataModel = WeatherDataModel()
    var addCities : [String] = []
    var addTemp : [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    //var cityListArray : [WeatherDataModel] = []
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "1dd1e0b08f4e193eabfb665c83a7d60c"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
        print("Alla städer : \(addCities)")
        print("Temperaturer : \(addTemp)")
    }


    

    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return addCities.count
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previewController" {
            if let cell = sender as? CustomTableViewCell{
                let indexOfCell : Int = tableView.indexPath(for: cell)!.row
                let ViewCityVC = segue.destination as! ViewCityViewController
                let cityName = addCities[indexOfCell]
                ViewCityVC.data = cityName
                }
            }else if segue.identifier == "newSearch" {
                let newCity = segue.destination as! NewCityViewController
                newCity.secondVC = self
            }
    }
    
    func userEnteredANewCityName(city: String) {
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
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
                
                //updateUIWithWeatherData()
            
        } else {
            print("error")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
        
//        for cities in addCities {
//            cell.cityLabel.text = addCities[indexPath.row]
//            userEnteredANewCityName(city: cities)
//        }
        
        cell.cityLabel.text = addCities[indexPath.row]
        userEnteredANewCityName(city: addCities[indexPath.row])
        cell.tempLabel.text = String("\(weatherDataModel.temperatue)℃")
        cell.weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
        
        return cell
        
        
        
    }
    
    func updateUIWithWeatherData() {

        let customCell = CustomTableViewCell()

        customCell.tempLabel.text = String("\(weatherDataModel.temperatue)℃")
        customCell.cityLabel.text = weatherDataModel.city
        customCell.weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)


    }
    
//    @IBOutlet weak var cellView: UIView!
//    @IBOutlet weak var weatherIcon: UIImageView!
//    @IBOutlet weak var cityLabel: UILabel!
//    @IBOutlet weak var tempLabel: UILabel!

}
