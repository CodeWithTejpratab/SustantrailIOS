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
    var body: some View {
        TabView {
            NavigationStack {
                //                HomeView()
            }
            .tabItem { Label("Home", systemImage: "house") }
            
            NavigationStack {
                //                SettingsView()
            }
            .tabItem { Label("Events", systemImage: "text.justify") }
            NavigationStack {
                //                SettingsView()
            }
            .tabItem { Label("Map", systemImage: "map") }
            NavigationStack {
                //                SettingsView()
            }
            .tabItem { Label("prfile", systemImage: "person") }
        }
    }
}
