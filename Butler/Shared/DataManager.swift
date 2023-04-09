//
//  DataManager.swift
//  Butler
//
//  Created by NMS15065-7-adisara on 3/21/23.
//

import Foundation
import KeychainSwift

public struct DataManager {
    private let keychain = KeychainSwift()
    
    func push(key: Keys, content: String) {
        keychain.set(content, forKey: key.rawValue)
    }
    
    func pull(key: Keys) -> String? {
        return keychain.get(key.rawValue)
    }
    
    public enum Keys: String {
        case Butler_UserOpenAIKey
    }
}

