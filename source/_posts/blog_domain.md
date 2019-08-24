---
title: 域名绑定，让你的博客拥有自己的个性
date: 2016-10-14 12:35:00
tags:
- 博客
categories:
- 零基础学习博客搭建
---

# 前情提要

之前使用hexo搭建了Github博客，感觉有了自己的小窝，很有归属感。但是看着博客的域名是二级域名，总有种寄宿的感觉，为了让博客更加正式，笔者在阿里云上买了一个域名，打算将域名绑定到博客上。笔者查找了网上的教程，发现文字描述总是缺胳膊少腿，走了一些弯路，所以索性写一篇绑定域名的教程，方便大家实践。

# 购买域名

笔者是在阿里云网站购买的域名，因此本教程以阿里云为例子，进入[阿里云域名注册页面](https://www.aliyun.com/)。

![万维网 域名注册](http://upload-images.jianshu.io/upload_images/291600-b4009c6ed1164f40.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

输入想要的域名，进行查询，选择未被注册的域名进行购买：

![购买域名](http://upload-images.jianshu.io/upload_images/291600-917d7eb20516ad6c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

接下来就是下订单购买的流程，在此不作多讲。对域名的选择，这里给几个建议：


```
1. 域名尽量知其名闻其意，与网站内容贴切
2. 域名长度尽可能短，方便被大家记住
3. 域名尽量避免随机数字和英文结合，这样网站看似不正规，访客看到这个域名会误认为是诈骗网站
4. 个人博客域名推荐:.com、.cn、me、.studio等，同样遵循知其名闻其意的原则
```

# 域名解析

购买域名后，登录进入阿里云官网的[控制台](https://home.console.aliyun.com/?spm=5176.8142029.388261.21.ZtVm97)，在域名列表中可查看自己购买的域名：

![域名列表](http://upload-images.jianshu.io/upload_images/291600-cfe23d089a6d4fdf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

点击列表中对应的域名所在列的**解析**，进入解析界面：

![域名解析](http://upload-images.jianshu.io/upload_images/291600-eae597fd9e1173ad.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

点击**添加解析**按钮，如图依次输入：**CNAME**、**@**、**Github博客域名**。选择保存完成**域名向博客**的映射。添加解析后，在浏览器输入我们新注册的域名：

![404](http://upload-images.jianshu.io/upload_images/291600-b616fdfde172b082.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

看到网站报出了**404**错误，说明域名已经成功映射到了Github网站，但是找不到博客的位置，所以需要实现**博客向域名的映射**，进入Github博客的仓库：

![Github博客仓库](http://upload-images.jianshu.io/upload_images/291600-1018a6ad868b33fb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

点击上图上方偏右的**Create new file**按钮，创建一个文件：

![添加CNAME文件](http://upload-images.jianshu.io/upload_images/291600-6c333ca3e16743af.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

文件名为**CNAME**(注意：没有扩展名)，文件内容为**个人域名**(注意：没有**http://**，没有**www**)，然后选择下方的**Commit new file**按钮。然后在浏览器端重新输入我们的域名，我们可以看到域名绑定成功：

![域名绑定成功](http://upload-images.jianshu.io/upload_images/291600-1a71090ce0e60b84.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

但是这时候问题开始出现了。

# 问题及解决

当在本地使用`hexo deploy`命令再一次部署博客时，会发现博客网页的**css样式丢失**或是**404**错误，这是因为本地的博客工程里面还没有CNAME，重新部署后，远程的博客工程会和本地保持同步，将CNAME文件删除，所以本地也需要添加CNAME文件：

![本地添加CNAME文件](http://upload-images.jianshu.io/upload_images/291600-8463c624350132ed.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**注意**：CNAME文件添加的目录是在根目录下的source文件夹，而不是.deploy_git文件夹，完成添加后重新部署，博客网站即可恢复正常。

# 参考

* [github怎么绑定自己的域名？](https://www.zhihu.com/question/31377141)
* [hexo部署后，CNAME会被自动删除，怎么办？](http://www.zhihu.com/question/28814437)