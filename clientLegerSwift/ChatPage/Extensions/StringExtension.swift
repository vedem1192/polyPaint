//
//  StringExtension.swift
//  clientLegerSwift
//
//  Created by veronique demers on 18-01-31.
//  Copyright © 2018 log3900. All rights reserved.
//

import Foundation

extension String {
    func withoutWhitespace() -> String {
        return self.replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "\0", with: "")
    }
    
    func isValidIP() -> Bool {
        let parts = self.split(separator: ".")
        
        if parts.count != 4 {
            return false
        }
        for num in parts {
            if Int(num)! < 1 || Int(num)! > 254 {
                return false
            }
        }
        return true
    }
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}
