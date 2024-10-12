//
//  WeatherViewModel.swift
//  W_T
//
//  Created by Lakshmi on 10/10/24.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weather: Weather?
    @Published var city: String = "Columbus"
    @Published var errorMessage: String = ""
    private var cancellables = Set<AnyCancellable>()
    private let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
    }

    func identifyQueryType(from input: String) -> WeatherQuery {
        let trimmedInput = input.trimmingCharacters(in: .whitespacesAndNewlines)

        if isValidZipCode(trimmedInput) {
            return .zipCode(trimmedInput)
        }
        
        if let cityID = Int(trimmedInput) {
            return .cityID(cityID)
        }
        
        return .cityName(trimmedInput)
    }

    func isValidZipCode(_ input: String) -> Bool {
        let zipCodeRegex = "^[0-9]{5}(?:-[0-9]{4})?(?:,[a-zA-Z]{2})?$"
        let zipCodePredicate = NSPredicate(format: "SELF MATCHES %@", zipCodeRegex)
        return zipCodePredicate.evaluate(with: input)
    }
    
    func getWeather() {
        let q = identifyQueryType(from: city)
        self.errorMessage = ""
        weatherService.fetchWeather(for: q)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.weather = nil
                    if let weatherError = error as? WeatherError {
                        self.errorMessage = weatherError.message
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                case .finished:
                    break
                }
            }, receiveValue: { weather in
                self.weather = weather
                self.city = weather.name
            })
            .store(in: &cancellables)
    }
    
    
    func iconURL(for icon: String) -> URL? {
        return URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
}
