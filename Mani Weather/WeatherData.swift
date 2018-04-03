//
//  WeatherData.swift
//  Mani Weather
//
//  Created by Mani Sedighi on 2018-03-30.
//  Copyright © 2018 Mani Sedighi. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let temp: String
    let icon: String
}
