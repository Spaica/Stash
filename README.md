# Stash: Your Personal Library (iOS App)

This is an iOS application developed using **SwiftUI** designed to allow users to search for books using the Google Books API, add them to a personal library list, and ensure the data persists across app sessions.

---

## Key Features

* **Advanced Search & Debounce:** The search covers all fields (Title, Author, ISBN) and employs a **Debounce** mechanism (0.5s delay) using Combine to prevent API overload while the user types.
* **Local Data Persistence:** Saved books are stored persistently on the device between sessions using **`UserDefaults`** and the **`Codable`** protocol.
* **MVVM Architecture:** The project strictly follows the **Model-View-ViewModel** pattern, separating business logic (`LibraryViewModel`, `BookViewModel`) from the presentation layer.
* **Comprehensive State Management:** The search view explicitly handles **Loading**, **Error**, **No Results**, and **Initial** states.
* **CRUD Functionality:** Users can **Add** (`addBook`) and **Remove** (`removeBook`) books from the main library list.
* **Modal Presentation:** Uses a modal view (`.sheet`) for the book addition screen, managed by the `LibraryView`.

---

## Technology Stack
| **Language** | Swift |

| **UI Framework** | SwiftUI |

| **Architecture** | MVVM (Model-View-ViewModel) |

| **Networking** | `URLSession` with `async/await` |

| **Asynchronous Handling** | `Combine` Framework (for Debounce logic) |

| **Local Persistence**| `UserDefaults` and `Codable` |

---

## Project Structure (MVVM)
| `LibraryViewModel.swift` | ViewModel | Manages the persistent `savedBooks` array, handling `addBook()`, `removeBook()`, and persistence logic (`loadBooks`/`saveBooks`).

| `BookViewModel.swift` | ViewModel | Manages search state, loading indicators, and calls the `APIService`. |

| `Books.swift` | Model | Defines all data structures (`Book`, `Info`, `Links`, etc.) conforming to `Codable`. |

| `APIService.swift` | Service/Model | Handles URL construction and execution of the asynchronous API request. |

| `LibraryView.swift` | View | Displays the saved books and manages the presentation of the `AddBookView` modal. |
| `AddBookView.swift` | View | Contains the search bar and implements the search debounce logic. |
| `BookDetailsView.swift` / `BookDetails2View.swift` | View | Display book details and provide buttons for adding or removing the book from the library. |
