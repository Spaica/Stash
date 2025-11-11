//
//  APIHandler.swift
//  BookApp
//
//  Created by Andreina Costagliola on 10/11/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError
}

protocol BookFetching {
    func searchBooks(query: String) async throws -> BookAPIResponse
}

class BookAPIService: BookFetching {
    
    // URL di base dell'API di Google Books per la ricerca di volumi
    private let baseURL = "https://www.googleapis.com/books/v1/volumes"
    private let decoder = JSONDecoder()
    
    func searchBooks(query: String) async throws -> BookAPIResponse {
        // Codifica la query per gestire spazi e caratteri speciali
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            throw APIError.invalidURL
        }
        
        // Costruzione dell'URL: q è la query, maxResults limita a 10 per pagina
        guard let url = URL(string: "\(baseURL)?q=\(encodedQuery)&maxResults=10") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Verifica che la risposta sia HTTP 200 OK
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }
            
            // Decodifica il JSON nei nostri Modelli Swift
            let result = try decoder.decode(BookAPIResponse.self, from: data)
            return result
            
        } catch is DecodingError {
            // Cattura specificamente gli errori di decodifica JSON
            throw APIError.decodingError
        } catch {
            // Cattura qualsiasi altro errore di rete
            throw error
        }
    }
}
