//
//  RankingView.swift
//  Ranking and Ladder Board
//
//  Created on 2025/11/9.
//

import SwiftUI
import Charts

struct RankingView: View {
    @StateObject private var viewModel = RankingViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab选择器
                Picker("排行榜类型", selection: $viewModel.selectedTab) {
                    Text("天梯榜").tag(0)
                    Text("单题榜").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                // 内容区域
                TabView(selection: $viewModel.selectedTab) {
                    LadderBoardView(entries: viewModel.ladderEntries)
                        .tag(0)
                    
                    ProblemRankingView(entries: viewModel.rankingEntries)
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("排行榜")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            if viewModel.selectedTab == 0 {
                                await viewModel.loadLadder()
                            } else {
                                await viewModel.loadRanking(problemId: viewModel.selectedProblemId)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
}

struct LadderBoardView: View {
    let entries: [LadderEntry]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                // 前三名卡片
                if entries.count >= 3 {
                    TopThreeView(entries: Array(entries.prefix(3)))
                        .padding()
                }
                
                // 其他排名
                ForEach(entries.dropFirst(3)) { entry in
                    LadderEntryCard(entry: entry)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(
            LinearGradient(
                colors: [Color.orange.opacity(0.1), Color.yellow.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

struct TopThreeView: View {
    let entries: [LadderEntry]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 16) {
            if entries.count >= 2 {
                // 第二名
                PodiumCard(entry: entries[1], rank: 2, height: 100)
            }
            
            if entries.count >= 1 {
                // 第一名
                PodiumCard(entry: entries[0], rank: 1, height: 140)
            }
            
            if entries.count >= 3 {
                // 第三名
                PodiumCard(entry: entries[2], rank: 3, height: 80)
            }
        }
    }
}

struct PodiumCard: View {
    let entry: LadderEntry
    let rank: Int
    let height: CGFloat
    
    var medalColor: Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .brown
        default: return .blue
        }
    }
    
    var medalIcon: String {
        switch rank {
        case 1: return "crown.fill"
        case 2, 3: return "medal.fill"
        default: return "star.fill"
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // 奖牌
            Image(systemName: medalIcon)
                .font(.system(size: rank == 1 ? 40 : 30))
                .foregroundStyle(medalColor.gradient)
            
            // 昵称
            Text(entry.handle)
                .font(rank == 1 ? .headline : .subheadline)
                .bold()
                .lineLimit(1)
            
            // 分数
            Text("\(entry.totalScore) 分")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            // 领奖台
            RoundedRectangle(cornerRadius: 8)
                .fill(medalColor.opacity(0.3).gradient)
                .frame(height: height)
                .overlay {
                    Text("#\(rank)")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.white)
                }
        }
        .frame(maxWidth: .infinity)
    }
}

struct LadderEntryCard: View {
    let entry: LadderEntry
    
    var body: some View {
        HStack(spacing: 16) {
            // 排名
            Text("#\(entry.rank)")
                .font(.title3)
                .bold()
                .foregroundStyle(.blue)
                .frame(width: 50)
            
            // 用户信息
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.handle)
                    .font(.headline)
                
                Text("已解决 \(entry.solvedCount) 题")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // 总分
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(entry.totalScore)")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.orange)
                
                Text("总分")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct ProblemRankingView: View {
    let entries: [RankingEntry]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(entries) { entry in
                    RankingEntryCard(entry: entry)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.green.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }
}

struct RankingEntryCard: View {
    let entry: RankingEntry
    
    var rankColor: Color {
        switch entry.rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .brown
        default: return .blue
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // 排名徽章
            ZStack {
                Circle()
                    .fill(rankColor.gradient)
                    .frame(width: 50, height: 50)
                
                Text("#\(entry.rank)")
                    .font(.headline)
                    .bold()
                    .foregroundStyle(.white)
            }
            
            // 用户信息
            VStack(alignment: .leading, spacing: 6) {
                Text(entry.handle)
                    .font(.headline)
                
                HStack(spacing: 12) {
                    Label("\(entry.byteCount) 字节", systemImage: "doc.text")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Label("\(entry.score) 分", systemImage: "star.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
            
            Spacer()
            
            // 时间
            Text(formatDate(entry.submittedAt))
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            if entry.rank <= 3 {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(rankColor.opacity(0.5), lineWidth: 2)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
}

struct ProfileView: View {
    @AppStorage("userHandle") private var userHandle = ""
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.blue.gradient)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(userHandle.isEmpty ? "未设置昵称" : userHandle)
                                .font(.title2)
                                .bold()
                            
                            Text("C Code Golf 选手")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.leading, 8)
                    }
                    .padding(.vertical, 8)
                }
                
                Section("统计") {
                    StatRow(icon: "trophy.fill", title: "总积分", value: "0", color: .orange)
                    StatRow(icon: "checkmark.circle.fill", title: "已解决", value: "0 题", color: .green)
                    StatRow(icon: "chart.line.uptrend.xyaxis", title: "排名", value: "未上榜", color: .blue)
                }
                
                Section("关于") {
                    Link(destination: URL(string: "https://chenyuheee.github.io/c/about.html")!) {
                        HStack {
                            Label("关于项目", systemImage: "info.circle")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Link(destination: URL(string: "https://github.com/ChenyuHeee/CCG")!) {
                        HStack {
                            Label("GitHub", systemImage: "chevron.left.forwardslash.chevron.right")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Section {
                    Button {
                        showingSettings = true
                    } label: {
                        Label("设置", systemImage: "gear")
                    }
                }
            }
            .navigationTitle("我的")
            .sheet(isPresented: $showingSettings) {
                SettingsView(handle: $userHandle)
            }
        }
    }
}

struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .foregroundStyle(color)
            
            Spacer()
            
            Text(value)
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }
}

struct SettingsView: View {
    @Binding var handle: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("昵称", text: $handle)
                } header: {
                    Text("个人信息")
                } footer: {
                    Text("设置你在排行榜上显示的昵称")
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    RankingView()
}
