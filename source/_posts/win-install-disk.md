---
title: 一招搞定Windows无法安装到GPT分区形式磁盘疑难
categories:
  - 计算机外围技能储备
date: 2017-01-23 19:23:28
tags:
  - Windows
---

# 前情提要

![Windows无法安装到这个磁盘](http://upload-images.jianshu.io/upload_images/291600-f296635d92b4e4c3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/640)

今天给堂弟的电脑重装系统时，遇到了以往USB安装系统经常出现的问题，“**Windows无法安装到这个磁盘。选中的磁盘采用GPT分区形式**”。之前在CSDN的博客上有记录相关解决方法，但因CSDN博客打开繁琐，点击层级太多，因此转移至此，以作备份。

#  进入命令行

上述疑难是通过命令行对磁盘进行重新分区解决的，在执行命令之前，先在磁盘选择界面，按`shift`+`F10`进入命令行，出现命令行界面如下图。

![命令行](http://upload-images.jianshu.io/upload_images/291600-2d65e2ee67b8dee9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/640)

# 指令输入

在终端首先输入命令进入磁盘分区：

```
diskpart
```

在DISKPART中可使用磁盘操作命令，下面是具体的命令操作，注释已详细嵌入命令中，不作过多讲解了：

```
> list disk                                  // 显示所有磁盘  
> select disk x                              // 选择进入某一个磁盘，x一般为0, 1, 2...  
> clean                                      // 清楚当前所在磁盘的所有内容  
> convert mbr                                // 更改所选磁盘形式为MBR
> create partition primary size = 102400     // 创建容量为100G的主分区  
> active                                     // 激活主分区  
> format quick                               // 快速格式化该主分区，默认格式NTFS格式  
/*  
format quick                                 快速格式分区，默认格式为NTFS格式  
format fs = NTFS quick                       分区格式为NTFS，并快速格式化  
format fs = FAT32 quick                      分区格式为FAT32，并快速格式化  
*/  
  
> create partition extended                  // 创建逻辑分区  
> create partition logical size = 102400     //创建逻辑分区一，容量为100G  
> format quick                               // 快速格式化  
> create partition logical size = 102400     //创建逻辑分区二，容量为100G  
> format quick                               // 快速格式化  
> create partition logical                   // 创建逻辑分区三，容量为剩余空间  
> format quick                               // 快速格式化分区  
> exit                                       // 退出  
> exit                                       // 退出  
```

# 附加说明

上述指令中`create partition logical size = xxxx`可根据磁盘具体大小多次执行，格式化指令建议使用`format quick`，速度会比其他两者更快。