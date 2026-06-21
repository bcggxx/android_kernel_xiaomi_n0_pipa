# 🎯 n0_kernel_pipa

<p align="center">
  <strong>🌍 English</strong> &nbsp;|&nbsp; <a href="README.md"><strong>🇨🇳 简体中文</strong></a>
  <br>
  <sub><i>Click above to switch language · 点击上方链接切换语言</i></sub>
</p>

A non-GKI kernel build project based on the **Xiaomi SM8250** platform, integrating **KernelSU + SuSFS + ReKernel**.

[![Build Migration](https://img.shields.io/badge/Build-New%20Project-blue?style=flat-square)](https://github.com/bcggxx/NonGKI_Kernel_Build_2nd/)
[![ReSukiSU](https://img.shields.io/badge/KernelSU-ReSukiSU-red?style=flat-square)](https://github.com/ReSukiSU/ReSukiSU/)
[![SuSFS](https://img.shields.io/badge/root-SuSFS-green?style=flat-square)](https://gitlab.com/simonpunk/susfs4ksu/)
[![ReKernel](https://img.shields.io/badge/Kernel-ReKernel-purple?style=flat-square)](https://github.com/Sakion-Team/Re-Kernel/)
![Visitors](https://visitor-badge.laobi.icu/badge?page_id=bcggxx.n0_kernel_pipa&logo=github)

---

## 📦 Project Description

The kernel source repository will **forever remain free of any integrations**.

The Root version builds for this repository have been migrated to the [NonGKI_Kernel_Build_2nd](https://github.com/bcggxx/NonGKI_Kernel_Build_2nd/) project for maintenance, which integrates the following components:

- [**ReSukiSU**](https://github.com/ReSukiSU/ReSukiSU/) — A more stable fork of SukiSU. SukiSU itself is a powerful kernel-level Root solution that makes no compromises on security; ReSukiSU further improves stability on top of that foundation.
- [**SuSFS**](https://gitlab.com/simonpunk/susfs4ksu/) — A root-hiding kernel patch and userspace module designed for KernelSU, effectively bypassing root detection by apps.
- [**ReKernel**](https://github.com/Sakion-Team/Re-Kernel/) — Committed to providing a smoother and more stable user experience for tombstone users.

## ⚙️ ReKernel Usage Notes

When using ReKernel, you need to **manually set the NetLink option to `22`** in advanced settings apps such as **NoActive** for it to take effect properly.

## 🚀 Quick Start

### Building a Kernel Without Root

To compile a kernel without Root, simply fork this repository and run it via Actions.

### Building a Kernel With Root

To build a kernel with Root, fork the [NonGKI_Kernel_Build_2nd](https://github.com/bcggxx/NonGKI_Kernel_Build_2nd) repository.  
Don't want to use ReSukiSU? After forking, simply change the `KERNELSU_AUTO_FORK` variable to your desired KernelSU fork, and SuSFS will already be pre-patched for you.

> 📖 **Detailed Guide**: See [Build a Kernel with Any Root Manager](./Build-Kernel-For-Any-Root.en.md) or [中文版本](./Build-Kernel-For-Any-Root.md).

## 🙏 Acknowledgements

Thanks to the following projects and individuals for their contributions:

- [CuriousNom / n0_kernel_pipa](https://github.com/CuriousNom/n0_kernel_pipa)
- [EmanuelCN / kernel_xiaomi_sm8250](https://github.com/EmanuelCN/kernel_xiaomi_sm8250)
- [JackA1ltman / NonGKI_Kernel_Build_2nd](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd)

## 🤖 About AI

Most of the content in this repository (only my commits) was written with reference to documentation from various experts and assisted by AI. Among them, JackA1ltman's [Wiki](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd/wiki) was most heavily referenced.

---

## ⭐ Star History

If you find this project helpful, feel free to give it a star! 🌟

<a href="https://www.star-history.com/?repos=bcggxx%2Fn0_kernel_pipa&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=bcggxx/n0_kernel_pipa&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=bcggxx/n0_kernel_pipa&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/chart?repos=bcggxx/n0_kernel_pipa&type=date&legend=top-left" />
 </picture>
</a>