//
//  ChallengeDetailViewModel.swift
//  ViewModel for Challenge Detail
//
//  Created on 2025/11/9.
//

import Foundation
import Combine

@MainActor
class ChallengeDetailViewModel: ObservableObject {
    @Published var challenge: Challenge
    @Published var userCode: String = ""
    @Published var testResults: [TestResult] = []
    @Published var isRunning = false
    @Published var byteCount: Int = 0
    @Published var estimatedScore: Int = 0
    
    private let apiService = APIService.shared
    
    init(challenge: Challenge) {
        self.challenge = challenge
        updateByteCount()
    }
    
    func updateCode(_ code: String) {
        userCode = code
        updateByteCount()
    }
    
    private func updateByteCount() {
        byteCount = userCode.utf8.count
        // 假设最小字节数为100（实际需要从API获取）
        let minBytes = 100
        estimatedScore = calculateScore(minBytes: minBytes)
    }
    
    private func calculateScore(minBytes: Int) -> Int {
        guard byteCount > 0 else { return 0 }
        if byteCount == minBytes {
            return challenge.difficulty
        }
        return Int(round(Double(challenge.difficulty) * Double(minBytes) / Double(byteCount)))
    }
    
    func runTests() async {
        isRunning = true
        testResults = []
        
        // 模拟测试运行
        await Task.sleep(1_000_000_000) // 1秒
        
        // 这里需要实现实际的C代码编译和运行逻辑
        // 可以使用 WebAssembly 或调用服务器API
        
        for example in challenge.examples {
            let result = TestResult(
                passed: true,
                input: example.input,
                expectedOutput: example.output,
                actualOutput: example.output,
                errorMessage: nil
            )
            testResults.append(result)
        }
        
        isRunning = false
    }
    
    func submitCode(handle: String) async throws {
        guard !handle.isEmpty else {
            throw NSError(domain: "CCGApp", code: 1, userInfo: [NSLocalizedDescriptionKey: "请输入昵称"])
        }
        
        guard !userCode.isEmpty else {
            throw NSError(domain: "CCGApp", code: 2, userInfo: [NSLocalizedDescriptionKey: "请输入代码"])
        }
        
        _ = try await apiService.submitCode(challenge: challenge, code: userCode, handle: handle)
    }
}
