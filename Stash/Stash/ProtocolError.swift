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
        case .invalidURL: return "Error: The API call URL is not valid."
        case .invalidResponse: return "Network error: HTTP responde not valid or status code not 200."
        case .noData: return "Error: No data received from server"
        case .decodingFailed(let error): return "Error on JSON decoding: \(error.localizedDescription)"
        }
    }
}
