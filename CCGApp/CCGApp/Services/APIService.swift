//
//  APIService.swift
//  Network Service Layer
//
//  Created on 2025/11/9.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case serverError(Int)
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "无效的URL"
        case .networkError(let error):
            return "网络错误: \(error.localizedDescription)"
        case .decodingError(let error):
            return "数据解析错误: \(error.localizedDescription)"
        case .serverError(let code):
            return "服务器错误: \(code)"
        case .unknown:
            return "未知错误"
        }
    }
}

class APIService {
    static let shared = APIService()
    
    private let baseURL = "https://chenyuheee.github.io/c/competition"
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 300
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Challenge APIs
    
    /// 获取挑战列表
    func fetchChallenges() async throws -> [Challenge] {
        // 这里需要根据实际 API 调整
        // 示例：从 problems.json 获取
        let urlString = "\(baseURL)/problems.json"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.serverError(httpResponse.statusCode)
            }
            
            let challenges = try JSONDecoder().decode([Challenge].self, from: data)
            return challenges
        } catch let error as DecodingError {
            throw APIError.decodingError(error)
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    /// 获取题目详情（从 HTML 解析）
    func fetchChallengeDetail(id: Int) async throws -> String {
        let urlString = "\(baseURL)/\(id).html"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await session.data(from: url)
        guard let html = String(data: data, encoding: .utf8) else {
            throw APIError.decodingError(DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid UTF-8")))
        }
        
        return html
    }
    
    // MARK: - Ranking APIs
    
    /// 获取单题排行榜
    func fetchRanking(problemId: Int) async throws -> [RankingEntry] {
        let urlString = "\(baseURL)/rank/week.json?problem=\(problemId)"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await session.data(from: url)
        let entries = try JSONDecoder().decode([RankingEntry].self, from: data)
        return entries
    }
    
    /// 获取天梯榜
    func fetchLadder() async throws -> [LadderEntry] {
        let urlString = "\(baseURL)/rank/ladder.json"
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await session.data(from: url)
        let entries = try JSONDecoder().decode([LadderEntry].self, from: data)
        return entries
    }
    
    // MARK: - Submission APIs
    
    /// 提交代码（需要 GitHub API）
    func submitCode(challenge: Challenge, code: String, handle: String) async throws -> Submission {
        // 这里需要实现 GitHub API 提交逻辑
        // 1. Fork repository
        // 2. Create/Update file in submissions/handle/solution.c
        // 3. Create Pull Request
        
        // 临时模拟提交
        let byteCount = code.utf8.count
        let score = calculateScore(difficulty: challenge.difficulty, minBytes: 100, currentBytes: byteCount)
        
        return Submission(
            id: UUID(),
            challengeId: challenge.id,
            handle: handle,
            code: code,
            byteCount: byteCount,
            score: score,
            submittedAt: Date(),
            rank: nil
        )
    }
    
    // MARK: - Helper Methods
    
    private func calculateScore(difficulty: Int, minBytes: Int, currentBytes: Int) -> Int {
        if currentBytes == minBytes {
            return difficulty
        }
        return Int(round(Double(difficulty) * Double(minBytes) / Double(currentBytes)))
    }
}
