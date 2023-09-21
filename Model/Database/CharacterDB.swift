//
//  CharacterDB.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import Foundation
import RealmSwift

class CharacterDB: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var status: String
    @Persisted var species: String
    @Persisted var gender: String
    @Persisted var image: String
    @Persisted var idLocation: Int
    @Persisted var isFavorited: Bool

    convenience init(id: Int,
                     name: String,
                     status: String,
                     species: String,
                     gender: String,
                     image: String,
                     idLocation: Int,
                     isFavorited: Bool = false) {
        self.init()
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.image = image
        self.isFavorited = isFavorited
    }
}

extension CharacterDB {
    static func mapperCharacterApi(apiItem: CharacterModel) -> CharacterDB {
        let characterModelViewModel = MapperCharacterModelViewModel.map(entity: apiItem)
        return CharacterDB(id: characterModelViewModel.id,
                           name: characterModelViewModel.name,
                           status: characterModelViewModel.status,
                           species: characterModelViewModel.species,
                           gender: characterModelViewModel.gender,
                           image: characterModelViewModel.image,
                           idLocation: characterModelViewModel.idLocation,
                           isFavorited: characterModelViewModel.isFavorited)
     }

    static func mapperCharacterModelViewModelToCharacterDB(item: CharacterModelViewModel) -> CharacterDB {
        return CharacterDB(id: item.id,
                           name: item.name,
                           status: item.status,
                           species: item.species,
                           gender: item.gender,
                           image: item.image,
                           idLocation: item.idLocation,
                           isFavorited: item.isFavorited)
    }
}

