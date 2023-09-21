//
//  CharacterRepositoryTest.swift
//  RickAndMortyTests
//
//  Created by gabatx on 20/9/23.
//

import Foundation
import XCTest
import Combine
import RealmDataManager
import Alamofire

@testable import RickAndMorty

class CharacterRepositoryTest: XCTestCase {

    // Propiedad que querramos testear
    private var repository: CharacterRepository!
    var cancellables: Set<AnyCancellable> = []

    private var mockConfiguration: MockConfiguration!
    private var mockApiRestClient: MockApiRestClient!
    private var mockDatabase: Database!

    @MainActor override func setUpWithError() throws {
        try super.setUpWithError()
        mockConfiguration = MockConfiguration()
        mockApiRestClient = MockApiRestClient()
        mockDatabase = MockDatabaseBuilder.build()

        repository = CharacterRepository(apiRestClient: mockApiRestClient, databaseManager: mockDatabase, configurationService: mockConfiguration)
    }

    override func tearDownWithError() throws {
        mockConfiguration = nil
        mockApiRestClient = nil
        mockDatabase = nil
        repository = nil
        try super.tearDownWithError()
    }

    func testGetCharacter_OK() async throws {
        let expectation = XCTestExpectation(description: "get a character")
        await repository.$result.dropFirst().sink { result in
            XCTAssertNotNil(result)
            XCTAssertEqual(result?.id, 12345)
            XCTAssertEqual(result?.image, "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
            expectation.fulfill()
        }.store(in: &cancellables)
        mockApiRestClient.fetchCharacterDetail = try await MockApiObjectData.buildSuccessApiObjectCharacter()
        await repository.loadCharacter(idCharacter: 12345)
    }

    @MainActor
    func testGetMovie_WRONG() async {
        let expectation = XCTestExpectation(description: "get a character")

        repository.$result.dropFirst().sink { result in
            XCTAssertNil(result)
            expectation.fulfill()

        }.store(in: &cancellables)

        mockApiRestClient.fetchCharacterDetail = try? await MockApiObjectData.buildErrorApiObject().value //Añadimos datos de entrada mock
        await repository.loadCharacter(idCharacter: 12345)
    }
}
