//
//  Destination.swift
//  SustantrailIOS
//
//  Created by Rahul Ramjeawon on 10/15/26.
//

import Foundation

enum Destination: Hashable {
    case tab(_ destination: TabDestination)
    case push(_ destination: PushDestination)
    case sheet(_ destination: SheetDestination)
    case fullScreen(_ destination: FullScreenDestination)
}

extension Destination: CustomStringConvertible {
    var description: String {
        switch self {
        case let .tab(destination): ".tab(\(destination))"
        case let .push(destination): ".push(\(destination))"
        case let .sheet(destination): ".sheet(\(destination))"
        case let .fullScreen(destination): ".fullScreen(\(destination))"
        }
    }
}

enum PushDestination: Hashable, CustomStringConvertible {
    case expositions(screen: Screen)
    
    var description: String {
        switch self {
        case let .expositions(screen): ".expositions(\(screen.rawValue))"
        }
    }
}

enum TabDestination: String, Hashable {
    case home
    case events
    case map
    case profile
}

enum SheetDestination: Hashable, CustomStringConvertible {
    case expositionInfo(title: String, message: String)
    
    var description: String {
        switch self {
        case let .expositionInfo(title, _): ".expositionInfo(\(title))"
        }
    }
}

extension SheetDestination: Identifiable {
    var id: String {
        switch self {
        case let .expositionInfo(title, message): "\(title)-\(message)"
        }
    }
}

enum FullScreenDestination: Hashable, CustomStringConvertible {
    case imageGallery(urls: [String], selectedIndex: Int)
    
    var description: String {
        switch self {
        case let .imageGallery(urls, selectedIndex):
            ".imageGallery(count: \(urls.count), selected: \(selectedIndex))"
        }
    }
}

extension FullScreenDestination: Identifiable {
    var id: String {
        switch self {
        case let .imageGallery(urls, selectedIndex):
            "\(urls.joined(separator: ","))::\(selectedIndex)"
        }
    }
}
