//
//  UserDefaults+Extensions.swift
//  Weather!
//
//  Created by Dave Piernick on 4/16/23.
//

import Foundation

extension UserDefaults {
    func saveObject(_ object: Codable, forKey: String) {
        let data = try? JSONEncoder().encode(object)
        UserDefaults.standard.set(data, forKey: forKey)
    }
}
