//
//  ApiService.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import Foundation
import Alamofire

// Configuramos los tipos de errores.
struct ApiRestError: Error {
    let error: Error
    let serverError: ServerError?
}

struct ServerError: Codable, Error {
    var status: String
    var message: String
}

struct ConfigError: Error {
    var code: Int
    var message: String
}

protocol ApiServiceProtocol {
    func fetchListOfCharacters(page: Int) async throws -> ApiDataPager?
    func fetchCharacterDetail(idCharacter: Int) async throws -> CharacterModel?
    func fetchLoadLocation(idLocation: Int) async throws -> LocationModel?
}

class ApiRestClient {
    private let urlBase: String = "https://rickandmortyapi.com/api/"
    private let APIKEY_NAME: String = "api_key"
    private let configuration: Configuration

    public init(configuration: Configuration) {
        self.configuration = configuration
    }

    private func get<T: Codable>(url: URL) async throws -> T {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedData = try? JSONDecoder().decode(T.self, from: data) {
                return decodedData 
            } else{
                return try JSONDecoder().decode([T].self, from: data) as! T
            }
        } catch {
            throw error
        }
    }
}

extension ApiRestClient: ApiServiceProtocol {
    func fetchListOfCharacters(page: Int) async throws -> ApiDataPager? {
        guard
            // let apiKey = configuration.apiKey,
            let url = URL(string: "\(urlBase)character?page=\(page)") else {
            throw ConfigError(code: 555, message: "La URL no está definida")
        }

        do {
            let result: ApiDataPager = try await get(url: url)
            return result
        } catch {
            print("Error en al obtener los personajes: \(error)")
            let apiRestError = ApiRestError(error: error, serverError: nil)
            throw apiRestError
        }
    }

    func fetchCharacterDetail(idCharacter: Int) async throws -> CharacterModel? {
        guard
            //let apiKey = configuration.apiKey
            let url = URL(string: "\(urlBase)character/\(idCharacter)") else {
            throw ConfigError(code: 555, message: "La URL no está definida")
        }

        do {
            let result: CharacterModel = try await get(url: url)
            return result
        } catch {
            let apiRestError = ApiRestError(error: error, serverError: nil)
            throw apiRestError
        }
    }

    func fetchLoadLocation(idLocation: Int) async throws -> LocationModel? {
        guard
            //let apiKey = configuration.apiKey
            let url = URL(string: "\(urlBase)location/\(idLocation)") else {
            throw ConfigError(code: 555, message: "La URL no está definida")
        }
        do {
            let result: LocationModel = try await get(url: url)
            return result
        } catch {
            let apiRestError = ApiRestError(error: error, serverError: nil)
            throw apiRestError
        }
    }
}
