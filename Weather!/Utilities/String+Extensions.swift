//
//  String+Extensions.swift
//  Weather!
//
//  Created by Dave Piernick on 4/16/23.
//

import Foundation

extension String {
    static func locationDisplayString(_ location: Location) -> String {
        if let state = location.state {
            return "\(location.name ?? ""), \(state), \(location.country ?? "")"
        } else {
            return "\(location.name ?? ""), \(location.country ?? "")"
        }
    }
    
    static func apiKey() -> String {
        return "fd34ae8403ed1cd793ffe2e7cda09f9f"
    }
}
