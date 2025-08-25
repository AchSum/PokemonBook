//
//  PokemonEntity+Mapping.swift
//  pokemontest
//
//  Created by Achmad Sumadi on 25/08/25.
//


import CoreData

extension PokemonEntity {
    func apply(from p: Pokemon) {
        id = Int64(p.id)
        name = p.name
        imageURL = p.imageURL?.absoluteString
    }

    func toDomain() -> Pokemon {
        Pokemon(
            id: Int(id),
            name: name ?? "",
            imageURL: imageURL.flatMap(URL.init(string:))
        )
    }
}
