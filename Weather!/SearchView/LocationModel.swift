//
//  LocationModel.swift
//  Weather!
//
//  Created by Dave Piernick on 4/14/23.
//

import Foundation

struct Location: Codable, Hashable {
    var name: String?
    var state: String?
    var country: String?
    var lat: Double?
    var lon: Double?
}
