//
//  BookViewModel.swift
//  BookApp
//
//  Created by Andreina Costagliola on 10/11/25.
//

import Foundation
import SwiftUI

// ObservableObject rende la classe osservabile.
class BookViewModel: ObservableObject {
    
    // 1. STATO: Le proprietà che la View osserva per aggiornarsi.
    @Published var books: [Book] = [] // Lista dei libri
    @Published var isLoading: Bool = false // Stato di caricamento
    @Published var errorMessage: String? // Messaggio di errore
    @Published var searchText: String = "" // Input di ricerca dall'utente
    
    // 2. DIPENDENZA INIETTATA: Usa il contratto BookFetching per la flessibilità.
    private let apiService: BookFetching
    
    // Iniezione della Dipendenza (DI) - Permette di usare APIService in produzione e MockService nei test
    init(apiService: BookFetching = APIService()) {
        self.apiService = apiService
    }
    
    // 3. LOGICA: Metodo per avviare la ricerca
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
