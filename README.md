# KidAppLimiter iOS / 轻用

KidAppLimiter 是一个开源 iOS 家长控制项目，基于 Apple Screen Time、Family Controls 和 Managed Settings 框架构建。

它的目标很简单：让家长可以在孩子设备上选择需要管理的 App、网站或类别，并在需要时一键启用系统级屏蔽，帮助孩子减少短视频、游戏、社交媒体等娱乐应用带来的打扰。

本项目不会读取孩子的聊天内容、浏览记录、定位、截图或屏幕内容，也不会上传孩子的使用数据。被管理的 App 和网站由 Apple 的系统选择器处理，并以隐私保护令牌的方式保存在本地设备上。

需要说明的是，iOS 目前没有公开 API 可以让普通 App 精确降低其他 App 的网速。因此，本项目不承诺“按 App 降速”，而是在 Apple 官方能力范围内提供 App / 网站 / 类别的选择、屏蔽和恢复功能。

## 项目初衷

我原本想把它做成一个收费工具，但后来觉得，能帮助一些家长和孩子少一点沉迷、多一点主动选择，本身也挺有意义。

所以这个项目开源出来，给需要的人参考、使用和继续完善。如果你也在关心孩子的手机使用、短视频沉迷、游戏时间管理，欢迎一起改进它。

## English Introduction

KidAppLimiter is an open-source iOS parental control project built with Apple's Screen Time, Family Controls, and Managed Settings frameworks.

It helps parents or guardians select apps, websites, or activity categories on a child device, then temporarily shield them through Apple's system-level controls. The goal is to reduce distractions from short videos, games, social media, and other entertainment apps while keeping the implementation transparent and privacy-conscious.

The app does not read messages, browsing history, location, screenshots, screen recordings, or on-screen content. It does not upload a child's usage data. Selected apps and websites are handled by Apple's system picker and stored locally as privacy-preserving tokens.

Please note that iOS does not provide a public API for ordinary apps to precisely throttle network speed for other apps. This project does not claim to slow down individual apps; it focuses on selecting, shielding, and restoring apps, websites, and categories using official Apple APIs.

## 首版功能

- 请求 Family Controls 授权。
- 使用系统 FamilyActivityPicker 选择要管理的 App、网站或类别。
- 一键启用屏蔽。
- 一键恢复全部。
- 本地保存选择，不上传孩子的使用数据。

## 交给 iOS 开发者的步骤

1. 在 Mac 上安装 Xcode 16 或更新版本。
2. 安装 XcodeGen：`brew install xcodegen`。
3. 进入本目录，运行：`xcodegen generate`。
4. 打开 `KidAppLimiter.xcodeproj`。
5. 把 `project.yml` 里的 `PRODUCT_BUNDLE_IDENTIFIER` 改成正式 bundle id。
6. 在 Apple Developer 后台给 App ID 申请并启用 Family Controls。
7. 在 Xcode 里选择团队账号，使用真机测试。Screen Time API 不适合只靠模拟器验证。
8. 通过 Archive 打包，上传 TestFlight。

## 上架前必须处理

- 替换 App 名称、图标、隐私政策链接。
- 申请 Family Controls 分发权限。
- 文案里使用“屏蔽/限制/管理”，不要写“降低到 3G”或“给任意 App 限速”。
- 明确说明：家长授权后，系统会阻止孩子绕过限制；App 不读取短视频内容，不采集聊天、浏览记录或定位。

## 目录

- `Sources/KidAppLimiter`: iOS App 源码。
- `Docs/AppStoreNotes.md`: 上架和审核说明。
- `Docs/FamilyControlsEntitlement.md`: Family Controls 权限申请话术。
