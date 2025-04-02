//
//  WeatherViewModel.swift
//  WeatherClientSwiftUI
//
//  Created by Ruslan Liulka on 29.01.2025.
//

import Foundation
import SwiftData

@MainActor
class WeatherViewModel: ObservableObject {
    
    @Published var cityName: String = "Loading.."
    @Published var temperature: String = "--"
    @Published var pressure: String = "0.0"
    @Published var humidity: String = "0.0"
    @Published var description: String = "Loading..."
    @Published var wind: String = "none"
    @Published var timeUpdate: String = ""
    
    @Published var city: String = ""
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    
//    @Published var currentWeather: StoredWeather?
    @Published var weatherResult: WeatherResult?
    
    private let networkService: NetworkService
    private let fileService: FileServiceProtocol
    private let fileName: String = "weather.json"
    private let updateTime: TimeInterval = 10
    

    init(fileService: FileServiceProtocol = FileService(), networkService: NetworkService = .shared) {
        self.fileService = fileService
        self.networkService = networkService

    }
    
    
    func fetchWeatherCity() async {
        guard !city.isEmpty else { return }
        
        do {
            let weather = try await networkService.fetchWeather(byCyti: city)
            print("Fetching wether for city: \(city)")
            updateUI(with: weather, time: Date())
            weatherResult = weather
            //currentWeather = StoredWeather(weather: weather, time: Date().timeIntervalSince1970)

            
        } catch {
            print("Error fetching weather: \(error)")
        }
    }
    
    func fetchWeatherCoordinate() async {
        
        guard !latitude.isEmpty, !longitude.isEmpty else { return }
        
        do {
            let weather = try await networkService.fetchWeather(byLatitude: latitude, byLongitude: longitude)
            print("Fetching weather for coord: lat = \(latitude), lon = \(longitude)")
            updateUI(with: weather, time: Date())
            weatherResult = weather
           // currentWeather = StoredWeather(weather: weather, time: Date().timeIntervalSince1970)
        } catch {
            print("Error fethcin weather: \(error)")
        }
    }
    
    func updateUI(with weather: WeatherResult, time: Date? = nil) {
        cityName = "\(weather.name)"
        temperature = "\(weather.main.temp) C"
        pressure = "\(weather.main.pressure)"
        humidity = "\(weather.main.humidity)"
        description = weather.weather.first?.description.capitalized ?? "N/A"
        wind = windDirection(deg: weather.wind.deg)
        
        if let updateTime = time {
            timeUpdate = "Last updte: \(formateDate(timeInterval: updateTime.timeIntervalSince1970))"
        }

    }
    
    func saveToSwiftData(context: ModelContext) async {
        guard let weather = weatherResult else {
            print("No data with weather")
            return
        }
        
        let newWeather = SwiftDataSave(id: weather.id, name: weather.name, date: Date(), weatherDescription: weather.weather[0].description, humidity: weather.main.humidity, preassure: weather.main.pressure, temp: weather.main.temp, windDeg: weather.wind.deg, lat: weather.coord.lat, lon: weather.coord.lon)
        
        context.insert(newWeather)
        
        do {
            try context.save()
            print("Weather succesfully saved to SwiftData")
        } catch {
            print("Error to save!!")
        }
    }
    
    func inserWeatherData(with saveWeather: SwiftDataSave) -> WeatherResult {
        let result = WeatherResult(coord: WeatherResult.CityCoordainates.init(lon: saveWeather.lon, lat: saveWeather.lon),
                                   weather: [WeatherResult.WeatherInfo.init(id: 0, main: "", description: saveWeather.weatherDescription, icon: "")],
                                   base: "",
                                   main: WeatherResult.Main.init(temp: saveWeather.temp, feelsLike: 0, tempMin: 0, tempMax: 0, pressure: saveWeather.preassure, humidity: saveWeather.humidity, seaLevel: 0, grndLevel: 0),
                                   visibility: 0,
                                   wind: WeatherResult.WindInfo.init(speed: 0, deg: saveWeather.windDeg, gust: 0),
                                   clouds: WeatherResult.CloudsInfo.init(all: 0),
                                   dt: 0,
                                   sys: WeatherResult.SysInfo.init(country: "", sunrise: 0, sunset: 0),
                                   timezone: 0,
                                   id: saveWeather.id,
                                   name: saveWeather.name,
                                   cod: 0)
        return result
    }
    
    @MainActor
    func loadFromSwiftData(context: ModelContext) async {
        do {
            let descriptor = FetchDescriptor<SwiftDataSave>(sortBy: [SortDescriptor(\.date, order: .reverse)])
            let savedWeather = try context.fetch(descriptor)
            
            if let lastWeather = savedWeather.first {
                let weatherResult = inserWeatherData(with: lastWeather)
                
                print("Data load from SwiftData")
                
                let currentTime = Date().timeIntervalSince1970
                let timeDifference = currentTime - lastWeather.date.timeIntervalSince1970
                
                if timeDifference > updateTime {
                    
                    print("Data need to be update")
                    let updateWeather = try await networkService.fetchWeather(byCyti: weatherResult.name)
                    updateUI(with: updateWeather, time: Date())
                    //currentWeather = StoredWeather(weather: updateWeather, time: Date().timeIntervalSince1970)
                    await saveToSwiftData(context: context)
                    
                    
                } else {
                    updateUI(with: weatherResult, time: lastWeather.date)
                    print("Data does not need to update")
                }
            }
        } catch {
            print("Error load from swift data: \(error.localizedDescription)")
        }
        
    }
    
    private func formateDate(timeInterval: TimeInterval) -> String{
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    private func windDirection(deg: Int) -> String {
        switch deg {
        case 337...360, 0..<22:
            return "North"
        case 22..<67:
            return "North-East"
        case 67..<112:
            return "East"
        case 112..<157:
            return "South-East"
        case 157..<202:
            return "South"
        case 202..<247:
            return "South-West"
        case 247..<292:
            return "West"
        case 292..<337:
            return "North-West"
        default:
            return "Unknown"
        }

    }
    
}

