//
//  BookAppApp.swift
//  BookApp
//
//  Created by Andreina Costagliola on 06/11/25.
//

import SwiftUI

@main
struct BookApp: App {
    @StateObject var libraryViewModel = LibraryViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContainerView()
                .environmentObject(libraryViewModel)
        }
    }
}
