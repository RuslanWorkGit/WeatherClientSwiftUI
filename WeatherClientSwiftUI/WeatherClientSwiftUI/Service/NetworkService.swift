//
//  NetworkManager.swift
//  WeatherClientSwiftUI
//
//  Created by Ruslan Liulka on 19.02.2025.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    func fetchWeather(byCyti city: String) async throws -> WeatherResult {
        let linkApi = ConstantLink.mainLink.rawValue + ConstantLink.city.rawValue + "\(city)" + "&" + ConstantLink.appid.rawValue + "&" + ConstantLink.metrics.rawValue
       
        
        guard let url = URL(string: linkApi) else {
            assertionFailure("Wrong link Api \(linkApi)")
            throw URLError(.badURL)
        }
        
        var requestUrl = URLRequest(url: url)
        requestUrl.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: requestUrl)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(WeatherResult.self, from: data)
    }
    
    func fetchWeather(byLatitude latitude: String, byLongitude longitude: String) async throws -> WeatherResult{
        
        let linkApi = ConstantLink.mainLink.rawValue + ConstantLink.latitude.rawValue + "\(latitude)" + "&" + ConstantLink.longitude.rawValue + "\(longitude)" + "&" + ConstantLink.appid.rawValue + "&" + ConstantLink.metrics.rawValue
        
        guard let url = URL(string: linkApi) else {
            assertionFailure("Wring url link: \(linkApi)")
            throw URLError(.badURL)
        }
        
        var requestUrl = URLRequest(url: url)
        requestUrl.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: requestUrl)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(WeatherResult.self, from: data)
        
    }
}
