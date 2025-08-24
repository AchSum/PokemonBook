//
//  SplashView.swift
//  pokemontest
//
//  Created by Achmad Sumadi on 24/08/25.
//

// =============================================================
// MARK: Presentation/Views
// =============================================================
import SwiftUI

struct SplashView: View {
  var onFinish: () -> Void

  @State private var opacity = 0.0
  @State private var scale: CGFloat = 0.9

  var body: some View {
    VStack {
      Image("Imagebola")
        .resizable()
        .scaledToFit()
        .frame(width: 200, height: 200)
        .scaleEffect(scale)
        .opacity(opacity)

        Text("Pokemon Book")
          .font(.title2).bold()
          .foregroundColor(.red)
          .frame(maxWidth: .infinity, alignment: .center)

    }
    .onAppear {
      withAnimation(.easeOut(duration: 2.5)) {
        opacity = 1; scale = 1.0
      }
      // Tahan sejenak lalu keluar
      Task {
          
        try? await Task.sleep(nanoseconds: 2000_000_000) // ~2s
        withAnimation(.easeInOut(duration: 0.25)) { opacity = 0 }
        try? await Task.sleep(nanoseconds: 250_000_000)
        onFinish()
      }
    }
  }
}
