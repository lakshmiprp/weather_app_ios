//
//  MockWeatherService.swift
//  W_T
//
//  Created by Lakshmi on 10/11/24.

import Combine
@testable import W_T

class MockWeatherService: WeatherServiceProtocol {
    var weatherResult: Result<Weather, Error>?

    func fetchWeather(for query: WeatherQuery) -> AnyPublisher<Weather, Error> {
        return Future { promise in
            if let result = self.weatherResult {
                promise(result)
            } else {
                let error = WeatherError(cod: "404", message: "City not found")
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}

