//
//  Scraper.swift
//  Redwood
//
//  Created by Aditya Saravana on 12/17/23.
//

import Foundation
import SwiftSoup

class Scraper {
    static let shared = Scraper()
    
    func scrapeHTML(from urlString: String) {
        if let url = URL(string: "https://www.hackingwithswift.com") {
            do {
                let contents = try String(contentsOf: url)
                print(contents)
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
    }
}
