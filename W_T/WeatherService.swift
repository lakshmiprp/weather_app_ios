//
//  WeatherService.swift
//  W_T
//
//  Created by Admin on 10/10/24.
//

import Combine
import Foundation

enum WeatherQuery: Equatable {
    case cityName(String)
    case zipCode(String)
    case cityID(Int)
}


protocol WeatherServiceProtocol {
    func fetchWeather(for query: WeatherQuery) -> AnyPublisher<Weather, Error>
}

class WeatherService: WeatherServiceProtocol  {
    func fetchWeather(for query: WeatherQuery) -> AnyPublisher<Weather, Error> {
        let apiKey = "725a6b86ac28246464d17fdf250632c6"
        let defaultCountry = "US"
        var input = ""
        switch query {
        case .cityName(let string):
            input = "q=\(string)"
        case .zipCode(let string):
            input = "zip=\(string)"
        case .cityID(let int):
            input = "id=\(int)"
        }
        if input.components(separatedBy: ",").last?.lowercased() != defaultCountry.lowercased() {
            input += ",\(defaultCountry)"
        }
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?\(input)&appid=\(apiKey)&units=imperial"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                       if let response = output.response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                           let errorResponse = try JSONDecoder().decode(WeatherError.self, from: output.data)
                           throw errorResponse
                       }
                       return output.data
                   }
            .decode(type: Weather.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct WeatherError: Decodable, Error {
    let cod: String
    let message: String
}
