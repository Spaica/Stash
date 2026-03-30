//
//  BookDetailsView.swift
//  BookApp
//
//  Created by Andreina Costagliola on 13/11/25.
//

import SwiftUI

struct BookDetails2View: View {
    let book : Book
    @EnvironmentObject var libraryViewModel : LibraryViewModel
    @Environment(\.dismiss) var dismiss
    
    var authors: String {
        if let authors = book.volumeInfo.authors, !authors.isEmpty {
            return authors.joined(separator: ", ")
        }
        return "Unknown Author"
    }
    
    var body: some View {
        ScrollView{
            VStack{
                if let url = book.volumeInfo.imageLinks?.thumbnail {
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
                    .frame(width: 150, height: 225)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
                    .clipped()
                    
                } else {
                    // Placeholder statico se l'URL dell'immagine non è disponibile
                    BookPlaceholderView(iconName: "book.closed.fill")
                        .foregroundColor(.gray)
                    
                }
            }
            .navigationTitle(book.volumeInfo.title ?? "Book Details")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Remove"){
                        libraryViewModel.removeBook(book)
                        dismiss()
                    }
                }
            }
            
            VStack{
                
                Text(authors)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                
                Text("\(book.volumeInfo.pageCount ?? 1) pages")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .foregroundColor(.black)
                
                
                if book.volumeInfo.maturityRating != "NOT_MATURE" {
                    HStack(spacing: 0){
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.red)
                        Text("18+")
                            .foregroundColor(.red)
                    }
                }
            }//Vstack
            VStack(alignment: .leading, spacing: 10){
                
                var categories: String {
                    if let categories = book.volumeInfo.categories, !categories.isEmpty {
                        return categories.joined(separator: ", ")
                    }
                    return "Unknown categories"
                }
                
                Divider()
                
                Text("Language: " + (book.volumeInfo.language ?? "Unknown"))
                    .font(.footnote)
                
                Text("Categories: " + categories)
                    .font(.footnote)
                
                Divider()
                Text("Description:")
                    .bold()
                
                
                Text(book.volumeInfo.description ?? " ")
                    .padding(.horizontal)
            }
            .padding(.top, 15)
            .padding(.horizontal)
            VStack{
                
                Text("Publisher: " + (book.volumeInfo.publisher ?? "Unknown"))
                    .foregroundColor(.secondary)
                Text("Published date: " + (book.volumeInfo.publishedDate ?? "Unknown"))
                    .foregroundColor(.secondary)
            }
            .padding()
        }//scrollview
    }
}

#Preview {
    
    // 1. Crea un'istanza di esempio del ViewModel della libreria
    let sample = LibraryViewModel()
    
    // 2. Assicurati di avere un oggetto Book di esempio per la vista di dettaglio
    let sampleBook = Book(
        id: "1",
        volumeInfo: Info(title: "Example", authors: ["Author"], description: "kuhAGSDFiuhwdfuioahwofuihwebhaujemnrgdjdhjdjwhfòjowhhdjfhnjadhjahdljkahdfkjadkfhahkdfhadfhjagdfhgahgf", imageLinks: nil)
    )
    
    // 3. Inietta il LibraryViewModel nella preview
    return BookDetails2View(book: sampleBook)
        .environmentObject(sample)
}
