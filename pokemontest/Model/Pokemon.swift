//
//  Pokemon.swift
//  pokemontest
//
//  Created by Achmad Sumadi on 24/08/25.
//

// =============================================================
// MARK: Domain/Entities/Pokemon.swift
// =============================================================
import Foundation

struct Pokemon: Identifiable, Hashable {
    let id: Int
    let name: String
    let imageURL: URL?
}
