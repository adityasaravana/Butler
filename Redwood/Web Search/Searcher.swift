//
//  Searcher.swift
//  Redwood
//
//  Created by Aditya Saravana on 12/18/23.
//

import Foundation
import SwiftSoup

class Searcher {
    static let shared = Searcher()
    let scraper = Scraper.shared

    func fetchBraveSearchResults() {
        // BRAVE API KEY: BSASUZkH6dWPjHvQL44jldVo_9ziReF
        
//        curl -s --compressed "https://api.search.brave.com/res/v1/web/search?q=brave+search" -H "Accept:
//              application/json" -H "Accept-Encoding: gzip" -H "X-Subscription-Token: <YOUR_API_KEY>"
    }
}
