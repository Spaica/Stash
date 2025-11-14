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
    @State private var isShowingAddBookView = false
    
    var body: some View {
        NavigationStack{
            VStack{
                
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

#Preview {
    LibraryView()
}
