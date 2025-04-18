//
//  WeatherView.swift
//  WeatherClientSwiftUI
//
//  Created by Ruslan Liulka on 29.01.2025.
//

import SwiftUI
import SwiftData

struct WeatherView: View {
    

    @StateObject private var viewModel = WeatherViewModel()
    @State private var segmentValue = 0
    @Environment(\.modelContext) private var modelContext
    @Query private var savedWeatherItems: [SwiftDataSave]
    

    var body: some View {
        
        VStack {
            Picker("Type", selection: $segmentValue) {
                Text("City").tag(0)
                Text("Coordinates").tag(1)
            }
            .pickerStyle(.segmented)
            
            .onChange(of: segmentValue) { oldValue, newValue in
                print("new value: \(newValue)")
            }
            
            if segmentValue == 0 {
                TextField( "city name", text: $viewModel.city)
                    .padding(10)
                    .textFieldStyle(.roundedBorder)
                
            } else {
                TextField( "latitude", text: $viewModel.latitude)
                    .padding(10)
                    .textFieldStyle(.roundedBorder)
                TextField( "longitude", text: $viewModel.longitude)
                    .padding(10)
                    .textFieldStyle(.roundedBorder)
            }
            
            Button("Search 🔎") {
                if segmentValue == 0 {
                    print(viewModel.city)
                    Task {
                        await viewModel.fetchWeatherCity()
                        
                    }
                } else {
                    print("Lat: \(viewModel.latitude), lon: \(viewModel.longitude)")
                    Task {
                        await viewModel.fetchWeatherCoordinate()
                        
                    }
                    
                }
            }
            .frame(width: 100)
            .buttonStyle(.automatic)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            
            Button("Save") {
                Task {
                    await viewModel.saveToSwiftData(context: modelContext)
                }
            }
            .frame(width: 100)
            .buttonStyle(.automatic)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            
            
            Button("Load") {
                Task {
                    await viewModel.loadFromSwiftData(context: modelContext)
                }
            }
            .frame(width: 100)
            .buttonStyle(.automatic)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            
            Spacer()
            
            WeatherInfoView(viewModel: viewModel)
            
            Spacer()
            
        }
        .padding()
        .onAppear(){
            Task {
                //await viewModel.load()
            }
        }
        .modelContainer(for: SwiftDataSave.self)
        
    }
        
        
}


#Preview {
    WeatherView()
}


