---
title: PS批处理，带你体验计算机的速度
date: 2018-07-23 13:31:43
tags:
---

# 背景叨叨叨

最近笔者在游戏项目中做技能模块的时候，用到外包给的一系列技能图标，但发现外包给到的图标分辨率、尺寸不一致。想到在校时，《软件设计与交互》课上有提到PS可以将一系列操作行为记录下来，从而实现批量编辑，便实践了一下，现将此过程下来，分享给读者们。

# 提前准备

为了方便操作，先将需要操作的图片放到一个文件夹下，如下图所示，考虑到项目保密，将这些图片打个码-_-||

![](https://upload-images.jianshu.io/upload_images/291600-b73efada927e1035.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

除了这些图片，还需要PS软件（Photoshop），任何版本皆可，读者们可自行上网下载。

# 新建动作

先用PS打开一张需要处理的图片，如下图所示：

![](https://upload-images.jianshu.io/upload_images/291600-e75997d338d61b86.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在菜单栏，单击**窗口**、**动作**，可以在历史记录的统计tab栏中找到动作页签，如下图所示：

![](https://upload-images.jianshu.io/upload_images/291600-30a7a8576be434bd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

点击**新建**图标，新建一个动作：

![](https://upload-images.jianshu.io/upload_images/291600-9ec607f33b81c3b1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在弹出的弹窗中输入名称，单击**记录**按钮，开始录制PS的操作：

![](https://upload-images.jianshu.io/upload_images/291600-78030149d6d36224.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在工作栏中看到**红色的小圆点**，表示录制开始：

![](https://upload-images.jianshu.io/upload_images/291600-45065bdecb3d2921.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

操作前先声明一下笔者的需求：

> 分辨率: **72像素/英寸**<br/>
> 图像像素大小： **156 * 156** （单位：像素）<br/>
> 画布像素大小： **160 * 160** （单位：像素）

调整一下图像的分辨率，按住快捷键`Ctrl` + `Alt` + `i`，弹出调整图像大小窗口，调整**分辨率**和**图像像素大小**：

![](https://upload-images.jianshu.io/upload_images/291600-b909cd970b5c6531.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**将分辨率大小调整为72**，可以看到原来像素为156 * 156的图片，像素变成了117 * 117，然后调整像素大小为**156 * 156**，单击**确定**按钮，完成调整。这时可以在动作工作栏中**动作1**的子菜单向看到**图像大小**，说明PS已经记录下图像大小调整的动作。

![](https://upload-images.jianshu.io/upload_images/291600-29caf1b1ab71d2e5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**调整画布大小至160 * 160**，按住快捷键`Ctrl` + `Alt` + `c`，弹出画布大小窗口：

![](https://upload-images.jianshu.io/upload_images/291600-06e2a882710bf9e6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

画布大小调整后，单击**确认**按钮，将图片保存到任意文件夹，如下图：

![](https://upload-images.jianshu.io/upload_images/291600-7305321c2a0c6e0a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

单击**保存**按钮。

这时一套完整的图像处理操作完成，在之前的动作工作栏中单击小方框，完成动作的录制。

![](https://upload-images.jianshu.io/upload_images/291600-a8afe469a26ce5d3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 批量处理

在PS的菜单栏中点击**文件**、**自动**、**批处理**，弹出批处理操作面板，按图中步骤可完成批处理操作。

![](https://upload-images.jianshu.io/upload_images/291600-5710948dfd2934c8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

操作步骤：

* 选择之前录制的动作——**动作1**
* 选择需要处理的图片来源，也就是存放图片的文件夹目录
* 选择导出路径
* 勾选**覆盖动作中“存储为”命令**
* 单机**确认**按钮

# 创建快捷批处理

为了方便后续进行同样的操作，可通过**创建快捷批处理**导出一个exe格式的可执行文件。在PS的菜单栏，单击**文件**、**自动**、**创建快捷批处理**：

![](https://upload-images.jianshu.io/upload_images/291600-d8466070452bdb2e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

操作步骤：

* 选择好导出路径
* 选择批处理的动作
* 选择处理后图片导出的位置
* 勾选**覆盖动作中“存储为”命令**
* 单击**确定**按钮

以上就是本教程的全部内容，感兴趣的读者欢迎在文章下方留言，一起交流PS技能的心得！