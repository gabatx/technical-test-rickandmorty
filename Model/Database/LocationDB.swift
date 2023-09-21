//
//  LocationDB.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import Foundation
import RealmSwift

class LocationDB: Object {

    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var type: String
    @Persisted var dimension: String
    @Persisted var residents: List<String>

    convenience init(id: Int,
                     name: String,
                     type: String,
                     dimension: String,
                     residents: List<String>) {
        self.init()
        self.id = id
        self.name = name
        self.type = type
        self.dimension = dimension
        self.residents = residents
    }
}

extension LocationDB {
    static func mapperLocationApi(apiItem: LocationModel) -> LocationDB {
        let residentsArray = List<String>()
        residentsArray.append(objectsIn: apiItem.residents) // Para pasar de [String] a List<String>
        return LocationDB(id: apiItem.id,
                          name: apiItem.name,
                          type: apiItem.type,
                          dimension: apiItem.dimension,
                          residents: residentsArray)
     }
}
