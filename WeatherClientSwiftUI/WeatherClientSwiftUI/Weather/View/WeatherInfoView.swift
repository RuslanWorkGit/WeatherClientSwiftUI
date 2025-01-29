//
//  WeaterInfo.swift
//  WeatherClientSwiftUI
//
//  Created by Ruslan Liulka on 29.01.2025.
//

//
//  ContentView.swift
//  WeatherClientSwiftUI
//
//  Created by Ruslan Liulka on 28.01.2025.
//

import SwiftUI

struct WeatherInfoView: View {
    @ObservedObject var viewModel: WeatherViewModel

    var body: some View {
       
        VStack(spacing: 15) {
            Text("Tempereture: \(viewModel.temperature)")
            
            Text("Humidity: \(viewModel.humidity)")
            
            Text("Pressure: \(viewModel.pressure)")
            
            Text("Description: \(viewModel.description)")
            
            Text("Wind: \(viewModel.wind)")
            
            
        }
  
    }
    
    
}


