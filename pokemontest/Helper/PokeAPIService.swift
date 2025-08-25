//
//  PokeAPIService.swift
//  pokemontest
//
//  Created by Achmad Sumadi on 24/08/25.
//

// =============================================================
// MARK: Data/Service (PokeAPI)
// =============================================================
import Foundation
import CoreData

// MARK: Paging model & list service
struct PokemonPage {
    let items: [Pokemon]
    let nextOffset: Int?
}

protocol PokemonService {
    func fetchPokemonPage(limit: Int, offset: Int) async throws -> PokemonPage
}

protocol PokemonDetailRepository {
    func fetchDetail(id: Int) async throws -> DetailPokemon
}

final class PokeAPIService: PokemonService, PokemonDetailRepository {

    // Base
    private let baseURL = URL(string: "https://pokeapi.co/api/v2")!
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared) {
        self.session = session
        let d = JSONDecoder()
        d.keyDecodingStrategy = .useDefaultKeys
        self.decoder = d
    }

    // MARK: - Generic GET + decode
    private func get<T: Decodable>(_ path: String,
                                   queryItems: [URLQueryItem] = []) async throws -> T {
        var comps = URLComponents(url: baseURL.appendingPathComponent(path),
                                  resolvingAgainstBaseURL: false)
        if !queryItems.isEmpty { comps?.queryItems = queryItems }
        guard let url = comps?.url else { throw NetworkError.invalidURL }

        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, resp) = try await session.data(for: req)
            guard let http = resp as? HTTPURLResponse else { throw NetworkError.invalidResponse }
            guard (200...299).contains(http.statusCode) else { throw NetworkError.statusCode(http.statusCode) }
            return try decoder.decode(T.self, from: data)
        } catch let e as NetworkError {
            throw e
        } catch let e as URLError {
            throw NetworkError.transport(e)
        } catch {
            throw NetworkError.decoding(error)
        }
    }

    // MARK: - PokemonService (list)
    func fetchPokemonPage(limit: Int, offset: Int) async throws -> PokemonPage {
    do {
        let dto: PokemonListResponse = try await get(
            "pokemon",
            queryItems: [
                URLQueryItem(name: "limit",  value: String(limit)),
                URLQueryItem(name: "offset", value: String(offset))
            ]
        )

        let items = dto.results.map { $0.toDomain() }

        // next offset dari dto.next
        var nextOffset: Int? = nil
        if let next = dto.next, let comps = URLComponents(string: next) {
            nextOffset = comps.queryItems?
                .first(where: { $0.name == "offset" })?
                .value.flatMap(Int.init)
        }
        
        saveToCoreData(items)    // <-- simpan cache di background
        return PokemonPage(items: items, nextOffset: nextOffset)
    } catch {
            // fallback ke cache
            let cached = await loadCachedPage(limit: limit, offset: offset)
            if !cached.isEmpty {
                return PokemonPage(items: cached, nextOffset: offset + cached.count)
            }
            throw error
        }
    }


    // MARK: - PokemonDetailRepository (detail)
    func fetchDetail(id: Int) async throws -> DetailPokemon {
        let dto: DetailPokemonResponseDTO = try await get("pokemon/\(id)/")
        return dto.toDomain()
    }

}

struct FetchPokemonDetail {
    let repo: PokemonDetailRepository
    func callAsFunction(_ id: Int) async throws -> DetailPokemon {
        try await repo.fetchDetail(id: id)
    }
}




fileprivate extension PokeAPIService {
    func saveToCoreData(_ items: [Pokemon]) {
        Task.detached {
            let ctx = CoreDataStack.shared.newBackgroundContext()
            ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            do {
                try await ctx.perform {
                    for p in items {
                        let req: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
                        req.fetchLimit = 1
                        req.predicate = NSPredicate(format: "id == %d", p.id)
                        let entity = (try? ctx.fetch(req).first) ?? PokemonEntity(context: ctx)
                        entity.apply(from: p)
                    }
                    if ctx.hasChanges { try ctx.save() }
                }
            } catch {
                print("CoreData save error:", error)
            }
        }
    }

    func loadCachedPage(limit: Int, offset: Int) async -> [Pokemon] {
        let ctx = CoreDataStack.shared.viewContext
        return await ctx.perform {
            let req: NSFetchRequest<PokemonEntity> = PokemonEntity.fetchRequest()
            req.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            req.fetchLimit = limit
            req.fetchOffset = offset
            return (try? ctx.fetch(req))?.map { $0.toDomain() } ?? []
        }
    }
}
