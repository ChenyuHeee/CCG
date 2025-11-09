//
//  ChallengeListViewModel.swift
//  ViewModel for Challenge List
//
//  Created on 2025/11/9.
//

import Foundation
import Combine

@MainActor
class ChallengeListViewModel: ObservableObject {
    @Published var challenges: [Challenge] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // 加载示例数据
        loadMockData()
    }
    
    func loadChallenges() async {
        isLoading = true
        errorMessage = nil
        
        do {
            challenges = try await apiService.fetchChallenges()
        } catch {
            errorMessage = error.localizedDescription
            print("加载挑战失败: \(error)")
        }
        
        isLoading = false
    }
    
    func refresh() async {
        await loadChallenges()
    }
    
    // 临时模拟数据
    private func loadMockData() {
        challenges = [
            Challenge(
                id: 0,
                title: "打印菱形（优化版）",
                description: "打印指定大小的菱形图案",
                difficulty: 150,
                inputFormat: "一个整数 n (1 ≤ n ≤ 100)，表示菱形的大小",
                outputFormat: "打印一个由 * 组成的菱形",
                examples: [
                    Challenge.Example(
                        input: "3",
                        output: "  *\n ***\n*****\n ***\n  *",
                        explanation: "大小为3的菱形"
                    )
                ],
                detailURL: "https://chenyuheee.github.io/c/competition/0.html",
                rankingURL: "https://chenyuheee.github.io/c/competition/rank/week.html?problem=0"
            ),
            Challenge(
                id: 1,
                title: "斐波那契数列",
                description: "计算斐波那契数列的第n项",
                difficulty: 100,
                inputFormat: "一个整数 n (1 ≤ n ≤ 40)",
                outputFormat: "输出第n个斐波那契数",
                examples: [
                    Challenge.Example(
                        input: "5",
                        output: "5",
                        explanation: "第5个斐波那契数是5"
                    )
                ],
                detailURL: "https://chenyuheee.github.io/c/competition/1.html",
                rankingURL: "https://chenyuheee.github.io/c/competition/rank/week.html?problem=1"
            )
        ]
    }
}
