//
//  Books.swift
//  BookApp
//
//  Created by Andreina Costagliola on 10/11/25.
//

import Foundation
import SwiftUI

//MARK: - Models
//decodable is for decoding from json format, and identifiable because the item can be identified with the id

struct APIResponse: Decodable {
    var totalItems: Int
    var items: [Book]?
}


struct Book: Decodable, Identifiable {
    var id: String
    var volumeInfo: Info
}

struct Info: Decodable {
    var title: String
    var authors: [String]?
    var description: String?
    var publisher: String?
    var publishedDate: String?
    var imageLinks: Links?
    var pageCount: Int?
    var categories: [String]?
    var maturityRating: String?
    var language: String?
    var industryIdentifier: ISBN
}

struct ISBN: Decodable {
    var type: String
    var identifier: String
}

struct Links: Decodable{
    var smallThumbnail: URL?
}



