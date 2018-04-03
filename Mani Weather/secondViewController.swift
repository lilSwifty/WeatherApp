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

    
    
    
    var weatherDelegate : showPussyProtocol?
    
    let weatherDataModel = WeatherDataModel()
    
    var cityListArray : [WeatherDataModel] = []
    
    var delegate : ChangeCityDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "1dd1e0b08f4e193eabfb665c83a7d60c"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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
        cell.tempLabel.text = "\(cityListArray[indexPath.row].temperatue)"
        cell.imageView?.image = UIImage(named: cityListArray[indexPath.row].updateWeatherIcon(condition: cityListArray[indexPath.row].condition))
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let cell = tableView.cellForRow(at: indexPath)
        
//        let a = cityListArray[indexPath.row]
        //weatherDelegate?.city = cityListArray[indexPath.row].city
        weatherDelegate?.showTheHotPocket(city : cityListArray[indexPath.row])
        
        //print("\(weatherDelegate?.city)")
        self.dismiss(animated: true, completion: nil)
//        performSegue(withIdentifier: "justShow", sender: self)
        
//        let chosenCity = cityListArray[indexPath.row].city
//        delegate?.userEnteredANewCityName(city: chosenCity)
//        self.dismiss(animated: true, completion: nil)
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

        customCell.tempLabel.text = String("\(weatherDataModel.temperatue)℃")
        customCell.cityLabel.text = weatherDataModel.city
        customCell.weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)

    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "justShow" {
//            if let cell = sender as? CustomTableViewCell{
//                let indexOfCell : Int = tableView.indexPath(for: cell)!.row
//                let ViewCityVC = segue.destination as! ViewController
//                let cityName = cityListArray[indexOfCell].city
//                delegate?.userEnteredANewCityName(city: cityName)
//                //ViewCityVC.data = cityName
//            }
//        }
//    }
}
