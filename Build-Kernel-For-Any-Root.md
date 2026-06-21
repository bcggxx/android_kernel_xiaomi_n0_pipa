# 🔧 为任意 Root 管理器构建内核

> 本教程将指导你如何通过 GitHub Actions 为 **NonGKI 设备** 构建带有任意 Root 管理器的内核。

---

## 📋 目录

- [第一步：Fork 仓库](#第一步fork-仓库)
- [第二步：选择 Root 管理器](#第二步选择-root-管理器)
- [第三步：使用预设的 Root 管理器](#第三步使用预设的-root-管理器)
- [第四步：使用未列出的 Root 管理器](#第四步使用未列出的-root-管理器)
- [第五步：提交更改](#第五步提交更改)
- [第六步：触发编译](#第六步触发编译)
- [第七步：下载内核](#第七步下载内核)

---

## 第一步：Fork 仓库

首先 Fork  [NonGKI_Kernel_Build_2nd](https://github.com/bcggxx/NonGKI_Kernel_Build_2nd) 仓库。

> ⚠️ **注意**：如果提示需要稍后才能完成 Fork，等待 10 秒左右刷新界面即可。

![Fork 后的界面示例](imgs/仓库.png)

---

## 第二步：选择 Root 管理器

### 2.1 进入 `.github/workflows`

点击仓库中的 `.github` 文件夹：

![进入 .github 文件夹](imgs/github文件夹.png)

进入 `workflows` 目录：

![进入 workflows 文件夹](imgs/workflows文件夹.png)

### 2.2 找到对应的工作流文件

往下滑，找到 `build-xiaomi-pad6-aosp-HOS-a15.yml` 或 `build-xiaomi-pad6-aosp-HOS-a16.yml`，这里以 **A15 版本** 演示：

![工作流文件列表](imgs/工作流文件.png)

### 2.3 编辑文件

点击铅笔图标（编辑文件）：

![点击编辑文件](imgs/编辑文件.png)

### 2.4 查找变量

按键盘上的 **Fn + F3** 打开查找，搜索 **`KERNELSU_AUTO_FORK`**：

![查找功能演示](imgs/标注.png)

![查找 KERNELSU_AUTO_FORK](imgs/查找.png)

---

## 第三步：使用预设的 Root 管理器

旁边的 `#` 注释标明了我们可以选择的管理器：

| 变量值 | 说明 |
|--------|------|
| `Rksu` | KernelSU 的 NonGKI 版本 |
| `NEXT` | KernelSU-NEXT |
| `ResukiSU` | **当前使用的版本**（推荐） |

> ⚠️ `magic` 作用不明，`rsuntk` 为 kernelsu 的 nongki 版本，`sukisu` 为 SukiSU Ultra，但该管理器已**不再支持 NonGKI 设备**。因此我们能选择的只有 **`Rksu`**、**`KernelSU-NEXT`** 和 **`ResukiSU`**。

![注释说明](imgs/注释.png)

将 `KERNELSU_AUTO_FORK` 的值修改为你想要的 Root 管理器，然后直接跳到 [第五步：提交更改](#第五步提交更改)。

---

## 第四步：使用未列出的 Root 管理器

如果你想使用这里没有列出来的管理器，需要修改 `KERNELSU_SOURCE` 和 `KERNELSU_BRANCH` 变量。

> ⚠️ **注意**：使用此方式时，需要将 `KERNELSU_AUTO_GET` 设置为 `false`。

![修改 KERNELSU_AUTO_GET](imgs/更改root为未列出的管理器.png)

### 4.1 获取 Raw 链接

先进入你选择的管理器仓库的 `kernel` 文件夹，这里以 **Rksu 的支持 SuSFS 的分支** 作为演示：

![Rksu-SuSFS 仓库](imgs/Rksu-SuSFS.png)

下滑找到 `setup.sh`：

![找到 setup.sh](imgs/setup.png)

点击文件，找到 **Raw** 按钮，右键复制链接地址：

![获取 Raw 链接](imgs/raw.png)

### 4.2 填写变量

将复制的 Raw 链接粘贴至 `KERNELSU_SOURCE` 的引号内。

### 4.3 确定分支名称

进入管理器仓库，查看当前使用的分支（一般 README.md 无特殊说明，仓库默认显示的分支即可）：

![查看分支](imgs/分支.png)

将分支名称填入 `KERNELSU_BRANCH`。

---

## 第五步：提交更改

编辑完成后，点击 **提交更改**：

![提交更改](imgs/提交更改.png)

在弹出的界面中，**选择直接提交到当前分支**，不要选择"创建 Pull Request"！

![直接提交](imgs/提交更改2.png)

✅ **大功告成！**

---

## 第六步：触发编译

### 6.1 进入 Actions

提交完成后回到仓库主页，点击 **Actions** 选项卡：

![进入 Actions](imgs/进入actions.png)

### 6.2 首次使用

如果首次进入 Actions，可能有一个介绍界面，点击绿色按钮了解工作流：

![查看更多](imgs/查看更多.png)

### 6.3 开始编译

点击工作流，然后点击 **Run workflow** 开始编译：

![准备编译](imgs/准备进行编译.png)

![开始编译](imgs/开始编译.png)

### 6.4 等待编译

进入编译界面，等待大约 **20 分钟** 后刷新页面即可：

![编译界面](imgs/界面.png)

---

## 第七步：下载内核

编译完成后，你会看到绿色的 ✅ 标志：

![编译完成](imgs/完成.png)

点击编译好的项目，下载到本地，然后自行刷入设备即可：

![下载内核](imgs/下载.png)

---

## 💡 提示

- 编译时间通常在 **20 分钟左右**，请耐心等待。
- 如果遇到编译失败，请检查变量配置是否正确。
- 如需更多帮助，请查看 [NonGKI_Kernel_Build_2nd Wiki](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd/wiki)。
- 也可以给这个项目提交issue,大概率我会帮你解决问题