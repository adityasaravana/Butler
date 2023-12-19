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
    
    private func scrapeHTML(from urlString: String) -> String? {
        if let url = URL(string: urlString) {
            do {
                let contents = try String(contentsOf: url)
                print(contents)
                return contents
            } catch {
                print("Scraper.scrapeHTML: caught")
                return nil
            }
        } else {
            print("Scraper.scrapeHTML: Bad URL")
            return nil
        }
    }
    
    private func parseTextFromString(from html: String?) -> String? {
        if let contents = html {
            do {
                let doc: Document = try SwiftSoup.parse(contents)
                return try doc.text()
            } catch Exception.Error(let type, let message) {
                print(message)
                return nil
            } catch {
                print("error")
                return nil
            }
        } else {
            print("contents = nil")
            return nil
        }
    }
    
    func parseTextFromURL(from urlString: String) -> String? {
        return parseTextFromString(from: scrapeHTML(from: urlString))
    }
}
