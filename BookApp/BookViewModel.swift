//
//  BookViewModel.swift
//  BookApp
//
//  Created by Andreina Costagliola on 10/11/25.
//

import Foundation
import SwiftUI
import Combine

// ObservableObject to make the class observable by the view
class BookViewModel: ObservableObject {
    
    //@Published: automatically notify the view every time that the proprierty changes
    @Published var books: [Book] = [] //the results items list
    @Published var isLoading: Bool = false //Flag to show/hide the loading indicator
    @Published var errorMessage: String? //Error message, nil if no errors
    @Published var searchText: String = "" //Text input from the view
    
    //The viewModel uses the protocol (BookFetching) instead of the concrete class (APIService)
    private let apiService: BookFetching //apiservice is a struct that should contain the array of items and the number of items
    
    //constructor
    init(apiService: BookFetching = APIService()) {
            self.apiService = apiService
        }
    
    //@MainActor means that all the UI update (the published proprieties) inside this function will take place on the main thread
    @MainActor
    func search(query: String) {
        guard !query.isEmpty else {
            self.books = []
            return
        }
        isLoading = true
        errorMessage = nil
        
        //Task is for the async
        Task {
            do {
                let response = try await apiService.searchBooks(query: query)
                self.books = response.items
                self.isLoading = false
            } catch {
                self.errorMessage = "Errore: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func resetState() {
        books = []
        isLoading = false
        errorMessage = nil
        searchText = ""
    }
}
