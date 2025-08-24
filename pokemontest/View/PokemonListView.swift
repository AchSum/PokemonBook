//
//  PokemonListView.swift
//  pokemontest
//
//  Created by Achmad Sumadi on 24/08/25.
//

// =============================================================
// MARK: Presentation/Views
// =============================================================
import SwiftUI


struct PokemonListView: View {
    @StateObject var viewModel: PokemonListViewModel
    @State private var tappedName: String? = nil  // simpan nama yang diklik

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading && viewModel.items.isEmpty {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Loading…")
                            .foregroundColor(.secondary)
                    }
                } else if let error = viewModel.errorMessage, viewModel.items.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 40))
                        Text(error).multilineTextAlignment(.center)
                        Button("Retry") { Task { await viewModel.refresh() } }
                    }
                    .padding()
                } else {
                    
                    List(viewModel.filteredItems) { p in
                        NavigationLink(
                            destination: PokemonDetailView(
                                viewModel: DetailPokemonViewModel(
                                    fetchDetail: FetchPokemonDetail(repo: PokeAPIService()),
                                    pokemonID: p.id
                                ),
                                pokemon: p
                            )
                        ) {
                            PokemonRowView(pokemon: p)
                        }
                        .task { await viewModel.loadMoreIfNeeded(currentItem: p) }
                    }


                    
                    
                }
            }
            .navigationTitle("Pokémon")
        }
        .searchable(text: $viewModel.searchText, prompt: "Search by name or id")
        .refreshable { await viewModel.refresh() }
        .task { await viewModel.loadInitial() }
        .alert(
            "Error",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.clearError() } }
            ),
            actions: { Button("OK", role: .cancel) { viewModel.clearError() } },
            message: { Text(viewModel.errorMessage ?? "") }
        )
    }
}

struct PokemonRowView: View {
    let pokemon: Pokemon


    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: pokemon.imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 56, height: 56)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 56, height: 56)
                        .foregroundColor(.secondary)
                @unknown default:
                    EmptyView()
                }
            }
            Text("#\(pokemon.id)  \(pokemon.name)")
                .font(.headline)
        }
        .padding(.vertical, 6)
        .onTapGesture {
            print(pokemon.name)
        }
    }
}



// =============================================================
// MARK: Previews
// =============================================================
import SwiftUI

struct PokemonListView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = PokemonListViewModel(service: PokeAPIService())
        return PokemonListView(viewModel: vm)
    }
}




