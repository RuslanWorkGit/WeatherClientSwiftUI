//
//  WeatherViewModel.swift
//  WeatherClientSwiftUI
//
//  Created by Ruslan Liulka on 29.01.2025.
//

import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    
    @Published var temperature: String = "--"
    @Published var pressure: String = "0.0"
    @Published var humidity: String = "0.0"
    @Published var description: String = "Loading..."
    @Published var wind: String = "none"
    
    @Published var city: String = ""
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    
 
    func fetchWeather(byCyti city: String) async {
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
                    self.updateUI(with: decodeData)
                }
                
            } catch(let parseError){
                print(parseError)
            }
        }
        task.resume()
  
        print("Fetching weather for city: \(city)")
    }
    
    func fetchWeather(byLatitude latitude: String, byLongitude longitude: String) async {
        
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
                    self.updateUI(with: decodeData)
                }
                
            } catch(let parseError) {
                print(parseError)
            }
        }
        task.resume()
        
        print("Fetching weather for latitude: \(latitude), longitude: \(longitude)")
    }

    private func updateUI(with weather: WeatherResult) {
        temperature = "\(weather.main.temp) C"
        pressure = "\(weather.main.pressure)"
        humidity = "\(weather.main.humidity)"
        description = weather.weather.first?.description.capitalized ?? "N/A"
        wind = windDirection(deg: weather.wind.deg)
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
