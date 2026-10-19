//
//  DeepLink.swift
//  SustantrailIOS
//
//  Created by Rahul Ramjeawon on 10/16/26.
//

import Foundation

struct DeepLink {
    static func destination(from url: URL) -> Destination? {
        guard url.scheme == Config.deepLinkScheme else { return nil }
        
        for parser in registeredParsers {
            if let destination = parser.parse(url) {
                return destination
            }
        }
        
        return nil
    }
    
    static let registeredParsers: [DeepLinkParser] = [
        .equal(to: ["home"], destination: .tab(.home)),
        .equal(to: ["events"], destination: .tab(.events)),
        .equal(to: ["map"], destination: .tab(.map)),
        .equal(to: ["profile"], destination: .tab(.profile)),
        .screen,
    ]
}
