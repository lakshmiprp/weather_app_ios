//
//  WeatherViewModelTests.swift
//  W_TTests
//
//  Created by Lakshmi on 10/11/24.
//
import XCTest
import Combine
@testable import W_T

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: mockWeatherService)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockWeatherService = nil
        cancellables = nil
        super.tearDown()
    }

    func testIdentifyQueryType_cityName() {
        let query = viewModel.identifyQueryType(from: "Columbus")
        XCTAssertEqual(query, .cityName("Columbus"))
    }

    func testIdentifyQueryType_zipCode() {
        let query = viewModel.identifyQueryType(from: "12345,us")
        XCTAssertEqual(query, .zipCode("12345,us"))
    }

    func testIdentifyQueryType_cityID() {
        let query = viewModel.identifyQueryType(from: "123456")
        XCTAssertEqual(query, .cityID(123456))
    }

    func testIsValidZipCode_validUSZipCode() {
        XCTAssertTrue(viewModel.isValidZipCode("12345"))
        XCTAssertTrue(viewModel.isValidZipCode("12345,us"))
    }

    func testIsValidZipCode_invalidZipCode() {
        XCTAssertFalse(viewModel.isValidZipCode("ABCDE"))
        XCTAssertFalse(viewModel.isValidZipCode("1234"))
    }

    func testGetWeather_success() {
        let expectation = self.expectation(description: "Weather fetch should succeed")
        let mockWeather = Weather(name: "Columbus", main: .init(temp: 25.0), weather: [.init(description: "", icon: "10d")])
        mockWeatherService.weatherResult = .success(mockWeather)

        viewModel.getWeather()

        viewModel.$weather
            .sink { weather in
                XCTAssertEqual(weather?.name, "Columbus")
                XCTAssertEqual(weather?.main.temp
                               , 25)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testGetWeather_failure() {
        let expectation = self.expectation(description: "Weather fetch should fail")
        mockWeatherService.weatherResult = .failure(WeatherError(cod: "2", message: "Network error"))

        viewModel.getWeather()

        viewModel.$errorMessage
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "Network error")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

