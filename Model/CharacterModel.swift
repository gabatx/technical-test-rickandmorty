//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import Foundation

struct CharacterModel: Codable{
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
    let location: LocationCharacter
    var isFavorited: Bool? = false
}

struct LocationCharacter: Codable {
    let name: String
    let url: String
}

let characterMockTest: [CharacterModelViewModel] = [
    .init(id: 1,
          name: "Rick Sanchez",
          status: "Alive",
          species: "Human",
          gender: "Male",
          image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
          idLocation: 1),
    .init(id: 2,
          name: "Morty Smith",
          status: "Alive",
          species: "Human",
          gender: "Human",
          image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
          idLocation: 3),
    .init(id: 3,
          name: "Summer Smith",
          status: "Alive",
          species: "Human",
          gender: "Female",
          image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg",
          idLocation: 20),
    .init(id: 4,
          name: "Beth Smith",
          status: "Alive",
          species: "Human",
          gender: "Female",
          image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg",
          idLocation: 20),
    .init(id: 5,
          name: "Jerry Smith",
          status: "Alive",
          species: "Human",
          gender: "Human",
          image: "https://rickandmortyapi.com/api/character/avatar/5.jpeg",
          idLocation: 20),
    .init(id: 6,
          name: "Abadango Cluster Princess",
          status: "Alive",
          species: "Human",
          gender: "Female",
          image: "https://rickandmortyapi.com/api/character/avatar/6.jpeg",
          idLocation: 2),
    .init(id: 7,
          name: "Abradolf Lincler",
          status: "Alive",
          species: "Human",
          gender: "Human",
          image: "https://rickandmortyapi.com/api/character/avatar/7.jpeg",
          idLocation: 21),
]

let locationMockTest: LocationModel = .init(id: 1,
                                            name: "Citadel of Ricks",
                                            type: "Space station",
                                            dimension: "unknown",
                                            residents: [
                                                "https://rickandmortyapi.com/api/character/8",
                                                "https://rickandmortyapi.com/api/character/14",
                                                "https://rickandmortyapi.com/api/character/15",
                                                "https://rickandmortyapi.com/api/character/18",
                                                "https://rickandmortyapi.com/api/character/21",
                                                "https://rickandmortyapi.com/api/character/22",
                                                "https://rickandmortyapi.com/api/character/27",
                                                "https://rickandmortyapi.com/api/character/42",
                                                "https://rickandmortyapi.com/api/character/43",
                                                "https://rickandmortyapi.com/api/character/44",
                                                "https://rickandmortyapi.com/api/character/48",
                                                "https://rickandmortyapi.com/api/character/53",
                                                "https://rickandmortyapi.com/api/character/56",
                                                "https://rickandmortyapi.com/api/character/61",
                                                "https://rickandmortyapi.com/api/character/69",
                                                "https://rickandmortyapi.com/api/character/72",
                                                "https://rickandmortyapi.com/api/character/73",
                                            ])
