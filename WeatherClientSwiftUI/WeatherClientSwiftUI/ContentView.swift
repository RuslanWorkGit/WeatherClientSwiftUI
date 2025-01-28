//
//  ContentView.swift
//  WeatherClientSwiftUI
//
//  Created by Ruslan Liulka on 28.01.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var city: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var segmentValue = 0
    
    
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
                TextField( "city name", text: $city)
                    .padding(10)
                    .textFieldStyle(.roundedBorder)
                    
            } else {
                TextField( "latitude", text: $latitude)
                    .padding(10)
                    .textFieldStyle(.roundedBorder)
                TextField( "longitude", text: $longitude)
                    .padding(10)
                    .textFieldStyle(.roundedBorder)
            }
            
            Button("Search 🔎") {
                if segmentValue == 0 {
                    Task{
                        
                    }
                } else {
                    
                }
            }
            .buttonStyle(.automatic)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
   
            Spacer()
            
            
        }
        .padding()
        
    }
    
    
}

#Preview {
    ContentView()
}
