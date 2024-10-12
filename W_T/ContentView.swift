//
//  ContentView.swift
//  W_T
//
//  Created by Lakshmi on 10/10/24.
//

import SwiftUI
import Combine
import UIKit

struct ContentView: View {
    var coordinator: WeatherCoordinator
    var body: some View {
        WeatherListView()
            .environmentObject(coordinator)
    }
}

struct Weather: Codable {
    let name: String
    let main: Main
    let weather: [WeatherCondition]
    
    struct Main: Codable {
        let temp: Double
    }
    
    struct WeatherCondition: Codable {
        let description: String
        let icon: String
    }
}
