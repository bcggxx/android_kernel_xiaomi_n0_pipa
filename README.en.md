# 🎯 android_kernel_xiaomi_n0_pipa

<p align="center">
  <strong>🌍 English</strong> &nbsp;|&nbsp; <a href="README.md"><strong>🇨🇳 简体中文</strong></a>
  <br>
  <sub><i>Click above to switch language · 点击上方链接切换语言</i></sub>
</p>

A non-GKI kernel build project based on the **Xiaomi SM8250** platform, integrating **KernelSU + SuSFS + ReKernel**.

[![Build Migration](https://img.shields.io/badge/Build-New%20Project-blue?style=flat-square)](https://github.com/bcggxx/NonGKI_Kernel_Build_2nd/)
[![ReSukiSU](https://img.shields.io/badge/KernelSU-ReSukiSU-red?style=flat-square)](https://github.com/ReSukiSU/ReSukiSU/)
[![SuSFS](https://img.shields.io/badge/root-SuSFS-orange?style=flat-square)](https://gitlab.com/simonpunk/susfs4ksu/)
[![ReKernel](https://img.shields.io/badge/Kernel-ReKernel-purple?style=flat-square)](https://github.com/Sakion-Team/Re-Kernel/)
[![CoolAPK](https://img.shields.io/badge/CoolAPK-View%20Post-green?style=flat-square)](https://www.coolapk.com/feed/72401325)
![Visitors](https://visitor-badge.laobi.icu/badge?page_id=bcggxx.android_kernel_xiaomi_n0_pipa&logo=github)

## 📑 Table of Contents

- [📦 Project Description](#project-description)
- [⚙️ ReKernel Usage Notes](#rekernel-usage-notes)
- [🚀 Quick Start](#quick-start)
  - [Building a Kernel Without Root](#building-a-kernel-without-root)
  - [Building a Kernel With Root](#building-a-kernel-with-root)
- [🙏 Acknowledgements](#acknowledgements)
- [🤖 About AI](#about-ai)
- [⭐ Star History](#star-history)

---

## 📦 Project Description

> [!NOTE]
> The kernel source in this repository will **forever remain free of any third-party integrations**.  
> Root-enabled builds have been migrated to the [NonGKI_Kernel_Build_2nd](https://github.com/bcggxx/NonGKI_Kernel_Build_2nd/) project for maintenance, which integrates the following components:

- [**ReSukiSU**](https://github.com/ReSukiSU/ReSukiSU/) — A more stable fork of SukiSU. SukiSU itself is a powerful kernel-level Root solution that makes no compromises on security; ReSukiSU further improves stability on top of that foundation.
- [**SuSFS**](https://gitlab.com/simonpunk/susfs4ksu/) — A root-hiding kernel patch and userspace module designed for KernelSU, effectively bypassing root detection by apps.
- [**ReKernel**](https://github.com/Sakion-Team/Re-Kernel/) — Committed to providing a smoother and more stable user experience, especially for users who freeze background apps.

## ⚙️ ReKernel Usage Notes

> [!IMPORTANT]
> When using ReKernel, you must **manually set the NetLink option to `22`** in advanced settings apps such as **NoActive** for it to take effect.

Once configured, ReKernel delivers a smoother and more stable experience, especially for apps frozen in the background.

## 🚀 Quick Start

> [!TIP]
> Just want a clean kernel? Fork this repo and run Actions.  
> Need Root? Fork the [NonGKI_Kernel_Build_2nd](https://github.com/bcggxx/NonGKI_Kernel_Build_2nd) repo and change the `KERNELSU_AUTO_FORK` variable to switch the KernelSU fork.

### Building a Kernel Without Root

To compile a kernel without Root, simply fork this repository and run it via Actions.

### Building a Kernel With Root

To build a kernel with Root, fork the [NonGKI_Kernel_Build_2nd](https://github.com/bcggxx/NonGKI_Kernel_Build_2nd) repository.  
Don't want to use ReSukiSU? After forking, simply change the `KERNELSU_AUTO_FORK` variable to your desired KernelSU fork, and SuSFS will already be pre-patched for you.

> 📖 **Detailed Guide**: See [Build a Kernel with Any Root Manager](https://github.com/bcggxx/android_kernel_xiaomi_n0_pipa/wiki/Build-Kernel-For-Any-Root.en) or [中文版本](https://github.com/bcggxx/android_kernel_xiaomi_n0_pipa/wiki/Build-Kernel-For-Any-Root).

## 🙏 Acknowledgements

Thanks to the following projects and individuals for their contributions:

- [CuriousNom / n0_kernel_pipa](https://github.com/CuriousNom/n0_kernel_pipa)
- [EmanuelCN / kernel_xiaomi_sm8250](https://github.com/EmanuelCN/kernel_xiaomi_sm8250)
- [JackA1ltman / NonGKI_Kernel_Build_2nd](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd)

## 🤖 About AI

Most of the content in this repository (only my commits) was written with reference to documentation from various experts and assisted by AI. Among them, JackA1ltman's [Wiki](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd/wiki) was the most heavily referenced.

---

## ⭐ Star History

If you find this project helpful, feel free to give it a star! 🌟

<a href="https://www.star-history.com/?repos=bcggxx%2Fandroid_kernel_xiaomi_n0_pipa&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=bcggxx/android_kernel_xiaomi_n0_pipa&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=bcggxx/android_kernel_xiaomi_n0_pipa&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=bcggxx/android_kernel_xiaomi_n0_pipa&type=date&legend=top-left" />
 </picture>
</a>