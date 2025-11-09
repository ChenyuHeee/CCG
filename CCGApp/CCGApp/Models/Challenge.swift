//
//  Challenge.swift
//  Data Models for Code Golf Challenges
//
//  Created on 2025/11/9.
//

import Foundation

/// 代码挑战题目
struct Challenge: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let description: String
    let difficulty: Int  // D value for scoring
    let inputFormat: String
    let outputFormat: String
    let examples: [Example]
    let detailURL: String
    let rankingURL: String
    
    struct Example: Codable, Hashable {
        let input: String
        let output: String
        let explanation: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, difficulty
        case inputFormat = "input_format"
        case outputFormat = "output_format"
        case examples
        case detailURL = "detail_url"
        case rankingURL = "ranking_url"
    }
}

/// 提交记录
struct Submission: Identifiable, Codable {
    let id: UUID
    let challengeId: Int
    let handle: String  // 昵称
    let code: String
    let byteCount: Int
    let score: Int
    let submittedAt: Date
    let rank: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case challengeId = "challenge_id"
        case handle, code
        case byteCount = "byte_count"
        case score
        case submittedAt = "submitted_at"
        case rank
    }
}

/// 排行榜条目
struct RankingEntry: Identifiable, Codable {
    let id: String
    let handle: String
    let byteCount: Int
    let score: Int
    let rank: Int
    let submittedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, handle
        case byteCount = "byte_count"
        case score, rank
        case submittedAt = "submitted_at"
    }
}

/// 天梯榜条目
struct LadderEntry: Identifiable, Codable {
    let id: String
    let handle: String
    let totalScore: Int
    let rank: Int
    let solvedCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, handle
        case totalScore = "total_score"
        case rank
        case solvedCount = "solved_count"
    }
}

/// 测试结果
struct TestResult: Identifiable {
    let id = UUID()
    let passed: Bool
    let input: String
    let expectedOutput: String
    let actualOutput: String
    let errorMessage: String?
}
