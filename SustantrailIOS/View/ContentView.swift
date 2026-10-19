//
//  ContentView.swift
//  SustantrailIOS
//
//  Created by Rahul Ramjeawon on 8/30/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        RootView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

struct RootView: View {
    @State private var router = Router(level: 0, identifierTab: nil)
    
    private var selectedTabBinding: Binding<TabDestination> {
        Binding(
            get: { router.selectedTab ?? .home },
            set: { router.selectedTab = $0 }
        )
    }
    
    var body: some View {
        TabView(selection: selectedTabBinding) {
            NavigationContainer(parentRouter: router, tab: .home) {
                HomeTabView()
            }
            .tag(TabDestination.home)
            .tabItem { Label("Home", systemImage: "house") }
            
            NavigationContainer(parentRouter: router, tab: .events) {
                EventsTabView()
            }
            .tag(TabDestination.events)
            .tabItem { Label("Events", systemImage: "text.justify") }
            
            NavigationContainer(parentRouter: router, tab: .map) {
                PlaceholderTabView(title: "Map")
            }
            .tag(TabDestination.map)
            .tabItem { Label("Map", systemImage: "map") }
            
            NavigationContainer(parentRouter: router, tab: .profile) {
                PlaceholderTabView(title: "Profile")
            }
            .tag(TabDestination.profile)
            .tabItem { Label("Profile", systemImage: "person") }
        }
        .onAppear {
            if router.selectedTab == nil {
                router.selectedTab = .home
            }
        }
    }
}

private struct HomeTabView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Sustantrail")
                .font(.title2)
            
            NavigationButton(push: .expositions(screen: .home)) {
                Label("Open Home Feed", systemImage: "arrow.right.circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            
            NavigationButton(sheet: .expositionInfo(title: "Home", message: "This tab can push model-backed exposition screens.")) {
                Label("Show Info", systemImage: "info.circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle("Home")
    }
}

private struct EventsTabView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Events")
                .font(.title2)
            
            NavigationButton(push: .expositions(screen: .events)) {
                Label("Open Events Feed", systemImage: "calendar")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Events")
    }
}

private struct PlaceholderTabView: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "hammer")
                .font(.largeTitle)
            Text("\(title) coming soon")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle(title)
    }
}
