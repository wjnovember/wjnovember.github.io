---
title: 《Unity Shader入门精要》笔记（一）
categories:
  - TA不是他她它祂
date: 2021-11-07 16:29:58
tags:
  - Unity Shader
---

# 渲染流水线
**渲染流水线**的工作任务是：将三维场景里的物体投到屏幕上，生成一张二维图像。
可分为三个阶段：**应用阶段**、**几何阶段**、**光栅化阶段**。

![](UnityShadersBook01/img_01.png)

* **应用阶段**
CPU负责的阶段，应用主导，开发者有绝对的控制权，主要有三个任务：
  * 准备好场景数据
  * 不可见物体剔除，提高渲染性能
  * 设置好每个模型的渲染状态，如：材质、纹理、Shader等

  该阶段最重要的输出是**渲染图元**，如：点、线、三角面等，会被传递到下一个有GPU负责的阶段——几何阶段。

* **几何阶段**
GPU负责的阶段，与每个渲染图元打交道，将三维空间的顶点数据转换到屏幕空间中，再将转换后的数据交给下一个阶段——光栅化阶段处理。关键词：**逐顶点**。

* **光栅化阶段**
GPU负责的阶段，从上一阶段接过图元在屏幕空间的数据，差值计算后，决定图元里哪些像素会被绘制到屏幕中、被绘制成什么颜色。关键词：**逐像素**。

# CPU和GPU之间的通信
应用阶段的三个阶段：
* **把数据加载到显存**
数据加载到显存后，RAM的数据就可以移除了。但从硬盘加载到RAM过程十分耗时，CPU依然要访问数据，所以有些RAM中的数据不会马上移除。

![](UnityShadersBook01/img_02.png)

* **设置渲染状态**
这些状态定义了场景中的网格是怎么被渲染的。

![](UnityShadersBook01/img_03.png)

* **调用Draw Call**
Draw Call就是CPU发起命令，告诉GPU去执行一个渲染过程。一次DC（Draw Call）会指向本次调用需要渲染的图源列表。

# GPU流水线
GPU从CPU那里拿到顶点数据后，经过**几何阶段**和**光栅化阶段**将场景里的物体绘制到屏幕中。

![](UnityShadersBook01/img_04.png)

* **几何阶段**
  * 顶点着色器
完全可编程，实现顶点的空间变换、顶点着色等功能。
  * 曲面细分着色器
可选的着色器，用于细分图元。
  * 几何着色器
可选的着色器，执行逐图元的着色操作，或者生产更多的图元。
  * 裁剪
将不存在摄像机视野内的顶点裁掉，并剔除某些三角图元的面片；也可以通过指令控制裁剪三角图元的正面或背面。
  * 屏幕映射
不可配置、不可编程，负责把每个图元的坐标转换到屏幕坐标系中。
* **光栅化阶段**
  * 三角形设置
固定函数的阶段。
  * 三角形遍历
固定函数的阶段。
  * 片元着色器
完全可编程，实现逐片元的着色操作。
  * 逐片元操作
不可编程，但可配置性很高，负责执行很多重要操作，如：修改颜色、深度缓冲、进行混合等。

我们需要重点关注的是**顶点着色器（Vertex Shader）**和**片元着色器（Fragment Shader）**。

## 顶点着色器
顶点着色器需要完成工作主要有：**坐标转换**和**逐顶点光照**。

![](UnityShadersBook01/img_05.png)

坐标转换，将模型的顶点坐标从模型空间转换到其次裁剪空间。

![](UnityShadersBook01/img_06.png)

需要注意：
OpenGL中NDC的z分量范围是[-1, 1]
DirectX中NDC的z分量范围是[0, 1]

NDC，全称Normalized Device Coordinates，归一化的设备坐标。（后续会详细了解）

## 裁剪
一个图元和摄像机视野的关系有3种：
* 完全在视野范围内
不裁剪，直接进入下一流水线阶段。
* 部分在视野范围内
进行裁剪后，进入下一流水线阶段。
* 完全在视野范围外
被剔除，不会进入下一流水线阶段。

![](UnityShadersBook01/img_07.png)

## 屏幕映射
屏幕映射前，顶点的坐标仍然在三维坐标系下，屏幕映射的任务是将每个图元的x、y坐标转换到屏幕坐标系下。
屏幕坐标系和z坐标一起构成了**窗口坐标系**。

屏幕坐标系在OpenGL和DirectX之间的差异：

![](UnityShadersBook01/img_08.png)

## 三角形设置
光栅化的第一个流水线阶段。
光栅化两个最重要的目标：
* 计算每个图元（一般是三角形面片）覆盖了哪些像素
* 为这些像素计算颜色

三角形设置是一个计算三角形网格表示数据的过程，提供三角形边界的表示方式，为下阶段三角形遍历做准备。

## 三角形遍历
遍历判断每个像素是否被一个三角网格覆盖，若覆盖，则生成一个**片元（fragment）**，这个过程也叫扫描变换。片元的信息数据通过三个顶点差值得到。

## 片元着色器
DirectX中也被称为**像素着色器（Pixel Shader）**。
片元着色器的输入是顶点着色器的输出差值得到的结果，片元着色器的输出是一个或多个颜色值。

![](UnityShadersBook01/img_09.png)

## 逐片元操作
OpenGL里称为**逐片元操作**，DirectX中称为**输出合并阶段**。这个阶段有几个主要任务：
* 决定每个片元可见性，涉及：深度测试、模板测试等。
* 通过测试后的片元与颜色缓冲区的颜色进行合并/混合。

![](UnityShadersBook01/img_10.png)

深度测试、模板测试的简化流程图：

![](UnityShadersBook01/img_11.png)

* **模板测试**
高度可配置。
模板缓冲，和颜色缓冲、深度缓冲几乎是一类东西。即当前像素读取的参考值和模板缓冲中读取的参考值进行比较，满足条件则通过模板测试，条件规则由开发者指定。
不管模板测试有没有通过，我们都可以根据模板测试和深度测试的结果来修改模板缓冲区，操作修改可由开发者指定。

* **深度测试**
高度可配置。
与模板测试类似，将当前片元的深度值和深度缓冲区的深度值进行比较，比较函数可由开发者设置，通常这个比较函数是小于等于的关系，也就是显示距离相机更近的物体。
如果深度测试没有通过，它没有权利更改深度缓冲区中的值；如果通过了，开发者可以指定是否用这个片元的深度值盖掉缓冲区中的深度值——通过开启/关闭深度写入来控制。

![](UnityShadersBook01/img_12.png)

* **混合**
高度可配置。
开发者可选择开启/关闭混合模式，来控制是直接覆盖，还是将源颜色（当前片元的颜色）和目标颜色（颜色缓冲区的颜色）进行混合后写入颜色缓冲区。

有些GPU为了提高性能，将深度测试放到片元着色器之前处理，这种技术称为**Early-Z技术**。

经过上述流程，颜色缓冲区中的颜色值被显示到屏幕上，但是为了防止正在进行光栅化的图元被显示在屏幕上，GPU采取了 **双重缓冲（Double Buffering）** 的策略，所以对场景的渲染是发生在幕后的，即： **后置缓冲（Back Buffer）** 中。

# 什么是Shader
Shader本质就是运行在GPU流水线上的可高度编程的代码，主要有：**顶点着色器（Vertex Shader）**、**片元着色器（Fragment Shader）**，今后的开发学习中也主要是和这两个着色器打交道。