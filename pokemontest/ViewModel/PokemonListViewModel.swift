//
//  PokemonListViewModel.swift
//  pokemontest
//
//  Created by Achmad Sumadi on 24/08/25.
//

// =============================================================
// MARK: Presentation/ViewModel
// =============================================================
import Foundation

@MainActor
final class PokemonListViewModel: ObservableObject {
    @Published private(set) var items: [Pokemon] = []
    @Published private(set) var isLoading: Bool = true
    @Published private(set) var errorMessage: String? = nil

    @Published var searchText: String = ""

    private let service: PokemonService
    private var nextOffset: Int? = 0
    private let pageSize: Int = 40

    func clearError() {
        errorMessage = nil
    }
    
    init(service: PokemonService) {
        self.service = service
    }

    var filteredItems: [Pokemon] {
        guard !searchText.isEmpty else { return items }
        let q = searchText.lowercased()
        return items.filter { $0.name.lowercased().contains(q) || String($0.id).contains(q) }
    }

    func loadInitial() async {
        // avoid duplicate initial loads
        if !items.isEmpty { return }
        await refresh()
    }

    func refresh() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        do {
            let page = try await service.fetchPokemonPage(limit: pageSize, offset: 0)
            items = page.items
            nextOffset = page.nextOffset
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }

    func loadMoreIfNeeded(currentItem: Pokemon?) async {
        guard let currentItem = currentItem else { return }
        let thresholdIndex = items.index(items.endIndex, offsetBy: -5, limitedBy: items.startIndex) ?? items.startIndex
        if items.firstIndex(of: currentItem) == thresholdIndex {
            await loadMore()
        }
    }

    private func loadMore() async {
        guard let offset = nextOffset, !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let page = try await service.fetchPokemonPage(limit: pageSize, offset: offset)
            items.append(contentsOf: page.items)
            nextOffset = page.nextOffset
        } catch {
            // don't override existing items; just surface a toast-able error
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }
}
