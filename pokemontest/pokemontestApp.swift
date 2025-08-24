//
//  pokemontestApp.swift
//  pokemontest
//
//  Created by Achmad Sumadi on 24/08/25.
//

import SwiftUI

@main
struct pokemontestApp: App {
  @State private var showSplash = true
  var body: some Scene {
    WindowGroup {
      Group {
        
        if showSplash {
          SplashView { showSplash = false }
        } else {
          PokemonListView(viewModel: PokemonListViewModel(service: PokeAPIService()))
        }
      }
    }
  }
}




