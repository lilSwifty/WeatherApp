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
    var save : Bool = false
    
    func giveGoodTips(condition: Int) -> String {
        
        switch (condition) {
            
        case 0...300 :
            return "It's windy outside! Hold your hat!"
            
        case 301...500 :
            return "You might experience some light rain.."
            
        case 501...600 :
            return "Don't forget your umbrella!"
            
        case 601...700 :
            return "It's snowing! Grab some good boots!"
            
        case 701...771 :
            return "Be careful if you're driving..."
            
        case 772...799 :
            return "Expect the worst. Best to just keep inside!"
            
        case 800 :
            return "What a lovely weather, you should go for a walk"
            
        case 801...804 :
            return "You might see the sun..."
            
        case 900...903, 905...1000  :
            return "Holy shit, it's armageddon"
            
        case 903 :
            return "snow, snow, snow, when will it end?"
            
        case 904 :
            return "Glory! Praise the lord for this weather"
            
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
