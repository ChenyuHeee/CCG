# CCG iOS 开发快速指南

## 🎯 项目概述

这是一个为 C Code Golf 挑战平台开发的 iOS 原生应用，使用 SwiftUI 构建。

## 📋 开发环境配置

### 必需工具
- **macOS**: 14.0 或更高版本
- **Xcode**: 15.0 或更高版本
- **iOS SDK**: 17.0+

### 首次运行

1. 在 Xcode 中打开 `CCGApp.xcodeproj`
2. 等待 Swift Package Manager 自动下载依赖
3. 选择模拟器或真机
4. 点击运行按钮或按 `Cmd + R`

## 🏗️ 项目架构详解

### MVVM 模式

```
View (SwiftUI Views)
  ↓
ViewModel (Business Logic)
  ↓
Model (Data Structures)
  ↓
Service (API Calls)
```

### 数据流

1. **View** 显示 UI 并响应用户交互
2. **ViewModel** 处理业务逻辑，更新 `@Published` 属性
3. **View** 通过 `@StateObject` 或 `@ObservedObject` 监听变化
4. **Service** 负责网络请求和数据获取

## 🔧 关键技术点

### 1. SwiftUI 状态管理

```swift
@StateObject     // 创建并持有 ViewModel
@ObservedObject  // 观察外部传入的 ViewModel
@Published       // 在 ViewModel 中标记可观察属性
@State           // 视图内部状态
@Binding         // 双向绑定
@AppStorage      // UserDefaults 存储
```

### 2. 异步编程

使用 Swift 5.5+ 的 async/await:

```swift
Task {
    await viewModel.loadData()
}
```

### 3. 网络请求

```swift
let (data, response) = try await URLSession.shared.data(from: url)
```

## 📱 主要页面说明

### ChallengeListView
- 显示所有挑战题目
- 搜索过滤功能
- 下拉刷新
- 导航到详情页

### ChallengeDetailView
- 显示题目详情
- 代码编辑器
- 运行测试
- 提交代码

### RankingView
- 天梯榜展示
- 单题排行榜
- 前三名领奖台

### ProfileView
- 用户信息
- 统计数据
- 设置入口

## 🎨 UI 组件库

### 自定义组件

- **ChallengeCard**: 题目卡片
- **DifficultyBadge**: 难度徽章
- **PodiumCard**: 领奖台卡片
- **TestResultCard**: 测试结果卡片

### 设计原则

1. 使用 `.ultraThinMaterial` 实现毛玻璃效果
2. 使用 `LinearGradient` 添加渐变背景
3. 统一使用 12-16pt 圆角
4. 阴影使用 `.shadow(color:radius:x:y:)`

## 🔌 API 集成指南

### 当前状态
项目包含模拟数据，真实 API 需要实现。

### 实现步骤

1. **修改 APIService.swift**
   - 实现真实的网络请求
   - 添加错误处理
   - 实现数据解析

2. **题目数据获取**
```swift
func fetchChallenges() async throws -> [Challenge] {
    // 从 problems.json 获取
}
```

3. **排行榜数据**
```swift
func fetchRanking(problemId: Int) async throws -> [RankingEntry] {
    // 从 rank/week.json 获取
}
```

4. **提交功能**
   - 需要实现 GitHub OAuth
   - Fork 仓库
   - 创建/更新文件
   - 创建 Pull Request

## 🚧 待实现功能

### Phase 1: 基础功能完善
- [ ] 连接真实 API
- [ ] 实现 HTML 到 Markdown 解析
- [ ] 改进代码编辑器（语法高亮）
- [ ] 实现本地测试逻辑

### Phase 2: 提交功能
- [ ] GitHub OAuth 登录
- [ ] 自动化 Fork 和 PR
- [ ] 提交历史记录

### Phase 3: 增强功能
- [ ] 离线模式
- [ ] 推送通知
- [ ] 代码片段分享
- [ ] 深色模式优化

## 🐛 调试技巧

### 常见问题

1. **编译错误**: 确保安装了所有依赖
2. **网络错误**: 检查 API 端点配置
3. **UI 不更新**: 确保使用 `@Published` 和 `@MainActor`

### 调试工具

- **Xcode Debugger**: 断点调试
- **Instruments**: 性能分析
- **Console**: 查看日志输出
- **SwiftUI Preview**: 实时 UI 预览

## 📚 学习资源

- [SwiftUI 官方文档](https://developer.apple.com/documentation/swiftui/)
- [Swift 官方文档](https://docs.swift.org)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [WWDC Sessions](https://developer.apple.com/videos/)

## 💡 最佳实践

1. **代码组织**: 保持文件职责单一
2. **命名规范**: 使用清晰的命名
3. **注释**: 为复杂逻辑添加注释
4. **错误处理**: 使用 Result 或 throws
5. **性能**: 使用 LazyVStack 优化列表
6. **可访问性**: 添加 accessibility 标签

## 🤝 贡献代码

1. 创建功能分支
2. 遵循现有代码风格
3. 添加必要的注释
4. 测试新功能
5. 提交 Pull Request

## 📞 获取帮助

- 查看项目 README
- 搜索现有 Issues
- 创建新 Issue 描述问题
- 联系项目维护者

---

Happy Coding! 🎉
