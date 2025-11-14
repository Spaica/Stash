//
//  LibraryView.swift
//  BookApp
//
//  Created by Andreina Costagliola on 10/11/25.
//

import SwiftUI
import Combine

// MARK: - Library view
struct LibraryView: View {
    @EnvironmentObject var libraryViewModel : LibraryViewModel
    @State private var isShowingAddBookView = false
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    if libraryViewModel.savedBooks.isEmpty {
                        ContentUnavailableView("No Books Saved", systemImage: "book.fill")
                            .padding(.top, 200)
                    } else {
                        ForEach(libraryViewModel.savedBooks){
                            book in
                            NavigationLink{
                                BookDetails2View(book: book)
                            } label:{
                                BookCardView(book: book)
                            }
                        }
                        
                    }
                }
                .navigationTitle("Library")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isShowingAddBookView = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                        }
                    }
                }
                .sheet(isPresented: $isShowingAddBookView){
                    AddBookView()
                }
            }
        }
    }
}


#Preview {
    let sample = LibraryViewModel()
    return LibraryView()
        .environmentObject(sample)
}
