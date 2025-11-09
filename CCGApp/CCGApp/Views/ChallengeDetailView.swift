//
//  ChallengeDetailView.swift
//  Challenge Detail with Code Editor
//
//  Created on 2025/11/9.
//

import SwiftUI

struct ChallengeDetailView: View {
    @StateObject private var viewModel: ChallengeDetailViewModel
    @State private var showingSubmitSheet = false
    @State private var userHandle = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(challenge: Challenge) {
        _viewModel = StateObject(wrappedValue: ChallengeDetailViewModel(challenge: challenge))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 题目信息
                ProblemInfoSection(challenge: viewModel.challenge)
                
                // 输入输出格式
                IOFormatSection(challenge: viewModel.challenge)
                
                // 样例
                ExamplesSection(examples: viewModel.challenge.examples)
                
                // 代码编辑器
                CodeEditorSection(
                    code: $viewModel.userCode,
                    byteCount: viewModel.byteCount,
                    estimatedScore: viewModel.estimatedScore
                )
                
                // 操作按钮
                ActionButtons(
                    isRunning: viewModel.isRunning,
                    onRun: {
                        Task {
                            await viewModel.runTests()
                        }
                    },
                    onSubmit: {
                        showingSubmitSheet = true
                    }
                )
                
                // 测试结果
                if !viewModel.testResults.isEmpty {
                    TestResultsSection(results: viewModel.testResults)
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.challenge.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingSubmitSheet) {
            SubmitSheet(
                handle: $userHandle,
                onSubmit: {
                    Task {
                        do {
                            try await viewModel.submitCode(handle: userHandle)
                            alertMessage = "提交成功！"
                            showingSubmitSheet = false
                            showingAlert = true
                        } catch {
                            alertMessage = error.localizedDescription
                            showingAlert = true
                        }
                    }
                }
            )
        }
        .alert("提示", isPresented: $showingAlert) {
            Button("确定", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
}

struct ProblemInfoSection: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("难度积分", systemImage: "star.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("D\(challenge.difficulty)")
                    .font(.headline)
                    .foregroundStyle(.blue)
            }
            
            Text(challenge.description)
                .font(.body)
                .foregroundStyle(.primary)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct IOFormatSection: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            FormatCard(title: "输入格式", content: challenge.inputFormat, icon: "arrow.down.circle.fill")
            FormatCard(title: "输出格式", content: challenge.outputFormat, icon: "arrow.up.circle.fill")
        }
    }
}

struct FormatCard: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundStyle(.blue)
            
            Text(content)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct ExamplesSection: View {
    let examples: [Challenge.Example]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("样例", systemImage: "doc.text.fill")
                .font(.headline)
                .foregroundStyle(.blue)
            
            ForEach(Array(examples.enumerated()), id: \.offset) { index, example in
                ExampleCard(number: index + 1, example: example)
            }
        }
    }
}

struct ExampleCard: View {
    let number: Int
    let example: Challenge.Example
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("样例 \(number)")
                .font(.subheadline)
                .bold()
            
            VStack(alignment: .leading, spacing: 4) {
                Text("输入:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(example.input)
                    .font(.system(.caption, design: .monospaced))
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 6))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("输出:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(example.output)
                    .font(.system(.caption, design: .monospaced))
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.green.opacity(0.1), in: RoundedRectangle(cornerRadius: 6))
            }
            
            if let explanation = example.explanation {
                Text(explanation)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct CodeEditorSection: View {
    @Binding var code: String
    let byteCount: Int
    let estimatedScore: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("代码编辑器", systemImage: "chevron.left.forwardslash.chevron.right")
                    .font(.headline)
                    .foregroundStyle(.blue)
                
                Spacer()
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.text")
                            .font(.caption)
                        Text("\(byteCount) 字节")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                        Text("\(estimatedScore) 分")
                            .font(.caption)
                    }
                    .foregroundStyle(.orange)
                }
            }
            
            // 简单的文本编辑器（实际应使用专业代码编辑器）
            TextEditor(text: $code)
                .font(.system(.body, design: .monospaced))
                .frame(minHeight: 200)
                .padding(8)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct ActionButtons: View {
    let isRunning: Bool
    let onRun: () -> Void
    let onSubmit: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onRun) {
                HStack {
                    if isRunning {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "play.fill")
                    }
                    Text("运行测试")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.gradient)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(isRunning)
            
            Button(action: onSubmit) {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text("提交")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.gradient)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

struct TestResultsSection: View {
    let results: [TestResult]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("测试结果", systemImage: "checkmark.circle.fill")
                .font(.headline)
                .foregroundStyle(.green)
            
            ForEach(results) { result in
                TestResultCard(result: result)
            }
        }
    }
}

struct TestResultCard: View {
    let result: TestResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: result.passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(result.passed ? .green : .red)
                Text(result.passed ? "通过" : "失败")
                    .font(.subheadline)
                    .bold()
            }
            
            if !result.passed {
                if let error = result.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct SubmitSheet: View {
    @Binding var handle: String
    let onSubmit: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("请输入昵称", text: $handle)
                } header: {
                    Text("提交信息")
                } footer: {
                    Text("提交将通过 GitHub Pull Request 完成")
                }
            }
            .navigationTitle("提交代码")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("提交") {
                        onSubmit()
                    }
                    .disabled(handle.isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChallengeDetailView(challenge: Challenge(
            id: 0,
            title: "打印菱形",
            description: "打印指定大小的菱形图案",
            difficulty: 150,
            inputFormat: "一个整数 n",
            outputFormat: "打印菱形",
            examples: [
                Challenge.Example(input: "3", output: "  *\n ***\n*****", explanation: nil)
            ],
            detailURL: "",
            rankingURL: ""
        ))
    }
}
