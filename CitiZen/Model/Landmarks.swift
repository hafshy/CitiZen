//
//  Landmarks.swift
//  CitiZen
//
//  Created by Kenneth Widjaya on 28/06/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let landmarks = try? newJSONDecoder().decode(Landmarks.self, from: jsonData)

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let landmarks = try? newJSONDecoder().decode(Landmarks.self, from: jsonData)

import Foundation
import MapKit

// MARK: - Landmarks
struct Landmarks: Codable {
    let total: Int
    let data: [Datum]
    static let landmarks: Landmarks = Bundle.main.decode(file: "data.json")
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int
    let category, name, icon: String
    let latitude, longitude: Double
    let adress: String
    let operasionalHours: OperasionalHours
    let trivia: String
    let cerita: String?
    let photo: [String]
    let tourPrice: String?

    enum CodingKeys: String, CodingKey {
        case id, category, name, icon, latitude, longitude, adress
        case operasionalHours = "operasional_hours"
        case trivia, cerita, photo
        case tourPrice = "tour_price"
    }
}

// MARK: - OperasionalHours
struct OperasionalHours: Codable {
    let senin, selasa, rabu, kamis: String
    let jumat, sabtu, minggu: String
    let siteTour: String?

    enum CodingKeys: String, CodingKey {
        case senin = "Senin"
        case selasa = "Selasa"
        case rabu = "Rabu"
        case kamis = "Kamis"
        case jumat = "Jumat"
        case sabtu = "Sabtu"
        case minggu = "Minggu"
        case siteTour = "SiteTour"
    }
}

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in the project")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) in the project")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not load \(file) in the project")
        }
        print("TEST")
        
        return loadedData
    }
}
