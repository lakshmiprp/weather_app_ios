//
//  WeatherCoordinator.swift
//  W_T
//
//  Created by Lakshmi on 10/10/24.
//

import Foundation
import UIKit
import SwiftUI
import Combine

class WeatherCoordinator: ObservableObject {
    @Published var isDetailActive: Bool = false
    
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func showWeatherDetail(weather: Weather) {
        let detailViewModel = WeatherDetailViewModel(weather: weather)
        let weatherDetailView = WeatherDetailView(viewModel: detailViewModel)
        let detailHostingController = UIHostingController(rootView: weatherDetailView)
        navigationController?.pushViewController(detailHostingController, animated: true)
    }
}
