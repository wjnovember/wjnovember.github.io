---
title: Markdown，一款让你爱上写博客的神器（内附Markdown编辑器推荐）
date: 2016-09-16 22:10:00
tags:
---

# 叨叨在前

之前无意间接触到Markdown，花了一个下午的时间学习了语法，此后养成了用Markdown写博客的习惯，再也停不下来。相比于富文本，Markdown省去了点点点的烦恼，不在为了让标题字号大一些，费神找字体放大按钮，可以让作者将更多的精力集中在写作本身上。今天分享常用的Markdown语法，希望可以帮助读者们快速入门Markdown。

# 语法

## 标题

* 输入

![](https://upload-images.jianshu.io/upload_images/291600-bae0cbcd048bb01f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 效果

![](https://upload-images.jianshu.io/upload_images/291600-3f132765d2c2b8f5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 文本

文本的显示形式可分为粗体、斜体两种，通过在文本前后输入若干个`*`。

* 输入

![](https://upload-images.jianshu.io/upload_images/291600-ced2cc15b791efd9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 效果

![](https://upload-images.jianshu.io/upload_images/291600-b32492d026bc3c52.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


## 图片

图片的输入语法为：

```
![图片内容](图片链接)
```

* 输入

![](https://upload-images.jianshu.io/upload_images/291600-d8e4f2d84168533d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 效果

![我的简书个人主页](http://upload-images.jianshu.io/upload_images/291600-f1aa74cf4c14c6c0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


> **注意**：这里的`!`、`[`、`]`、`(`、`)`均为英文输入法。


除了静态图片，Markdown支持Gif动图，效果如下，语法与静态图一致：

![动图效果](http://upload-images.jianshu.io/upload_images/291600-3b00271942fef854.gif?imageMogr2/auto-orient/strip)

## 链接

链接的语法与图片类似，只要在图片语法的基础上去掉`!`即可。

* 输入

![](https://upload-images.jianshu.io/upload_images/291600-ea28ab14cb1cc0b6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


* 效果

[这个我的博客链接](https://wjnovember.github.io)

## 列表

列表可分为**有序列表**和**无序列表**。

**无序列表**可通过在每行文本前输入`*`、`+`、`-`来实现。

* 输入

![](https://upload-images.jianshu.io/upload_images/291600-5859da00d763d690.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 效果

![](https://upload-images.jianshu.io/upload_images/291600-136681039a78a4d3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**有序列表**可通过在每行文本前面输入`数字`+`.`+`空格`来实现。

* 输入

![](https://upload-images.jianshu.io/upload_images/291600-6bf13cfa2db165b2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


* 效果

![](https://upload-images.jianshu.io/upload_images/291600-4147b72e5e553255.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 引用

**引用**即我们文章中摘抄他人文章中写的内容，也可以作提示文字的样式，可以通过`>`来实现。

* 输入

![](https://upload-images.jianshu.io/upload_images/291600-05c9029870267125.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 效果

> 这是一段引用文章的文字，此处省略1000字。。。

## 行内代码块

**行内代码块**可用于关键字词，将其与普通文本区分开，语法是在文字内容开始与结尾添加 ` ` `。

* 输入

![](https://upload-images.jianshu.io/upload_images/291600-d7fcfeac3f987718.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 效果

`这是行内代码块`

## 代码块

**代码块**实则是行内代码快的扩展，用于将多行代码或文本内容与其他文本内容区分开来，其效果如下：

* 输入

![](https://upload-images.jianshu.io/upload_images/291600-a6a81e72f30388fb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

（每两个竖线之间是4个Tab键或8个空格键）


* 效果

        public int add(int a, int b) {
            return a + b;
        }

## 加强代码块

**加强代码块**是代码块的增强版，省去了多行代码每行输入Tab键的烦恼，只要在多行代码的开始和结尾输入3个点即可。

* 输入

![](https://upload-images.jianshu.io/upload_images/291600-d3fc5e932453430f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 效果

```
public int add(int a, int b) {
    return a + b;
}
```

## 表格

表格的语法主要用到的符号为`|`、`-`、`:`。

* 输入

![](https://upload-images.jianshu.io/upload_images/291600-afb377fbc78eacac.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 效果

|默认|居中|左对齐|右对齐|
|--|:-:|:-|-:|
|换行\n换行失败|简书Markdown|不支持|换行|
|*支持斜体*|**粗体**|***斜体+粗体***||
|# 不支持标题|[支持链接](http://jianshu.com)|[图片上传失败...(image-ea8611-1532052436234)]|`支持行内代码块` |

## 删除线

* 输入

![](https://upload-images.jianshu.io/upload_images/291600-de817c64d61abfb7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 效果

~~删除线~~

## 分割线

分割线可使用`*`、`-`来实现。

* 输入

![分割线](https://upload-images.jianshu.io/upload_images/291600-617904b3b02df032.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 效果

---
***



以上是笔者针对常用的Markdown用法进行罗列，读者们也可以在其他平台上看到Markdown更加高阶的用法，如：[cmd Markdown](https://www.zybuluo.com/mdeditor?url=https://www.zybuluo.com/static/editor/md-help.markdown#fn:footnote)，对原生Markdown进行了更进一步的封装和扩展，可支持LaTex、Todo列表、Toc目录、Mermaid 序列图等，Markdown是一个很有意思的语法，感兴趣的读者们可以进行更深入的探索！

# Markdown工具

Markdown工具可分为**在线**和**客户端**两种，接下来笔者给大家推荐几款体验较好的Markdown编辑工具。

## 在线

### [简书](http://jianshu.com)

![](http://upload-images.jianshu.io/upload_images/291600-486b29859e021c70.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**简书**设置Markdown编辑器方法如下：

![](http://upload-images.jianshu.io/upload_images/291600-89e5fc65cf97ad71.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

点击齿轮图标，进入设置；

![](http://upload-images.jianshu.io/upload_images/291600-6248d4b5443b6901.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**基础设置**页签下，在下方**选择常用的编辑器**选择`Markdown`，点击`保存`按钮即可；

![](http://upload-images.jianshu.io/upload_images/291600-cc0bf1c046d4b055.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### [作业部落](https://www.zybuluo.com)

![](http://upload-images.jianshu.io/upload_images/291600-db35a832a1ecd54c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**作业部落**乍一听，有点学生气，有点小学时候用的错题本的感觉，但是其功能非常强大，**支持实时预览**，对Markdown进行了**完美的封装**，扩展了以下功能：

```
1. Todo列表
2. LaTex公式
3. 简易流程图
4. 序列图
5. 甘特图
6. TOC目录
7. 标签分类
8. 注脚
9. Mermaid 流程图
10. Mermaid 序列图
11. 定义型列表
12. 内嵌图标
```

可以说，使用Cmd Markdown完成一篇格式比较专业的学术论文是没问题的。

### [马克飞象](https://maxiang.io)

![](http://upload-images.jianshu.io/upload_images/291600-7299bfc2163bb81a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如果读者们是**印象笔记**迷，那么**马克飞象**可以说是福音了，它支持将文本存到印象笔记，且功能特性与**作业部落**相差无几，但是有一点让人遗憾的是：

马克飞象是一款收费软件，在10天的试用期结束后，只有通过收费才能继续使用！

![](http://upload-images.jianshu.io/upload_images/291600-22e4e4b56b70be34.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

同**作业部落**一样，**马克飞象**也支持客户端，支持本地缓存。

### [有道云笔记](http://note.youdao.com)

![](http://upload-images.jianshu.io/upload_images/291600-ece80fd826efb38f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

或许你听惯了**有道词典**，这个八竿子打不着的**词典**与**Markdown**突然有一天走到一起产生了爱情的火花，诞生出了**有道云笔记**。

![](http://upload-images.jianshu.io/upload_images/291600-b9e1cf6d891de5b5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![](http://upload-images.jianshu.io/upload_images/291600-2db580ea7b5f9563.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

有一个功能有道云笔记做的不错，就是可以**将自己的笔记发布到网上，他人可以像浏览网页一样查看自己的记录**。

### [小书匠](http://soft.xiaoshujiang.com)

![](http://upload-images.jianshu.io/upload_images/291600-264af054aaa12c24.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**小书匠**是一款内容丰富的个性化Markdown编辑工具，为什么说它个性化呢？我们来看看它的功能：

```
1. 全屏预览
2. 实时可获取html代码
3. 自定义CSS样式
4. 多方式预览：普通预览、ppt预览、pdf预览
5. 多种预览排版方式：上、下、左、右、浮动
6. 内容可以标题为节点隐藏
7. 映射关系
8 大纲查看，自动生成目录
```

![](http://upload-images.jianshu.io/upload_images/291600-902c6f72b766a08c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**土豪金**配上**经典黑**就足以闪瞎凡人的双眸，高逼格、高内涵、~~高血压~~高品质的Markdown编辑器，你值得拥有！

另外，**小书匠支持windows、Linux、Mac、Web多端编辑！**

## 客户端

除了以上同时支持客户端的在线Markdown编辑器外，来说说其他的客户端Markdown编辑器。

### [Mou](http://25.io/mou/)

![](http://upload-images.jianshu.io/upload_images/291600-6fccd4a7583f4bef.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**Mou**是笔者尝试的第一款Markdown客户端软件，支持最基本的Markdown语法，界面简洁。因其主题风格不是很心仪，后来笔者将它静静地从电脑上卸载了-_-#，但这并不影响Markdown迷们对它的喜爱！

### [MacDown](http://macdown.uranusjr.com)

![](http://upload-images.jianshu.io/upload_images/291600-9f3ecabdc091dce1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**MacDown**是笔者使用Markdown编辑器以来用的最久的一款，其主题样式和预览效果都还是不错的，重要的是：它**开源*免费***，***免费***，***免费***，***免费！***

但它有一个不足，就是：一个窗口只能打开一个文件，这就显得比较鸡肋了，后来笔者弃用了MacDown-_-||

### [Atom](https://atom.io)

![](http://upload-images.jianshu.io/upload_images/291600-ead6377370329138.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**Atom**是一款很强大比较稳定的一款Markdown编辑器，支持多文件显示，文件目录缩进，有丰富的插件，插件的下载方式为：

```
Preferences->install->想要插件的名称->搜索->下载
```

然后重启即可。

### [Sublime](http://www.sublimetext.com)

![](http://upload-images.jianshu.io/upload_images/291600-fdfb0c42a819590b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**Sublime**是一款通用型编辑器。**如果说Atom是17世纪的物理牛顿，那么Sublime就是15世纪的全能达芬奇。**之所以提到Sublime，是因为Sublime支持Markdown**插件**，通过安装下载，Sublime也同样可以实现Markdown编辑器的效果，但是它的预览还是挺鸡肋的，它只能像Html一样，在浏览器中预览，而且**不支持实时预览**。但是毕竟是老牌编辑器，强大的通用性让其在编辑器领域鹤立鸡群。

### [Visual Studio Code](https://code.visualstudio.com/)

![](https://upload-images.jianshu.io/upload_images/291600-eefe611c2009def7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


VS Code自带Markdown实时预览功能，也支持加强型预览插件下载，笔者个人还是挺心仪这款工具的，且经常用它来做开发，是一款多能型工具。


# 参考

* [好用的Markdown编辑器一览](http://www.williamlong.info/archives/4319.html)