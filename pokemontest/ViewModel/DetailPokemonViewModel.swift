//
//  DetailPokemonViewModel.swift
//  pokemontest
//
//  Created by Achmad Sumadi on 24/08/25.
//

// =============================================================
// MARK: Presentation/ViewModel
// =============================================================
import Foundation

@MainActor
final class DetailPokemonViewModel: ObservableObject {
    @Published private(set) var detail: DetailPokemon?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let fetchDetail: FetchPokemonDetail
    private let pokemonID: Int

    init(fetchDetail: FetchPokemonDetail, pokemonID: Int) {
        self.fetchDetail = fetchDetail
        self.pokemonID = pokemonID
    }

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            detail = try await fetchDetail(pokemonID)
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }

    func clearError() { errorMessage = nil }

    // buat UI
    var title: String { detail?.name ?? "" }
    var imageURL: URL? { detail?.imageURL }
    var typeNames: [String] { detail?.types ?? [] }
    var moveNames: [String] { detail?.moves ?? [] }
}


