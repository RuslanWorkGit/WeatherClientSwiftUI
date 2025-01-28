//
//  NetworkManager.swift
//  WeatherClientSwiftUI
//
//  Created by Ruslan Liulka on 28.01.2025.
//

import Foundation

enum ConstantLink: String {
    case mainLink = "https://api.openweathermap.org/data/2.5/weather?"
    case city = "q="
    case latitude = "lat="
    case longitude = "lon="
    case appid = "appid=9150ef8248678c9c51a5dfe2d87e208d"
    case metrics = "units=metric"
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private func fetchWeather(byCyti city: String) {
        let linkApi = ConstantLink.mainLink.rawValue + ConstantLink.city.rawValue + "\(city)" + "&" + ConstantLink.appid.rawValue + "&" + ConstantLink.metrics.rawValue
       
        
        guard let url = URL(string: linkApi) else {
            assertionFailure("Wrong link Api \(linkApi)")
            return
        }
        
        var requestUrl = URLRequest(url: url)
        requestUrl.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: requestUrl) { data, response, error in
            if let responseError = error {
                assertionFailure("\(responseError)")
            }
            
            guard let responseData = data else {
                assertionFailure("Problem with data")
                return
            }
            
            do {
                let decodeData = try JSONDecoder().decode(WeatherResult.self, from: responseData)
//                print(decodeData)
                
                DispatchQueue.main.async {
                    //self.showWeatherDetails(with: decodeData)
                }
                
            } catch(let parseError){
                print(parseError)
            }
        }
        task.resume()
  
        print("Fetching weather for city: \(city)")
    }
    
    private func fetchWeather(byLatitude latitude: String, byLongitude longitude: String) {
        
        let linkApi = ConstantLink.mainLink.rawValue + ConstantLink.latitude.rawValue + "\(latitude)" + "&" + ConstantLink.longitude.rawValue + "\(longitude)" + "&" + ConstantLink.appid.rawValue + "&" + ConstantLink.metrics.rawValue
        
        guard let url = URL(string: linkApi) else {
            assertionFailure("Wring url link: \(linkApi)")
            return
        }
        
        var requestUrl = URLRequest(url: url)
        requestUrl.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: requestUrl) { data, response, error in
            if let responseError = error {
                assertionFailure("\(responseError)")
            }
            
            guard let responseData = data else {
                assertionFailure("No data")
                return
            }
            
            do {
                let decodeData = try JSONDecoder().decode(WeatherResult.self, from: responseData)
                print(decodeData)
                
                DispatchQueue.main.async {
                    //self.showWeatherDetails(with: decodeData)
                }
                
            } catch(let parseError) {
                print(parseError)
            }
        }
        task.resume()
        
        print("Fetching weather for latitude: \(latitude), longitude: \(longitude)")
    }
    
}
