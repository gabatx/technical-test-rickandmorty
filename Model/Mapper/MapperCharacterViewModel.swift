//
//  MapperCharacterModelViewModel.swift
//  RickAndMorty
//
//  Created by gabatx on 21/9/23.
//

import Foundation


struct MapperCharacterModelViewModel {
    static func map(entity: CharacterModel) -> CharacterModelViewModel {
        let idLocation = Int(entity.location.url.split(separator: "/").last ?? "1")!
        return CharacterModelViewModel(
            id: entity.id,
            name: entity.name,
            status: entity.status,
            species: entity.species,
            gender: entity.gender,
            image: entity.image,
            idLocation: idLocation,
            isFavorited: false)
    }
}
