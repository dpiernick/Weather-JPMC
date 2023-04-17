//
//  WeatherViewController.swift
//  Weather!
//
//  Created by Dave Piernick on 4/16/23.
//

import UIKit
import SwiftUI

class WeatherViewController: UIViewController {
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(location: Location) {
        super.init(nibName: nil, bundle: nil)
        let weatherView = UIHostingController(rootView: WeatherView(location: location)).view ?? UIView()
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherView)
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    
    
}
