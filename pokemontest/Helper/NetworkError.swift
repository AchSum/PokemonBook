//
//  NetworkError.swift
//  pokemontest
//
//  Created by Achmad Sumadi on 24/08/25.
//

// =============================================================
// MARK: Core/Network Errors
// =============================================================
import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case transport(URLError)
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid Response"
        case .statusCode(let c): return "HTTP Status Code: \(c)"
        case .transport(let e): return e.localizedDescription
        case .decoding(let e): return "Decoding Error: \(e.localizedDescription)"
        }
    }
}
