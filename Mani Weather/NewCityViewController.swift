//
//  NewCityViewController.swift
//  Mani Weather
//
//  Created by Mani Sedighi on 2018-03-26.
//  Copyright © 2018 Mani Sedighi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol ChangeCityDelegate {
    func userEnteredANewCityName (city: String)
}


class NewCityViewController: UIViewController{

  
    //var cityListData : [WeatherDataModel] = []
    
    var delegate : ChangeCityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBOutlet weak var newCityTextField: UITextField!
    
    @IBAction func getCityButton(_ sender: AnyObject) {
        
        let cityName = newCityTextField.text!
        
        delegate?.userEnteredANewCityName(city: cityName)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
