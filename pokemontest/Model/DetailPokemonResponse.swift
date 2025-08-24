//
//  DetailPokemonResponse.swift
//  pokemontest
//
//  Created by Achmad Sumadi on 24/08/25.
//

// =============================================================
// MARK: Data/DTOs
// =============================================================
import Foundation


extension DetailPokemonResponseDTO {
  func toDomain() -> DetailPokemon {
    let img = sprites?.other?.officialArtwork?.frontDefault.flatMap(URL.init(string:))

    let typeNames = (types ?? [])
      .sorted { ($0.slot ?? 0) < ($1.slot ?? 0) }
      .compactMap { $0.type?.name?.capitalized }

    let moveNames = (moves ?? [])
      .compactMap { $0.move?.name }
      .map { $0.replacingOccurrences(of: "-", with: " ").capitalized }
      .sorted()

    // ← pakai let, bukan var { get }
    let displayName = (species?.name ?? "")
      .replacingOccurrences(of: "-", with: " ")
      .capitalized

    return DetailPokemon(
      name: displayName,
      imageURL: img,
      types: typeNames,
      moves: moveNames
    )
  }
}



// MARK: - DetailPokemon
struct DetailPokemonResponseDTO: Decodable {
    let abilities: [Ability]?
    let baseExperience: Int?
    let forms: [Species]?
    let gameIndices: [GameIndex]?
    let height: Int?
    let heldItems: [HeldItem]?
    let id: Int?
    let isDefault: Bool?
    let locationAreaEncounters: String?
    let moves: [Move]?
    var name: String?
    let order: Int?
    let species: Species?
    let sprites: Sprites?
    let types: [TypeElement]?
    let weight: Int?
    
    enum CodingKeys: String, CodingKey {
        case abilities
        case baseExperience = "base_experience"
        case forms
        case gameIndices = "game_indices"
        case height
        case heldItems = "held_items"
        case id
        case isDefault = "is_default"
        case locationAreaEncounters = "location_area_encounters"
        case moves, name, order
        case species, sprites, types, weight
    }
}

// MARK: - Ability
struct Ability: Decodable {
    let ability: Species?
    let isHidden: Bool?
    let slot: Int?
    
    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

// MARK: - Species
struct Species: Decodable {
    var name: String?
    let url: String?
}

// MARK: - GameIndex
struct GameIndex: Decodable {
    let gameIndex: Int?
    let version: Species?
    
    enum CodingKeys: String, CodingKey {
        case gameIndex = "game_index"
        case version
    }
}

// MARK: - HeldItem
struct HeldItem: Decodable {
    let item: Species?
    let versionDetails: [VersionDetail]?
    
    enum CodingKeys: String, CodingKey {
        case item
        case versionDetails = "version_details"
    }
}

// MARK: - VersionDetail
struct VersionDetail: Decodable {
    let rarity: Int?
    let version: Species?
}

// MARK: - Move
struct Move: Decodable {
    let move: Species?
    let versionGroupDetails: [VersionGroupDetail]?
    
    enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
}

// MARK: - VersionGroupDetail
struct VersionGroupDetail: Decodable {
    let levelLearnedAt: Int?
    let moveLearnMethod, versionGroup: Species?
    
    enum CodingKeys: String, CodingKey {
        case levelLearnedAt = "level_learned_at"
        case moveLearnMethod = "move_learn_method"
        case versionGroup = "version_group"
    }
}

// MARK: - GenerationV
struct GenerationV: Decodable {
    let blackWhite: Sprites?
    
    enum CodingKeys: String, CodingKey {
        case blackWhite = "black-white"
    }
}

// MARK: - GenerationIv
struct GenerationIv: Decodable {
    let diamondPearl, heartgoldSoulsilver, platinum: Sprites?
    
    enum CodingKeys: String, CodingKey {
        case diamondPearl = "diamond-pearl"
        case heartgoldSoulsilver = "heartgold-soulsilver"
        case platinum
    }
}

// MARK: - Versions
struct Versions: Decodable {
    let generationI: GenerationI?
    let generationIi: GenerationIi?
    let generationIii: GenerationIii?
    let generationIv: GenerationIv?
    let generationV: GenerationV?
    let generationVi: [String: Home]?
    let generationVii: GenerationVii?
    let generationViii: GenerationViii?
    
    enum CodingKeys: String, CodingKey {
        case generationI = "generation-i"
        case generationIi = "generation-ii"
        case generationIii = "generation-iii"
        case generationIv = "generation-iv"
        case generationV = "generation-v"
        case generationVi = "generation-vi"
        case generationVii = "generation-vii"
        case generationViii = "generation-viii"
    }
}

// MARK: - Sprites
class Sprites: Decodable {
    let backDefault: String?
    let backShiny: String?
    let frontDefault: String?
    let frontShiny: String?
    let other: Other?
    let versions: Versions?
    let animated: Sprites?
    
    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backShiny = "back_shiny"
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case other, versions, animated
    }
}

// MARK: - GenerationI
struct GenerationI: Codable {
    let redBlue, yellow: RedBlue?
    
    enum CodingKeys: String, CodingKey {
        case redBlue = "red-blue"
        case yellow
    }
}

// MARK: - RedBlue
struct RedBlue: Codable {
    let backDefault, backGray, backTransparent, frontDefault: String?
    let frontGray, frontTransparent: String?
    
    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backGray = "back_gray"
        case backTransparent = "back_transparent"
        case frontDefault = "front_default"
        case frontGray = "front_gray"
        case frontTransparent = "front_transparent"
    }
}

// MARK: - GenerationIi
struct GenerationIi: Codable {
    let crystal: Crystal?
    let gold, silver: Gold?
}

// MARK: - Crystal
struct Crystal: Codable {
    let backDefault, backShiny, backShinyTransparent, backTransparent: String?
    let frontDefault, frontShiny, frontShinyTransparent, frontTransparent: String?
    
    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backShiny = "back_shiny"
        case backShinyTransparent = "back_shiny_transparent"
        case backTransparent = "back_transparent"
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case frontShinyTransparent = "front_shiny_transparent"
        case frontTransparent = "front_transparent"
    }
}

// MARK: - Gold
struct Gold: Codable {
    let backDefault, backShiny, frontDefault, frontShiny: String?
    let frontTransparent: String?
    
    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backShiny = "back_shiny"
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
        case frontTransparent = "front_transparent"
    }
}

// MARK: - GenerationIii
struct GenerationIii: Codable {
    let emerald: Emerald?
    let fireredLeafgreen, rubySapphire: Gold?
    
    enum CodingKeys: String, CodingKey {
        case emerald
        case fireredLeafgreen = "firered-leafgreen"
        case rubySapphire = "ruby-sapphire"
    }
}

// MARK: - Emerald
struct Emerald: Codable {
    let frontDefault, frontShiny: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

// MARK: - Home
struct Home: Codable {
    let frontDefault: String?
    let frontShiny: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}

// MARK: - GenerationVii
struct GenerationVii: Codable {
    let icons: DreamWorld?
    let ultraSunUltraMoon: Home?
    
    enum CodingKeys: String, CodingKey {
        case icons
        case ultraSunUltraMoon = "ultra-sun-ultra-moon"
    }
}

// MARK: - DreamWorld
struct DreamWorld: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// MARK: - GenerationViii
struct GenerationViii: Codable {
    let icons: DreamWorld?
}

// MARK: - Other
struct Other: Codable {
    let dreamWorld: DreamWorld?
    let home: Home?
    let officialArtwork: OfficialArtwork?
    
    enum CodingKeys: String, CodingKey {
        case dreamWorld = "dream_world"
        case home
        case officialArtwork = "official-artwork"
    }
}

// MARK: - OfficialArtwork
struct OfficialArtwork: Codable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}


// MARK: - TypeElement
struct TypeElement: Decodable {
    let slot: Int?
    let type: Species?
}
