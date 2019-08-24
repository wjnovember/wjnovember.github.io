---
title: 2小时还你一个集打赏、评论、RSS功能于一身的个性化博客
date: 2017-03-13 13:15:43
tags: 
categories:
- 零基础学习博客搭建
---

> **备注**：该教程基于Hexo 2.x版本。

# 前情提要

几个月前，写过几篇关于[Hexo博客搭建的教程](https://wjnovember.github.io/2016/10/12/blog_basic/)，最近几天，发现有一些读者私信一些Hexo搭建过程中遇到的问题，于是笔者重新燃起Hexo博客的兴趣，花了一两天的时间重新将Hexo博客搭建了一下，并通过配置实现了一些附加功能，写下此篇教程，希望可以帮助读者们深入了解Hexo博客的使用。

本篇教程基于NexT主题的博客配置，实现更换主题、评论、打赏等功能，接下来根据这些功能进行分点描述。

# 搭建基本Hexo博客

Hexo博客基本搭建参考：《[全民博客时代的到来——20分钟简要教程](https://wjnovember.github.io/2016/10/12/blog_basic/)》一文，笔者按照教程的顺序一步一步来，是没有出现错误的，如果读者们在搭建的时候遇到了问题不知如何解决，可以自行查阅网上资料，或私信笔者。

# Hexo博客绑定域名
关于Hexo博客如何绑定自己的域名，详情可参阅《[域名绑定，让你的博客拥有自己的个性](https://wjnovember.github.io/2016/10/14/blog_domain/)》一文。

# 更换Hexo主题

笔者更换后的主题为[NexT](https://github.com/iissnan/hexo-theme-next)。首先将NexT的主题源文件下载到本地，可使用Git克隆指令或直接在网页上通过Zip包的形式下载，Git指令如下：

```
git clone https://github.com/iissnan/hexo-theme-next
```

下载后，将压缩包解压缩，将根目录文件夹的名称修改为`next`，并将其移到Hexo的主题目录下，主题目录的路径为：

```
Hexo博客根目录/themes/
```

效果如下图所示：

![NexT主题包](http://upload-images.jianshu.io/upload_images/291600-b83b62262041a552.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在Hexo根目录下有一个以`_config.yml`命名的文件（下称**站点配置文件**），用文本编辑器打开，在其中找到`theme`属性，将其由`landscape`改为`next`。

![修改主题](http://upload-images.jianshu.io/upload_images/291600-e53768fa6014081b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

然后在Hexo根目录执行**部署Hexo**指令：

```
// 清理缓存
hexo clean
// 生成文件
hexo generate
// 部署
hexo deploy
```

随即，可在远程的博客上看到修改主题后的样式。

![NexT主题样式](http://upload-images.jianshu.io/upload_images/291600-a98ec710fd6b30b5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

# 设置Hexo主题模式

Hexo主题支持多种不同的模式，通过配置，让NexT主题显示不一样的样式。在NexT根目录下有一个同样名为`_config.yml`的配置文件，为了区分hexo根目录下的`_config.yml`，将前者称为**主题配置文件**，在其中找到`scheme`属性，如下图所示：

![scheme属性](http://upload-images.jianshu.io/upload_images/291600-6322b239804a6b9e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

NexT主题默认使用`Muse`模式，读者可根据自己的喜好，选择其中一种模式。
> **温馨提示：** 在不想要效果的一行最前面加上`#`，在想要的效果一样去掉最前面的`#`。

# 设置预览摘要

设置完模式后，读者们会发现，首页文章列表中，每一篇文章都显示了所有内容，看起来不舒服，这时可以启用预览摘要模式，在**主题配置文件**中找到`auto_excerpt`属性，将`enable`设置为`true`，`length`表示预览显示的最大字数，如下图所示：

![设置预览摘要](http://upload-images.jianshu.io/upload_images/291600-1abc682d4f4c9d0c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

设置完毕后，调用**部署指令**：

```
// 清理缓存
hexo clean
// 生成文件
hexo generate
// 部署
hexo deploy
```

> **温馨提示：** 上述的部署指令中`hexo deploy`可以换成`hexo server`，两者的区别在于，前者是将博客部署到远程的Github上，而后者是运行在本地，通过`http://localhost:4000`在浏览器中访问，方便调试，但是最终本地博客还是需要`hexo deploy`指令将其部署至Github上。

# 添加评论功能

NexT目前出到5.1.0版本，功能模块已经相当的丰富。NexT主题集成了评论系统，只需要设置相关的属性即可实现功能，其目前支持**多说**、**Disqus**、**Facebook评论**、**Hyper评论**、**网页云跟帖**等，其中“多说”是NexT推荐的评论系统，但是多说评论系统不稳定，经常会出现服务异常等问题：

![“多说”服务异常](http://upload-images.jianshu.io/upload_images/291600-aae8029a499ce300.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/350)

所以笔者查阅了网上，找到了另一款名为**友言**的评论系统，它也是NexT集成自带的，可以直接拿来用的。下面对其配置进行讲解：

## 注册友言账号

打开[友言官网](http://www.uyan.cc/)，注册账号，再次不作过多讲解。

## 获取uid

注册完登录后，在首页单击**后台管理**按钮，进入后台界面可看到用户ID，将其复制下来。

![获取uid](http://upload-images.jianshu.io/upload_images/291600-d01c7b97bd74641f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/300)

## 设置uid

打开**主题配置文件**，找到属性`youyan_uid`，然后在`:`后添加之前复制的uid：

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/291600-b4fe31987d2d2820.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> **温馨提示**：所有属性的设置，`:`后必须有一个空格。

使用hexo指令部署博客，可看到实现的评论功能，如下图所示：

![友言评论功能](http://upload-images.jianshu.io/upload_images/291600-7c3ee709ce89010e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

> **温馨提示：** 在笔者配置评论功能的时候，笔者遇到了一个问题：*本地博客有评论功能，而远程博客却没有* 。折腾了一下午，始终不知原因。后来，当笔者对博客绑定自己的域名后，发现远程的博客自动出现了评论功能，这里不清楚是域名的缘故还是*hexo generate*存在未刷新的缘故。若读者们遇到这个情况，可以先放放，配置其他功能。

# 添加打赏功能

打赏是笔者协作的强大动力，写作的同时可以收到一笔打赏小费，那是再好不过！这里讲解一下打赏功能的实现，其本质是放一张收款二维码图片。

## 获取微信收款二维码

微信二维码的获取途径还是比较容易的，按照[这个教程](http://jingyan.baidu.com/article/b907e627b641b646e6891c6b.html)即可实现，读者们也可以预先设置收款的金额。

## 获取支付宝收款二维码

笔者上网查了很多关于支付宝收款二维码的相关信息，奈何得到的结果不是版本不一致就是商家认证，找了好久，终于找到一个符合要求的[教程](http://blog.csdn.net/china8848/article/details/53504223)，读者们可别被“商家平台”这几个字吓到了，普通用户一样可以开通，且不需要相关证件的认证，读者们可根据这个教程获得自己的支付宝收款二维码。

## 添加二维码图片资源

将二维码图片放到`NexT根目录/source/images/`文件夹下即可。

## 开启打赏功能

找到**主题配置文件**，在最后添加打赏的配置信息:

```
reward_comment: 打赏文字提示
wechatpay: 图片链接或图片相对路径
alipay: 图片链接或图片相对路径
```

信息配置如下图：

![开启打赏功能](http://upload-images.jianshu.io/upload_images/291600-406e48d89492c2a8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

效果图如下：

![打赏功能效果图](http://upload-images.jianshu.io/upload_images/291600-873b0d38fcc6adfe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

# 设置侧边栏显示效果

鉴于个人喜好，笔者不是很喜欢在打开一篇文章的时候，刚想好好品读，却因为侧边栏的出现扰乱视觉，所以想对侧边栏的显示进行设置。

![侧边栏在文章加载好时出现](http://upload-images.jianshu.io/upload_images/291600-3e0dec2281c46e83.gif?imageMogr2/auto-orient/strip)

在**主题配置文件**中，找到`sidebar`的`display`属性，`display`属性有四种显示模式：分别为：

```
post    // 默认显示方式
always  // 一直显示
hide    // 初始隐藏
remove  // 移除侧边栏
```

笔者将其设置为`hide`模式，如下图所示：

![设置侧边栏显示效果](http://upload-images.jianshu.io/upload_images/291600-19c1082a43fbac79.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

读者们可根据个人喜好进行设置。

# 添加菜单选项

默认情况下，菜单导航栏有**首页**、**归档**、**关于**三个选项，此外笔者还添加了**分类**、**标签**。在**主题配置文件**中，找到`menu`属性，并去掉`categories`、 `tags`的的注释（前面的`#`），如下图所示：

![菜单选项设置](http://upload-images.jianshu.io/upload_images/291600-6c0f70e126d3d214.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

然后在Hexo根目录执行指令如下：
```
// 添加分类页面
hexo new page "categories"
// 添加标签页面
hexo new page "tags"
// 添加关于页面
hexo new page "about"
```

在`Hexo根目录/source/`文件夹下创建三个文件夹，命名分别为：categories、tags、about文件夹，在这些文件夹中分别会创建一个以`index`命名的Markdown文件，对这三个Markdown文件内容进行修改，使之分别为：

```
---
title: 分类
date: 2017-03-12 22:06:24
type: "categories"
---
```

```
---
title: 标签
date: 2017-03-12 17:27:16
type: "tags"
---
```

```
---
title: 关于
date: 2017-03-12 22:07:26
type: "about"
---
```

完成文件的修改，部署Hexo即可。

# 添加搜索功能

![导航菜单栏](http://upload-images.jianshu.io/upload_images/291600-39c0a90a589b5ed4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/350)

搜索功能源于第三方服务——**Algolia**，接下来看看配置：

## 注册Algolia，创建Index

在[Algolia官网](https://www.algolia.com/)注册一个账户，完成账户注册后，创建Index，如下图：

![创建Index](http://upload-images.jianshu.io/upload_images/291600-7d845e9f7813684a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/500)

## 安装Hexo Algolia

在Hexo根目录执行如下指令，进行Hexo Algolia的安装：

```
npm install --save hexo-algolia
```

若出现安装失败，或发现安装成功后搜索功能可以搜索但是不可以点击搜索到的文章，是因为5.1.0版本NexT在`package.json`文件的配置中存在错误。到Hexo的根目录，在其中找到`package.json`文件，修改其中的`hexo-algolia`属性值为`^0.2.0`，如下图所示：

![修改package.json文件](http://upload-images.jianshu.io/upload_images/291600-80a532accf68abe8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
"hexo-algolia": "^0.2.0"
```

然后重新执行安装指令。

## 获取Key，修改站点配置

完成Hexo Algolia后，回到Algolia官网的Dashboard，在左侧导航栏选择`API Keys`，跳转到如下页面：

![获取Key](http://upload-images.jianshu.io/upload_images/291600-2f482b12b6e5ed3a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

基于这个页面的Key，编辑**站点配置文件**，在文件内容最后添加如下图所示的信息，包括 `ApplicationID`、`Search-Only API Key`、 `Admin API Key`和`indexName`，其中`apiKey`就是`Search-Only API Key`：

![Algolia配置信息](http://upload-images.jianshu.io/upload_images/291600-db3e4570db72fe5a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 更新Index

配置好Key后，在Hexo根目录执行`hexo algolia`更新Index，若出现下图所示内容，则表示更新成功：

![更新Index](http://upload-images.jianshu.io/upload_images/291600-f76e6a040c19eef5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

若更新失败，则返回上面**安装Hexo Algolia**的步骤，查看一下hexo-algolia是否安装成功，并核实一下package.json信息是否正确。

## 启用配置搜索功能

打开**主题配置文件**，找到`algolia_search`属性，将其`enable`子属性改为`true`，再找到其子属性`labels`，修改相应的提示文本，使之更加适合自己的风格，属性配置如下图所示：

![启用配置搜索功能](http://upload-images.jianshu.io/upload_images/291600-e3bffdb065acdff8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

部署Hexo，可在博客中看到效果如下：

![找到搜索结果](http://upload-images.jianshu.io/upload_images/291600-20222e583f1f4c61.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

![未找到搜索结果](http://upload-images.jianshu.io/upload_images/291600-a3c8fd57e38b785c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

# 添加阅读次数统计

笔者以为，写技术博客一方面作为个人知识积累外，更重要的是让读者通过阅读有所收获。阅读量作为评价一篇文章质量好坏的参考因素，可以为作者继续创作带来信心。阅读次数统计是基于第三方服务——**LeanCloud**实现的，配置详情如下：

## 创建LeanCloud账号

进入[LeanCloud官网](https://leancloud.cn/)，完成注册。

## 创建应用

登录LeanCloud，进入控制台，单击**创建应用**按钮，输入新应用名称，选择**开发版**，单击**创建**按钮完成创建，如下图所示：

![创建应用](http://upload-images.jianshu.io/upload_images/291600-a114303ec633d628.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

## 创建Class

进入到刚刚创建的应用中，选择左侧导航栏的**存储**，点击**创建Class**，将Class名称填为`Counter`，选择**无限制**选项，然后单击**创建Class**按钮完成Class的创建，如下图所示：

![创建Class](http://upload-images.jianshu.io/upload_images/291600-47b6f370eeb9384f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

点击创建好的Counter其本质是一张结构表，用来记录文章的浏览量，如下图所示），这里的表可以直接对文章阅读次数进行修改，所以如果想要追求阅读次数，可以在表上直接进行修改。

![Counter表](http://upload-images.jianshu.io/upload_images/291600-ebe85e15adad1960.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

## 配置Key

在左侧导航栏的设置界面，单击**应用Key**可以看到应用的`App ID`和`App Key`。

![Key](http://upload-images.jianshu.io/upload_images/291600-9bfefff56f9884d3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

复制ID和Key，然后将其配置到**主题配置文件**中。在文件中找到`leancloud_visitors`属性，将`enable`设置为`true`，粘贴之前复制的ID和Key粘贴到相应的属性中。

![配置ID和Key](http://upload-images.jianshu.io/upload_images/291600-0a317ed31a11027a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

至此，阅读次数统计添加完成，其效果图如下所示：

![添加阅读次数统计](http://upload-images.jianshu.io/upload_images/291600-961cf82d2e506b28.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/600)

# 添加RSS

RSS是一种订阅方式，可以方便读者获取博客的最新内容，话不多说，先配置，再来看效果。

## 安装 [hexo-generator-feed](https://github.com/hexojs/hexo-generator-feed) 插件

RSS需要Feed链接，通过`hexo-generator-feed`插件来生成。在Hexo根目录执行安装指令：

```
npm install hexo-generator-feed --save
```

## 配置feed信息

在**站点配置文件**中追加配置信息，如下图所示：

![RSS配置](http://upload-images.jianshu.io/upload_images/291600-48049f258dfded85.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

`feed`属性下的各个子属性的含义，feed官方给出的解释如下：
* type - Feed type. (atom/rss2)
* path - Feed path. (Default: atom.xml/rss2.xml)
* limit - Maximum number of posts in the feed (Use 0 or false to show all posts)
* hub - URL of the PubSubHubbub hubs (Leave it empty if you don't use it)
* content - (optional) set to 'true' to include the contents of the entire post in the feed.

配置后，效果如下：

![RSS效果](http://upload-images.jianshu.io/upload_images/291600-b978ffc2b560c77c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

单击RSS按钮，跳转如下界面：

![](http://upload-images.jianshu.io/upload_images/291600-0a280494cde74c9f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

若点击订阅的文章出现无法访问的情况，可检查域名是否有过改动。

# 添加社交链接

社交链接可以是Github链接、其他博客平台链接、技术栈链接等。配置步骤如下：

## 添加链接

在**主题配置文件**中找到`social`属性，在下方添加社交链接，格式为：

```
社交平台名称：链接
```

笔者添加的内容：

![添加社交链接](http://upload-images.jianshu.io/upload_images/291600-132c68eec03fb97e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 添加链接图标

读者们可根据自己喜好，选择是否启用显示链接的图标。链接的图标全部来自于[Font Awesome](http://fontawesome.io/) ，配置方式也很简单，在**主题配置文件**中找到`social_icons`，修改其状态值为`true`，然后配置对应链接的图标，格式为：

```
社交平台名称: Font Awesome中的图标的名字（区分大小写）
```

如下图所示：

![添加链接图标](http://upload-images.jianshu.io/upload_images/291600-6996375a604d5e7c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如笔者添加的社交链接是Font Awesome平台没有的图标，博客中会显示默认的图标：

![默认图标](http://upload-images.jianshu.io/upload_images/291600-f644825841dbb010.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 添加友情链接功能

笔者身边有很多志同道合的好友，也都有用其他框架搭建的博客，写的文章多了，希望可以获得更多的流量，这时好友之间就可以互相帮忙，在自己的博客上添加好友的博客链接。接下来看一下友情链接的配置：

在**主题配置文件**中找到`links`属性，修改`links_title`属性的值为“友情链接”（也可以是其他文案），然后添加上好友的博客名称和博客地址，格式如下：

```
博客名称: 博客链接
```

笔者的配置信息：

![](http://upload-images.jianshu.io/upload_images/291600-2b48ae358539d93f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

部署Hexo，效果如下：

![友情链接](http://upload-images.jianshu.io/upload_images/291600-004e6ede8b77527c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 写在后面

其实笔者本篇教程是在阅读完NexT的官方配置文档后写的，考虑到文档内容较多，且其中很多功能一般用不到，就挑选了一些常用的功能。对于本文描述不清楚的地方，有疑问的读者们，可在文章下方留言，亦可参阅官方文档进行对比配置，最后附上官方文档的链接供读者们参阅：
http://theme-next.iissnan.com/