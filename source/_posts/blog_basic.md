---
title: 全民博客时代的到来——20分钟简要教程
date: 2016-10-12 01:21:33
tags:
---

> **备注**：该教程基于Hexo 2.x版本。

# 背景叨叨叨

很久以前就想搭建一个个人技术博客的网站了，但是那时候接触的东西不多，没有听说过hexo、jekyll、wordpress等快速blog生成工具，自己在网上找了博客模板，修改了一下前端代码，用eclipse基于jsp搭建了一个小型博客发布到阿里云，但是时间久了发现自己写的代码不稳定，经常获取不到数据库数据，于是放弃了做个人博客网站的想法。

后来听说了hexo，但是一直没有定下心去看官方文档，于是搭博客网站的想法再一次不了了之。今晚闲暇，实在不知道该干什么，于是捡起了搭博客的想法，入门了hexo搭建github博客，现在记录下来，也算是作个念象，给想要搭建个人博客网站的小伙伴们一个参考。

PS: 因本人使用的是苹果机，所以本教程以Mac OS为参考，其实mac与windows搭建github博客相差无几，如果有用windows的小伙伴感到不适，可以参考《[手把手教你建github技术博客](http://www.jianshu.com/p/701b1095da11)》一文。

# 注册Github账号

这里我们就不多讲了，小伙伴们可以进入[官网](https://github.com)自行注册。

# 创建仓库

![图片来自Github](http://upload-images.jianshu.io/upload_images/291600-bf68e5e46e09a1a6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

登录账号后，在Github页面的右上方选择New repository进行仓库的创建。

![图片来自Github](http://upload-images.jianshu.io/upload_images/291600-7cec7b9f28359ea5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在仓库名字输入框中输入：

```
Github昵称.github.io
```

然后点击`Create repository`即可。

# 生成添加秘钥

在终端（Terminal）输入：

```
ssh-keygen -t rsa -C "Github的注册邮箱地址"
```

生成密钥的位置：

```
windows: C:/Users/用户名/.ssh/
mac: ~/.ssh/
```

> **温馨提示：**
> * .ssh文件为隐藏文件，需要先设置隐藏文件可见才可以看到
> * npm install时，出现npm error: RPC failed错误
将npm镜像修改为淘宝镜像，详细修改方式详见：http://blog.csdn.net/zhy421202048/article/details/53490247

一路`Enter`过来就好，待秘钥生成完毕，会得到两个文件**id_rsa**和**id_rsa.pub**，用带格式的记事本打开id_rsa.pub，Ctrl + a复制里面的所有内容，然后进入[https://github.com/settings/ssh](https://github.com/settings/ssh)：

![图片来自Github](http://upload-images.jianshu.io/upload_images/291600-3bff2a591beb2bb6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

将复制的内容粘贴到Key的输入框，随便写好Title里面的内容，点击`Add SSH key`按钮即可。

# 安装node.js

点击进入[node.js官网](https://nodejs.org/en/)

![图片来自node.js官网](http://upload-images.jianshu.io/upload_images/291600-90eef94fb6e1595f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

目前node.js有两个推荐版本，分为[通用版](https://nodejs.org/dist/v4.6.0/node-v4.6.0.pkg)和[最新版](https://nodejs.org/dist/v6.7.0/node-v6.7.0.pkg)，点击可直接进行下载。下载好后，按照既定的套路安装即可。

# 安装git

这里说的git实则是为了使用git指令，我们的git使用一般有两种方式，一种是**图形化界面（GUI）**，另一种是通过**命令行**，我们这里要使用的是后者，进入[git网站](http://git-scm.com/downloads)下载git的安装包。

![图片来自git](http://upload-images.jianshu.io/upload_images/291600-25cf02703765ff4e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 安装配置hexo

强调一下，这一步使我们搭建博客的核心，是重中之重。

![图片来自hexo](http://upload-images.jianshu.io/upload_images/291600-fc61b6d6d2b38fa2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
有能力的同学可以选择进入[官网](https://hexo.io)自行查看[hexo官方文档](https://hexo.io/docs/)，愿意听我叨叨的同学可以继续往下看。

接下来我们的操作都将在Terminal终端进行：

* 定位博客本地放置的路径

```
$ cd <文件夹>
```

![定位博客所在目录](http://upload-images.jianshu.io/upload_images/291600-7c0e65577b549a03.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**强调**：强烈建议 ***不要*** 选择需要管理员权限才能创建文件（夹）的文件夹。

* 下载安装hexo

```
$ npm install -g hexo-cli
```

安装好hexo以后，在终端输入：

```
$ hexo
```

若出现下图，说明hexo安装成功：

![hexo安装成功](http://upload-images.jianshu.io/upload_images/291600-34e4d1af45d6f267.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 初始化博客

```
// 建立一个博客文件夹，并初始化博客，<folder>为文件夹的名称，可以随便起名字
$ hexo init <folder>
// 进入博客文件夹，<folder>为文件夹的名称
$ cd <folder>
// node.js的命令，根据博客既定的dependencies配置安装所有的依赖包
$ npm install
```

初始化博客以后，我们可以看到博客文件夹里的文件是这样的：

![hexo博客文件夹](http://upload-images.jianshu.io/upload_images/291600-9b841f932140214d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 配置博客

基于上一步，我们对博客修改相应的配置，我们用到 **_config.yml** 文件，下面是该文件的默认参数信息：

```
# Hexo Configuration
## Docs: https://hexo.io/docs/configuration.html
## Source: https://github.com/hexojs/hexo/

# Site
title: # The title of your website
subtitle: # The subtitle of your website
description: # The description of your website
author: # Your name
language: # The language of your website
timezone: 

# URL
## If your site is put in a subdirectory, set url as 'http://yoursite.com/child' and root as '/child/'
url: http://yoursite.com/child
root: /
permalink: :year/:month/:day/:title/
permalink_defaults:

# Directory
source_dir: source
public_dir: public
tag_dir: tags
archive_dir: archives
category_dir: categories
code_dir: downloads/code
i18n_dir: :lang
skip_render:

# Writing
new_post_name: :title.md # File name of new posts
default_layout: post
titlecase: false # Transform title into titlecase
external_link: true # Open external links in new tab
filename_case: 0
render_drafts: false
post_asset_folder: false
relative_link: false
future: true
highlight:
  enable: true
  line_number: true
  auto_detect: false
  tab_replace:

# Category & Tag
default_category: uncategorized
category_map:
tag_map:

# Date / Time format
## Hexo uses Moment.js to parse and display date
## You can customize the date format as defined in
## http://momentjs.com/docs/#/displaying/format/
date_format: YYYY-MM-DD
time_format: HH:mm:ss

# Pagination
## Set per_page to 0 to disable pagination
per_page: 10
pagination_dir: page

# Extensions
## Plugins: https://hexo.io/plugins/
## Themes: https://hexo.io/themes/
theme: landscape

# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
  type: 
```

看到这里，大家千万别被一长串英文给吓到了，我们实际上要修改的配置只有几项，拿我自己的配置，我们继续往下看：

**1. 修改网站相关信息**

```
title: inerdstack
subtitle: the stack of it nerds
description: start from zero
author: inerdstack
language: zh-CN
timezone: Asia/Shanghai
```

language和timezone都是有输入规范的，详细可参考[语言规范](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)和[时区规范](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)。

**注意**：每一项的填写，其`:`后面都要保留一个空格，下同。

**2. 配置统一资源定位符（个人域名）**

```
url: http://inerdstack.com
```

对于root（根目录）、permalink（永久链接）、permalink_defaults（默认永久链接）等其他信息保持默认。

**3. 配置部署**

```
deploy:
  type: git
  repo: https://github.com/iNerdStack/inerdstack.github.io.git
  branch: master
```

其中repo项是之前Github上创建好的仓库的地址，可以通过如下图所示的方式得到：

![图片来自Github](http://upload-images.jianshu.io/upload_images/291600-973015a8b5aa2d03.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

branch是项目的分支，我们默认用主分支master。

# 发表一篇文章

在终端输入：

```
// 新建一篇文章
hexo new "文章标题"
```

我们可以在本地博客文件夹`source`->`_post`文件夹下看到我们新建的markdown文件。

![md文件](http://upload-images.jianshu.io/upload_images/291600-4d9ed33b20022819.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

用Markdown编辑器打开文件，我们可以看到这样的内容：

![md文件自动生成内容](http://upload-images.jianshu.io/upload_images/291600-b65250dd3ecb585b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们写下：

```
你好，欢迎来到我的个人技术博客。
```

![输入文章内容](http://upload-images.jianshu.io/upload_images/291600-9cc8db576372ccd9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

保存后，我们进行本地发布：

```
$ hexo server
```

如下图：

![本地发布博客](http://upload-images.jianshu.io/upload_images/291600-df83a54c79bcd507.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

打开浏览器，输入：

```
http://localhost:4000/
```

我们可以在浏览器端看到我们搭建好的博客和发布的文章：

![本地博客发布](http://upload-images.jianshu.io/upload_images/291600-2f95d22d612e8ad7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

当然，我们也可以手动添加Markdown文件在`source`->`_deploy`文件夹下：

![手动添加markdown文件](http://upload-images.jianshu.io/upload_images/291600-af309e593abd0efd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

其效果同样可以媲美`hexo new <article>`：

![本地发布效果图](http://upload-images.jianshu.io/upload_images/291600-7b0989c15dc7f538.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

但是毕竟我们目前发布的只有本机看得到，怎么让其他人看到我们写的博客呢？这时候我们来看看博客的部署。

我们只要在终端执行这样的命令即可：

```
$ hexo generate
$ hexo deploy
```

如果执行`deploy`指令时，出现如下的错误：

```
Deployer not found: git
```

需要另外安装**deployer git**，输入指令如下：

```
$ npm install hexo-deployer-git --save
```

然后再执行一次`deloy`指令即可。

这时候我们的博客已经部署到网上了，我们可以在浏览器地址输入栏输入我们的网址即可，如我的博客是：[inerdstack.github.io](https://inerdstack.github.io)。

![已发布的博客](http://upload-images.jianshu.io/upload_images/291600-e2bafa911bbd8582.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

本教程为博客搭建入门教程，大家可以根据自己的需求做进一步改进，如更换主题、删除文章等，详情参考[官方文档](https://hexo.io/docs/)。