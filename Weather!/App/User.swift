//
//  User.swift
//  Weather!
//
//  Created by Dave Piernick on 4/16/23.
//

import Foundation

class User {
    
    static let shared = User()
    static var lastLocationString = "lastLocation"
    var lastSearchedLocation: Location? {
        return try? JSONDecoder().decode(Location.self, from: UserDefaults.standard.object(forKey: User.lastLocationString) as? Data ?? Data())
    }
}
