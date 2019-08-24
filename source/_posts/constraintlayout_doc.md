---
title: 细细品读！深入浅出，官方文档看ConstraintLayout
date: 2017-03-11 11:21:27
tags:
- Android开发
categories:
- Android开发从入门到炸机
---

# 写在前面

之前品读了**郭霖**大神写的《[Android新特性介绍，ConstraintLayout完全解析](http://blog.csdn.net/guolin_blog/article/details/53122387)》，受其感染，写了一篇《[未来布局之星——ConstraintLayout](https://wjnovember.github.io/constraintlayout_basic/)》，回过头来看，感觉这一篇文章太注重可视化操作，于是去翻阅了一下ConstraintLayout的官方文档，决定从官方文档的角度在代码层面来了解一下ConstraintLayout。

# 继承关系

![继承关系](http://upload-images.jianshu.io/upload_images/291600-c42a2d4e2f5e897e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

ConstraintLayout和其他布局一样，继承自ViewGroup，但是不同点在于它调整控件的位置和大小时更加得灵活，功能更加强大。

# 版本支持

ConstraintLayout是一个Support库，意味着向前兼容，它可以兼容至API 9，也就是Android 2.3，鉴于现在市场上手机基本都是2.3及以上的，所以如果不是特殊情况，开发者可以不用考虑版本问题。下面是官网文档引文：

> Note: ConstraintLayout is available as a support library that you can use on Android systems starting with API level 9 (Gingerbread).

# 新特性

相对于传统布局，ConstraintLayout在以下方面提供了一些新的特性：

* 相对定位
* 外边距
* 居中和倾向
* 可见性的表现
* 尺寸约束
* Chain
* 辅助工具

接下来就这些新特性进行详细了解。

# 相对定位

相对定位是在ConstraintLayout中创建布局的最基本构建块，也就是一个控件相对于另一个控件进行定位，可以从横向、纵向添加约束关系，用到的边分别有：

* 横向：Left、Right、Start、End
* 纵向：Top、Bottom、Baseline（文本底部的基准线）

通常是一条边**向**另一条边添加约束，就像下面按钮B要定位在按钮A的右边一样：

![Fig. 1 - 相对定位例子](http://upload-images.jianshu.io/upload_images/291600-477d3abec28c553b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/350)

这种情况代码实现是这样的：

```
<Button android:id="@+id/buttonA" ... />
<Button android:id="@+id/buttonB" ...
    app:layout_constraintLeft_toRightOf="@+id/buttonA" />
```

这样系统就会知道按钮B的左侧被**约束**在按钮A的右侧，这里的**约束**可以理解为边的对齐。

![Fig. 2 - 相对定位的约束](http://upload-images.jianshu.io/upload_images/291600-bacaa11453ba32ff.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/350)

上图是相对定位的约束，图中每一条边（top、bottom、baseline、left、start、right、end）都可以与其他控件形成约束，罗列这些边形成的相对定位关系如下：

```
* layout_constraintLeft_toLeftOf          // 左边左对齐
* layout_constraintLeft_toRightOf         // 左边右对齐
* layout_constraintRight_toLeftOf         // 右边左对齐
* layout_constraintRight_toRightOf        // 右边右对齐
* layout_constraintTop_toTopOf            // 上边顶部对齐
* layout_constraintTop_toBottomOf         // 上边底部对齐
* layout_constraintBottom_toTopOf         // 下边顶部对齐
* layout_constraintBottom_toBottomOf      // 下边底部对齐
* layout_constraintBaseline_toBaselineOf  // 文本内容基准线对齐
* layout_constraintStart_toEndOf          // 起始边向尾部对齐
* layout_constraintStart_toStartOf        // 起始边向起始边对齐
* layout_constraintEnd_toStartOf          // 尾部向起始边对齐
* layout_constraintEnd_toEndOf            // 尾部向尾部对齐
```

上面的这些属性需要结合`id`才能进行约束，这些`id`可以指向控件也可以指向父容器（也就是ConstraintLayout），比如：

```
<Button android:id="@+id/buttonB" ...
    app:layout_constraintLeft_toLeftOf="parent" />
```

# 外边距

![Fig. 3 - 相对定位的外边距](http://upload-images.jianshu.io/upload_images/291600-87bd07f0d3d9896b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/350)

这里的外边距相信大家都理解，这里就不赘述了，罗列外边距的属性如下：

```
* android:layout_marginStart
* android:layout_marginEnd
* android:layout_marginLeft
* android:layout_marginTop
* android:layout_marginRight
* android:layout_marginBottom
```

来主要看一下外边距的新属性：**GONE MARGIN**
以图 3为例，这里的gone margin指的是B向A添加约束后，如果A的可见性变为GONE，这时候B的外边距可以改变，也就是B的外边距根据A的可见性分为两种状态。

```
* layout_goneMarginStart
* layout_goneMarginEnd
* layout_goneMarginLeft
* layout_goneMarginTop
* layout_goneMarginRight
* layout_goneMarginBottom
```

# 居中和倾向

## 居中

在**相对定位**一小节，我们了解了两个控件之间添加约束，现在来看看一个控件和父布局（ConstraintLayout）建立约束。当相同方向上（横向或纵向），控件两边同时向ConstraintLayout添加约束，情况就会像图 4所示的这样。

![Fig. 4 - 居中定位](http://upload-images.jianshu.io/upload_images/291600-411c90cf0e869dc0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/350)

而代码的书写是这样的：

```
<android.support.constraint.ConstraintLayout ...>
    <Button android:id="@+id/button" ...
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintRight_toRightOf="parent/>
<android.support.constraint.ConstraintLayout/>
```

这种情况就感觉像是控件两边有两个反向相等大小的力在拉动它一样，所以才会产生控件居中的效果。

> **这里说明一下：** 如果在居中方向上（横向或纵向）控件的尺寸和ConstraintLayout的尺寸一样，那么就无所谓居中了，此时约束的存在是没有意义的。

## 倾向

在这种约束是同向相反的情况下，默认控件是居中的，但是也可以像拔河一样，让两个约束的力大小不等，这样就产生了**倾向**，其属性是：

```
* layout_constraintHorizontal_bias
* layout_constraintVertical_bias
```

![Fig. 5 - 带倾向的居中](http://upload-images.jianshu.io/upload_images/291600-40eadcbf968b3e3c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/350)

下面这段代码就是让左边占30%，右边占70%（默认两边各占50%），这样左边就会短一些，如图5所示，此时代码是这样的：

```
<android.support.constraint.ConstraintLayout ...>
    <Button android:id="@+id/button" ...
        app:layout_constraintHorizontal_bias="0.3"
        app:layout_constraintLeft_toLeftOf="parent"
        app:layout_constraintRight_toRightOf="parent/>
<android.support.constraint.ConstraintLayout/>
```

通过设置倾向，可以非常便捷地实现屏幕适配。

# 可见性的表现

ConstraintLayout对可见性被标记`View.GONE`的控件（后称“`GONE`控件”）有特殊的处理。一般情况下，`GONG`控件是不可见的，且不再是布局的一部分，但是在**布局计算**上，ConstraintLayout与传统布局有一个很重要的区别：

* 传统布局下，`GONE`控件的尺寸会被认为是0（当做**点**来处理）
* 在ConstraintLayout中，`GONE`控件尺寸仍然按其可见时的大小计算，但是其外边距大小按0计算

![Fig. 6 - 可见时的表现](http://upload-images.jianshu.io/upload_images/291600-195889fb755f0bc4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/350)

*这种特殊的行为让我们在无需打乱布局情况下，在标记`GONE`控件的地方构建布局，这样的做法对于做简单的布局动画很有用。*

**说明一下：** 笔者在理解原文这句话的时候不是很理解，希望有经验的读者可以指点迷津，原文如下：

> This specific behavior allows to build layouts where you can temporarily mark widgets as being GONE, without breaking the layout (Fig. 6), which can be particularly useful when doing simple layout animations.

关于目标控件（如图 6中的A）设置为`GONE`时，受约束的控件（如图 6中的B）的外边距的变化设置请查看上面的**外边距**小节的GONE MARGIN属性。

> **Note:** The margin used will be the margin that B had defined when connecting to A (see Fig. 6 for an example). In some cases, this might not be the margin you want (e.g. A had a 100dp margin to the side of its container, B only a 16dp to A, marking A as gone, B will have a margin of 16dp to the container). For this reason, you can specify an alternate margin value to be used when the connection is to a widget being marked as gone (see[the section above about the gone margin attributes](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#GoneMargin)).

# 尺寸约束

## ConstraintLayout中的最小尺寸

ConstraintLayout本身可以定义自己的最小尺寸：

* **android:minWidth** 设置布局的最小宽度
* **android:minHeight** 设置布局的最小高度

这些最小尺寸当ConstraintLayout被设置为**WRAP_CONTENT**时有效。

## 控件尺寸约束

控件的尺寸可以通过`android:layout_width`和`android:layout_height`来设置，有三种方式：

* 使用**固定值**
* 使用**WRAP_CONTENT**
* 使用**0dp**（相当于**MATCH_CONSTRAINT**）

![Fig. 7 - 尺寸约束](http://upload-images.jianshu.io/upload_images/291600-31eb036200682d30.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

前两种方式和其他布局的用法相同，最后一种是通过填充约束来重新设置控件的尺寸（如图 7，(a)是`wrap_content`，(b)是`0dp`）。代码案例如下：

```
<Button android:layout_width="0dp" // 这里对宽度设置MATCH_CONSTRAINT，结合3、4两行实现约束
    android:layout_height="wrap_content"
    app:layout_constraintLeft_toLeftOf="parent"
    app:layout_constraintRight_toRightOf="parent"/>
```

如果控件设置了外边距，那么外边距就会在尺寸计算中被考虑进去，效果如图图 7 (c)所示。

**敲黑板，划重点：** 一般`MATCH_PARENT`在ConstraintLayout布局下是不支持的，但是在简单的布局结构（如控件的约束只与ConstraintLayout关联）下，`MATCH_PARENT`是被支持的，其作用与`MATCH_CONSTRAINT`相同。

## 比例

这里的比例指的是宽高比，通过设置比例，让宽高的其中一个随另一个变化。为了实现比例，需要让控件宽或高**受约束**，且尺寸设置为`0dp `（也可以是`MATCH_CONSTRAINT`），实现代码如下：

```
<Button android:layout_width="wrap_content"
    android:layout_height="0dp"
    app:layout_constraintTop_toTopOf="parent"
    app:layout_constraintDimensionRatio="1:1" />
```

上述代码中，按钮的高度满足**受约束且设置为`0dp`**的条件，所以其尺寸会按照比例**随**宽度调整。

比例的设置有两种格式：

* 宽度与高度的**比**，可理解为`受约束的一方尺寸:另一方尺寸`
* `受约束的一方尺寸/另一方尺寸`得到的**浮点数**值

如果宽高都设置了`MATCH_CONSTRAINT`（`0dp`）和约束，那么需要在比例前添加`W,`或`H,`以确定受约束的是高还是宽，然后受约束的一方根据不受约束的一方，按照比例计算自己的尺寸。

关于上面这段话，原文是：

> You can also use ratio if both dimensions are set to MATCH_CONSTRAINT (0dp). In this case the system sets the largest dimensions the satisfies all constraints and maintains the aspect ratio specified. To constrain one specific side based on the dimensions of another. You can pre append W," or H, to constrain the width or height respectively. 

笔者个人感觉官方文档对于这一块表述较模糊，可能跟自己的英语阅读能力有关，望有经验的过来人答疑解惑。

关于上述的案例，代码如下：

```
<Button android:layout_width="0dp"
    android:layout_height="0dp"
    app:layout_constraintDimensionRatio="H,16:9"
    app:layout_constraintBottom_toBottomOf="parent"
    app:layout_constraintTop_toTopOf="parent"/>
```

上述代码对宽度和高度都进行了**约束**，通过`H,`指定高度受约束，所以高度的尺寸会根据宽度大小按照比例得到，其效果如图所示：

![Ratio](http://upload-images.jianshu.io/upload_images/291600-dfb461d52b61d94b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/350)

至于为何高度填充屏幕而宽度不填充，其玄机在于下面这句话，能理解它，就理解了比例使用的精髓：

> In this case the system sets the largest dimensions the satisfies all constraints and maintains the aspect ratio specified. 

# Chain

Chain是一系列双向连接的控件连接在一起的形态（如图 8所示，是最小单位的Chain，只有两个组件）。

![Fig. 8 - Chain](http://upload-images.jianshu.io/upload_images/291600-ed06c50b9487da49.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/350)

## Chain头部

横向上，Chain头部是Chain最左边的控件；纵向上，Chain头部是Chain最顶部的控件。

## Chain外边距

如果连接时定义了外边距，Chain就会发生变化。在`SPREAD CHAIN`中，外边距会从已经分配好的空间中去掉。原文如下：

> If margins are specified on connections, they will be taken in account. In the case of spread chains, margins will be deducted from the allocated space.

## Chain样式

当对Chain的第一个元素设置`layout_constraintHorizontal_chainStyle `或`layout_constraintVertical_chainStyle`属性，Chain就会根据特定的样式（默认样式为`CHAIN_SPREAD`）进行相应变化，样式类型如下：

* `CHAIN_SPREAD` 元素被分散开（默认样式）
* 在`CHAIN_SPREAD`模式下，如果一些控件被设置为`MATCH_CONSTRAINT`，那么控件将会把所有剩余的空间均分后“吃掉”
* `CHAIN_SPREAD_INSIDE` Chain两边的元素贴着父容器，其他元素在剩余的空间中采用`CHAIN_SPREAD`模式
* `CHAIN_PACKED` Chain中的所有控件合并在一起后在剩余的空间中居中

![Fig. 10 - Chain样式](http://upload-images.jianshu.io/upload_images/291600-f946591834de8def.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/500)

## 带权重的Chain

默认的Chain会在空间里平均散开。如果其中有一个或多个元素使用了`MATCH_CONSTRAINT`属性，那么他们会将剩余的空间平均填满。属性`layout_constraintHorizontal_height`和`layout_constraintVertical_weight`控制使用`MATCH_CONSTRAINT`的元素如何均分空间。
例如，一个Chain中包含两个使用`MATCH_CONSTRAINT`的元素，第一个元素使用的权重为2，第二个元素使用的权重为1，那么被第一个元素占用的空间是第二个元素的2倍。

# 辅助工具

这里“辅助工具”的原文是**Virtual Helper objects**，对于ConstraintLayout，其辅助工具目前是**Guidline**。关于**Guideline**的了解，读者们可先尝试《[未来布局之星——ConstraintLayout](https://wjnovember.github.io/constraintlayout_basic/)》一文中的Guideline操作。在此基础上，访问[Guideline类](https://developer.android.google.cn/reference/android/support/constraint/Guideline.html)了解详情，附上Guideline类的代码案例供读者们了解：

```
<android.support.constraint.ConstraintLayout
        xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:app="http://schemas.android.com/apk/res-auto"
        xmlns:tools="http://schemas.android.com/tools"
        android:layout_width="match_parent"
        android:layout_height="match_parent">

    <android.support.constraint.Guideline
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:id="@+id/guideline"
            app:layout_constraintGuide_begin="100dp"
            android:orientation="vertical"/>

    <Button
            android:text="Button"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:id="@+id/button"
            app:layout_constraintLeft_toLeftOf="@+id/guideline"
            android:layout_marginTop="16dp"
            app:layout_constraintTop_toTopOf="parent" />

</android.support.constraint.ConstraintLayout>
```

# 相关方法

|Public构造方法|
|:--|
|[ConstraintLayout](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#ConstraintLayout(android.content.Context))([Context](http://developer.android.google.cn/reference/android/content/Context.html) context)|
|ConstraintLayout([Context](http://developer.android.google.cn/reference/android/content/Context.html)context,[AttributeSet](http://developer.android.google.cn/reference/android/util/AttributeSet.html)attrs)|
|ConstraintLayout([Context](http://developer.android.google.cn/reference/android/content/Context.html)context,[AttributeSet](http://developer.android.google.cn/reference/android/util/AttributeSet.html)attrs, int defStyleAttr)|

|Public方法||
|:--|:--|
|void|[addView](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#addView(android.view.View, int, android.view.ViewGroup.LayoutParams))([View](http://developer.android.google.cn/reference/android/view/View.html)child, int index,[ViewGroup.LayoutParams](http://developer.android.google.cn/reference/android/view/ViewGroup.LayoutParams.html)params)|
|[ConstraintLayout.LayoutParams](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.LayoutParams.html)|[generateLayoutParams](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#generateLayoutParams(android.util.AttributeSet))([AttributeSet](http://developer.android.google.cn/reference/android/util/AttributeSet.html)attrs)|
|int|[getMaxHeight](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#getMaxHeight())()|
|int|[getMaxWidth](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#getMaxWidth())()|
|int|[getMinHeight](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#getMinHeight())()|
|int|[getMinWidth](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#getMinWidth())()|
|void|[onViewAdded](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#onViewAdded(android.view.View))([View](http://developer.android.google.cn/reference/android/view/View.html)view)|
|void|[onViewRemoved](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#onViewRemoved(android.view.View))([View](http://developer.android.google.cn/reference/android/view/View.html)view)|
|void|[removeView](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#removeView(android.view.View))([View](http://developer.android.google.cn/reference/android/view/View.html)view)|
|void|[requestLayout](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#requestLayout())()|
|void|[setConstraintSet](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#setConstraintSet(android.support.constraint.ConstraintSet))([ConstraintSet](https://developer.android.google.cn/reference/android/support/constraint/ConstraintSet.html)set)|
|void|[setMaxHeight](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#setMaxHeight(int))(int value)|
|void|[setMaxWidth](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#setMaxWidth(int))(int value)|
|void|[setMinHeight](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#setMinHeight(int))(int value)|
|void|[setMinWidth](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#setMinWidth(int))(int value)|

|Protected方法||
|:--|:--|
|boolean|[checkLayoutParams](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#checkLayoutParams(android.view.ViewGroup.LayoutParams))([ViewGroup.LayoutParams](http://developer.android.google.cn/reference/android/view/ViewGroup.LayoutParams.html)p)|
|[ConstraintLayout.LayoutParams](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.LayoutParams.html)|[generateDefaultLayoutParams](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#generateDefaultLayoutParams())()|
|[ViewGroup.LayoutParams](http://developer.android.google.cn/reference/android/view/ViewGroup.LayoutParams.html)|[generateLayoutParams](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#generateLayoutParams(android.view.ViewGroup.LayoutParams))([ViewGroup.LayoutParams](http://developer.android.google.cn/reference/android/view/ViewGroup.LayoutParams.html)p)|
|void|[onLayout](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#onLayout(boolean, int, int, int, int))(boolean changed, int left, int top, int right, int bottom)|
|void|[onMeasure](https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html#onMeasure(int, int))(int widthMeasureSpec, int heightMeasureSpec)|

# 写在最后

第一次用所剩无几的英语能力蹩脚地翻译官方文档，看着密密麻麻的英文写到这里，如今已经头昏眼花、不知所云，若读者们有发现文章错误的地方，欢迎在文章下方评论留言。个人感觉，想要深入理解ConstraintLayout，还是需要多使用、多实践，并且要结合源码分析，但愿通过这篇文章的学习，读者们可以达到入门ConstraintLayout的目的。翻译不易，转载请注明链接，最后附上官方文档的地址，供读者们比对学习，感谢阅读！
https://developer.android.google.cn/reference/android/support/constraint/ConstraintLayout.html