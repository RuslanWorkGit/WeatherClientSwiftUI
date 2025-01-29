//
//  WeatherModel.swift
//  WeatherClientSwiftUI
//
//  Created by Ruslan Liulka on 29.01.2025.
//


import Foundation

struct WeatherResult: Codable {
    
    let coord: CityCoordainates
    let weather: [WeatherInfo]
    let base: String
    let main: Main
    let visibility: Int
    let wind: WindInfo
    let clouds: CloudsInfo
    let dt: Int
    let sys: SysInfo
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    
    struct CityCoordainates: Codable {
        let lon: Double
        let lat: Double
    }

    struct WeatherInfo: Codable {
        
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    struct Main: Codable {
        let temp, feelsLike, tempMin, tempMax: Double
        let pressure, humidity, seaLevel, grndLevel: Int
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure, humidity
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
    }

    struct WindInfo: Codable {
        let speed: Double
        let deg: Int
        let gust: Double
    }

    struct CloudsInfo: Codable {
        let all: Int
    }

    struct SysInfo: Codable {
        let country: String
        let sunrise, sunset: Int
    }

}



