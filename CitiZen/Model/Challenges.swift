//
//  Challenge.swift
//  CitiZen
//
//  Created by Trevincen Tambunan on 12/07/22.
//

import Foundation

struct Challenge: Codable {
    let id: Int
    let name, icon: String
    let challenges: [ChallengeClass]
    static let challenge: [Challenge] = Bundle.main.decode(file: "challenge_data.json")
}

// MARK: - ChallengeClass
struct ChallengeClass: Codable {
    let id: Int
    let category, question: String
    let choices, answer: [String]
}

typealias Challenges = [Challenge]
