---
title: 未来布局之星——ConstraintLayout
date: 2017-03-10 17:27:50
tags:
- Android开发
categories:
- Android开发从入门到炸机
---

# 知识背景

> 名称：**ConstraintLayout**<br/>
出身：Android Studio 2.2新增功能<br/>
成就：2016年Google I/O大会黑马奖；可视化Android界面编写领军角色<br/>
关键词：约束

ConstraintLayout是Android Studio 2.2中具有亮点的新功能之一，相比于RelativeLayout、LinearLayout等传统布局，它打破了开发者使用XML编写布局的依赖。

虽然传统布局也可以使用可视化界面拖动控件来搭建布局，但是因为不够灵活，大多数开发者还是会选择通过XML代码来搭建布局。而ConstraintLayout的出现将开发者带入可视化布局编程的新纪元，通过建立控件之间的**约束**，实现布局的构建。这样做有一个很大的优点，就是减少了布局的嵌套，减少了布局渲染的层数，降低了CPU的消耗，提高了程序的性能。

ConstraintLayout与RelativeLayout相似，都是通过建立控件与控件之间的位置关系来搭建布局，但是ConstraintLayout远远比RelativeLayout强大很多，接下来看一下ConstraintLayout的使用。

# 建立依赖

ConstraintLayout布局是Android Studio 2.2的新增功能，所以在建立依赖前需要将Android Studio更新至2.2版本或以上。

在app/build.gradle文件中添加依赖，如下：

```
dependencies {
    compile 'com.android.support.constraint:constraint-layout:1.0.0-beta4'
}
```

# 修改布局为ConstraintLayout

打开AndroidStudio，新建一个工程，找到布局文件activity_main.xml，打开让其以`Design`方式显示，如下图所示。界面中央有两块区域，左边是预览界面，右边的蓝色区域是控件拖动操作界面。

![可视化布局搭建](http://upload-images.jianshu.io/upload_images/291600-52790b337eb601cd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

默认创建的activity_main文件的根布局是一个RelativeLayout，接下来将RelativeLayout布局改为ConstraintLayout布局，找到`Component Tree`，在其下方右键单击activity_main(RelativeLayout)，在弹出的列表中选择`Convert RelativeLayout to ConstraintLayout`，如下图所示：

![将布局修改为ConstraintLayout](http://upload-images.jianshu.io/upload_images/291600-1b3c556027b97153.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

# 删除一个控件

完成转换后，可以在`Component Tree`下方看到ConstraintLayout里面有原来存在的TextView控件，如果不需要，可以在蓝色区域选中TextView控件，单击键盘`delete`按钮删除该控件。

# 切换视图

点击菜单栏的中的`Show Design`、`Show Blueprint`和`Show Design + Blueprint`按钮可以对操作视图进行切换，如下图所示：

![切换视图](http://upload-images.jianshu.io/upload_images/291600-bef33c37ccb1d63f.gif?imageMogr2/auto-orient/strip)

# 添加约束

百闻不如一见，先来看看添加约束的操作，如下图所示：

![添加约束演示]([图片上传中...(image.png-6f063-1562484811740-0)]
)

可以看到，按钮控件有四个方向的约束，如下图所示，按钮的**上、下、左、右**边上各有一个小圆圈，鼠标可拖动小圆圈到ConstraintLayout，与其添加约束。

![Button控件约束](http://upload-images.jianshu.io/upload_images/291600-85ab8f622faca3a7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如将按钮下边圆圈拖至ConstraintLayout底部，则按钮移动至底部；再将按钮上边圆圈拖动至ConstraintLayout顶部，垂直方向上有两个约束的按钮控件就会实现垂直居中。

![添加约束](http://upload-images.jianshu.io/upload_images/291600-4de51c14488859f3.gif?imageMogr2/auto-orient/strip)

# 约束位置比例调整

当然如果ConstraintLayout添加约束仅仅能实现水平、垂直居中，那么它在功能上与RelativeLayout就没有差别了。除了居中，约束还可以设置控件两边到边界之间的距离比例，通过在右侧属性面板中，拖动水平和垂直方向的进度条来调整两边距离的比例。

![调整约束位置比例](http://upload-images.jianshu.io/upload_images/291600-5d4d3177e87d6c22.gif?imageMogr2/auto-orient/strip)

# 控件之间添加约束

除了与ConstraintLayout添加约束，控件与控件之间同样可以添加约束。如下图所示，在调整按钮宽度后，将两个按钮的左右两边添加约束，然后将下方按钮的上边与上方按钮的下边添加约束，拖动下方的按钮，可设置两个按钮之间的外边距。

![控件之间添加约束](http://upload-images.jianshu.io/upload_images/291600-e814c547622d896e.gif?imageMogr2/auto-orient/strip)

通过控件之间添加约束和调整约束距离比例，开发者可实现较为复杂的约束。

![多控件约束](http://upload-images.jianshu.io/upload_images/291600-506a4d7ea3a560b2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![较为复杂的约束](http://upload-images.jianshu.io/upload_images/291600-02e85c6fcedd4a17.gif?imageMogr2/auto-orient/strip)

# 调整控件外边距及尺寸

细心的读者们或许会发现，在调整控件位置比例的时候，当进度条滑动至100时，控件未能完全贴上布局的右边界，这是因为控件存在外边距。

![调整控件外边距](http://upload-images.jianshu.io/upload_images/291600-6b0c81f425c3360f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

这时候可以修改属性面板中的数值来调整控件的外边距大小，如下图所示：

![修改控件外边距](http://upload-images.jianshu.io/upload_images/291600-c32ddd5ce43f0ed1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在控件尺寸调整上，ConstraintLayout提供了三种模式，在属性面板中点击下图红色框框区域实现模式的切换。

![切换尺寸模式](http://upload-images.jianshu.io/upload_images/291600-e1c6a34a875c7d14.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这三种分别为：

* **wrap content**

![wrap_content](http://upload-images.jianshu.io/upload_images/291600-b3b5528ebb36940b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

wrap content模式就是平时常用的根据内容来设定控件尺寸。

* **固定值**

![固定值](http://upload-images.jianshu.io/upload_images/291600-4314b554f154e21b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

固定值模式也是平时常用的，通过设定具体数值来确定控件的大小。如下图所示，切换为固定模式后，在下方的`layout_width`一栏填写具体的宽度数值。

![设置控件大小](http://upload-images.jianshu.io/upload_images/291600-cac0c176f4f4f49f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* **any size**

![any size](http://upload-images.jianshu.io/upload_images/291600-94472c2f856e43c4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

any size与match parent类似，都是充满整个范围，但是不同点在于match parent充满相对于父容器，而any size是相对于约束条件，即在约束条件下，能填充的范围全部充满，如下图所示：

![设置为any size](http://upload-images.jianshu.io/upload_images/291600-38cc760addcdd58b.gif?imageMogr2/auto-orient/strip)

这里说明一下，ConstraintLayout其实也有match parent模式，但是因为ConstraintLayout不存在多层嵌套关系，所以match parent这种相对于父容器的模式在ConstraintLayout中很少会使用。


# 删除约束

学习了添加约束后，来看看如何删除约束？删除约束有三种方式：

* **删除单个约束**

将鼠标移动到要删除的约束对应的小圆圈，待小圆圈出现闪烁的红色圈圈时，点击小圆圈即可删除约束。

![删除单个约束](http://upload-images.jianshu.io/upload_images/291600-fdd60ed653b1dbaa.gif?imageMogr2/auto-orient/strip)

除了上面这种删除方法，也可以在属性面板中，将鼠标移动到下图红色框框标记的位置，待出现叉叉图标，点击可删除该约束。

![删除单个约束](http://upload-images.jianshu.io/upload_images/291600-d604aedaef646425.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


* **删除单个控件的所有约束**

用鼠标点击控件，在其左下方会出现一个小叉叉图标，点击小图标即可删除当前控件的所有约束。

![删除单个控件的所有约束](http://upload-images.jianshu.io/upload_images/291600-914f40e162960b10.gif?imageMogr2/auto-orient/strip)

* **删除当前界面的所有约束**

点击工具栏中`删除所有约束`图标的按钮，即可删除当前界面所有的约束。

![删除当且界面的所有约束](http://upload-images.jianshu.io/upload_images/291600-99411797db6acd15.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


# Guidelines

学完基本的依赖操作，来看一下ConstraintLayout的进阶用法。这里有一个需求，要求将两个控件合在一起，实现水平居中。如果不使用ConstraintLayout，读者们或许会想到用RelativeLayout嵌套LinearLayout来实现。那么在ConstraintLayout这样不存在多布局嵌套的情况下该怎么实现呢？

这时候就提出了**Guidelines**，GuideLines就如同Photoshop中参考线的概念一样。如下图，创建一个垂直方向的参考线，将其切换至百分比模式，拖动到50%的位置，再将两个控件在左右两侧分别与Guidelines添加约束，然后两个控件的底边相互添加约束即可实现合并居中的效果。此时ConstraintLayout展现了其强大的优势，通过其特性优雅地完成需求。

![Guidelines](http://upload-images.jianshu.io/upload_images/291600-a6737f34ac5ad74d.gif?imageMogr2/auto-orient/strip)

这里说明一下，创建完Guidelines后，读者们会发现它很难拖动，这里有一个小技巧：将鼠标按住划过Guidelines，然后放到Guidelines的位置，按住鼠标即可轻松实现拖动。

![拖动Guidelines](http://upload-images.jianshu.io/upload_images/291600-31f7783c444aa75e.gif?imageMogr2/auto-orient/strip)

# Autoconnect

或许因为我们是第一次接触ConstraintLayout，所以感觉添加约束的操作很有趣，但是在项目中，当控件数量比较多时，每个控件的每条边都要一个一个添加约束，这样就会拖慢开发效率，所以ConstraintLayout提出了`Autoconnect`的用法。

如下图所示，单击打开工具栏中`Autoconnect`功能按钮，将控件拖至屏幕中心，然后约束就会自动添加了，这个相信使用过**墨刀**设计过APP原型的读者们会感到很熟悉。

![Autoconnect](http://upload-images.jianshu.io/upload_images/291600-1ced9132a90a8aa3.gif?imageMogr2/auto-orient/strip)

Autoconnect会根据我们的意图来判断是否添加相应的约束，当然自动添加的约束不一定全是想要的效果，这时候可以关闭Autoconnect，然后手动修改约束。

![Autoconnect](http://upload-images.jianshu.io/upload_images/291600-f73b47f9987ff980.gif?imageMogr2/auto-orient/strip)

# Inference

Inference与Autoconnect功能相同，都是用于自动添加约束的，但是Inference更加强大。Inference是手动添加约束后，对当前界面所有控件的位置关系添加整体约束关系，感觉和Photoshop里面不同布局中的图像调整好位置后合并可见图层很像。Inference操作如下图所示：

![4.gif](http://upload-images.jianshu.io/upload_images/291600-72db88ec184210fa.gif?imageMogr2/auto-orient/strip)

# 写在后面

本文是在拜读**郭霖**大神的《Android新特性介绍，ConstraintLayout完全解析》一文后写的，本文的案例和描述基本都是参考自这篇文章，权当是转载来的吧！请叫我**佳作搬运工**!
最后附上大神原文链接供大家品读：
http://blog.csdn.net/guolin_blog/article/details/53122387