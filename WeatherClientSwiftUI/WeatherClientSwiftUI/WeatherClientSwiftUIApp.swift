//
//  WeatherClientSwiftUIApp.swift
//  WeatherClientSwiftUI
//
//  Created by Ruslan Liulka on 28.01.2025.
//

import SwiftUI
import SwiftData

@main
struct WeatherClientSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView()
        }
        .modelContainer(for: SwiftDataSave.self)
    }
}
