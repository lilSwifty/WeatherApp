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

protocol previewCityDelegate {
    func userEnteredANewCityName (city: String)
}



class NewCityViewController: UIViewController {
    
    let weatherDataModel = WeatherDataModel()
    
    var addTemp = ""
    
    
    var secondVC : secondViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var newCityTextField: UITextField!
    
    @IBAction func getCityButton(_ sender: AnyObject) {
        
//        performSegue(withIdentifier: "newSearch", sender: self)
    
        
        secondVC.addCities.append(newCityTextField.text!)
        //secondVC.addTemp.append("\(weatherDataModel.temperatue)℃")
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "newSearch" {
//
//            secondVC.addCities.append(newCityTextField.text!)
//
//            let secondVC = segue.destination as! secondViewController
//
//            secondVC.cityList.append(newCityTextField.text!)
//
//            self.dismiss(animated: true, completion: nil)
//
//        }
//    }

}
