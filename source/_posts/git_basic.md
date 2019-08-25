---
title: Git指令，版本管理神器——程序员的入门技能
categories:
  - 计算机外围技能储备
date: 2016-11-02 17:41:04
tags:
  - Git
---

在前面几篇中，笔者曾多次和大家提到过[Github网站](https://www.github.com)，作为全球最大的同性交友网站，想必，各位小伙伴们也是迫不及待地在这个网站上找到自己的知己。如同在百合网相亲一样，我们需要上传个人信息供其他人了解自己，在Github上，代码就是我们的名片。今天笔者带大家熟悉一下几个常用的Git指令。

# Git常用命令速查表

![](http://upload-images.jianshu.io/upload_images/291600-2a9d3e2e5ab123b8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这张表包含了大部分项目上传用到的命令，笔者将按照上传一个项目的流程过一下Git命令。

# 上传代码流程

## 注册Github账号

![注册Github账号](http://upload-images.jianshu.io/upload_images/291600-9378ea1489257a9e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

进入[Github网站](https://github.com/join?source=header-home)注册账号，注册流程在此不多讲解。

## 新建Github仓库

![新建Github仓库](http://upload-images.jianshu.io/upload_images/291600-2a347bace9ad7467.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**仓库**指的就是Github网站上存放代码的地方，每个项目一个仓库，点击[这里](https://github.com/new)新建项目。新建时，有一个**Initialize this repository with a README**选项，如果勾选，会在新建项目过程中生成一个**README.md**的文件，md指的是Markdown文件，其作用是对描述项目的，以比较有名的**ButterKnife**为例（如下图所示），将编辑好的Markdown文件命名为`README.md`，放到项目根目录即可。

![Butter Knife说明页](http://upload-images.jianshu.io/upload_images/291600-06f2a59451417656.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

新建完毕后，若出现下图所示内容，表示新建项目完毕：

![Github项目结构](http://upload-images.jianshu.io/upload_images/291600-928be475eb3f8c73.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 配置Git命令环境

Git命令需要在对应的环境下才能使用，下载配置Git命令环境，点击[这里](http://git-scm.com/downloads)进入Git下载页面：

![git下载页面](http://upload-images.jianshu.io/upload_images/291600-30404e246f38dc49.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 上传本地工程代码

笔者以安卓工程为例，打开命令行，进入项目根目录，进行如下操作：

```
// 进入项目根目录，当前项目名为Mitu，本地项目名和远程仓库的命长可以不一致
cd /Volumes/J_Eric/J_workRoom/AndroidStudio/MiTu
// 初始化本地项目的git，会在当前目录下生成一个.git文件夹，所有的git配置都在其中
git init
// 建立远程连接，项目连接可在Github相应目录下得到，如下图
git remote add origin https://github.com/inerdstack/MyFirstProject.git
// 添加账户信息：账户名
git config user.name "inerdstack"
// 添加账户信息：绑定的邮箱
git config user.email "wjnovember@gmail.com"
// 添加本地项目文件（夹子）,"."或"-A"表示添加所有文件
// 若添加个别文件，可以输入文件路径，多个文件之间以空格隔开
git add .
// 添加本次提交描述
git commit -m "我的第一次提交"
// 因为我们远程新建项目的时候，自动生成了README.md的文件
// 所以我们需要将远程的文件先拉到本地，与本地文件进行合并比较
// master表示项目的分支，默认主分支（master）
git pull origin master
// 拉到本地后，进行核查，如果文件不存在冲突，则进行上传，将本地项目推上去
git push origin master
```

![得到远程链接](http://upload-images.jianshu.io/upload_images/291600-98f7f51eb6b76365.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

至此，项目上传完毕，同时Github网站的仓库页面变成下图所示内容：

![远程代码](http://upload-images.jianshu.io/upload_images/291600-e3dc7fc8b2c5dd5b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

以上讲解的是HTTPS的上传方式，接下来讲解SSH的方式上传，与HTTPS基本一致，区别有以下两点：

* 在git push命令前添加项目的deploy key

![Add deploy key](http://upload-images.jianshu.io/upload_images/291600-d038979e60c3d045.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在Terminal中输入：

```
// 生成key
ssh-keygen -t rsa -C "Github的注册邮箱地址"
// 打开key文件所在的文件夹，默认路径：~/.ssh
open ~/.ssh
```

![.ssh文件](http://upload-images.jianshu.io/upload_images/291600-fd15bf59916887d6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

打开id_rsa.pub文件，复制所有内容，进入Github仓库里的Deploy key设置页面，点击**Add deploy key**，在key项粘贴复制的内容，输入标题（命名最好与目前设备相关），点击**Add key**完成key的添加。

* git remote add origin链接

如下图所示：

![SSH](http://upload-images.jianshu.io/upload_images/291600-f47bd3471980c035.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 创建分支

在实际开发中，开发者会把上线的代码和开发时的代码区分开，需要创建新分支（注意与默认的主分支`master`区别开），上线的代码放到主分支上，开发代码一般放在新分支，命名为`dev`（或其他名称）。

创建分支分两部分：

## 远程创建分支

![远程创建分支](http://upload-images.jianshu.io/upload_images/291600-0f70c61afef5332a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在远端的项目仓库中，点击branch，在输入框输入新分支的名称，按回车键完成远程分支的创建，新建的分支，其文件默认与master的一样。

## 本地创建分支并上传

打开Terminal，在本地项目根目录下，实现如下操作：

```
// 创建一个新的分支
git checkout -b "debug"
// 拉分支上的代码到本地，实现代码同步
git pull origin debug
// 推本地的代码到远程的分支
git push origin debug
```

# 克隆工程

开发过程中，当有新的成员加入时，需要拿到项目的代码，可使用**克隆**将远程的代码同步到本地，Terminal命令如下：

```
// 将远程的仓库克隆到本地
git clone https://github.com/inerdstack/MyFirstProject.git
// 若想远程克隆其他分支上的代码，则添加-b 分支名
git clone -b debug https://github.com/inerdstack/MyFirstProject.git
```

# 分支合并

当项目上线时，开发分支的代码同步到主分支，需要用到分支的**合并**，打开命令行，进行如下操作：

```
// 将当前分值切换到主分支
git checkout master
// 将次分支的文件合并到主分支
git merge origin/debug
```

通过以上指令，可以实现`debug`分支的代码向`master`分支的合并。

# 冲突解决

**文件冲突**在分支合并的时候会经常用到，比如A对x文件的第n行代码进行了更改，B对x文件的对应代码也进行了更改，当进行merge操作的时候就会发生冲突。这时候就需要A、B两名程序员针对冲突的地方进行沟通，达成一致修改方案后，对文件对应代码位置进行修改，标记冲突为`resolved`，文件的冲突状态消失，然后上传代码即可。