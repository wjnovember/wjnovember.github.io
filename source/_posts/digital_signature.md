---
title: 一文读懂数字签名
categories:
  - Android开发从入门到炸机
date: 2017-12-22 21:15:48
tags:
  - 数字签名
---

# 前情提要

在写上一篇《[Android Keystore漫谈](https://wjnovember.github.io/android_keystore)》时对数字证书和数字签名的区别感觉模棱两可，于是网上找了找资料发现了一篇简单易懂的文章，对证书和签名有了一个较清晰的概念：

## 数字签名

信息实体经HASH函数后得到一个摘要，摘要经过私钥加密后形成数字签名。

## 数字证书

证书中心的信息+个人的信息+个人的公钥，经过证书中心的私钥加密后，得到数字证书。

虽然CSDN博客上已经有人对这篇文章翻译过，但是感觉还是有必要自己翻译一遍，一来作为备份，二来也希望可以为简书用户们认识数字签名提供一个参考。

# 翻译内容

## 主标题

数字签名是什么？

## 副标题

数字签名的介绍

## 作者

David Youd

## 原文链接

http://www.youdzone.com/signature.html

## 译文

![](http://upload-images.jianshu.io/upload_images/291600-88d27e869dc4861f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

Bob有两把钥匙，一把叫做**公钥**（公共密钥），另一把叫做**私钥**（私有密钥）。

![](http://upload-images.jianshu.io/upload_images/291600-58255a654264fca0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

Bob的**公钥**是可以给任何人的，但是**私钥**只能自己持有。密钥的作用是加密信息，加密信息意味着打乱信息，所以只有拿着密钥的人才可以解密这些加密的信息。公钥和私钥任意一个都可以用来加密，而另一个用于解密。比如：

Susan喜欢Bob，想约会Bob，给Bob写了一封信，并用Bob的公钥对信进行加密，Bob收到信后用私钥解密后就可以看到信的内容，于是准备约会。Bob完全不用担心信落到其他同事的手里，因为信是加密过的，没有私钥，是无法解读的。

![](http://upload-images.jianshu.io/upload_images/291600-0f3885f6679b4cca.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

Bob给Susan回信约好午餐的时间，但是担心回信在回寄过程中被篡改，于是采用**数字签名**的方式。**数字签名**相当于Bob的私人印章，是独一无二、不可以仿冒的，可以检查信的内容有没有被篡改。

![](http://upload-images.jianshu.io/upload_images/291600-6b9b95469064e753.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

那么这个**数字签名**是怎么签名的呢？Bob使用**HASH**算法对信的内容进行打乱，打乱后的内容称之为**消息摘要**（这一打乱的过程是不可逆的）。

![](http://upload-images.jianshu.io/upload_images/291600-94ba938cb29c6fe9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

消息摘要经过Bob的私钥加密就变成了**数字签名**。

![](http://upload-images.jianshu.io/upload_images/291600-7e2ff0edf2f08ad7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

最后Bob将这个数字签名和信的内容放到了一起，然后发给了Susan。那么Susan怎么验证Bob的回信有没有被篡改过呢？首先Susan用Bob的公钥解密数字签名，形成了**消息摘要A**，然后通过HASH算法对信的原始内容进行打乱形成**消息摘要B**，如果两份信息摘要内容一致，说明信息没有被篡改过。

![](http://upload-images.jianshu.io/upload_images/291600-ddd31533aeae7bb6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

但是这时候Bob坏坏的基友Doug吃醋了，不想让他们的约会成功。 于是偷偷地使用Susan电脑将Bob的公钥掉包，导致Susan怀疑正确的信内容被篡改。

![](http://upload-images.jianshu.io/upload_images/291600-23761b197d518ecd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

所幸Susan刚好在证书权威中心工作，她用Bob的信息、公钥以及证书中心的信息通过证书中心的私钥加密形成了一份**数字证书**。

![](http://upload-images.jianshu.io/upload_images/291600-b0222651fa9dbbdc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这样Bob再发送消息给其他人，只要附加上**数字证书**，收信人便可检查公钥是否被篡改以进行正确的解密。那么收件人如何确认公钥正确呢？

首先使用证书中心的公钥进行解密得到证书中心信息，查看证书中心是否是受信任的权威中心，然后检查证书中的个人信息是否是Bob的信息以确认证书中的公钥是否为Bob的公钥，当确认正确后可使用Bob的公钥进行信息完整性的验证。

# 写在最后

本来打算照着原文的原话进行翻译，但是翻译过程中发现以翻译的习惯来写这篇文章会让语言变得拗口，所以仅以半翻半掰的方式将翻译内容描述完整。关于数字证书有一个非常好的实例，便是**https协议**，在《[数字签名与数字证书的区别](http://blog.csdn.net/until_v/article/details/40889565)》一文中有非常清晰的讲述。

# 参考

* [What is a Digital Signature?](http://www.youdzone.com/signature.html)
* [数字签名与数字证书的区别](http://blog.csdn.net/until_v/article/details/40889565)