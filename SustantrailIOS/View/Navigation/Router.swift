//
//  Router.swift
//  SustantrailIOS
//
//  Created by Rahul Ramjeawon on 10/15/26.
//

import SwiftUI
import OSLog

/// A way to specify navigation
@Observable
final class Router {
    let id = UUID()
    let level: Int
    
    /// Specifies which tab the router was build for
    let identifierTab: TabDestination?
    
    /// Only relevant for the `level 0` root router. Defines the tab to select
    var selectedTab: TabDestination?
    
    /// Values presented in the navigation stack
    var navigationStackPath: [PushDestination] = []
    
    /// Current presented sheet
    var presentingSheet: SheetDestination?
    
    /// Current presented full screen
    var presentingFullScreen: FullScreenDestination?
    
    let logger = Logger(subsystem: Config.bundleID, category: "Navigation")
    
    /// Reference to the parent router to form a hierarchy
    /// Router levels increase for the children
    weak var parent: Router?
    
    /// A way to track which router is visible/active
    /// Used for deep link resolution
    private(set) var isActive: Bool = false
    
    init(level: Int, identifierTab: TabDestination?) {
        self.level = level
        self.identifierTab = identifierTab
        self.parent = nil
        
        logDebug("\(self.debugDescription) initialized")
    }
    
    deinit {
        Logger(subsystem: "com.SustantrailIOS", category: "Navigation")
            .debug("Router cleared")
    }
    
    private func resetContent() {
        navigationStackPath = []
        presentingSheet = nil
        presentingFullScreen = nil
    }
    
    private func logDebug(_ message: String) {
        logger.debug("\(message, privacy: .public)")
    }
}

// MARK: - Router Management

extension Router {
    func childRouter(for tab: TabDestination? = nil) -> Router {
        let router = Router(level: level + 1, identifierTab: tab ?? identifierTab)
        router.parent = self
        return router
    }
    
    func setActive() {
        logDebug("\(self.debugDescription): \(#function)")
        parent?.resignActive()
        isActive = true
    }
    
    func resignActive() {
        logDebug("\(self.debugDescription): \(#function)")
        isActive = false
    }
    
    static func previewRouter() -> Router {
        Router(level: 0, identifierTab: nil)
    }
}

// MARK: - Navigation

extension Router {
    func navigate(to destination: Destination) {
        switch destination {
        case let .tab(tab):
            select(tab: tab)
            
        case let .push(destination):
            push(destination)
            
        case let .sheet(destination):
            present(sheet: destination)
            
        case let .fullScreen(destination):
            present(fullScreen: destination)
        }
    }
    
    func select(tab destination: TabDestination) {
        logDebug("\(self.debugDescription) \(#function) \(destination.rawValue)")
        if level == 0 {
            selectedTab = destination
        } else {
            parent?.select(tab: destination)
            resetContent()
        }
    }
    
    func push(_ destination: PushDestination) {
        logDebug("\(self.debugDescription): \(#function) \(destination)")
        navigationStackPath.append(destination)
    }
    
    func present(sheet destination: SheetDestination) {
        logDebug("\(self.debugDescription): \(#function) \(destination)")
        presentingSheet = destination
    }
    
    func present(fullScreen destination: FullScreenDestination) {
        logDebug("\(self.debugDescription): \(#function) \(destination)")
        presentingFullScreen = destination
    }
    
    func deepLinkOpen(to destination: Destination) {
        guard isActive else { return }
        
        logDebug("\(self.debugDescription): \(#function) \(destination)")
        navigate(to: destination)
    }
}

extension Router: CustomDebugStringConvertible {
    var debugDescription: String {
        "Router[\(shortId) - \(identifierTabName) - Level: \(level)]"
    }
    
    private var shortId: String { String(id.uuidString.split(separator: "-").first ?? "") }
    
    private var identifierTabName: String {
        identifierTab?.rawValue ?? "No Tab"
    }
}
