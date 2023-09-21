//
//  HomeViewModel.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import Foundation
import RealmSwift
import Factory
import Combine


protocol HomeViewProtocol {
    func loadCharacters() async
}

@MainActor
class HomeViewModel: ObservableObject, HomeViewProtocol {

    @Injected(\.charactersRepository) private var repository: CharactersRepository
    @Published var characters: [CharacterModelViewModel] = []
    @Published var errorMessage: String? = nil
    @Published var loadMoreState: LoadMoreState = LoadMoreState(isRunning: false, hasMorePages: true)
    private var cancellableSet: Set<AnyCancellable> = []

    @Published var searchText: String = ""
    @Published var isFilteredList: Bool = false
    var auxSearches: [CharacterModelViewModel] = []

    init() {
        // Nos subcribimos a los cambios que haya en la propiedad del repositorio
        repository.$result.compactMap { $0 }
            .assign(to: \.self.characters, on: self)
            .store(in: &cancellableSet)

        repository.$errorMessage.compactMap { $0 }
            .assign(to: \.self.errorMessage, on: self)
            .store(in: &cancellableSet)

        repository.$loadMoreState.compactMap { $0 }
            .assign(to: \.self.loadMoreState, on: self)
            .store(in: &cancellableSet)

        $searchText
            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                self.repository.loadFromDataBase()
                self.filterSearches(writtenText: value)
            }).store(in: &cancellableSet)
    }

    func loadCharacters() async {
        await repository.loadCharacters()
    }

    func loadNextPage() async {
        await repository.fetchNextPage()
    }

    // Función que filtra el texto que se va añadiendo al TextField.
    private func filterSearches(writtenText: String) {
        if writtenText.isEmpty {
            isFilteredList = false
            auxSearches = characters
        } else {
            isFilteredList = true
            characters = auxSearches.filter { $0.name.lowercased().contains(writtenText.lowercased()) }
        }
    }

    func changeFavoriteState(id: Int) throws {
        let filteredItems = characters.map { character in
            guard character.id == id else { return character }
            var updatedCharacter = character
            updatedCharacter.isFavorited.toggle()
            return updatedCharacter
        }
        try repository.changeFavoriteState(id: id) // Cambiará el estado y volverá a cargar characters desde la bd.
        auxSearches = characters
        characters = filteredItems
    }
}

#if DEBUG
class MockHomeViewModel: HomeViewModel{
    override func loadCharacters() async {
        self.characters = characterMockTest
    }
}
#endif
