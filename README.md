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
- Data (Remote): `PokeAPIService` (URLSession) + DTO → mapping ke domain
- Data (Local): Core Data (`NSPersistentContainer`) untuk cache list

  ## Persistence (Core Data)
- **Tujuan**: cache hasil list Pokémon agar:
  - halaman yang sudah pernah dimuat tetap tersedia saat offline,
  - app terasa cepat saat membuka ulang.

### Alur singkat
1. `PokeAPIService.fetchPokemonPage(limit:offset:)` memanggil endpoint `pokemon`.
2. Hasil mapping → `[Pokemon]`.
3. **saveToCoreData** (BG) melakukan **upsert by `id`** ke `PokemonEntity`.
4. Jika network error:
   - **loadCachedPage** membaca dari Core Data (limit/offset) dan mengembalikan data cache bila ada.

## Notes
- Networking: `URLSession` (tanpa library).
- Clean-ish layering: View → ViewModel → UseCase → Repository → Service (+ Core Data cache).
- Paging, search, detail (fetch per Pokémon) tersedia.


