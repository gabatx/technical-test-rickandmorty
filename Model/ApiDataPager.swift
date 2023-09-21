//
//  ApiObjectPaginator.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import Foundation

struct ApiDataPager: Codable {
    let info: Info
    let results: [CharacterModel]
}

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
