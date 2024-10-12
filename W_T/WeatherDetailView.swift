//
//  WeatherDetailView 2.swift
//  W_T
//
//  Created by Lakshmi on 10/10/24.
//



import SwiftUI

struct WeatherDetailView: View {
    @ObservedObject var viewModel: WeatherDetailViewModel
    
    var body: some View {
        VStack {
            Text("Weather Details")
                .font(.largeTitle)
            
            Text("Temperature: \(viewModel.weather.main.temp)°F")
            Text("Description: \(viewModel.weather.weather.first?.description ?? "")")
        }
        .padding()
    }
}

