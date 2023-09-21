//
//  CharacterViewModel.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import Foundation
import Factory
import RealmSwift
import Combine
import SwiftUI

@MainActor
class CharacterViewModel: ObservableObject {

    @Injected(\.characterRepository) private var characterRepository: CharacterRepository
    @Injected(\.locationRepository) private var locationRepository: LocationRepository
    @Published var character: CharacterModelViewModel? = nil
    @Published var location: LocationModel? = nil
    @Published var storedImage: UIImage?
    @Published var errorMessage: String? = nil
    @Published var loadMoreState: LoadMoreState = LoadMoreState(isRunning: false, hasMorePages: true)

    private var cancellableSet: Set<AnyCancellable> = []

    // Nos subcribimos a los cambios que haya en la propiedad del repositorio
    init() {
        characterRepository.$result.compactMap { $0 }
            .assign(to: \.character, on: self)
            .store(in: &cancellableSet)

        characterRepository.$loadMoreState.compactMap { $0 }
            .assign(to: \.self.loadMoreState, on: self)
            .store(in: &cancellableSet)

        characterRepository.$errorMessage.compactMap { $0 }
            .assign(to: \.self.errorMessage, on: self)
            .store(in: &cancellableSet)

        locationRepository.$result.compactMap { $0 }
            .assign(to: \.location, on: self)
            .store(in: &cancellableSet)
    }

    func loadCharacter(idCharacter: Int) async {
        await characterRepository.loadCharacter(idCharacter: idCharacter)
    }

    func changeFavoriteState(idLocation: Int) throws {
        try characterRepository.changeFavoriteState(id: idLocation)
    }

    func loadLocation() async {
        guard let idLocation = character?.id else { return }
        await locationRepository.loadLocation(idLocation: idLocation)
    }
}
