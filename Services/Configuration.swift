//
//  Configuration.swift
//  RickAndMorty
//
//  Created by gabatx on 20/9/23.
//

import Foundation

protocol ConfigurationProtocol {
    var apiKey: String? { get set }
}

class Configuration: ConfigurationProtocol {
    // Esta propiedad estará leyendo la propiedad API_KEY de nuestro info.plist
    var apiKey: String? = Bundle.main.infoDictionary?["API_KEY"] as? String
    static var urlImages: String = "https://rickandmortyapi.com/api/character/avatar/"


    static func extractImageId(urlImage: String) -> Int {
        let id = urlImage.split(separator: "/").last ?? ""
        return Int(id) ?? 0
    }

    static func mapperUrlImage(id: Int) -> String {
        return self.urlImages + "\(id).jpeg"
    }
}
