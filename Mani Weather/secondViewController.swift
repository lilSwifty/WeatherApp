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

protocol sendBack  {
    func updateUIWithData(city: String)
}


class secondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating{
   
    
    var recievedCity = ""
    
    //var weatherDelegate : showWeatherProtocol?
    
    let weatherDataModel = WeatherDataModel()
    
    var cityListArray : [WeatherDataModel] = []
    
    var searchResult : [String] = []
    
    var loadedCities : [String] = []
    
    var searching = false
    
    @IBOutlet weak var tableView: UITableView!
    
    var backDelegate : sendBack?
    
    var defaults = UserDefaults.standard
    var key = "FavoriteCities"
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

    
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "1dd1e0b08f4e193eabfb665c83a7d60c"
    
    var searchController : UISearchController!
    
    override func viewDidLoad() {
        
//        print("TableVC show mainVC cityFavs: \(mainVC.cityListArray)")
//        print("TableVC count mainVC cityFavs: \(mainVC.cityListArray.count)")
        super.viewDidLoad()
        
        loadedCities = defaults.stringArray(forKey: key) ?? [String]()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        print("TableVC loaded: \(loadedCities)")
        tableView.delegate = self
        tableView.dataSource = self
        
        animateTable()
        
        definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        
        //updateSearchResults(for: searchController)
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let text = searchController.searchBar.text?.lowercased() {
            searchResult = loadedCities.filter({ $0.lowercased().contains(text) })
        } else {
            searchResult = []
        }
        tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadedCities = defaults.stringArray(forKey: key) ?? [String]()

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
        
        if searching {
            return searchResult.count
        }
        return loadedCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2

        let params : [String : String] = ["q" : loadedCities[indexPath.row], "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params, cell: cell)
        
//        cell.cityLabel.text = cityListArray[indexPath.row].city
//        cell.tempLabel.text = "\(cityListArray[indexPath.row].temperatue)℃"
//        cell.imageView?.image = UIImage(named: cityListArray[indexPath.row].updateWeatherIcon(condition: cityListArray[indexPath.row].condition))
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        print("User clicked: \(loadedCities[indexPath.row])")
        
        let city = loadedCities[indexPath.row]
        
        backDelegate?.updateUIWithData(city: city)
        
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)

        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            //mainVC.cityListFav.remove(at: indexPath.row)
            
            loadedCities.remove(at: indexPath.row)
            defaults.set(loadedCities, forKey: key)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    
//    func userEnteredANewCityName(city: String) {
//        let params : [String : String] = ["q" : city, "appid" : APP_ID]
//
//        getWeatherData(url: WEATHER_URL, parameters: params)
//    }
    
    func getWeatherData(url: String, parameters: [String: String], cell: CustomTableViewCell){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                print("TableVC: Success! Got the weather data")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON, cell: cell)
            
            } else {
                print("TableVC: Error \(String(describing: response.result.error))")
                
            }
        }
        
    }

    func updateWeatherData(json: JSON, cell: CustomTableViewCell){

            if let tempResult = json["main"]["temp"].double{
                
                weatherDataModel.temperatue = Int(tempResult - 273.15)
                
                weatherDataModel.city = json["name"].stringValue
                
                weatherDataModel.condition = json["weather"][0]["id"].intValue
                
                weatherDataModel.humidity = json["main"]["humidity"].intValue
                
                weatherDataModel.pressure = json["main"]["pressure"].intValue
                
                weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
                
                cell.cityLabel.text = self.weatherDataModel.city
                cell.tempLabel.text = "\(self.weatherDataModel.temperatue)℃"
                cell.weatherIcon.image = UIImage(named: self.weatherDataModel.weatherIconName)
            
        } else {
            print("TableVC: error")
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
