# PokemonBook

Sample app (SwiftUI + MVVM + use case + repository). Fitur: list + search + paging + detail (fetch PokeAPI).

## Requirements
- Xcode 16.2 (Swift 5)
- iOS 15+

## Run
Open `pokemontest.xcodeproj` → Run.

## Arch
- Presentation: SwiftUI Views + ViewModels (`ObservableObject`)
- Domain: Use Case (`FetchPokemonDetail`), Models (`Pokemon`, `DetailPokemon`)
- Data: `PokeAPIService` (implements repositories), DTO + mapping

## Notes
- Networking: `URLSession` (tanpa library).
- Clean-ish layering: View → ViewModel → UseCase → Repository → Service.
