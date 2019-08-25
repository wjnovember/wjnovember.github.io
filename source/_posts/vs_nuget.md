---
title: Visual Studio 2017添加NuGet包管理器
categories:
  - 计算机外围技能储备
date: 2019-01-25 13:38:23
tags:
  - Visual Studio
---

# 背景叨叨叨

今天学习视频教程的时候发现，视频教程中的Visual Studio 2017菜单栏**工具**下有一个**NuGet包管理器**，但发现自己的VS 2017却没有。

![](https://upload-images.jianshu.io/upload_images/291600-832c087a62bdcebc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

本以为NuGet官网会提供离线下载的方式，后来发现NuGet已经被集成在了VS 2017里面。

![](https://upload-images.jianshu.io/upload_images/291600-91f31b5e3ae80b26.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

接下来了解一下VS 2017下载NuGet包管理器的方法。

# 开始说正经的了

打开VS 2017，在菜单栏**工具**选项下，找到**获取工具和功能**，如下图：

![](https://upload-images.jianshu.io/upload_images/291600-2b46eb9cb269e6f2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在弹出的面板中，选择Tab**工作负载**，勾选选项**Visual Studio扩展开发**：

![](https://upload-images.jianshu.io/upload_images/291600-0bfe04e5b5052626.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

然后选择Tab**单个组件**，勾选选项**NuGet包管理器**：

![](https://upload-images.jianshu.io/upload_images/291600-013b3c630c298541.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

点击右下角的**修改**按钮，等待下载安装完毕后，重启VS 2017即可在**工具**菜单下，找到**NuGet包管理器**了。
