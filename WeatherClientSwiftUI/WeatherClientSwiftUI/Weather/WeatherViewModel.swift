//
//  WeatherViewModel.swift
//  WeatherClientSwiftUI
//
//  Created by Ruslan Liulka on 29.01.2025.
//

import Foundation

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
    
    @Published var currentWeather: StoredWeather?
    
    private let networkService: NetworkService
    private let fileService: FileServiceProtocol
    private let fileName: String = "weather.json"
    private let updateTime: TimeInterval = 3 * 60 * 60
    
    
    init(fileService: FileServiceProtocol = FileService(), networkService: NetworkService = .shared) {
        self.fileService = fileService
        self.networkService = networkService
    }
    
    
    func fetchWeatherCity() async {
        guard !city.isEmpty else { return }
        
        do {
            let weather = try await networkService.fetchWeather(byCyti: city)
            print("Fetching wether for city: \(city)")
            updateUI(with: weather)
            currentWeather = StoredWeather(weather: weather, time: Date().timeIntervalSince1970)
        } catch {
            print("Error fetching weather: \(error)")
        }
    }
    
    func fetchWeatherCoordinate() async {
        
        guard !latitude.isEmpty, !longitude.isEmpty else { return }
        
        do {
            let weather = try await networkService.fetchWeather(byLatitude: latitude, byLongitude: longitude)
            print("Fetching weather for coord: lat = \(latitude), lon = \(longitude)")
            updateUI(with: weather)
            currentWeather = StoredWeather(weather: weather, time: Date().timeIntervalSince1970)
        } catch {
            print("Error fethcin weather: \(error)")
        }
    }
    
    func updateUI(with weather: WeatherResult) {
        cityName = "\(weather.name)"
        temperature = "\(weather.main.temp) C"
        pressure = "\(weather.main.pressure)"
        humidity = "\(weather.main.humidity)"
        description = weather.weather.first?.description.capitalized ?? "N/A"
        wind = windDirection(deg: weather.wind.deg)

    }
    
    func save() {
        guard let weather = currentWeather else {
            print("No weather data to save")
            return
        }
        
        do {
            try fileService.saveData(object: weather, fileName: fileName)
            timeUpdate = "Last update: \(formateDate(timeInterval: Date().timeIntervalSince1970))"
            print("Data saved")
        } catch {
            print("Error save data")
        }
    }
    
    func load() async {
        do {
            let saveWeather = try fileService.loadData(type: StoredWeather.self, fileName: fileName)
            updateUI(with: saveWeather.weather)
            timeUpdate = "Last update: \(formateDate(timeInterval: saveWeather.time))"
    
            let currentTime = Date().timeIntervalSince1970
            let timeDifference = currentTime - saveWeather.time
            
            if timeDifference > updateTime {
                print("Data need to update")
                
                let updateWeather = try await networkService.fetchWeather(byCyti: saveWeather.weather.name)
                currentWeather = StoredWeather(weather: updateWeather, time: Date().timeIntervalSince1970)
                save()
            } else {
                print("Data no need to update")
            }
        } catch {
            print("Error load data")
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
