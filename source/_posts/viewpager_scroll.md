---
title: 听说你想用ViewPager实现这样的效果？
date: 2016-09-13 16:20:58
tags:
- Android开发
categories:
- Android开发从入门到炸机
---

# 效果图

![ViewPager实现多个View](http://upload-images.jianshu.io/upload_images/291600-4a2d2176f95be5a5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![此图盗于https://github.com/smallnew/FuCardPager](http://upload-images.jianshu.io/upload_images/291600-86d59532cd37f25c.gif?imageMogr2/auto-orient/strip)


# 代码实现

实现效果有两种：

* 重写**PagerAdapter**的**getPageWidth()**方法
* 布局参数设置

## 重写**PagerAdapter**的**getPageWidth()**方法

```
@Override
public float getPageWidth(int position) {
    return (float)0.8;
}
```

该方法返回结果*默认为1.0*，其效果为**ViewPager的Item占满整个ViewPager控件的宽度**，如果我们将返回的结果重写为小于1的数，则Item会相对默认效果变小，两边的Item也会相应地靠近过来，从而来到屏幕可见的区域，实现了我们想要的效果。

## 布局参数设置

这里我们设置的参数有点杂乱，我们分块来看：

### xml-ViewPager

![设置外边距和clipChildren](http://upload-images.jianshu.io/upload_images/291600-c8e52d2b64c03ca5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

代码如下：

```
android:layout_marginLeft="xx"
android:layout_marginRight="xx"
android:clipChildren="false"
```

### xml-ViewPager的父容器

![设置clipChildren和layerType](http://upload-images.jianshu.io/upload_images/291600-af304b5a260a2514.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

代码如下：

```
android:clipChildren="false"
android:layerType="software"
```

### java-viewPager

![设置最多一屏最多显示个数及page间距](http://upload-images.jianshu.io/upload_images/291600-5ad6aeaded7fd52d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

代码如下：

```
viewPager.setOffscreenPageLimit(4);
viewPager.setPageMargin(xxx);
```

***知其然，知其所以然！*** 我们来看看其中的原理：

**android:clipChildren**表示是否限制子View在其范围内，如果**clipChildren**属性设置为***true***,就表明我们要**将children给clip掉**，就是说对于子元素来说，超出当前view的部分都会被切掉，所以我们需要将**clipChidren**设置为***false***。

**setClipChildren**(false)在**3.0以上版本**中，开启了硬件加速后将***不能*** 正常工作，所以需要将其设置为**软件加速**。即：**android:layerType="software"**。

**注意一下**：PAGE_MARGIN的间距要***小于*** VIEW_PAGER_MARGIN的间距才可以实现一屏多View的效果。

# 实现居中

有的时候，我们为了好看，想要将我们的item实现居中。实现居中的方法很灵活，这里说一个比较接地气的方法：

```
ViewPager宽度设置为MATCH_PARENT，横向间距设置相同宽度。
```