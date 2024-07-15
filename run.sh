#!/bin/bash

# 检查ImageMagick是否安装
if ! command -v convert &> /dev/null
then
    echo "ImageMagick 未安装，请安装后再运行此脚本。"
    exit 1
fi

# 获取宽度参数，默认为1200
output_width="${1:-1200}"

# 检查是否提供了图像文件名参数
if [ -z "$2" ]; then
    echo "请提供图像文件的名称。"
    exit 1
fi

# 获取图像文件名参数
img="$2"

# 创建隐藏的临时文件夹 .temp
mkdir -p .temp

# 定义图片文件名和URL
logo_on_url="https://raw.githubusercontent.com/kailous/RAD-XHS-Cover-Maker/main/logo_on.png"
logo_off_url="https://raw.githubusercontent.com/kailous/RAD-XHS-Cover-Maker/main/logo_off.png"

# 定义本地文件名
logo_on=".temp/logo_on.png"
logo_off=".temp/logo_off.png"
resized_logo_on=".temp/resized_logo_on.png"
resized_logo_off=".temp/resized_logo_off.png"
resized_img=".temp/resized_img.png"
output1=".temp/01.png"
output2=".temp/02.png"
output3=".temp/03.png"
output_webp="output.webp"
output_zip="output.zip"

# 下载图片文件
curl -o "$logo_on" "$logo_on_url"
curl -o "$logo_off" "$logo_off_url"

# 等比缩放素材文件
convert "$logo_on" -resize "${output_width}x" "$resized_logo_on"
convert "$logo_off" -resize "${output_width}x" "$resized_logo_off"
convert "$img" -resize "${output_width}x" "$resized_img"
echo "将素材文件等比缩放至宽度 $output_width"

# 合并 resized_img.png 与 resized_logo_on.png 成为 01.png
convert "$resized_img" "$resized_logo_on" -gravity center -composite "$output1"
echo "合并 $resized_img 和 $resized_logo_on 成为 $output1"

# 合并 resized_img.png 与 resized_logo_off.png 成为 02.png
convert "$resized_img" "$resized_logo_off" -gravity center -composite "$output2"
echo "合并 $resized_img 和 $resized_logo_off 成为 $output2"

# 复制 02.png 为 03.png
cp "$output2" "$output3"
echo "复制 $output2 为 $output3"

# 生成 output.webp 动画
convert -delay 1x6000 "$output1" -delay 100x1 "$output2" -delay 100x1 "$output3" -loop 0 "$output_webp"
echo "生成 $output_webp 动画"

# 打包 output.webp 和 png 文件成 zip 文件
zip -j "$output_zip" "$output_webp" "$output1" "$output2" "$output3"
echo "打包 $output_webp 和 PNG 文件成 $output_zip"

# 删除隐藏的临时文件夹 .temp
rm -rf .temp
echo "删除隐藏的临时文件夹 .temp"

echo "操作完成。"
