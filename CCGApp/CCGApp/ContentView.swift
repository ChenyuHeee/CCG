//
//  ContentView.swift
//  CCGApp - Main Tab Navigation
//
//  Created on 2025/11/9.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ChallengeListView()
                .tabItem {
                    Label("挑战", systemImage: "trophy.fill")
                }
                .tag(0)
            
            RankingView()
                .tabItem {
                    Label("排行榜", systemImage: "chart.bar.fill")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("我的", systemImage: "person.fill")
                }
                .tag(2)
        }
        .tint(.blue)
    }
}

#Preview {
    ContentView()
}
