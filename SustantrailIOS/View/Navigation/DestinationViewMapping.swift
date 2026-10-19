//
//  DestinationViewMapping.swift
//  SustantrailIOS
//
//  Created by Rahul Ramjeawon on 10/15/26.
//

import SwiftUI

@ViewBuilder func view(for destination: PushDestination) -> some View {
    switch destination {
    case let .expositions(screen):
        ExpositionsScreen(screen: screen)
    }
}

@ViewBuilder func view(for destination: SheetDestination) -> some View {
    switch destination {
    case let .expositionInfo(title, message):
        VStack(spacing: 12) {
            Text(title)
                .font(.headline)
            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .presentationDetents([.medium, .large])
        .presentationBackground(.regularMaterial)
    }
}

@ViewBuilder func view(for destination: FullScreenDestination) -> some View {
    Group {
        switch destination {
        case let .imageGallery(urls, selectedIndex):
            TabView(selection: .constant(selectedIndex)) {
                ForEach(Array(urls.enumerated()), id: \.offset) { index, url in
                    VStack(spacing: 12) {
                        Text("Image \(index + 1)")
                            .font(.headline)
                        Text(url)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
    }
    .presentationBackground(.black)
}

private struct ExpositionsScreen: View {
    let screen: Screen
    @State private var expositions: [Exposition] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        List {
            if isLoading {
                ProgressView("Loading...")
            } else if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            } else {
                ForEach(Array(expositions.enumerated()), id: \.offset) { index, exposition in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(rowTitle(for: exposition))
                            .font(.headline)
                        Text(rowSubtitle(for: exposition))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                    .accessibilityIdentifier("exposition-row-\(index)")
                }
            }
        }
        .navigationTitle(screen == .home ? "Home" : "Events")
        .task {
            await loadExpositions()
        }
    }
    
    @MainActor
    private func loadExpositions() async {
        isLoading = true
        errorMessage = nil
        
        if let result = await APIRepository.shared.fetchExpositions(screen: screen) {
            expositions = result
        } else {
            errorMessage = "Failed to load expositions."
        }
        
        isLoading = false
    }
    
    private func rowTitle(for exposition: Exposition) -> String {
        switch exposition {
        case .graph:
            return "Graph"
        case .news:
            return "News"
        case .ad:
            return "Ad"
        case .event:
            return "Event"
        }
    }
    
    private func rowSubtitle(for exposition: Exposition) -> String {
        switch exposition {
        case let .graph(scoreData):
            return "Total score: \(scoreData.totalValue)"
        case let .news(newsSection):
            let count = newsSection.articles?.count ?? 0
            return "\(count) article(s)"
        case let .ad(adPlus):
            return adPlus.header ?? "No ad header"
        case let .event(eventSection):
            let count = eventSection.events?.count ?? 0
            return "\(count) event(s)"
        }
    }
}
