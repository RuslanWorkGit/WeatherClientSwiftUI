//
//  NetworkManager.swift
//  WeatherClientSwiftUI
//
//  Created by Ruslan Liulka on 19.02.2025.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    func fetchWeather(byCyti city: String, completion: @escaping (WeatherResult) -> Void) async {
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
                
                DispatchQueue.main.async {
                    completion(decodeData)
                    //self.updateUI(with: decodeData)
                }
                
            } catch(let parseError){
                print(parseError)
            }
        }
        task.resume()
  
        print("Fetching weather for city: \(city)")
    }
    
    func fetchWeather(byLatitude latitude: String, byLongitude longitude: String, completion: @escaping (WeatherResult) -> Void) async {
        
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
                    completion(decodeData)
                    //self.updateUI(with: decodeData)
                }
                
            } catch(let parseError) {
                print(parseError)
            }
        }
        task.resume()
        
        print("Fetching weather for latitude: \(latitude), longitude: \(longitude)")
    }
}
