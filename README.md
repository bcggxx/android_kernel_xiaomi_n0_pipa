# 🎯 android_kernel_xiaomi_n0_pipa

<p align="center">
  <a href="README.en.md"><strong>🌍 English</strong></a> &nbsp;|&nbsp; <strong>🇨🇳 简体中文</strong>
  <br>
  <sub><i>点击上方链接切换语言 · Click above to switch language</i></sub>
</p>

基于 **Xiaomi SM8250** 平台的非 GKI 内核构建项目，集成 **KernelSU + SuSFS + ReKernel**。

[![编译迁移](https://img.shields.io/badge/编译-新项目-blue?style=flat-square)](https://github.com/bcggxx/NonGKI_Kernel_Build_2nd/)
[![ReSukiSU](https://img.shields.io/badge/KernelSU-ReSukiSU-red?style=flat-square)](https://github.com/ReSukiSU/ReSukiSU/)
[![SuSFS](https://img.shields.io/badge/HideRoot-SuSFS-orange?style=flat-square)](https://gitlab.com/simonpunk/susfs4ksu/)
[![ReKernel](https://img.shields.io/badge/内核-ReKernel-purple?style=flat-square)](https://github.com/Sakion-Team/Re-Kernel/)
[![酷安](https://img.shields.io/badge/酷安-查看帖子-green?style=flat-square)](https://www.coolapk.com/feed/72401325)
![Visitors](https://visitor-badge.laobi.icu/badge?page_id=bcggxx.android_kernel_xiaomi_n0_pipa&logo=github)

## 📑 目录

- [🏆 为什么选择我们](#为什么选择我们)
- [📦 项目说明](#项目说明)
- [⚙️ ReKernel 使用说明](#rekernel-使用说明)
- [🚀 快速开始](#快速开始)
  - [构建无 Root 内核](#构建无-root-内核)
  - [构建有 Root 内核](#构建有-root-内核)
- [🙏 致谢](#致谢)
- [🤖 关于 AI](#关于-ai)
- [⭐ Star History](#star-history)

---

## 🏆 为什么选择我们

- **开箱即用** — Fork 仓库即可通过 Actions 编译，零本地环境配置，小白也能出包
- **灵活切换** — SuSFS 预集成 + `KERNELSU_AUTO_FORK` 一键切换 KernelSU 分支，不被单一 Root 方案绑定
- **持续维护** — 项目持续跟进上游更新，ReSukiSU/SuSFS/ReKernel 版本同步
- **架构清晰** — 纯净内核与 Root 编译分离维护，各取所需互不干扰
- **稳定优先** — 采用 ReSukiSU（更稳定的 SukiSU 分支），在安全性与稳定性之间取得平衡
- **墓碑友好** — 集成 ReKernel，为冻结后台应用的用户提供更流畅的体验
- **文档完善** — 配有详细 Wiki 教程，新手也能快速上手
- **完全免费** — 开源免费，无任何商业绑定

## 📦 项目说明

> [!NOTE]
> 本仓库的**内核源代码始终保持纯净，不集成任何第三方组件**。  
> 带 Root 的编译版本已统一迁移至 [NonGKI_Kernel_Build_2nd](https://github.com/bcggxx/NonGKI_Kernel_Build_2nd/) 项目进行维护，该项目集成了以下组件：

- [**ReSukiSU**](https://github.com/ReSukiSU/ReSukiSU/) — 一个更加稳定的 SukiSU 分支。SukiSU 本身是强大的内核级 Root 权限方案，在安全性上毫不让步；ReSukiSU 则在此基础上进一步提升了稳定性。
- [**SuSFS**](https://gitlab.com/simonpunk/susfs4ksu/) — 面向 KernelSU 的 Root 隐藏内核补丁及用户空间模块，能够有效绕过应用对 Root 的检测。
- [**ReKernel**](https://github.com/Sakion-Team/Re-Kernel/) — 致力于为墓碑用户提供更流畅、更稳定的使用体验。

## ⚙️ ReKernel 使用说明

> [!IMPORTANT]
> 使用 ReKernel 时，需在 **NoActive 高级设置等类似软件** 中，**将 NetLink 选项手动设置为 `22`** 才能生效。

设置完成后，ReKernel 即可为后台墓碑应用提供更流畅、更稳定的体验。

## 🚀 快速开始

> [!TIP]
> 只想编译纯净内核？直接 Fork 本仓库并运行 Actions 即可。  
> 需要 Root 权限？请 Fork [NonGKI_Kernel_Build_2nd](https://github.com/bcggxx/NonGKI_Kernel_Build_2nd) 仓库，修改 `KERNELSU_AUTO_FORK` 变量即可切换 KernelSU 分支。

### 构建无 Root 内核

如需编译不带 Root 的内核，直接 Fork 本仓库，前往 Actions 运行即可。

### 构建有 Root 内核

如需构建带有 Root 的内核，请 Fork [NonGKI_Kernel_Build_2nd](https://github.com/bcggxx/NonGKI_Kernel_Build_2nd) 仓库。  
不想使用 ReSukiSU？Fork 后仅需将 `KERNELSU_AUTO_FORK` 变量修改为你想要的 KernelSU 分支即可，SuSFS 已为你预先 Patch 好。

> 📖 **详细教程**：请参阅 [为任意 Root 管理器构建内核](https://github.com/bcggxx/android_kernel_xiaomi_n0_pipa/wiki/Build-Kernel-For-Any-Root) 或 [English Version](https://github.com/bcggxx/android_kernel_xiaomi_n0_pipa/wiki/Build-Kernel-For-Any-Root.en)。

## 🙏 致谢

感谢以下项目与个人的贡献：

- [CuriousNom / n0_kernel_pipa](https://github.com/CuriousNom/n0_kernel_pipa)
- [EmanuelCN / kernel_xiaomi_sm8250](https://github.com/EmanuelCN/kernel_xiaomi_sm8250)
- [JackA1ltman / NonGKI_Kernel_Build_2nd](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd)

## 🤖 关于 AI

本仓库的大部分内容（仅我的提交）均参考了各大佬的文档，并使用 AI 辅助编写。其中文档参考较多的是 JackA1ltman 的 [Wiki](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd/wiki)。

---

## ⭐ Star History

如果你觉得这个项目对你有帮助，不妨给我点个 Star 吧！🌟

<a href="https://www.star-history.com/?repos=bcggxx%2Fandroid_kernel_xiaomi_n0_pipa&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=bcggxx/android_kernel_xiaomi_n0_pipa&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=bcggxx/android_kernel_xiaomi_n0_pipa&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=bcggxx/android_kernel_xiaomi_n0_pipa&type=date&legend=top-left" />
 </picture>
</a>
