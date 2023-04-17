//
//  Weather_Tests.swift
//  Weather!Tests
//
//  Created by Dave Piernick on 4/13/23.
//

import XCTest
import CoreLocation
@testable import Weather_

final class Weather_Tests: XCTestCase {
    
    let loc = Location(name: "Test", state: "Test", country: "Test", lat: 42, lon: -85)
    
    func testGetLocationForCoord() async {
        let vm = SearchViewModel()
        let coord = CLLocationCoordinate2D(latitude: 42, longitude: -85)
        let loc = await vm.getLocationForCLLocationCoord(coord)
        XCTAssertNotNil(loc.name)
    }
    
    func testUpdateSearchTerm() {
        let vc = SearchViewController()
        _ = vc.view
        vc.searchViewModel.task = Task { try? await Task.sleep(for: .seconds(1)) }
        vc.searchViewModel.results = [Location()]
        vc.searchViewModel.updateSearchTask("D")
        
        XCTAssertTrue(vc.searchViewModel.task.isCancelled)
        XCTAssertTrue(vc.searchViewModel.results.isEmpty)
        XCTAssertTrue(vc.activityIndicator.isAnimating)
    }
    
    func testUpdateSearchTermBlank() {
        let vc = SearchViewController()
        _ = vc.view
        vc.searchViewModel.task = Task { try? await Task.sleep(for: .seconds(1)) }
        vc.searchViewModel.results = [Location()]
        vc.searchViewModel.updateSearchTask("")
        
        XCTAssertTrue(vc.searchViewModel.task.isCancelled)
        XCTAssertTrue(vc.searchViewModel.results.isEmpty)
        XCTAssertTrue(vc.activityIndicator.isAnimating == false)
    }

    func testFetchSuggestions() async {
        let viewModel = SearchViewModel()
        await viewModel.fetchSuggestions("A")
        XCTAssertNotNil(viewModel.results)
    }
    
    func testGetWeather() async {
        let vm = await WeatherViewModel(location: loc)
        await vm.getWeather(for: loc)
        let weather = await vm.weather
        XCTAssertNotNil(weather)
    }
    
    func testFetchImage() async {
        let vm = await WeatherViewModel(location: loc)
        let image = await vm.fetchImage(code: "01d")
        XCTAssertNotNil(image)
    }
    
    func testGetImageFromCache() async {
        let vm = await WeatherViewModel(location: loc)
        _ = await vm.fetchImage(code: "01d")
        let image = await vm.getImageFromCache(code: "01d")
        XCTAssertNotNil(image)
    }
}
