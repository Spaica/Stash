//
//  APIService.swift
//  BookApp
//
//  Created by Andreina Costagliola on 11/11/25.
//

import Foundation

// Implementa il contratto BookFetching, quindi ha il metodo searchbooks
struct APIService: BookFetching {
    
    // Implementazione del metodo di ricerca asincrona
    // 'query: String' è il testo di ricerca fornito dall'utente.
    // 'async' significa che l'operazione è asincrona (non blocca l'UI mentre attende la risposta).
    // 'throws' significa che la funzione può fallire lanciando un errore (un APIError).
    func searchBooks(query: String) async throws -> APIResponse {
        
        // 1. Costruzione dell'URL in modo sicuro.
        var components = URLComponents() //uso un framework swift
        components.scheme = "https" //scelgo il protocollo di sicurezza
        components.host = "www.googleapis.com" //inserisco il dominio del servizio, di google
        components.path = "/books/v1/volumes" //
        
        // Aggiunge la query dell'utente e il limite di risultati
        components.queryItems = [
            URLQueryItem(name: "q", value: query), //q è il parametro di ricerca per l'api books di google
            URLQueryItem(name: "maxResults", value: "20")
        ]
        
        // Controlla che l'URL sia valido e crea la costante url, altrimenti lancia invalidURL
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        // 2. Esecuzione della richiesta di rete
        //try away serve a farlo in modo asincrono
        let (data, response) = try await URLSession.shared.data(from: url) //per scaricare i dati da rete dall'url fornito con il framework apple
        
        // 3. CONTROLLO DELLA RISPOSTA HTTP ---
        // Converti la risposta generica in HTTPURLResponse per accedere a proprietà specifiche (come statusCode).
        // 'guard let' verifica che la risposta sia di tipo HTTP E che lo status code sia 200 (Successo).
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            
            // Se fallisce, prendiamo lo status code (o 0 se non disponibile)
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            // E lanciamo l'errore 'invalidResponse' con il codice di stato specifico.
            throw APIError.invalidResponse
        }
        
        // 4. Controllo Dati (se il JSON è vuoto)
        guard data.count > 0 else {
            throw APIError.noData
        }
        
        // 5. Decodifica dei Dati JSON
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(APIResponse.self, from: data)
        } catch {
            // Lancia decodingFailed se la decodifica fallisce
            throw APIError.decodingFailed(error)
        }
    }
}
