//
//  AddBookView.swift
//  BookApp
//

import SwiftUI
import Combine

// MARK: - View Principale
struct AddBookView: View {
    @StateObject var bookViewModel = BookViewModel()
    //to manage the debounce option
    @State private var searchCancellable: AnyCancellable?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                //research bar
                TextField("Search", text: $bookViewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding([.horizontal, .bottom])
                    .padding(.top, 8)
                //call the debounce when changing the text
                    .onChange(of: bookViewModel.searchText) { _, newQuery in
                        self.debounceSearch(query: newQuery)
                    }
                
                //State manage
                Group {
                    if bookViewModel.isLoading {
                        //A: loading
                        ProgressView("Loading books...")
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let error = bookViewModel.errorMessage {
                        //B: Error
                        Text("\(error)")
                            .foregroundColor(.red)
                            .padding()
                    } else if bookViewModel.books.isEmpty && !bookViewModel.searchText.isEmpty {
                        //C: no results
                        ContentUnavailableView(
                            "No Results Found",
                            systemImage: "doc.text.magnifyingglass",
                            description: Text("Your search for '\(bookViewModel.searchText)' returned no matches. Try a different query.")
                        )
                    } else if bookViewModel.books.isEmpty && bookViewModel.searchText.isEmpty {
                        //D: Initial state, no research
                        ContentUnavailableView(
                            "Search to Add a Book",
                            systemImage: "magnifyingglass.circle.fill",
                            description: Text("Enter a book title, author, or ISBN to search for the book you want to add.")
                        )
                    } else {
                        //E: results
                        
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(bookViewModel.books) {
                                    book in
                                    BookCardView(book: book)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle("Add a book")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("Close or new function tapped")
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
        }
    }
    
    //Debounce
    private func debounceSearch(query: String) {
        //cancel the previous search if the use is still typing
        searchCancellable?.cancel()
        
        guard !query.isEmpty else {
            bookViewModel.search(query: query)
            return
        }
        
        searchCancellable = Future<String, Never> { promise in
            promise(.success(query))
        }
        .delay(for: .seconds(0.5), scheduler: RunLoop.main)
        .sink { [weak bookViewModel] finalQuery in
            bookViewModel?.search(query: finalQuery)
        }
    }
}

// MARK: - Book card view
struct BookCardView: View {
    let book: Book
    
    //to link multiple authors strings
    var authors: String {
        if let authors = book.volumeInfo.authors, !authors.isEmpty {
            return authors.joined(separator: ", ")
        }
        return "Unknown Author"
    }
    
    
    var body: some View{
        HStack(alignment: .top, spacing: 15) {
            
            //1: Image
            if let url = book.volumeInfo.imageLinks?.smallThumbnail {
                AsyncImage(url: url) { phase in //load the image from the url without pausing the UI, phase is a parameter used to see it the image is empty, loaded successfully or error
                    Group{
                        if let image = phase.image {
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                        } else if phase.error != nil {
                            //placeholder
                            BookPlaceholderView(iconName: "xmark.octagon")
                            
                        }else{
                            
                            BookPlaceholderView(iconName: "photo.fill")
                                .opacity(0.7)
                        }
                    }
                }
                .frame(width: 70, height: 105)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .clipped()
                
            } else {
                // Placeholder statico se l'URL dell'immagine non è disponibile
                BookPlaceholderView(iconName: "book.closed.fill")
                    .foregroundColor(.gray)
            }
            
            //2: Text
            VStack(alignment: .leading, spacing: 4) {
                Text(book.volumeInfo.title ?? "Untitled")
                    .font(.headline)
                    .lineLimit(2)
                
                Text(authors)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                
                Text("\(book.volumeInfo.pageCount ?? 1) pages")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                
                if book.volumeInfo.maturityRating != "NOT_MATURE" {
                    HStack{
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.red)
                        Text("18+")
                            .foregroundColor(.red)
                    }
                }
                
                Spacer()
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 3)
        .padding(.horizontal)
    }
}

struct BookPlaceholderView: View {
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 70, height: 105)
            .padding(10)
    }
}

// MARK: - Preview

#Preview {
    // La preview è necessaria per visualizzare la vista
    AddBookView()
}
