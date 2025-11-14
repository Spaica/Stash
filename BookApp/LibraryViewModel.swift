//
//  LibraryViewModel.swift
//  BookApp
//
//  Created by Andreina Costagliola on 14/11/25.
//

import Foundation
import Combine

class LibraryViewModel: ObservableObject {
    
    //the view observes this array (it's published and the class is observable)
    @Published var savedBooks: [Book] = []
    
    //logic to save a book
    func addBook(_ book: Book) {
        if !savedBooks.contains(where: { $0.id == book.id }) {
            savedBooks.append(book)
            print("Book: '\(book.volumeInfo.title ?? "")' saved!")
        } else {
            print("Book already saved")
        }
    }
    
    func isBookSaved(_ book: Book) -> Bool {
        return savedBooks.contains(where: { $0.id == book.id })
    }
}
