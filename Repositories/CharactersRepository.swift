//
//  CharactersRepository.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import Foundation
import Factory
import RealmSwift
import RealmDataManager

// Estructura que nos indica si está cargando. Nos dará información sobre este proceso.
struct LoadMoreState {
    var isRunning: Bool
    let hasMorePages: Bool
}

class CharactersRepository: NetworkBoundResource<[CharacterModelViewModel], CharacterDB, ApiDataPager> {

    private var apiRestClient: ApiServiceProtocol
    private var databaseManager: Database
    private var configurationService: ConfigurationProtocol

    init(apiRestClient: ApiServiceProtocol, databaseManager: Database, configurationService: ConfigurationProtocol) {
        self.apiRestClient = apiRestClient
        self.databaseManager = databaseManager
        self.configurationService = configurationService
    }

    func loadCharacters() async {
        await fetch()
        loadFromDataBase()
    }

    override func fetchDatabase() throws -> Results<CharacterDB>? {
        return try databaseManager.get(type: CharacterDB.self)
    }

    override func deleteDatabase() throws {
        try? self.databaseManager.delete(type: CharacterDB.self)
    }

    override func convertFromDatabaseToResults(data: Results<CharacterDB>) -> [CharacterModelViewModel]? {
        data.compactMap { characterDB in
            CharacterModelViewModel(id: characterDB.id,
                                    name: characterDB.name,
                                    status: characterDB.status,
                                    species: characterDB.species,
                                    gender: characterDB.gender,
                                    image: characterDB.image,
                                    idLocation: characterDB.idLocation,
                                    isFavorited: characterDB.isFavorited)
        }
    }

    override func fetchWebService(page: Int) async throws -> ApiDataPager? {
        try? await apiRestClient.fetchListOfCharacters(page: page)
    }

    override func saveFromApiToDatabase(response: ApiDataPager) async throws {
        let objects: [Object] = response.results.compactMap { characterApi in
            CharacterDB.mapperCharacterApi(apiItem: characterApi)
        }
        // Se borran los datos de la db para que no mantenga los personajes ya vistos al iniciar la app
        if numPage == 1 {
            try? self.deleteDatabase()
        }
        try? self.databaseManager.save(objects: objects)
    }

    func changeFavoriteState(id: Int) throws {
        guard
            let objectDB = try? databaseManager.get(type: CharacterDB.self, query: { $0.id == id }),
            var characterModelViewModel = convertFromDatabaseToResults(data: objectDB)?.first  else { return }
        characterModelViewModel.isFavorited.toggle()
        let characterDB = CharacterDB.mapperCharacterModelViewModelToCharacterDB(item: characterModelViewModel)
        try? self.databaseManager.save(objects: [characterDB])
        loadFromDataBase()
    }
}
