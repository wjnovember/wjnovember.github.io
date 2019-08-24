---
title: 听说你想玩RecyclerView嵌套GridView
date: 2016-09-15 15:15:59
tags:
categories:
- Android开发从入门到炸机
---

# 效果图

![RecyclerView嵌套GridView](http://upload-images.jianshu.io/upload_images/291600-3b00271942fef854.gif?imageMogr2/auto-orient/strip)

# 问题及原因

有很多小伙伴们可能会遇到这样的问题：

**为什么不论我传入多大size的List，我的GridView只能显示一行？**

因为RecyclerView和GridView都属于**可滑动控件**，两者嵌套会导致**滑动冲突**，Android不允许这样的情况出现，所以索性将GridView宽度定死，定为一行Item的高度且不可滑动，所以导致了我们只显示一行这个问题的出现。

# 源码浅析

解决的思路是：***重新计算高度！***

想要计算高度，我们就要知道它计算高度的机制。我们来看看**源码**：

![继承GridView自定义控件里的onMeasure方法](http://upload-images.jianshu.io/upload_images/291600-75ca2206ba6c222c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们可以看到如果我们自定义控件，且什么都不做时，它会调用父类（GridView）的onMeasure方法，我们来看看GridView里面的onMeasure源码：

```Java
@Override
protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
    // Sets up mListPadding
    super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    int widthMode = MeasureSpec.getMode(widthMeasureSpec);
    int heightMode = MeasureSpec.getMode(heightMeasureSpec);
    int widthSize = MeasureSpec.getSize(widthMeasureSpec);
    int heightSize = MeasureSpec.getSize(heightMeasureSpec);  
    if (widthMode == MeasureSpec.UNSPECIFIED) {    
        if (mColumnWidth > 0) {        
            widthSize = mColumnWidth + mListPadding.left + mListPadding.right;    
        } else {        
            widthSize = mListPadding.left + mListPadding.right;    
        }    
        widthSize += getVerticalScrollbarWidth();
    }
    int childWidth = widthSize - mListPadding.left - mListPadding.right;
    boolean didNotInitiallyFit = determineColumns(childWidth);int childHeight = 0;
    int childState = 0;
    mItemCount = mAdapter == null ? 0 : mAdapter.getCount();
    final int count = mItemCount;
    if (count > 0) {    
        final View child = obtainView(0, mIsScrap);    
        AbsListView.LayoutParams p = (AbsListView.LayoutParams) child.getLayoutParams();    
        if (p == null) {        
            p = (AbsListView.LayoutParams) generateDefaultLayoutParams();        
            child.setLayoutParams(p);
        }
        p.viewType = mAdapter.getItemViewType(0);
    p.forceAdd = true;
    int childHeightSpec = getChildMeasureSpec(            
           MeasureSpec.makeSafeMeasureSpec(MeasureSpec.getSize(heightMeasureSpec),
                        MeasureSpec.UNSPECIFIED), 0, p.height);
    int childWidthSpec = getChildMeasureSpec(
                MeasureSpec.makeMeasureSpec(mColumnWidth, MeasureSpec.EXACTLY), 0, p.width);
        child.measure(childWidthSpec, childHeightSpec);
        childHeight = child.getMeasuredHeight();
        childState = combineMeasuredStates(childState, child.getMeasuredState());
    if (mRecycler.shouldRecycleViewType(p.viewType)) {
        mRecycler.addScrapView(child, -1);
        }
    }
if (heightMode == MeasureSpec.UNSPECIFIED) {
        heightSize = mListPadding.top + mListPadding.bottom + childHeight +
            getVerticalFadingEdgeLength() * 2;
    }
    if (heightMode == MeasureSpec.AT_MOST) {
        int ourSize =  mListPadding.top + mListPadding.bottom;
       final int numColumns = mNumColumns;
        for (int i = 0; i < count; i += numColumns) {
            ourSize += childHeight;
        if (i + numColumns < count) {
                ourSize += mVerticalSpacing;
            }
        if (ourSize >= heightSize) {
                ourSize = heightSize;
            break;
        }
        }
    heightSize = ourSize;
}
    if (widthMode == MeasureSpec.AT_MOST && mRequestedNumColumns != AUTO_FIT) {
        int ourSize = (mRequestedNumColumns*mColumnWidth)
                + ((mRequestedNumColumns-1)*mHorizontalSpacing)
                + mListPadding.left + mListPadding.right;
    if (ourSize > widthSize || didNotInitiallyFit) {
        widthSize |= MEASURED_STATE_TOO_SMALL;
        }
    }
    setMeasuredDimension(widthSize, heightSize);
mWidthMeasureSpec = widthMeasureSpec;
}
```

既然我们关注的是高度，我们就来看看高度相关的变量：

![GridView的onMeasure](http://upload-images.jianshu.io/upload_images/291600-39ab5838f82ceaab.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**onMeasure()**方法传入了两个变量：**widthMeasureSpec**和**heightMeasureSpec**，它们是什么呢？在这之前我们讲一讲**MeasureSpec**类的模式，我们用一张图来说明：

![MeasureSpec的模式说明图](http://upload-images.jianshu.io/upload_images/291600-dcd5988f0c743b69.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们可以把MeasureSpec的模式标记理解成一个32位的二进制数字，最高两位表示**模式**，其他30位表示**大小**（即像素点或尺寸），MeasureSpec提供了*三种模式* 用来计算控件的尺寸：

* EXACTLY
在控件宽高设置为**具体数值**或**MATCH_PARENT**时，使用该模式；

* AT_MOST
在控件宽高设置为**WRAP_CONTENT**时，使用该模式；

* UNSPECIFIED
除上述两种情况外的其他情况（*即未指定宽高时*），使用该模式。

知道了MeasureSpec，我们回到GridView的onMeasure方法，方法里获取了高度的**模式**和**大小**：

```
int heightMode = MeasureSpec.getMode(heightMeasureSpec);
int heightSize = MeasureSpec.getSize(heightMeasureSpec);
```

PS: `getMode()`及`getSize()`分析见附录一

我们继续往下看：

## AT_MOST

![AT_MOST模式](http://upload-images.jianshu.io/upload_images/291600-423b26b363fd9553.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如果高度模式为***AT_MOST***，则它首先会计算GridView的内容高度，内容高度的计算式为：

```
paddingTop: GridView上内边距
paddingBottom: GridView下内边距
verticalSpacing: GridView每行垂直方向间距
spaceNum: GridView行数 - 1
lineNum: GridView行数
itemHeight: GridView每项高度

内容高度 = paddingTop + paddingBottom + verticalSpacing * spacingNum + itemHeight * lineNum
```
其中，`childHeight`通过**child.getMeasuredHeight()**获得。

计算好内容高度以后，它会和最大允许高度比较：
如果内容高度**未超过**最大高度，则**内容高度**作为GridView的高度；
如果内容高度**超过**最大高度，则**最大高度**作为GridView的高度；

## UNSPECIFIED

![UNSPECIFIED模式](http://upload-images.jianshu.io/upload_images/291600-ab38a50aa000ecb9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如果高度模式为***UNSPECIFIED***，则它会计算包含一个Item的GridView的内容高度，其计算式为：

```
内容高度 = 上内边距 + 下内边距 + 一个子项高度 + 边宽 * 2
```

个人猜测，**当RecyclerView嵌套GridView的时候，其GridView的MeasureSpec的模式为*UNSPECIFIED***。

## EXACTLY

![EXACTLY模式](http://upload-images.jianshu.io/upload_images/291600-91aa2f488cbfc95f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

因EXACTLY模式下，GridView的高度已经设定好了，所以不用获取子项的高度及边距等，源码中通过`int heightSize = MeasureSpec.getSize(heightMeasureSpec);`在heightSize声明的时候，将其获取到了，所以没有将**EXACTLY**单独IF语句进行判断。

# 解决方案

之前我们说过，解决思路是重新计算GridView高度，这里我们介绍两种计算GridView的高度的方法：

## 自定义控件

![自定义控件](http://upload-images.jianshu.io/upload_images/291600-fe1defc0783883a3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

通过自定义控件继承GridView，重写onMeasure方法，将计算高度的模式设置为**AT_MOST**即可。

代码如下：

```Java
import android.content.Context;
import android.util.AttributeSet;
import android.widget.GridView;
/**
 * Created by inerdstack on 2016/9/14.
 */
public class MyGridView extends GridView {

    public MyGridView(Context context) {
        super(context);
    }

    public MyGridView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public MyGridView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {

        int expandSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2,
                MeasureSpec.AT_MOST);
        super.onMeasure(widthMeasureSpec, expandSpec);

    }

    @Override
    public int getNumColumns() {
        return 2;
    }
}
```

## 手动计算GridView高度

![计算GridView高度](http://upload-images.jianshu.io/upload_images/291600-ca5bc1b2b40babfb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这里我们计算的是相同类型View下的GridView的高度，切记要在***setAdapter以后调用这个方法*** ，否则会无效。本人尝试使用这种方法解决问题，但是没有成功，但是同事使用了这种方法写了一个Demo成功了。
个人猜想可能跟我的布局有关，我的**GridView**所在的环境是**Activity**的**Fragment**的**PtrFrameLayout**（下拉刷新框架的一个控件）的**RecyclerView**的**Item**里面，不过不排除我的代码问题，如果小伙伴们找到了我的问题所在，欢迎在文章下方评论留言。

文章至此基本告终，接下来说说getSize()、getMode的源码浅析，感兴趣的小伙伴可以看看。

# 附录一 getSize()、getMode()源码分析

之前我们在GridView类的onMeasure方法里看到这样的方法：

![onMeasure方法](http://upload-images.jianshu.io/upload_images/291600-54f6b53ffe0816bc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们讲到过MeasureSpec的模式组成是**模式**+**大小**组成的32位二进制整型数字：

![MeasureSpec的模式说明图](http://upload-images.jianshu.io/upload_images/291600-99f0d648e83f0754.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

那么它是怎么获取模式和大小的呢？

![getMode源码](http://upload-images.jianshu.io/upload_images/291600-9e1e2a0548f7c4ff.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![getSize源码](http://upload-images.jianshu.io/upload_images/291600-edeab093bf13de47.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们可以看到两个方法里都用了`MODE_MASK`，我们来看看`MODE_MASK`是何方神圣：

![MeasureSpec.MODE_MASK](http://upload-images.jianshu.io/upload_images/291600-44d8c481052e758c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在MeasureSpec类里面，声明了如下几个常量：

* MODE_SHIFT
30位表示大小的位数的标记

* MODE_MASK
经移位转换为二进制后的数值为：`11000000000000000000000000000000`

* UNSPECIFIED
经移位转换为二进制后的数值为：`00000000000000000000000000000000`

* EXACTLY
经移位转换为二进制后的数值为：`01000000000000000000000000000000`

* AT_MOST
经移位转换为二进制后的数值为：`10000000000000000000000000000000`

```
科普：
<< 为二进制数的左移标记，其计算方式为：
a << b
则先将a转化为二进制数，然后左移b位
如：10 << 3
10 = 101
10 << 3 = 101000
```

在getMode方法中,`measureSpec & MODE_MASK`的逻辑计算结果是`XX000000000000000000000000000000`，也就是说，不论我们measureSpec的低30位上数字是什么最终都会转化为  `000000000000000000000000000000`，去掉了大小位上的非0数字，得到了与模式标记数字相同的结果，实现了提取模式的作用。

而在getSize方法中，`~MODE_MASK`是`MODE_MASK`取反，即`001111111111111111111111111111111`，`measureSpec & ~MODE_MASK`的逻辑计算结果则为`00XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`，与getMode同理，去掉了模式位上的非0数字，只留下了大小值。

以上就是getSize()、getMode()的源码浅析，有不足的地方，欢迎小伙伴们批评指正！