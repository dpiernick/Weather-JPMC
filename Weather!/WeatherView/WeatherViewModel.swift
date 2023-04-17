//
//  WeatherViewModel.swift
//  Weather!
//
//  Created by Dave Piernick on 4/16/23.
//

import Foundation
import SwiftUI

@MainActor class WeatherViewModel: ObservableObject {
    
    var location: Location
    @Published var weather: WeatherModel?
    @Published var image: UIImage?
    
    init(location: Location) {
        self.location = location
        Task { await self.getWeather(for: location) }
    }
    
    func weatherURLString(lat: Double, lon: Double) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=imperial&appid=\(String.apiKey())"
    }
    
    func sunriseTime() -> String {
        let timeInterval = TimeInterval(weather?.sunriseSunset?.sunrise ?? 0)
        let date = Date(timeIntervalSince1970: timeInterval)
        return date.formatted(date: .omitted, time: .shortened)
    }
    
    func sunsetTime() -> String {
        let timeInterval = TimeInterval(weather?.sunriseSunset?.sunset ?? 0)
        let date = Date(timeIntervalSince1970: timeInterval)
        return date.formatted(date: .omitted, time: .shortened)
    }
    
    func getWeather(for location: Location) async {
        guard let lat = location.lat,
              let lon = location.lon,
              let url = URL(string: weatherURLString(lat: lat, lon: lon)) else { return }
          
        do {
            let request = URLRequest(url: url)
            let (data, _) = try await URLSession.shared.data(for: request)
            let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
            self.image = await getImage(code: weather.weather?.first?.icon ?? "")
            DispatchQueue.main.async {
                self.weather = weather
                UserDefaults.standard.saveObject(location, forKey: User.lastLocationString)
            }
        } catch {
            print(error)
        }
    }
    
    func getImage(code: String) async -> UIImage? {
        if let image = getImageFromCache(code: code) {
            return image
        } else {
            return await fetchImage(code: code)
        }
    }
    
    func getImageFromCache(code: String) -> UIImage? {
        return UIImage(data: UserDefaults.standard.object(forKey: code) as? Data ?? Data())
    }
    
    func fetchImage(code: String) async -> UIImage? {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(code)@2x.png") else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                UserDefaults.standard.set(data, forKey: code)
                return image
            } else {
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
}
