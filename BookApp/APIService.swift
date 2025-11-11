//
//  APIService.swift
//  BookApp
//
//  Created by Andreina Costagliola on 11/11/25.
//

import Foundation

//Implements BookFetching, so the searchbooks method
struct APIService: BookFetching {
    
    //'query: String' is the research text provided by the user
    //'async' means that it will not interrrupt the UI while waiting for the answer
    //'throws' means that the function can fail (APIError)
    func searchBooks(query: String) async throws -> APIResponse {
        
        //1. Build the url:
        var components = URLComponents() //swift framework
        components.scheme = "https" //safe protocol
        components.host = "www.googleapis.com" //service host, google in this case
        components.path = "/books/v1/volumes"
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "maxResults", value: "20") //max number of results displayed in the list
        ]
        
        //Check on the url
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        //2. Net request execution
        //try away is for making it async
        let (data, response) = try await URLSession.shared.data(from: url) //to download data from the url through the apple framework function
        
        //3. Check on the HTTP response
        //Convert the response into HTTPURLResponse to access specific proprieties (statusCode)
        //'guard let' verify that the response status code is 200 ok
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            throw APIError.invalidResponse(statusCode)
        }
        
        //4. Check on data
        guard data.count > 0 else {
            throw APIError.noData
        }
        
        //5. Decode JSON data
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(APIResponse.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
}
