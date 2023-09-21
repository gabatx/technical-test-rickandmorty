//
//  MockApiRestClient.swift
//  RickAndMortyTests
//
//  Created by gabatx on 20/9/23.
//

import Foundation
import Alamofire

@testable import RickAndMorty

class MockApiRestClient: ApiServiceProtocol {

    var fetchListOfCharacters: ApiDataPager?
    var fetchCharacterDetail: CharacterModel?
    var fetchLoadLocation: LocationModel?

    func fetchListOfCharacters(page: Int) async throws -> ApiDataPager? {
        fetchListOfCharacters
    }

    func fetchCharacterDetail(idCharacter: Int) async throws -> CharacterModel? {
        fetchCharacterDetail
    }

    func fetchLoadLocation(idLocation: Int) async throws -> LocationModel? {
        fetchLoadLocation
    }
}
