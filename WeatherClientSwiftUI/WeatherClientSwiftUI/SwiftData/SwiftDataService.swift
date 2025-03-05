//
//  SwiftDataService.swift
//  WeatherClientSwiftUI
//
//  Created by Ruslan Liulka on 04.03.2025.
//

import Foundation
import SwiftData

class SwiftDataService {
    
    static let share = SwiftDataService()
    
    private let container: ModelContainer
    private let context: ModelContext
    
    private init() {
        do {
            container = try ModelContainer(for: SwiftDataSave.self)
            context = ModelContext(container)
        } catch {
            fatalError("Failed initiate SwiftData: \(error.localizedDescription)")
        }
    }
    
    func insertData(with weather: WeatherResult) -> SwiftDataSave {
        let result = SwiftDataSave(id: weather.id, name: weather.name, date: Date(), weatherDescription: weather.weather[0].description, humidity: weather.main.humidity, preassure: weather.main.pressure, temp: weather.main.temp, windDeg: weather.wind.deg, lat: weather.coord.lat, lon: weather.coord.lon)
        
        return result
    }
    
    func insertWeather(with weather: WeatherResult) {
        let newWeather = insertData(with: weather)
        
    }
}
