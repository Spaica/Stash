//
//  ContentView.swift
//  BookApp
//
//  Created by Andreina Costagliola on 06/11/25.
//

import SwiftUI

struct ContainerView: View {
    var body: some View {
        TabView {
            Tab("Library", systemImage: "books.vertical.fill"){
                LibraryView()
            }
            Tab("Quotes", systemImage: "quote.bubble.fill"){
                QuotesView()
            }
        }
    }
}

#Preview {
    ContainerView()
}
