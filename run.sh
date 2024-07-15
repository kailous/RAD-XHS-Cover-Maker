#!/bin/bash

# 检查ImageMagick是否安装
if ! command -v convert &> /dev/null
then
    echo "ImageMagick 未安装，请安装后再运行此脚本。"
    exit 1
fi

# 检查是否提供了宽度参数
if [ -z "$1" ]; then
    echo "请提供输出文件的宽度。"
    exit 1
fi

# 获取宽度参数
output_width="$1"

# 定义图片文件名
logo_on="logo_on.png"
logo_off="logo_off.png"
img="img.png"
output1="01.png"
output2="02.png"
output3="03.png"
output_webp="output.webp"
output_zip="output.zip"

# 等比缩放素材文件
convert "$logo_on" -resize "${output_width}x" "resized_logo_on.png"
convert "$logo_off" -resize "${output_width}x" "resized_logo_off.png"
convert "$img" -resize "${output_width}x" "resized_img.png"
echo "将素材文件等比缩放至宽度 $output_width"

# 合并 resized_img.png 与 resized_logo_on.png 成为 01.png
convert "resized_img.png" "resized_logo_on.png" -gravity center -composite "$output1"
echo "合并 resized_img.png 和 resized_logo_on.png 成为 $output1"

# 合并 resized_img.png 与 resized_logo_off.png 成为 02.png
convert "resized_img.png" "resized_logo_off.png" -gravity center -composite "$output2"
echo "合并 resized_img.png 和 resized_logo_off.png 成为 $output2"

# 复制 02.png 为 03.png
cp "$output2" "$output3"
echo "复制 $output2 为 $output3"

# 生成 output.webp 动画
convert -delay 1x6000 "$output1" -delay 100x1 "$output2" -delay 100x1 "$output3" -loop 0 "$output_webp"
echo "生成 $output_webp 动画"

# 打包 output.webp 和 png 文件成 zip 文件
zip -j "$output_zip" "$output_webp" "$output1" "$output2" "$output3"
echo "打包 $output_webp 和 PNG 文件成 $output_zip"

# 删除临时文件和缩放后的 PNG 文件
rm -f "$output1" "$output2" "$output3" "resized_logo_on.png" "resized_logo_off.png" "resized_img.png"
echo "删除临时文件和缩放后的 PNG 文件"

echo "操作完成。"