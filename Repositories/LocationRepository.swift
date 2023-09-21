//
//  LocationRepository.swift
//  RickAndMorty
//
//  Created by gabatx on 21/9/23.
//

import Foundation
import Factory
import RealmSwift
import Combine
import RealmDataManager

class LocationRepository: NetworkBoundResource<LocationModel, LocationDB, LocationModel> {
    private var apiRestClient: ApiServiceProtocol
    private var databaseManager: Database
    private var configurationService: ConfigurationProtocol

    private var idLocation: Int? = nil

    init(apiRestClient: ApiServiceProtocol, databaseManager: Database, configurationService: ConfigurationProtocol) {
        self.apiRestClient = apiRestClient
        self.databaseManager = databaseManager
        self.configurationService = configurationService
    }

    override func fetchDatabase() throws -> Results<LocationDB>? {
        guard let idLocation = idLocation else { return nil }
        return try? databaseManager.get(type: LocationDB.self) { $0.id == idLocation }
    }

    override func convertFromDatabaseToResults(data: Results<LocationDB>) -> LocationModel? {
        guard let location = data.last else { return nil }
        let residentsArray = Array(location.residents) // Convierte la List<String> en un array de String
        return LocationModel(id: location.id,
                             name: location.name,
                             type: location.type,
                             dimension: location.dimension,
                             residents: residentsArray)
    }

    override func fetchWebService(page: Int) async throws -> LocationModel? {
        guard let idLocation = idLocation else { return nil }
        return try await apiRestClient.fetchLoadLocation(idLocation: idLocation)
    }

    override func saveFromApiToDatabase(response: LocationModel) async throws {
        var objects: [Object] = []
        let characterDB = LocationDB.mapperLocationApi(apiItem: response)
        objects.append(characterDB)
        try? self.databaseManager.save(objects: objects)
    }

    func loadLocation(idLocation: Int) async {
        self.idLocation = idLocation
        await fetch()
    }
}

