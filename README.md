
# RAD-XHS-Cover-Maker

## 概述

`RAD-XHS-Cover-Maker` 是一个用于在 macOS 上自动合成和处理图片的 Automator 脚本。该脚本帮助 RAD 团队创建小红书动态封面，并通过 `ImageMagick` 进行图片合成。

## 下载

您可以从以下链接下载 Automator 脚本：

[Automator.zip](https://raw.githubusercontent.com/kailous/RAD-XHS-Cover-Maker/main/Automator.zip)

## 安装

### 1. 解压缩文件

下载并解压缩 `Automator.zip` 文件。您将获得一个 `.workflow` 文件，这是 Automator 脚本。

### 2. 双击安装脚本

双击 `.workflow` 文件，以安装自动化脚本。

## 使用

### 1. 准备工作

确保您的系统上已安装 `ImageMagick`。您可以通过以下命令检查 `ImageMagick` 是否已安装：

```sh
convert -version
```

如果未安装，可以使用 `Homebrew` 安装 `ImageMagick`：

```sh
brew install imagemagick
```

### 2. 运行 Automator 工作流程

1. 在需要生成封面的图片上右键选择 `快速操作`。
2. 选择 `小红书封面` 并点击运行。
3. 等待完成后得到 `output.webp` 封面文件和压缩包。
4. 分享封面文件时请使用压缩包，以防动画失效。

### 3. 检查日志文件

为了调试和查看详细信息，脚本的输出将记录到日志文件中。日志文件位于您的主目录下：

```sh
~/automator_script.log
```

您可以在终端中运行以下命令查看日志文件内容：

```sh
cat ~/automator_script.log
```

## 脚本说明

该 Automator 脚本会自动执行以下操作：

1. 检测 `ImageMagick` 的绝对路径并设置环境变量。
2. 获取所选文件的路径和目录。
3. 下载并执行远程脚本进行图片处理。
4. 将所有输出记录到日志文件中。

### 示例脚本内容

以下是 Automator 脚本的内容示例：

```sh
#!/bin/bash

# 日志文件
LOGFILE="$HOME/automator_script.log"

# 检测 convert 命令的绝对路径
IMAGEMAGICK_PATH=$(command -v convert)

# 提取目录路径
IMAGEMAGICK_DIR=$(dirname "$IMAGEMAGICK_PATH")

# 设置 PATH 环境变量
export PATH=$IMAGEMAGICK_DIR:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin

# 获取文件的目录
file_dir=$(dirname "$1")
file_path="$1"

# 设置变量
output_width="$2"
run=https://raw.githubusercontent.com/kailous/RAD-XHS-Cover-Maker/main/run.sh

# 打印信息以供调试
{
  echo "文件路径: $file_path"
  echo "文件目录: $file_dir"
  echo "输出宽度: $output_width"
  echo "ImageMagick 路径: $IMAGEMAGICK_PATH"
  echo "当前 PATH: $PATH"
} >> "$LOGFILE" 2>&1

# 切换到文件的目录
cd "$file_dir" || { echo "无法切换到目录 $file_dir" >> "$LOGFILE" 2>&1; exit 1; }

# 运行远程脚本
{
  bash <(curl -s $run) "$output_width" "$(basename "$file_path")"
} >> "$LOGFILE" 2>&1

# 打印执行结果
if [ $? -eq 0 ]; then
  echo "脚本执行成功。" >> "$LOGFILE" 2>&1
else
  echo "脚本执行失败。" >> "$LOGFILE" 2>&1
fi
```

## 问题反馈

如果您在使用过程中遇到任何问题或有任何建议，请在 GitHub 上提交 issue。

---

通过这些步骤，您应该能够成功下载、安装和使用 `RAD-XHS-Cover-Maker` Automator 脚本，帮助 RAD 团队创建小红书动态封面。如果有其他问题或需要进一步调整，请随时告诉我。
