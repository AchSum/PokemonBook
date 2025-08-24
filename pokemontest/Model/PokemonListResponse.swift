//
//  PokemonListResponse.swift
//  pokemontest
//
//  Created by Achmad Sumadi on 24/08/25.
//

// =============================================================
// MARK: Data/DTOs (PokeAPI)
// =============================================================
import Foundation

struct PokemonListResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [NamedAPIResourceDTO]
}

struct NamedAPIResourceDTO: Decodable {
    let name: String
    let url: String
}

extension NamedAPIResourceDTO {
    func toDomain() -> Pokemon {
        // Extract id from url: https://pokeapi.co/api/v2/pokemon/25/
        let parts = url.split(separator: "/").filter { !$0.isEmpty }
        let id = Int(parts.last ?? "0") ?? 0
        let img = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")
        return Pokemon(id: id, name: name.capitalized, imageURL: img)
    }
}
