//
//  SearchViewModel.swift
//  Weather!
//
//  Created by Dave Piernick on 4/13/23.
//

import Foundation
import UIKit
import CoreLocation

protocol SearchViewModelDelegate {
    func updateSuggestions(_ locations: [Location])
    func animateActivityIndicator(_ shouldAnimate: Bool)
    func showNoResultsLabel(_ shouldShow: Bool)
    func launchWeatherVC(for location: Location)
}

class SearchViewModel: NSObject, CLLocationManagerDelegate {
    
    var delegate: SearchViewModelDelegate?
    var timer = Timer()
    var task = Task {}
    
    var results = [Location]() {
        didSet {
            delegate?.updateSuggestions(results)
        }
    }
    
    var locationManager: CLLocationManager?
    
    func geoURLString(_ searchTerm: String) -> String {
        return "http://api.openweathermap.org/geo/1.0/direct?q=\(searchTerm)&limit=5&appid=\(String.apiKey())"
    }
    
    func requestLocationPermissions() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        if !(locationManager?.authorizationStatus == .authorizedAlways || locationManager?.authorizationStatus == .authorizedWhenInUse) {
            locationManager?.requestAlwaysAuthorization()
        } else {
            Task {
                await fetchWeatherForCurrentLocation()
            }
        }
    }
    
    func fetchWeatherForCurrentLocation() async {
        guard let location = locationManager?.location?.coordinate else { return }
        let searchTerm = await getLocationForCLLocationCoord(location)
        delegate?.launchWeatherVC(for: searchTerm)
    }

    func getLocationForCLLocationCoord(_ coordinate: CLLocationCoordinate2D) async -> Location {
        let place = try? await CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)).first
        let city = place?.locality
        let state = place?.administrativeArea
        let country = place?.country
        let location = Location(name: city,
                                    state: state,
                                    country: country,
                                    lat: coordinate.latitude,
                                    lon: coordinate.longitude)
        return location
    }
    
    func autoSearchWeather() {
        if let loc = User.shared.lastSearchedLocation {
            delegate?.launchWeatherVC(for: loc)
        } else {
            requestLocationPermissions()
        }
    }
    
    func updateSearchTask(_ searchTerm: String) {
        task.cancel()
        results = []
        delegate?.showNoResultsLabel(false)
        
        if searchTerm != "" {
            delegate?.animateActivityIndicator(true)
            Task { await fetchSuggestions(searchTerm) }
        } else {
            delegate?.animateActivityIndicator(false)
            task.cancel()
        }
    }
    
    func fetchSuggestions(_ searchTerm: String) async {
        self.task = Task {
            try? await Task.sleep(for: .seconds(1))
            do {
                guard let url = URL(string: self.geoURLString(searchTerm)), task.isCancelled == false else { return }
                let request = URLRequest(url: url)
                let (data, _) = try await URLSession.shared.data(for: request)
                let locations = try? JSONDecoder().decode([Location].self, from: data)
                DispatchQueue.main.async {
                    self.results = (Array(Set(locations ?? [])))  //Remove Duplicates
                    self.delegate?.animateActivityIndicator(false)
                    self.delegate?.showNoResultsLabel(locations?.isEmpty ?? true)
                }
            } catch {
                DispatchQueue.main.async {
                    self.delegate?.animateActivityIndicator(false)
                    self.delegate?.showNoResultsLabel(true)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            Task {
                await fetchWeatherForCurrentLocation()
            }
        }
    }
}
