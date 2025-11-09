# CCG iOS App - C Code Golf 挑战 iOS 客户端

<div align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%2017.0+-blue.svg" alt="Platform">
  <img src="https://img.shields.io/badge/Language-Swift%205.9-orange.svg" alt="Language">
  <img src="https://img.shields.io/badge/UI-SwiftUI-green.svg" alt="UI Framework">
</div>

## 📱 项目简介

CCG iOS App 是 [C Code Golf 挑战平台](https://chenyuheee.github.io/c/competition) 的原生 iOS 客户端，为用户提供优雅、流畅的移动端代码高尔夫挑战体验。

## ✨ 核心功能

### 1. 挑战列表
- 🎨 美观的卡片式设计
- 🔍 实时搜索功能
- 🏆 难度分级展示
- ↻ 下拉刷新

### 2. 题目详情
- 📖 完整的题目描述
- 📥📤 输入输出格式说明
- 🎯 样例展示
- 💻 内置代码编辑器
- 📊 实时字节数统计
- ⭐ 预估积分计算

### 3. 代码编辑与测试
- ✏️ 等宽字体代码编辑器
- 📏 UTF-8 字节数自动统计
- ▶️ 本地测试运行
- ✅ 测试结果可视化

### 4. 排行榜
- 🏅 天梯榜总排名
- 📊 单题排行榜
- 👑 前三名领奖台展示
- 📈 积分与解题数统计

### 5. 个人中心
- 👤 用户信息管理
- 📊 个人统计数据
- 🔗 快速访问项目链接

## 🏗️ 技术架构

### 技术栈
- **语言**: Swift 5.9
- **UI 框架**: SwiftUI
- **最低版本**: iOS 17.0+
- **架构模式**: MVVM (Model-View-ViewModel)
- **网络请求**: URLSession + async/await
- **状态管理**: @StateObject, @Published (Combine)

### 项目结构

```
CCGApp/
├── CCGApp/
│   ├── CCGAppApp.swift          # App 入口
│   ├── ContentView.swift        # 主 TabView
│   │
│   ├── Models/                  # 数据模型层
│   │   └── Challenge.swift      # Challenge, Submission, Ranking 等模型
│   │
│   ├── ViewModels/              # 视图模型层
│   │   ├── ChallengeListViewModel.swift
│   │   ├── ChallengeDetailViewModel.swift
│   │   └── RankingViewModel.swift
│   │
│   ├── Views/                   # 视图层
│   │   ├── ChallengeListView.swift    # 挑战列表
│   │   ├── ChallengeDetailView.swift  # 题目详情
│   │   └── RankingView.swift          # 排行榜
│   │
│   ├── Services/                # 服务层
│   │   └── APIService.swift     # 网络 API 服务
│   │
│   ├── Assets.xcassets/         # 图片资源
│   └── Info.plist              # 应用配置
│
├── Package.swift               # Swift Package 配置
└── CCGApp.xcodeproj/          # Xcode 项目文件
```

## 🚀 快速开始

### 环境要求

- macOS 14.0+
- Xcode 15.0+
- iOS 17.0+ 设备或模拟器

### 安装步骤

1. **克隆项目**
```bash
git clone https://github.com/ChenyuHeee/CCG.git
cd CCG/CCGApp
```

2. **打开项目**
```bash
open CCGApp.xcodeproj
```

3. **安装依赖**

项目使用 Swift Package Manager 管理依赖，Xcode 会自动下载：
- [swift-markdown-ui](https://github.com/gonzalezreal/swift-markdown-ui) - Markdown 渲染
- [STTextView](https://github.com/krzyzanowskim/STTextView) - 代码编辑器（可选）

4. **运行项目**
- 选择目标设备或模拟器
- 按 `Cmd + R` 运行

## 🎨 UI 设计特点

### 美观控件使用

1. **NavigationStack** - 现代导航系统
2. **TabView** - 底部标签导航
3. **LazyVStack** - 性能优化的列表
4. **AsyncImage** - 异步图片加载
5. **Material** - 毛玻璃背景效果
6. **LinearGradient** - 渐变色装饰
7. **SF Symbols** - 系统图标库
8. **Charts** - 数据可视化（用于排名）

### 设计原则

- ✅ 遵循 Apple Human Interface Guidelines
- 🌓 支持深色/浅色模式自适应
- 🎭 流畅的动画过渡
- 📱 响应式布局设计
- ♿ 无障碍访问支持

## 🔌 API 集成

### 当前实现

应用目前包含模拟数据用于演示。实际 API 集成需要：

1. **题目数据**: 从 `problems.json` 获取
2. **排行榜数据**: 从 `rank/*.json` 获取
3. **提交功能**: 通过 GitHub API 实现 Fork & PR

### API 端点配置

在 `APIService.swift` 中配置：

```swift
private let baseURL = "https://chenyuheee.github.io/c/competition"
```

## 📝 待实现功能

### 高优先级
- [ ] 真实 API 数据对接
- [ ] GitHub OAuth 登录
- [ ] 自动化代码提交（Fork & PR）
- [ ] C 代码在线编译运行（WebAssembly 或服务端 API）
- [ ] 专业代码编辑器集成（语法高亮、自动补全）

### 中优先级
- [ ] 离线缓存功能
- [ ] 推送通知（新题目、排名变化）
- [ ] 代码分享功能
- [ ] 历史提交记录
- [ ] 主题自定义

### 低优先级
- [ ] iPad 适配
- [ ] Widget 小组件
- [ ] Apple Watch 扩展
- [ ] 国际化支持

## 🛠️ 开发指南

### 添加新功能

1. 在 `Models/` 中定义数据模型
2. 在 `Services/` 中实现 API 调用
3. 在 `ViewModels/` 中创建业务逻辑
4. 在 `Views/` 中实现 UI 界面

### 代码规范

- 使用 Swift 标准命名规范
- 添加必要的注释和文档
- 保持 MVVM 架构清晰分离
- 使用 SwiftUI 最佳实践

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](../LICENSE) 文件了解详情

## 👨‍💻 作者

**C. He from ZJU**

- 网站: [https://chenyuheee.github.io](https://chenyuheee.github.io)
- GitHub: [@ChenyuHeee](https://github.com/ChenyuHeee)

## 🙏 致谢

- [Swift Markdown UI](https://github.com/gonzalezreal/swift-markdown-ui) - Markdown 渲染库
- Apple SwiftUI 团队 - 优秀的 UI 框架
- C Code Golf 社区 - 题目和创意

---

<div align="center">
  Made with ❤️ and SwiftUI
</div>
