//
//  BookViewModel.swift
//  BookApp
//
//  Created by Andreina Costagliola on 10/11/25.
//

import Foundation
import SwiftUI
import Combine

// ObservableObject rende la classe osservabile.
class BookViewModel: ObservableObject {
    
    // PROPRIETÀ DI STATO (Il "Cosa") ---
    // Le proprietà che la View osserva per aggiornarsi.
    @Published var books: [Book] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    // 2. DIPENDENZA (Il "Chi") ---
    // Usa il contratto BookFetching
    private let apiService: BookFetching
    
    // 3. INIZIALIZZAZIONE (Il "Come si crea") ---
    // Permette di usare APIService
    init(apiService: BookFetching = APIService()) {
        self.apiService = apiService
    }
    
    // 4. LOGICA DI BUSINESS (L' "Azione") ---
    // @MainActor garantisce che l'aggiornamento dello stato (Published) avvenga sul thread principale
    @MainActor
    func search(query: String) {
        // Se la query è vuota, pulisce i risultati e ferma la ricerca
        guard !query.isEmpty else {
            self.books = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Task è il modo per chiamare codice asincrono da una funzione sincrona (come search)
        Task {
            do {
                // Chiama il servizio (l'API) tramite il contratto (BookFetching)
                let response = try await apiService.searchBooks(query: query)
                
                // Aggiorna lo stato UI sul Main Actor
                self.books = response.items ?? []
                self.isLoading = false
            } catch {
                // Gestione errori UI
                self.errorMessage = "Errore: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    // Metodo per pulire lo stato
    func resetState() {
        books = []
        isLoading = false
        errorMessage = nil
        searchText = ""
    }
}
