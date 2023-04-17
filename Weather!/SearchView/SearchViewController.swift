//
//  ViewController.swift
//  Weather!
//
//  Created by Dave Piernick on 4/13/23.
//

import UIKit
import SwiftUI

class SearchViewController: UIViewController {
    
    let searchViewModel = SearchViewModel()
    let searchBar = UISearchBar()
    var searchBarTopOffset = NSLayoutConstraint()
    var searchBarTopPadding: CGFloat = 100
    var searchBarSidePadding: CGFloat = 20
    
    let resultsTableView = UITableView()
    var resultsTableViewHeight = NSLayoutConstraint()
    
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let noResultsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchViewModel.delegate = self
        
        let placeHolderView = UIHostingController(rootView: PlaceHolderView())
        placeHolderView.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeHolderView.view)
        NSLayoutConstraint.activate([placeHolderView.view.topAnchor.constraint(equalTo: view.topAnchor),
                                     placeHolderView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     placeHolderView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     placeHolderView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .black
        searchBar.searchTextField.leftView?.tintColor = .black
        searchBar.searchTextField.backgroundColor = .white
        searchBarTopOffset = searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: searchBarTopPadding)

        view.addSubview(searchBar)
        NSLayoutConstraint.activate([searchBarTopOffset,
                                     searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: searchBarSidePadding),
                                     searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -searchBarSidePadding),
                                     searchBar.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)])
        
        resultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        resultsTableView.translatesAutoresizingMaskIntoConstraints = false
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.layer.borderColor = UIColor.lightGray.cgColor
        resultsTableView.layer.borderWidth = 1
        view.addSubview(resultsTableView)
        NSLayoutConstraint.activate([resultsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                                     resultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: searchBarSidePadding),
                                     resultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -searchBarSidePadding),
                                     resultsTableView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)])
        
        resultsTableViewHeight = resultsTableView.heightAnchor.constraint(equalToConstant: 0)
        resultsTableViewHeight.isActive = true
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: -20),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)])

        noResultsLabel.text = "No locations with that name!"
        noResultsLabel.textColor = .white
        noResultsLabel.isHidden = true
        noResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noResultsLabel)
        noResultsLabel.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor).isActive = true
        noResultsLabel.centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor).isActive = true
                
        searchViewModel.autoSearchWeather()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewModel.updateSearchTask(searchText)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchViewModel.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.contentConfiguration = UIHostingConfiguration {
            Text(String.locationDisplayString(searchViewModel.results[indexPath.row]))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        launchWeatherVC(for: searchViewModel.results[indexPath.row])
        searchViewModel.results = []
    }
}

extension SearchViewController: SearchViewModelDelegate {
    func updateSuggestions(_ locations: [Location]) {
        resultsTableView.reloadData()
        
        self.searchBarTopOffset.constant = locations.isEmpty ? self.searchBarTopPadding : 0
        self.resultsTableViewHeight.constant = self.resultsTableView.contentSize.height
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func animateActivityIndicator(_ shouldAnimate: Bool) {
        shouldAnimate ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func showNoResultsLabel(_ shouldShow: Bool) {
        noResultsLabel.isHidden = !shouldShow
    }
    
    func launchWeatherVC(for location: Location) {
        DispatchQueue.main.async {
            let vc = WeatherViewController(location: location)
            self.navigationController?.navigationBar.tintColor = .white
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


