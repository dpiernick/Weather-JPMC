//
//  WeatherModel.swift
//  Weather!
//
//  Created by Dave Piernick on 4/14/23.
//

import Foundation

struct WeatherModel: Codable {
    var weather: [Weather]?
    var temp: Temperature?
    var sunriseSunset: SunriseSunset?
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temp = "main"
        case sunriseSunset = "sys"
    }
}

struct Weather: Codable {
    var id: Int?
    var description: String?
    var icon: String?
}

struct Temperature: Codable {
    var temp: Float?
    var temp_min: Float?
    var temp_max: Float?
}

struct SunriseSunset: Codable {
    var sunrise: Int?
    var sunset: Int?
}
