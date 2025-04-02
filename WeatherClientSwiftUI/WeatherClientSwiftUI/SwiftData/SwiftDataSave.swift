//
//  SwiftDataSave.swift
//  WeatherClientSwiftUI
//
//  Created by Ruslan Liulka on 04.03.2025.
//

import Foundation
import SwiftData

@Model
class SwiftDataSave {
    
    var id: Int
    var name: String
    var date: Date
    var weatherDescription: String
    var humidity: Int
    var preassure: Int
    var temp: Double
    var windDeg: Int
    var lat: Double
    var lon: Double
    
    init(id: Int, name: String, date: Date, weatherDescription: String, humidity: Int, preassure: Int, temp: Double, windDeg: Int, lat: Double, lon: Double) {
        self.id = id
        self.name = name
        self.date = date
        self.weatherDescription = weatherDescription
        self.humidity = humidity
        self.preassure = preassure
        self.temp = temp
        self.windDeg = windDeg
        self.lat = lat
        self.lon = lon
    }
}
