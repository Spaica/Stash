//
//  ProtocolError.swift
//  BookApp
//
//  Created by Andreina Costagliola on 10/11/25.
//

import Foundation

// MARK: - Protocol
//It's like an interface
protocol BookFetching {
    func searchBooks(query: String) async throws -> APIResponse
}

// MARK: - Errors
enum APIError: Error {
    case invalidURL
    case invalidResponse(Int)
    case noData
    case decodingFailed(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL: return "Errore: L'URL per la chiamata API non è valido."
        case .invalidResponse: return "Errore di rete: Risposta HTTP non valida o status code non 200."
        case .noData: return "Errore: Nessun dato ricevuto dal server."
        case .decodingFailed(let error): return "Errore di decodifica JSON: \(error.localizedDescription)"
        }
    }
}
