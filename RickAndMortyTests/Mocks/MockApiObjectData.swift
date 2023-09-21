//
//  MockApiObjectData.swift
//  RickAndMortyTests
//
//  Created by gabatx on 20/9/23.
//

import Foundation
import Alamofire
@testable import RickAndMorty

class MockApiObjectData {

    private static func createSuccessResponse<T: Codable>(data: T) throws -> T {
        return data
    }

    private static func createErrorResponse<T: Codable>(error: Error) throws -> DataResponse<T, ApiRestError> {
        let apiRestError = ApiRestError(error: error, serverError: nil)
        return DataResponse(request: nil,
                            response: nil,
                            data: nil,
                            metrics: nil,
                            serializationDuration: 0,
                            result: .failure(apiRestError))
    }

    // --- Respuesta: ---
    static func buildSuccessApiObjectCharacter() async throws -> CharacterModel {
        let data = CharacterModel(id: 12345,
                                  name: "Rick Sanchez",
                                  status: "Alive",
                                  species: "Human",
                                  gender: "Male",
                                  image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                                  location: LocationCharacter(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"))
        return try createSuccessResponse(data: data)
    }

    static func buildErrorApiObject<T: Codable>() async throws -> DataResponse<T, ApiRestError> {
        try createErrorResponse(error: ConfigError(code: 555, message: "No URL defined"))
    }
}
