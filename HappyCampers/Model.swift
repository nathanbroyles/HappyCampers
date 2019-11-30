//
//  Model.swift
//  HappyCampers
//
//  Created by Nathan Broyles on 11/29/19.
//  Copyright © 2019 DeadPixel. All rights reserved.
//

import Foundation
import CoreLocation

struct Model {
    
    static func loadCampsites(completion: ([Campsite]?) -> Void) {
        guard let jsonURL = Bundle.main.url(forResource: "campsites", withExtension: "json"),
            let jsonData = try? Data(contentsOf: jsonURL) else {
            completion(nil)
            return
        }
        
        if let campsites = try? JSONDecoder().decode([Campsite].self, from: jsonData) {
            return completion(campsites)
        } else {
            return completion(nil)
        }
    }
    
    static func createCampers(around coordinate: CLLocationCoordinate2D,completion: ([Camper]) -> Void) {
        var campers = [Camper]()
        for int in 0..<30 {
            let randomLat = Double.random(in: (coordinate.latitude - 0.5)...(coordinate.latitude + 0.5))
            let randomLong = Double.random(in: (coordinate.longitude - 0.5)...(coordinate.longitude + 0.5))
            let randomPhone = Int.random(in: 1000000000...9999999999)
            let camper = Camper(name: "Kid \(int)", description: "The best kid.", phone: randomPhone, lat: randomLat, long: randomLong)
            campers.append(camper)
        }
        completion(campers)
    }
}

protocol Mapable {
    
    var name: String { get }
    var description: String { get }
    var lat: Double { get }
    var long: Double { get }
    
    func subtitle() -> String
}

struct Campsite: Codable, Mapable {
    
    let name: String
    let description: String
    let lat: Double
    let long: Double
    
    func subtitle() -> String {
        return description
    }
}

struct Camper: Mapable {
    
    let name: String
    let description: String
    let phone: Int
    let lat: Double
    let long: Double
    
    func subtitle() -> String {
        return "Phone #: \(phone)\n\(description)"
    }
}
