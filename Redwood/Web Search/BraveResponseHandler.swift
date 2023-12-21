//
//  BraveResponseHandler.swift
//  Redwood
//
//  Created by Aditya Saravana on 12/20/23.
//

import Foundation

class BraveResponseHandler {
    
    // Function to decode JSON string into SearchResult
    func decode(from jsonString: String) -> SearchResult? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Error: Cannot create Data from jsonString")
            return nil
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            let searchResult = try decoder.decode(SearchResult.self, from: jsonData)
            return searchResult
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
}

struct SearchResult: Codable {
    let query: Query
    let mixed: Mixed
    let type: String
    let videos: Videos
    let web: Web
}

struct Query: Codable {
    let original: String
    let showStrictWarning: Bool
    let isNavigational: Bool
    let localDecision: String
    let localLocationsIdx: Int
    let isNewsBreaking: Bool
    let spellcheckOff: Bool
    let country: String
    let badResults: Bool
    let shouldFallback: Bool
    let postalCode: String
    let city: String
    let headerCountry: String
    let moreResultsAvailable: Bool
    let state: String
}

struct Mixed: Codable {
    let type: String
    let main: [Main]
    let top: [String]
    let side: [String]
}

struct Main: Codable {
    let type: String
    let index: Int?
    let all: Bool
}

struct Videos: Codable {
    let type: String
    let results: [VideoResult]
    let mutatedByGoggles: Bool
}

struct VideoResult: Codable {
    let type: String
    let url: String
    let title: String
    let description: String
    let age: String
    let pageAge: String
    let video: Video
    let metaUrl: MetaUrl
    let thumbnail: Thumbnail
}

struct Video: Codable {
    // Define properties based on the JSON structure
}

struct MetaUrl: Codable {
    let scheme: String
    let netloc: String
    let hostname: String
    let favicon: String
    let path: String
}

struct Thumbnail: Codable {
    let src: String
}

struct Web: Codable {
    let type: String
    let results: [WebResult]
}

struct WebResult: Codable {
    let title: String
    let url: String
    let isSourceLocal: Bool
    let isSourceBoth: Bool
    let description: String
    let pageAge: String
    let profile: Profile
    let language: String
    let familyFriendly: Bool
    let type: String
    let subtype: String
    let metaUrl: MetaUrl
    let thumbnail: Thumbnail
}

struct Profile: Codable {
    let name: String
    let url: String
    let longName: String
    let img: String
}
