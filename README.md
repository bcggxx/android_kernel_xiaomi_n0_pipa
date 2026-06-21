# 🎯 android_kernel_xiaomi_n0_pipa

<p align="center">
  <a href="README.en.md"><strong>🌍 English</strong></a> &nbsp;|&nbsp; <strong>🇨🇳 简体中文</strong>
  <br>
  <sub><i>点击上方链接切换语言 · Click above to switch language</i></sub>
</p>

基于 **Xiaomi SM8250** 平台的非 GKI 内核构建项目，集成 **KernelSU + SuSFS + ReKernel**。

[![编译迁移](https://img.shields.io/badge/编译-新项目-blue?style=flat-square)](https://github.com/bcggxx/NonGKI_Kernel_Build_2nd/)
[![ReSukiSU](https://img.shields.io/badge/KernelSU-ReSukiSU-red?style=flat-square)](https://github.com/ReSukiSU/ReSukiSU/)
[![SuSFS](https://img.shields.io/badge/root-SuSFS-green?style=flat-square)](https://gitlab.com/simonpunk/susfs4ksu/)
[![ReKernel](https://img.shields.io/badge/内核-ReKernel-purple?style=flat-square)](https://github.com/Sakion-Team/Re-Kernel/)
![Visitors](https://visitor-badge.laobi.icu/badge?page_id=bcggxx.android_kernel_xiaomi_n0_pipa&logo=github)

---

## 📦 项目说明

内核源代码仓库将**永远保持无任何东西集成**。

本仓库的 Root 版本编译已迁移至 [NonGKI_Kernel_Build_2nd](https://github.com/bcggxx/NonGKI_Kernel_Build_2nd/) 项目进行维护，集成了以下组件：

- [**ReSukiSU**](https://github.com/ReSukiSU/ReSukiSU/) — 一个更加稳定的 SukiSU 分支。SukiSU 本身是强大的内核级 Root 权限方案，在安全性上毫不让步；ReSukiSU 则在此基础上进一步提升了稳定性。
- [**SuSFS**](https://gitlab.com/simonpunk/susfs4ksu/) — 面向 KernelSU 的 Root 隐藏内核补丁及用户空间模块，能够有效绕过应用对 Root 的检测。
- [**ReKernel**](https://github.com/Sakion-Team/Re-Kernel/) — 致力于为墓碑用户提供更流畅、更稳定的使用体验。

## ⚙️ ReKernel 使用说明

使用 ReKernel 时，需要在 **NoActive 高级设置等类似软件** 中，**手动将 NetLink 选项设置为 `22`** 即可正常生效。

## 🚀 快速开始

### 构建无 Root 内核

如需编译不带 Root 的内核，直接 Fork 本仓库，前往 Actions 运行即可。

### 构建有 Root 内核

如需构建带有 Root 的内核，请 Fork [NonGKI_Kernel_Build_2nd](https://github.com/bcggxx/NonGKI_Kernel_Build_2nd) 仓库。  
不想使用 ReSukiSU？Fork 后仅需将 `KERNELSU_AUTO_FORK` 变量修改为你想要的 KernelSU 分支即可，SuSFS 已为你预先 Patch 好。

> 📖 **详细教程**：请参阅 [为任意 Root 管理器构建内核](./Build-Kernel-For-Any-Root.md) 或 [English Version](./Build-Kernel-For-Any-Root.en.md)。

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
