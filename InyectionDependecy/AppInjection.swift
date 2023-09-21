//
//  AppInjection.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import Foundation
import Factory
import RealmDataManager

extension Container {

    var configurationService: Factory<Configuration> {
        Factory(self) { Configuration() }
            .scope(.singleton)
    }

    var apiRestClientService: Factory<ApiRestClient> {
        Factory(self) {
            ApiRestClient(configuration: self.configurationService())
        }
        .scope(.singleton)
    }

    var databaseManager: Factory<Database> {
        Factory(self) {
            let configuration = DatabaseConfiguration(
                databaseName: "characters",
                type: .disk,
                debug: .all,
                schemaVersion: 1,
                objectTypes: [CharacterDB.self, LocationDB.self])
            return LocalDatabaseManager(configuration: configuration) as Database
        }
        .scope(.singleton)
    }

    @MainActor
    var homeViewModel: Factory<HomeViewModel> {
        Factory(self) { HomeViewModel() }
    }

    @MainActor
    var characterViewModel: Factory<CharacterViewModel> {
        Factory(self) { CharacterViewModel() }
    }

    // Repositorios
    @MainActor
    var charactersRepository: Factory<CharactersRepository> {
        Factory(self) {
            CharactersRepository(apiRestClient: self.apiRestClientService(),
                                 databaseManager: self.databaseManager(),
                                 configurationService: self.configurationService())
        }
    }

    @MainActor
    var characterRepository: Factory<CharacterRepository> {
        Factory(self) {
            CharacterRepository(apiRestClient: self.apiRestClientService(),
                                databaseManager: self.databaseManager(),
                                configurationService: self.configurationService())
        }
    }

    @MainActor
    var locationRepository: Factory<LocationRepository> {
        Factory(self) {
            LocationRepository(apiRestClient: self.apiRestClientService(),
                                databaseManager: self.databaseManager(),
                                configurationService: self.configurationService())
        }
    }
}
