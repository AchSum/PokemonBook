//
//  DetailPokemon.swift
//  pokemontest
//
//  Created by Achmad Sumadi on 24/08/25.
//
// =============================================================
// MARK: Domain/Entities/DetailPokemon.swift
// =============================================================
import Foundation

struct DetailPokemon: Equatable {
  let name: String
  let imageURL: URL?
  let types: [String]
  let moves: [String]
}



