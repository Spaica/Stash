# Stash: your personal library

This is an iOS application developed using **SwiftUI** designed to allow users to search for books using the Google Books API, add them to a personal library list, and ensure the data persists across app sessions.

## Key features

* **Advanced search and debounce:** The search covers all fields (Title, Author, ISBN) and employs a **debounce** mechanism (0.5s delay) using Combine to prevent API overload while the user types.
* **Local data persistence:** Saved books are stored persistently on the device between sessions using **`UserDefaults`** and the **`Codable`** protocol.
* **MVVM architecture:** The project strictly follows the **Model-View-ViewModel** pattern, separating business logic (`LibraryViewModel`, `BookViewModel`) from the presentation layer.
* **Comprehensive state management:** The search view explicitly handles **Loading**, **Error**, **No Results**, and **Initial** states.
* **CRUD functionality:** Users can **Add** (`addBook`) and **Remove** (`removeBook`) books from the main library list.
* **Modal presentation:** Uses a modal view (`.sheet`) for the book addition screen, managed by the `LibraryView`.

## Technology stack

**Language**: Swift 
**UI framework**: SwiftUI
**Architecture**: MVVM (Model-View-ViewModel)
**Networking**: `URLSession` with `async/await`
**Asynchronous Handling**: `Combine` framework (for debounce logic)
**Local persistence**: `UserDefaults` and `Codable`

## Project structure (MVVM)
`LibraryViewModel.swift` (ViewModel): Manages the persistent `savedBooks` array, handling `addBook()`, `removeBook()`, and persistence logic (`loadBooks`/`saveBooks`).

`BookViewModel.swift` (ViewModel): Manages search state, loading indicators, and calls the `APIService`.

`Books.swift` (Model): Defines all data structures (`Book`, `Info`, `Links`, etc.) conforming to `Codable`.

`APIService.swift` (Service/Model): Handles URL construction and execution of the asynchronous API request.

`LibraryView.swift` (View): Displays the saved books and manages the presentation of the `AddBookView` modal.

`AddBookView.swift` (View): Contains the search bar and implements the search debounce logic.

`BookDetailsView.swift` / `BookDetails2View.swift` (View): Display book details and provide buttons for adding or removing the book from the library.
