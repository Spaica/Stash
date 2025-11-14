//
//  ContainerView.swift
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
            Tab("To read", systemImage: "book.fill"){
                ToReadView()
            }
            Tab("Lists", systemImage: "text.below.folder"){
                ListsView()
            }
            Tab("Settings", systemImage: "slider.horizontal.3"){
                SettingsView()
            }
        }
    }
}

#Preview {
    let sampleLibraryVM = LibraryViewModel()
    
    return ContainerView()
        .environmentObject(sampleLibraryVM)
}
