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



class secondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    var weatherDelegate : showWeatherProtocol?
    
    let weatherDataModel = WeatherDataModel()
    
    var cityListArray : [WeatherDataModel] = []
    
    var loadedCities : [String] = []
    
    var delegate : ChangeCityDelegate?
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func addCityStringToClass(city : WeatherDataModel){
        loadedCities.append(city.city)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "1dd1e0b08f4e193eabfb665c83a7d60c"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(loadedCities)
        tableView.delegate = self
        tableView.dataSource = self
        //loadFavorites()
        animateTable()
    }
    
    func loadFavorites(){
        loadedCities = defaults.stringArray(forKey: "FavoriteCities") ?? [String]()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animateTable()
        
        //tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return cityListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2

        cell.cityLabel.text = cityListArray[indexPath.row].city
        cell.tempLabel.text = "\(cityListArray[indexPath.row].temperatue)℃"
        cell.imageView?.image = UIImage(named: cityListArray[indexPath.row].updateWeatherIcon(condition: cityListArray[indexPath.row].condition))
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        weatherDelegate?.showTheWeather(city : cityListArray[indexPath.row])
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            cityListArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

            // handle delete (by removing the data from your array and updating the tableview)
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
                
            
        } else {
            print("error")
        }
    }
    
    func updateUIWithWeatherData() {

        let customCell = CustomTableViewCell()
        
        //let indexOfCell : Int = tableView.indexPath(for: customCell)!.row

        customCell.tempLabel.text = String("\(weatherDataModel.temperatue)℃")
        customCell.cityLabel.text = weatherDataModel.city
        customCell.weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)

    }
    
    func animateTable(){
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05,usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseIn, .curveEaseOut], animations: {cell.transform = CGAffineTransform.identity}, completion: nil)
            delayCounter += 1
        }
    }
    
    
}
