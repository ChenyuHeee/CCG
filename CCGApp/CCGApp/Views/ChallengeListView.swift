//
//  ChallengeListView.swift
//  Beautiful Challenge List with Card Design
//
//  Created on 2025/11/9.
//

import SwiftUI

struct ChallengeListView: View {
    @StateObject private var viewModel = ChallengeListViewModel()
    @State private var searchText = ""
    
    var filteredChallenges: [Challenge] {
        if searchText.isEmpty {
            return viewModel.challenges
        }
        return viewModel.challenges.filter { challenge in
            challenge.title.localizedCaseInsensitiveContains(searchText) ||
            challenge.description.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景渐变
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredChallenges) { challenge in
                            NavigationLink(destination: ChallengeDetailView(challenge: challenge)) {
                                ChallengeCard(challenge: challenge)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
                .refreshable {
                    await viewModel.refresh()
                }
                
                if viewModel.isLoading {
                    ProgressView("加载中...")
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }
            .navigationTitle("代码挑战")
            .searchable(text: $searchText, prompt: "搜索题目")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            await viewModel.refresh()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .task {
            if viewModel.challenges.isEmpty {
                await viewModel.loadChallenges()
            }
        }
    }
}

struct ChallengeCard: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 标题和难度
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(challenge.id). \(challenge.title)")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text(challenge.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // 难度标签
                DifficultyBadge(difficulty: challenge.difficulty)
            }
            
            // 统计信息
            HStack(spacing: 16) {
                Label("\(challenge.examples.count) 样例", systemImage: "list.bullet")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(LinearGradient(
                    colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ), lineWidth: 1)
        }
    }
}

struct DifficultyBadge: View {
    let difficulty: Int
    
    var color: Color {
        switch difficulty {
        case ..<100:
            return .green
        case 100..<150:
            return .orange
        default:
            return .red
        }
    }
    
    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: "star.fill")
                .font(.caption2)
            Text("D\(difficulty)")
                .font(.caption2)
                .bold()
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(color.gradient)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ChallengeListView()
}
