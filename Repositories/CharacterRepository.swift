//
//  CharacterRepository.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import Foundation
import Factory
import RealmSwift
import Combine
import RealmDataManager

class CharacterRepository: NetworkBoundResource<CharacterModelViewModel, CharacterDB, CharacterModel> {
    private var apiRestClient: ApiServiceProtocol
    private var databaseManager: Database
    private var configurationService: ConfigurationProtocol

    private var idCharacter: Int? = nil
    private var idLocation: Int? = nil

    init(apiRestClient: ApiServiceProtocol, databaseManager: Database, configurationService: ConfigurationProtocol) {
        self.apiRestClient = apiRestClient
        self.databaseManager = databaseManager
        self.configurationService = configurationService
    }

    override func fetchDatabase() throws -> Results<CharacterDB>? {
        guard let idCharacter = idCharacter else { return nil }
        return try? databaseManager.get(type: CharacterDB.self) { $0.id == idCharacter }
    }

    override func convertFromDatabaseToResults(data: Results<CharacterDB>) -> CharacterModelViewModel? {
        if let character = data.last {
            return CharacterModelViewModel(id: character.id,
                                  name: character.name,
                                  status: character.status,
                                  species: character.species,
                                  gender: character.gender,
                                  image: character.image,
                                  idLocation: character.idLocation,
                                  isFavorited: character.isFavorited)
        } else {
            return nil
        }
    }

    override func fetchWebService(page: Int) async throws -> CharacterModel? {
        guard let idCharacter = idCharacter else { return nil }
        return try await apiRestClient.fetchCharacterDetail(idCharacter: idCharacter)
    }

    override func saveFromApiToDatabase(response: CharacterModel) async throws {
        var objects: [Object] = []
        let characterDB = CharacterDB.mapperCharacterApi(apiItem: response)
        objects.append(characterDB)
        try? self.databaseManager.save(objects: objects)
    }

    func changeFavoriteState(id: Int) throws {
        guard
            let objectDB = try? databaseManager.get(type: CharacterDB.self, query: { $0.id == id }),
            var characterModelViewModel = convertFromDatabaseToResults(data: objectDB) else { return }
        characterModelViewModel.isFavorited.toggle()
        let characterDB = CharacterDB.mapperCharacterModelViewModelToCharacterDB(item: characterModelViewModel)
        try? self.databaseManager.save(objects: [characterDB])
        loadFromDataBase()
    }

    func loadCharacter(idCharacter: Int) async {
        self.idCharacter = idCharacter
        await fetch()
    }
}
