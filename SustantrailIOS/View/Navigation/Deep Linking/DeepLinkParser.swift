//
//  Untitled.swift
//  SustantrailIOS
//
//  Created by Rahul Ramjeawon on 10/16/26.
//

import Foundation

/// A function that matches a deep link URL to a destination if possible
struct DeepLinkParser {
    let parse: (URL) -> Destination?
}

extension URL {
    /// Split URL components without considering the scheme
    ///
    /// Example:
    ///
    /// for `moviecat://movies/123/gallery` this returns
    ///
    /// ```swift
    /// ["movies", "123", "gallery"]
    /// ```
    var fullComponents: [String] {
        guard let scheme else { return [] }
        
        return absoluteString
            .replacingOccurrences(of: "\(scheme)://", with: "")
            .split(separator: "/")
            .map { String($0) }
    }
}

extension DeepLinkParser {
    static func equal(to components: [String], destination: Destination) -> Self {
        .init { url in
            guard url.fullComponents == components else { return nil }
            return destination
        }
    }
    
    static let screen: Self = .init { url in
        guard url.fullComponents.first == "screen", url.fullComponents.count == 2 else { return nil }
        
        let screenValue = url.fullComponents[1]
        guard let screen = Screen(rawValue: screenValue) else { return nil }
        
        return .push(.expositions(screen: screen))
    }
}
