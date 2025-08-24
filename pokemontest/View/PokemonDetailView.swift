//
//  PokemonDetailView.swift
//  pokemontest
//
//  Created by Achmad Sumadi on 24/08/25.
//

// =============================================================
// MARK: Presentation/Views
// =============================================================
import SwiftUI

struct PokemonDetailView: View {
    @ObservedObject var viewModel: DetailPokemonViewModel  // VM disuntik dari parent
    let pokemon: Pokemon
    let sizeImage: CGFloat = UIScreen.main.bounds.height / 2.7
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 12) {
            AsyncImage(url: viewModel.imageURL ?? pokemon.imageURL) { phase in
                switch phase {
                case .empty:   ProgressView().frame(width: sizeImage, height: sizeImage)
                case .success(let img): img.resizable().scaledToFit().frame(width: sizeImage, height: sizeImage)
                case .failure: Image(systemName: "photo").resizable().scaledToFit()
                                  .frame(width: sizeImage, height: sizeImage).foregroundColor(.secondary)
                @unknown default: EmptyView()
                }
            }

            Text("\(viewModel.title.isEmpty ? pokemon.name : viewModel.title)")
                .font(.title2).bold()

            if !viewModel.typeNames.isEmpty {
                HStack(spacing: 8) {
                    ForEach(viewModel.typeNames, id: \.self) { t in
                        Text(t)
                            .font(.caption).bold()
                            .padding(.horizontal, 10).padding(.vertical, 6)
                            .background(Capsule().fill(Color.gray.opacity(0.15)))
                    }
                }
            }
            
            if !viewModel.moveNames.isEmpty {
                Text(viewModel.moveNames.joined(separator: ", "))
                    .font(.caption).bold()
                    .multilineTextAlignment(.leading)
            }
            
            

        }
        .task { await viewModel.load() }
        .padding()
        .navigationBarTitleDisplayMode(.inline)  
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Detail Pokémon")
                    .font(.headline)
            }
        }
        .alert("Error",
               isPresented: .init(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.clearError() } }
               )) {
            Button("OK", role: .cancel) { viewModel.clearError() }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
