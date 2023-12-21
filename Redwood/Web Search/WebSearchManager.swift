//
//  WebSearchManager.swift
//  Redwood
//
//  Created by Aditya Saravana on 12/20/23.
//

import Foundation

struct WebSearchManager {
    let parser = Parser()
    let responseHandler = BraveResponseHandler()
    
    let apiKey = "BSASUZkH6dWPjHvQL44jldVo_9ziReF"
    
    func search(for query: String) -> [String] {
        return parseResults(for: getResults(for: query))
    }
    
    func getResults(for query: String) -> [URL] {
        let formattedQuery = query.replacingOccurrences(of: " ", with: "+")
        var urls = [URL]()
        
        if let jsonString = fetchBraveSearchResults(for: formattedQuery) {
            if let response = BraveResponseHandler().decode(from: jsonString) {
                
                
                for result in response.web.results {
                    urls.append(URL(string: result.url)!)
                }
            }
        }
        
        return urls
    }
    
    func parseResults(for urls: [URL]) -> [String] {
        var strings = [String]()
        for url in urls {
            strings.append(parser.parseTextFromURL(from: url.absoluteString) ?? "")
        }
        
        return strings
    }
    
    func fetchBraveSearchResults(for query: String) -> String? {
        var returnValue: String? = nil
        print("starting")
        let url = URL(string: "https://api.search.brave.com/res/v1/web/search?q=\(query)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        request.addValue("\(apiKey)", forHTTPHeaderField: "X-Subscription-Token")
        print("creating task")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Handle the JSON data response here
                print(String(data: data, encoding: .utf8) ?? "Invalid data")
                returnValue = String(data: data, encoding: .utf8) ?? "Invalid data"
            } else {
                print("HTTP Error: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
            }
        }
        
        task.resume()
        print("completed func")
        return returnValue
    }
}
