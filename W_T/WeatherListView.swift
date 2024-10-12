//
//  WeatherListView.swift
//  W_T
//
//  Created by Admin on 10/10/24.
//

import SwiftUI

struct WeatherListView: View {
    @StateObject var viewModel: WeatherViewModel = .init()
    @EnvironmentObject var coordinator: WeatherCoordinator

    var body: some View {
        VStack {
            TextField("Enter City, Zip Code, or City ID", text: $viewModel.city, onCommit: {
                viewModel.getWeather()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

            if let weather = viewModel.weather {
                VStack {
                    Text("Temperature: \(weather.main.temp)°F")
                        .font(.largeTitle)
                    Text(weather.weather.first?.description.capitalized ?? "")
                    if let icon = weather.weather.first?.icon,
                       let iconURL = viewModel.iconURL(for: icon) {
                        AsyncImage(url: iconURL) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                    }
                }
                .padding()
                Button("Show Details") {
                    coordinator.showWeatherDetail(weather: weather)
                }
                .padding()
            } else if !viewModel.errorMessage.isEmpty {
                Text("Error: \(viewModel.errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            Spacer()
        }
        .navigationTitle("Weather")
        .task {
            viewModel.getWeather()
        }
    }
}
