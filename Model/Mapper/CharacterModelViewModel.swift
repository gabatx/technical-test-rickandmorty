//
//  CharacterViewModel.swift
//  RickAndMorty
//
//  Created by gabatx on 21/9/23.
//

import Foundation

struct CharacterModelViewModel: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
    let idLocation: Int
    var isFavorited: Bool = false
}
