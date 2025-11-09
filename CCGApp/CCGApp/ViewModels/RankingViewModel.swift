//
//  RankingViewModel.swift
//  ViewModel for Rankings
//
//  Created on 2025/11/9.
//

import Foundation
import Combine

@MainActor
class RankingViewModel: ObservableObject {
    @Published var selectedTab = 0 // 0: 天梯榜, 1: 单题榜
    @Published var ladderEntries: [LadderEntry] = []
    @Published var rankingEntries: [RankingEntry] = []
    @Published var selectedProblemId: Int = 0
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    
    init() {
        loadMockLadderData()
        loadMockRankingData()
    }
    
    func loadLadder() async {
        isLoading = true
        errorMessage = nil
        
        do {
            ladderEntries = try await apiService.fetchLadder()
        } catch {
            errorMessage = error.localizedDescription
            print("加载天梯榜失败: \(error)")
        }
        
        isLoading = false
    }
    
    func loadRanking(problemId: Int) async {
        isLoading = true
        errorMessage = nil
        selectedProblemId = problemId
        
        do {
            rankingEntries = try await apiService.fetchRanking(problemId: problemId)
        } catch {
            errorMessage = error.localizedDescription
            print("加载排行榜失败: \(error)")
        }
        
        isLoading = false
    }
    
    // 模拟数据
    private func loadMockLadderData() {
        ladderEntries = [
            LadderEntry(id: "1", handle: "CodeMaster", totalScore: 850, rank: 1, solvedCount: 10),
            LadderEntry(id: "2", handle: "SwiftNinja", totalScore: 720, rank: 2, solvedCount: 8),
            LadderEntry(id: "3", handle: "CGolfPro", totalScore: 650, rank: 3, solvedCount: 7),
            LadderEntry(id: "4", handle: "ByteOptimizer", totalScore: 580, rank: 4, solvedCount: 6),
            LadderEntry(id: "5", handle: "CompactCoder", totalScore: 520, rank: 5, solvedCount: 5)
        ]
    }
    
    private func loadMockRankingData() {
        let dateFormatter = ISO8601DateFormatter()
        
        rankingEntries = [
            RankingEntry(id: "1", handle: "CodeMaster", byteCount: 45, score: 150, rank: 1, submittedAt: dateFormatter.date(from: "2025-11-08T10:30:00Z") ?? Date()),
            RankingEntry(id: "2", handle: "SwiftNinja", byteCount: 48, score: 140, rank: 2, submittedAt: dateFormatter.date(from: "2025-11-08T11:00:00Z") ?? Date()),
            RankingEntry(id: "3", handle: "CGolfPro", byteCount: 52, score: 129, rank: 3, submittedAt: dateFormatter.date(from: "2025-11-08T12:15:00Z") ?? Date())
        ]
    }
}
