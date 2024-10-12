//
//  WeatherDetailViewModel.swift
//  W_T
//
//  Created by Lakshmi on 10/10/24.
//


import Foundation

class WeatherDetailViewModel: ObservableObject {
    @Published var weather: Weather
    
    init(weather: Weather) {
        self.weather = weather
    }
}
