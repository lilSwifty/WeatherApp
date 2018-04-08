//
//  WeatherDataModel.swift
//  Mani Weather
//
//  Created by Mani Sedighi on 2018-03-25.
//  Copyright © 2018 Mani Sedighi. All rights reserved.
//

import UIKit


class WeatherDataModel {
    
    var temperatue : Int = 0
    var condition : Int = 0
    var city : String = ""
    var humidity : Int = 0
    var pressure : Int = 0
    var weatherIconName : String = ""
    var tips : String = ""
    var access : String = ""
    var save : Bool = false
    
    func giveGoodTips(condition: Int) -> String {
        
        switch (condition) {
         
        case 0...300 :
            return "yellowHat"
            
        case 301...500 :
            return "umbrella"
            
        case 501...600 :
            return "umbrella"
            
        case 601...700 :
            return "neck"
            
        case 701...771 :
            return "cap"
            
        case 772...799 :
            return "yellowHat"
            
        case 800 :
            return "sunglasses"
            
        case 801...804 :
            return "yellowHat"
            
        case 900...903, 905...1000  :
            return "neck"
            
        case 903 :
            return "neck"
            
        case 904 :
            return "bathingShorts"
            
        default :
            return "dunno"
        
        }
    }
    
    func updateWeatherIcon(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "tstorm1"
            
        case 301...500 :
            return "light_rain"
            
        case 501...600 :
            return "shower3"
            
        case 601...700 :
            return "snow4"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "tstorm3"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy2"
            
        case 900...903, 905...1000  :
            return "tstorm3"
            
        case 903 :
            return "snow5"
            
        case 904 :
            return "sunny"
            
        default :
            return "dunno"
        }
        
    }

}
