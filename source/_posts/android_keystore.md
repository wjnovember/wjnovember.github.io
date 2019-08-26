---
title: Android Keystore漫谈
categories:
  - Android开发从入门到炸机
date: 2017-12-19 23:39:50
tags:
  - Android开发
  - 数字签名
---

# 写在前面

今天使用高德地图为应用添加Key的时候，发现有一项需要用到安全码SHA1，而SHA1存在于Keystore中，遂简单地了解了一下Keystore。虽然之前实习开发中有用同事生成的Keystore对应用加过密，但是对它并不熟，今天以此文对Keystore的认识做一个记录，也希望可以给未接触过Keystore的小伙伴们作为参考。

# 为什么使用Keystore?

为什么使用Keystore？在回答这个问题前，我们先来看看Keystore是什么东西。我们都知道，古时丫鬟被买下时，主人要求丫鬟签写卖身契，表示这个丫鬟是老王头家的。Keystore就如同卖身契，表示这个APP是某一名开发者开发的。有了Keystore，开发者在发布自己的应用到市场时，就无需担心自己的APP被他人抢走了，因此使用Keystore很有必要。

那么Keystore怎么证明APP开发者的身份呢？在生成Keystore的时候，开发者会录入自己**姓名、单位、组织、所在城市、省份、国家代码**等信息以保证此Keystore是自己的，将录入自己信息的Keystore放入APP中，这样就可以保证这个APP是自己开发的了。

*此处添加[莫再讲xml](https://www.jianshu.com/u/f339f96aa3e3)对 **Keystore放入APP** 的纠正和补充*：

> Keystore 传统理解为密钥库，或者钥匙串。一个keystore里面可以放多组秘钥，每组密钥都有有效期、地址、公司等信息，可以通过别名来进行区分拿取。开发者将录入自己信息的秘钥（而非秘钥库Keystore）存入APP中，以认证此APP为自己开发。

Keystore可理解为一个容器，存放开发者信息、私钥、公钥的容器。乍一听，未接触过密码学的小伙伴们可能会对这些名词感到陌生，接下来我们来简单了解一下Keystore相关名词。

# 名词解释

## 加密

为了防止我的信息数据被不想看到的人看到，用特殊的算法打乱（信息内容的改变，而非简单的顺序改变）原来的信息数据，使他人即使得到打乱后的信息数据也无法理解其中的含义。

## 解密

为了看懂被打乱的信息数据，使用特殊的算法将打乱后的信息数据还原成原来的内容，以理解其中的含义。

## 实体

原始未被打乱的信息数据，密码学称之为**明文**，在Keystore里面我们称之为**实体**。

## 公钥

加密过程中，算法为了提高其加密程度，传入一个参数，使同一个算法在不同参数的作用下产生不同的加密效果。公钥持有者一般为群体，其作用是**验证**与**加密**。

## 私钥

通过传入与公钥钥配对的私钥到算法中，实现解密的效果。一般私钥由个人持有，需妥善保管，不可告诉他人，其作用是**解密**与**签章**。关于私钥、公钥的知识，在此不做过多讲解，引用[公钥和私钥](http://blog.csdn.net/tanyujing/article/details/17348321)中的内容，相信小伙伴们会有点收获。

> 比如说，我要给你发送一个加密的邮件。首先，我必须拥有你的公钥，你也必须拥有我的公钥。<br/>
首先，我用你的公钥给这个邮件加密，这样就保证这个邮件不被别人看到，而且保证这个邮件在传送过程中没有被修改。你收到邮件后，用你的私钥就可以解密，就能看到内容。<br/>
其次我用我的私钥给这个邮件加密，发送到你手里后，你可以用我的公钥解密。因为私钥只有我手里有，这样就保证了这个邮件是我发送的。

## 数字签名

实体经私钥加密后得到的数据。它可以通过公钥来解密，从而将解密后的内容与实体进行比对，来验证信息数据是否被篡改过。关于数字签名更深入的了解，可参考《[一文读懂数字签名](https://wjnovember.github.io/digital-signature)》一文。

## 别名

用来区分Keystore的唯一标识（字符串）。

# 默认Keystore和自定义Keystore

通过对Keystore相关名词的了解，我们大致清楚Keystore其实就是验证APP开发者身份的一个文件。Keystore分为默认Keystore和自定义Keystore，通常应用发布时不用默认的Keystore，因为它不包含开发者的有效信息，且密码是android，任何人都可通过keytool指令对其内容进行修改，无法验证APP的有效性。默认Keystore的存放位置为`$HOME/.android/debug.keystore`，若Android Studio打包签名apk的时候未找到默认的Keystore时会自动创建它。自定义Keystore可使用Keytool指令或Android Studio来生成，接下来我们来了解自定义KeyStore的生成方式。

# Keytool指令参数

Keytool是一个很有用的安全钥匙和证书的管理工具，使用该指令可实现密钥库（Keystore）的创建和查看等操作。我们先来看一下Keytool指令相关的参数。

> **-genkey**<br/>
在用户主目录中创建密钥库（Keystore），后缀名为.keystore。<br/>
**-alias** [alias]<br/>
产生别名，后面跟别名内容。若未指定，则别名默认为mykey.<br/>
**-keystore**<br/>
指定.keystore文件的名称，如：<br/>
`keytool -genkey -keystore dmkf.keystore`<br/>
用户主目录中会产生名称为**dmkf.keystore**的Keystore文件。若未使用该参数，则文件名默认为**.keystore**。<br/>
**-keyalg** [DSA/RSA]<br/>
指定密钥的算法，未指定时默认为DSA算法。<br/>
**-validity**<br/>
指定创建的证书有效期，单位为**天**。未指定时默认为1天。<br/>
**-dname**<br/>
证书持有者（APP开发者）信息。<br/>
CN：名字或姓氏<br/>
OU：组织单位名称<br/>
O：组织名称<br/>
L：城市或区域名称<br/>
ST：州或省份名称<br/>
C：单位的两字国家代码<br/>
**-list**<br/>
显示证书信息。<br/>
**-v**<br/>
显示证书详细信息。<br/>
**-export**<br/>
结合**-alias**导出指定的证书信息。如：<br/>
`keytool -export -alias dmkf -keystore dmkf.keystore -file D:/mykeystore/myexport.crt`<br/>
**-import**<br/>
将已签名的证书导入到密钥库，如：<br/>
`keytool -import -alias dmkf -keystore mystore.keystore -file D:/mykeystore/myanother.crt`<br/>
**-keysize**<br/>
指定密钥长度。<br/>
**-storepass**<br/>
操作密钥库所需的密码。<br/>
**-storepasswd**<br/>
修改操作密钥库所需的密码。<br/>
**-keypass**<br/>
指定别名条目的密码（私钥的密码）。<br/>
**-keypasswd**<br/>
修改指定别名条目的密码。<br/>
**-file**<br/>
结合**-export**，指定导出的证书位置及证书名称。<br/>
**-delete**<br/>
删除密钥库中某一条目。如：<br/>
`keytool -delete -alias dmkf -keystore dmkf.keystore`<br/>
**-printcert**<br/>
查询导出的证书信息，如：<br/>
`keytool -printcert -file D:/mykeystore/dmkf.crt`<br/>

# 常用Keytool指令操作

## 创建Keystore文件

生成一个别名为`dmkf`，名为`dmkf.keystore`的文件。

```
keytool -genkey -alias dmkf -keystore dmkf.keystore -keyalg RSA
```

## 查看Keystore文件

查看名为`dmkf.keystore`的Keystore文件信息。

```
keytool -list -v -keystore dmkf.keystore
Enter keystore password: ****（输入Keystore操作密码）
```

## 输出Keystore证书

从密钥库`dmkf.keystore`中导出别名为`dmkf`的证书到`dmkf.crt`文件中（导出的证书中包括主体信息和公钥）。

```
keytool -export -alias dmkf -keystore dmkf.keystore -file dmkf.crt
Enter keystore password: ****（输入Keystore操作密码）
```

## 查看导出的证书信息

查看导出并保存在`dmkf.crt`文件中的证书信息。

```
keytool -printcert -file dmkf.crt
```

## 导入证书

从名为`dmkf.crt`文件中取出别名为`dmkf`的证书信息导入到名为`truststore.keystore`密钥库中。

```
keytool -import -alias dmfk -keystore truststore.keystore -file dmkf.crt
```

# Android Studio生成Keystore

打开Android Studio，在菜单栏中找到`Build`，单击弹出下拉框，选择`Generate Signed APK...`。

![Generate Signed APK...](http://upload-images.jianshu.io/upload_images/291600-b42dfbdbddc4cbd2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

选择`app`，单击Next按钮。

![Generate Signed APK](http://upload-images.jianshu.io/upload_images/291600-6b3fa8642e7f3d56.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

单击Create new...按钮。

![Generate Signed APK](http://upload-images.jianshu.io/upload_images/291600-70d3d4a88f0beaf3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在弹出的New Key Store窗口中选择Keystore存放路径，设置Keystore密码、别名、别名密码、有效期以及个人信息，单击OK按钮完成Keystore的创建。

![New Key Store](http://upload-images.jianshu.io/upload_images/291600-b3453c70b6a474ed.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

此时Android Studio自动填充新建的Keystore相关信息，至此Android Studio已完成Keystore的创建。若想用这个Keystore继续打包APK，单击Next按钮。

![Generate Signed APK](http://upload-images.jianshu.io/upload_images/291600-e851e470bc74f29f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

设置密码数据库的密码，单击OK按钮，进入下一步。

![设置密码数据库的密码](http://upload-images.jianshu.io/upload_images/291600-9c7bc41de08a6c83.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

选择好APK导出的位置和编译方式（发布/调试），单击Finish按钮完成APK的打包。

![Paste_Image.png](http://upload-images.jianshu.io/upload_images/291600-fcfa9bc32e7b6f81.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

在项目根目录的`app`文件夹里可以找到命名为`app-release.apk`的apk文件。

![生成apk](http://upload-images.jianshu.io/upload_images/291600-214f8c31ceeb71ea.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

以上就是本次Keystore漫谈的所有内容，有不准确的地方，欢迎在文章下方的评论处评论指正！

# 参考

* [android keystore sha1 md5的理解](http://blog.csdn.net/yangsainan/article/details/40820699)
* [Android Studio中的keystore](http://blog.csdn.net/wf632856695/article/details/51193885)
* [Android Studio 默认keystore 以及自定义keystore](http://blog.csdn.net/nimasike/article/details/51457229)
* [Andriod Studio debug.keystore(默认)和如何生成自定义的keystore 以及如何生成数字签名](http://blog.csdn.net/u012005313/article/details/48577751)
* [android keystore sha1 md5的理解](http://blog.csdn.net/yangsainan/article/details/40820699)
* [keystore 介绍](http://marlay.iteye.com/blog/1402264)
* [关于keystore的简单介绍](http://blog.csdn.net/dotuian/article/details/51722300)