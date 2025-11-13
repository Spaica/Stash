//
//  BookDetailsView.swift
//  BookApp
//
//  Created by Andreina Costagliola on 13/11/25.
//

import SwiftUI

struct BookDetailsView: View {
    let book : Book
    
    var body: some View {
        Spacer()
        VStack{
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
        }
        Spacer()
        
        var authors: String {
            if let authors = book.volumeInfo.authors, !authors.isEmpty {
                return authors.joined(separator: ", ")
            }
            return "Unknown Author"
        }
        
            Text(book.volumeInfo.title ?? "Untitled")
                .font(.headline)
                .lineLimit(2)
                .foregroundColor(.black)
            
            Text(authors)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            
            Text("\(book.volumeInfo.pageCount ?? 1) pages")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .foregroundColor(.black)
            
        if book.volumeInfo.maturityRating != "NOT_MATURE" {
            HStack{
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.red)
                Text("18+")
                    .foregroundColor(.red)
            }
        }
        Spacer()
        Text("Description:")
        Text(book.volumeInfo.description ?? " ")
            .padding(.horizontal)
        Spacer()
    }
}

#Preview {
    BookDetailsView(book: Book(
        id: "1",
        volumeInfo: Info(title: "Example", authors: ["Author"], description: "kuhAGSDFiuhwdfuioahwofuihwebhaujemnrgdjdhjdjwhfòjowhhdjfhnjadhjahdljkahdfkjadkfhahkdfhadfhjagdfhgahgf", imageLinks: nil)
            ))
}
