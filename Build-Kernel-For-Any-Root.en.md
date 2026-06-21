# 🔧 Build a Kernel with Any Root Manager

> This guide will walk you through building a kernel with any Root manager for **NonGKI devices** via GitHub Actions.

---

## 📋 Table of Contents

- [Step 1: Fork the Repository](#step-1-fork-the-repository)
- [Step 2: Choose a Root Manager](#step-2-choose-a-root-manager)
- [Step 3: Use a Preset Root Manager](#step-3-use-a-preset-root-manager)
- [Step 4: Use an Unlisted Root Manager](#step-4-use-an-unlisted-root-manager)
- [Step 5: Commit Changes](#step-5-commit-changes)
- [Step 6: Trigger the Build](#step-6-trigger-the-build)
- [Step 7: Download the Kernel](#step-7-download-the-kernel)

---

## Step 1: Fork the Repository

First, fork the [NonGKI_Kernel_Build_2nd](https://github.com/bcggxx/NonGKI_Kernel_Build_2nd) repository.

> ⚠️ **Note**: If GitHub prompts you to wait before forking, refresh the page after about 10 seconds.

![Forked repository example](imgs/仓库.png)

---

## Step 2: Choose a Root Manager

### 2.1 Navigate to `.github/workflows`

Click on the `.github` folder in the repository:

![Enter .github folder](imgs/github文件夹.png)

Then enter the `workflows` directory:

![Enter workflows folder](imgs/workflows文件夹.png)

### 2.2 Find the Workflow File

Scroll down and find `build-xiaomi-pad6-aosp-HOS-a15.yml` or `build-xiaomi-pad6-aosp-HOS-a16.yml`. This guide uses the **A15 version** as an example:

![Workflow file list](imgs/工作流文件.png)

### 2.3 Edit the File

Click the pencil icon (Edit file):

![Click edit file](imgs/编辑文件.png)

### 2.4 Search for the Variable

Press **Fn + F3** on your keyboard to open search, then look for **`KERNELSU_AUTO_FORK`**:

![Search feature demo](imgs/标注.png)

![Searching for KERNELSU_AUTO_FORK](imgs/查找.png)

---

## Step 3: Use a Preset Root Manager

The `#` comments next to the variable list the available Root managers:

| Value | Description |
|-------|-------------|
| `Rksu` | NonGKI version of KernelSU |
| `KernelSU-NEXT` | KernelSU-NEXT |
| `ResukiSU` | **Currently used version** (recommended) |

> ⚠️ `magic` has an unknown purpose, `rsuntk` is the NonGKI flavor of KernelSU, and `sukisu` refers to SukiSU Ultra, which **no longer supports NonGKI devices**. Therefore, only **`Rksu`**, **`KernelSU-NEXT`**, and **`ResukiSU`** are viable options.

![Comments annotation](imgs/注释.png)

Change the value of `KERNELSU_AUTO_FORK` to your desired Root manager, then skip ahead to [Step 5: Commit Changes](#step-5-commit-changes).

---

## Step 4: Use an Unlisted Root Manager

If you want to use a Root manager not listed above, you need to modify the `KERNELSU_SOURCE` and `KERNELSU_BRANCH` variables.

> ⚠️ **Note**: When using this method, you must set `KERNELSU_AUTO_GET` to `false`.

![Modify KERNELSU_AUTO_GET](imgs/更改root为未列出的管理器.png)

### 4.1 Get the Raw URL

Go to the `kernel` folder of your chosen manager repository. This example uses the **SuSFS-supported branch of Rksu**:

![Rksu-SuSFS repository](imgs/Rksu-SuSFS.png)

Scroll down and find `setup.sh`:

![Find setup.sh](imgs/setup.png)

Click on the file, then find the **Raw** button, right-click and copy the link address:

![Get Raw link](imgs/raw.png)

### 4.2 Fill in the Variables

Paste the copied Raw URL inside the quotes for `KERNELSU_SOURCE`.

### 4.3 Determine the Branch Name

Go to the manager repository and check the currently active branch (unless the README.md specifies otherwise, the default branch displayed in the repository is fine):

![Check branch](imgs/分支.png)

Write the branch name into `KERNELSU_BRANCH`.

---

## Step 5: Commit Changes

After editing, click **Commit changes**:

![Commit changes](imgs/提交更改.png)

In the popup, **choose to commit directly to the current branch** — do NOT select "Create Pull Request"!

![Commit directly](imgs/提交更改2.png)

✅ **Done!**

---

## Step 6: Trigger the Build

### 6.1 Go to Actions

After committing, return to the repository homepage and click the **Actions** tab:

![Enter Actions](imgs/进入actions.png)

### 6.2 First-time Use

If this is your first time entering Actions, you may see an introduction screen. Click the green button to proceed:

![View workflows](imgs/查看更多.png)

### 6.3 Start the Build

Click on the workflow, then click **Run workflow** to start the build:

![Prepare to build](imgs/准备进行编译.png)

![Start building](imgs/开始编译.png)

### 6.4 Wait for the Build

You will be taken to the build interface. Wait approximately **20 minutes**, then refresh the page:

![Build interface](imgs/界面.png)

---

## Step 7: Download the Kernel

Once the build is complete, you will see a green ✅ indicator:

![Build complete](imgs/完成.png)

Click on the completed build item, download it to your local machine, and flash it onto your device:

![Download kernel](imgs/下载.png)

---

## 💡 Tips

- The build typically takes about **20 minutes** — please be patient.
- If the build fails, double-check that all variables are configured correctly.
- For further assistance, check the [NonGKI_Kernel_Build_2nd Wiki](https://github.com/JackA1ltman/NonGKI_Kernel_Build_2nd/wiki).
