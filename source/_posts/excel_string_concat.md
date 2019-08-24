---
title: Excel单元格内计算式及字符串拼接实现
categories:
  - 计算机外围技能储备
date: 2016-07-2 09:47:45
tags:
  - Excel
---

# 基本语法

* **&**
逻辑并，用以拼接字符串

* **=**
计算式求结果

* **" "**
其内部放入要显示的字符串


# 实现计算的方法

案例模拟：

![](http://upload-images.jianshu.io/upload_images/291600-535ed1aec7251251.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 定义名称

在Excel的菜单栏，插入->名称->定义...，在弹出框中进行设置：

![](http://upload-images.jianshu.io/upload_images/291600-2f03f60bbbfb5afc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 名称：
任意字符串皆可（注意不要和系统的变量重名，重名会有提示）

* 引用位置：
我们现在其中输入

```
=evaluate()
```

将鼠标的光标定位到括号中间，注意使用鼠标点击，而不是用键盘的方向键。

将鼠标移至单元格的位置，如下图，点击红色框框的位置：

![](http://upload-images.jianshu.io/upload_images/291600-7dad1935cc7f7006.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

选中计算式所在单元格的某一列，如下图所示：

![](http://upload-images.jianshu.io/upload_images/291600-bd7f0d27a3aace34.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

点击确定，完成名称的定义。

## 实现计算

![](http://upload-images.jianshu.io/upload_images/291600-5e5061b869706c16.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在我们要计算的单元格的同行的任意位置，输入：

```
=result
```

**result**是刚刚定义的名称的变量名，点击键盘的**enter键**，可以看到单元格中出现了计算结果。

![](http://upload-images.jianshu.io/upload_images/291600-0739462f7b1018a0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

基于此，将鼠标的放入单元格的右下角，待出现黑色`+`，点击鼠标左键，向下拉，接下来几行的计算结果都会自动显示出来。

![](http://upload-images.jianshu.io/upload_images/291600-3ad0aaf9fe71dcf7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

没有值的单元格会显示`#VALUE!`。

虽然目前单元格显示的是数值，但其实际是我们定义的名称，如果将定义的名称删掉，单元格便不再显示目前的数值，所以需要将这些单元格里的内容复制以后，进行**选择性粘贴**，这时候单元格内实际值才会变成了我们想要的值。

![](http://upload-images.jianshu.io/upload_images/291600-f91e06679f4e8208.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


案例模拟：

![](http://upload-images.jianshu.io/upload_images/291600-56882b5e3983ed44.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在合并字符串的单元格的同行找一个空单元格，输入：

```
=A1&B1
```

![](http://upload-images.jianshu.io/upload_images/291600-75ad01680c749aaf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](http://upload-images.jianshu.io/upload_images/291600-71d909b8f0166123.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**注意**：`A1``B1`是要合并的两个单元格的坐标，两者用&连接，如其中需要添加其他字符串可以这样：

```
=A1&"~"&B1
```

效果如下：

![](http://upload-images.jianshu.io/upload_images/291600-a760532e8bfd5577.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)