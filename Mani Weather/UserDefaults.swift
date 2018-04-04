//
//  UserDefaults.swift
//  Mani Weather
//
//  Created by Mani Sedighi on 2018-04-04.
//  Copyright © 2018 Mani Sedighi. All rights reserved.
//

import Foundation


class Defaults {
    let saved = UserDefaults.standard
    let key = "FavoriteCities"
    
    func saveCity(_ cityName: [String]){
        let encodeData: Data = NSKeyedArchiver.archivedData(withRootObject: cityName)
        saved.set(encodeData, forKey: key)
        if saved.synchronize(){
            print("Succes")
        } else {
            print("no succes")
        }
    }
    
    func addData(city: String){
        
        if !checkFavorite(city){
            var savedData = getData()
            savedData.append(city)
            saveCity(savedData)
        }
    }
    
    func getData() -> [String] {
        let savedData = saved.object(forKey: key)
        
        if savedData is [String]{
            return savedData as! [String]
        } else {
            return []
        }
    }
    
    func checkFavorite(_ city: String) -> Bool {
        return getData().contains(city)
    }
    
    func removeFavorite(city: String){
        let deleteFavorites = getData().filter {
            $0 != city
        }
        saveCity(deleteFavorites)
    }
    
    
}


