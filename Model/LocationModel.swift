//
//  LocationModel.swift
//  RickAndMorty
//
//  Created by gabatx on 21/9/23.
//

import Foundation

struct LocationModel: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
}
