//
//  LibraryViewModel.swift
//  BookApp
//
//  Created by Andreina Costagliola on 14/11/25.
//

import Foundation
import Combine
import SwiftUI

class LibraryViewModel: ObservableObject {
    
    //Key for userdefaults, for persistence
        private let saveKey = "SavedBooks"
    
    
    //the view observes this array (it's published and the class is observable)
    @Published var savedBooks: [Book] = []
    
    
    //constructor: loads data at the opening of the app
        init() {
            loadBooks()
        }
        
        //Reading from userdefaults
        func loadBooks() {
            if let data = UserDefaults.standard.data(forKey: saveKey) {
                do {
                    //decode data in a book array
                    let decodedBooks = try JSONDecoder().decode([Book].self, from: data)
                    self.savedBooks = decodedBooks
                    print("✅ CARICAMENTO RIUSCITO. Caricati \(savedBooks.count) libri.")
                } catch {
                    print("Failed to decode saved books: \(error)")
                    self.savedBooks = []
                }
            }
        }
        
        //Writing on userdefaultd
        func saveBooks() {
            do {
                // Tenta di codificare l'array di Book in Data
                let encoded = try JSONEncoder().encode(savedBooks)
                // Salva il Data in UserDefaults
                UserDefaults.standard.set(encoded, forKey: saveKey)
            } catch {
                print("Failed to encode books for saving: \(error)")
            }
        }
    
    func removeBook(_ book: Book) {
        //take the index
        if let index = savedBooks.firstIndex(where: { $0.id == book.id }) {
            savedBooks.remove(at: index)
            
            //save the update
            saveBooks()
            print("Book '\(book.volumeInfo.title ?? "")' removed")
        }
    }
    
    
    //logic to save a book
    func addBook(_ book: Book) {
        if !savedBooks.contains(where: { $0.id == book.id }) {
            savedBooks.append(book)
            saveBooks()
            print("Book: '\(book.volumeInfo.title ?? "")' saved!")
        } else {
            print("Book already saved")
        }
    }
    
    func isBookSaved(_ book: Book) -> Bool {
        return savedBooks.contains(where: { $0.id == book.id })
    }
}
