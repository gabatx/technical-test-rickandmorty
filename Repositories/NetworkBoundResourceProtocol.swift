//
//  NetworkBoundResourceProtocol.swift
//  RickAndMorty
//
//  Created by gabatx on 19/9/23.
//

import Foundation
import SwiftUI
import RealmSwift

@MainActor
protocol NetworkBoundResourceProtocol: ObservableObject {
    associatedtype ResultType
    associatedtype DatabaseRequestType: Object
    associatedtype ApiRequestType: Codable

    var result: ResultType? { get set }
    var loadMoreState: LoadMoreState { get set }
    var errorMessage: String? { get set }

    func fetchDatabase() throws -> Results<DatabaseRequestType>?
    func convertFromDatabaseToResults(data: Results<DatabaseRequestType>) -> ResultType?
    func deleteDatabase() throws
    func fetchWebService(page: Int) async throws -> ApiRequestType?
    func saveFromApiToDatabase(response: ApiRequestType) async throws
    func hasMorePages(reponse: ApiRequestType) -> Bool
}

@MainActor
open class NetworkBoundResource<ResultType, DatabaseRequestType:Object, ApiRequestType: Codable>: NetworkBoundResourceProtocol {
    @Published var result: ResultType? = nil
    @Published var loadMoreState: LoadMoreState = LoadMoreState(isRunning: false, hasMorePages: true)
    @Published var errorMessage: String? = nil

    internal var numPage: Int = 0

    func fetchDatabase() throws -> Results<DatabaseRequestType>? { nil }
    func convertFromDatabaseToResults(data: Results<DatabaseRequestType>) -> ResultType? { nil }
    func deleteDatabase() throws { }
    func fetchWebService(page: Int) async throws -> ApiRequestType? { nil }
    func saveFromApiToDatabase(response: ApiRequestType) async throws { }
    func hasMorePages(reponse: ApiRequestType) -> Bool { true }

    func fetch() async {
        await fetchNextPage()
        loadFromDataBase()
    }

    func loadFromDataBase() {
        let objects = try? fetchDatabase()
        guard let objects = objects else {
            print("Error al obtener el listado desde la base de datos")
            return
        }
        self.result = convertFromDatabaseToResults(data: objects)
    }

    func fetchNextPage() async {
        // Añadimos una comprobación para que cuando se esté ejecutando, no se vuelva a ejecutar al mismo tiempo otra petición
        if self.loadMoreState.isRunning || !self.loadMoreState.hasMorePages {
            return
        }
        self.loadMoreState = LoadMoreState(isRunning: true, hasMorePages: true)

        numPage += 1
        try? await loadFromApi(page: numPage)
        loadFromDataBase()
    }

    func loadFromApi(page: Int) async throws {
        do {
            let data = try await fetchWebService(page: self.numPage)
            guard let data = data else {
                print("Error al obtener los datos desde la api")
                throw ApiRestError(error: ConfigError(code: 555, message: "Error al obtener los datos desde la api"), serverError: nil)
            }
            try? await self.saveFromApiToDatabase(response: data)
            self.loadMoreState = LoadMoreState(isRunning: false, hasMorePages: self.hasMorePages(reponse: data))
        } catch {
            errorMessage = "Ocurrió un error al cargar las películas"
            print("Error loadFromApi: \(error.localizedDescription)")
        }
    }
}

