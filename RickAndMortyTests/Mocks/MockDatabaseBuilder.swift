//
//  MockDatabaseBuilder.swift
//  RickAndMortyTests
//
//  Created by gabatx on 20/9/23.
//

import Foundation
import RealmDataManager

@testable import RickAndMorty

class MockDatabaseBuilder {

    public static func build() -> Database {

        let time = Date().timeIntervalSince1970 * 1000
        let rnd = Double.random(in: 0.0...100.0)

        let configuration = DatabaseConfiguration(
            databaseName: "characters_\(time)_\(rnd)",
            type: .memory,
            debug: .all,
            schemaVersion: 1,
            objectTypes: [CharacterDB.self]
        )

        return LocalDatabaseManager(configuration: configuration) as Database
    }
}
