---
title: 树莓派远程及文件传输：以呼吸参数测量及获取为例
categories:
  - 软科生玩硬件
date: 2016-08-04 16:03:20
tags:
  - 树莓派
---

# 所需设备

* 野生的**树莓派**一只
* 萌萌哒**windows 10台式机**一个
* 装有**raspbian系统**的胖胖的**4G SD卡**一张
* 名字有点长  的**Micro HDMI USB充电线**一条
* **输出5V = 2A充电头**（装逼名称：**变压器**）一枚
* 另加一连串乱七八糟的**硬件电路板**加**导联线**
* 一个被笔者落下的**显示屏**（可以直接使用台式机的显示屏）

# 设备图片

![野生的树莓派](http://upload-images.jianshu.io/upload_images/291600-c312b2bc731fca8b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![翻个个儿的野生的树莓派](http://upload-images.jianshu.io/upload_images/291600-193659e17fb76eba.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![萌萌哒windows 10台式机](http://upload-images.jianshu.io/upload_images/291600-794069a82dc40a02.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![肥肥的4G SD卡](http://upload-images.jianshu.io/upload_images/291600-790649b467bc93af.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![身姿妖娆的Micro HDMI USB充电线](http://upload-images.jianshu.io/upload_images/291600-41b2b922038b8efc.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![学名“变压器”的充电头](http://upload-images.jianshu.io/upload_images/291600-8f966443f413d49d.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![一堆不知名的硬件](http://upload-images.jianshu.io/upload_images/291600-9c4e512e911f6913.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![我们的主角：气流感应器](http://upload-images.jianshu.io/upload_images/291600-f93e1ac66f1b5166.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 树莓派知识储备

戳这里==> [树莓派菜鸟入门攻略](http://www.tuicool.com/articles/RBVNfef)

# 组装

完成图如下：

![组装完成](http://upload-images.jianshu.io/upload_images/291600-0c57905494ca7321.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

组装主要操作：

* 将Rj-45水晶头网线插到树莓派的以太网接口中
* 将两块硬件电路板按照引脚的位置插到树莓派上
* 接通树莓派的电源
* 插上装有raspbian操作系统的SD卡

当看到指示灯如下图亮起时，树莓派硬件层即组装完成：

![四盏指示灯（橙黄、闪绿、绿、红）全部亮起，说明我们的树莓派已组装完成](http://upload-images.jianshu.io/upload_images/291600-0eef5914d755e11f.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 树莓派网络配置

在组装完树莓派以后，需要树莓派变成“中央空调”：让其他电脑都可以通过远程/局域网来访问控制树莓派。

**首先**，需要给树莓派接上显示屏，配置树莓派的网络参数。

![raspberian系统GUI显示屏](http://upload-images.jianshu.io/upload_images/291600-b26d5646b9bda0c6.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**然后**，打开命令行，使用指令修改或获取树莓派的IP地址。

* 打开命令行

![raspberian命令行](http://upload-images.jianshu.io/upload_images/291600-8f8da77b8be351fb.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![raspberian命令行](http://upload-images.jianshu.io/upload_images/291600-1453a29764bf051b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 通过命令行，进入/etc/network文件夹

![进入/etc/network文件夹](http://upload-images.jianshu.io/upload_images/291600-c84241ee908c75fc.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![网络参数配置的文件夹——/etc/network文件夹](http://upload-images.jianshu.io/upload_images/291600-0a98d7efa14cc3f9.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 对interfaces文件进行查看编辑

![编辑interfaces文件（管理员身份）](http://upload-images.jianshu.io/upload_images/291600-7f4c714a894b7e6b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![interfases文件内容](http://upload-images.jianshu.io/upload_images/291600-b8fff56d7c315f23.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

因为通过rj-45接头的网线连接树莓派，所以修改**宽带**信息，即eth0参数下的ip地址等信息：

```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
address 172.17.64.197
network 255.255.255.0
gateway 172.17.64.1
```

上述代码为***静态IP配置***，其**好处**是：当树莓派在固定局域网中使用时，无需每次查询树莓派的IP地址；**坏处**是：当**网络变掉**时，需要重新接上树莓派的HDMI视频接口**连接上显示屏**，然后通过USB**连接鼠标键盘**，在**延时性超强**的图形化界面下**重新配置IP地址**，笔者表示已经累死在插拔显示屏的路上。。。

下面，来看看***动态IP配置***的代码：

```
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
```

其**好处**是：适用于**经常变化的网络环境**下，只需要通过访问路由器的设备IP列表即可查看树莓派的IP地址；其**坏处**是：每次都要查看树莓派的IP地址。

**最后**，萌萌的windows 10台式机登场，连接树莓派所在的局域网，使用`ping`命令验证网络配置是否成功。指令为：

```
ping [ip地址]
```

如IP地址为：

```
172.17.64.197
```

则输入：

```
ping 172.17.64.197
```

若网络`ping`不通，需要检查网络问题，这里不做过多讲解。

# 让程序跑起来

完成网络配置以后，就开始实现远程访问并获取呼吸数据了。使用`ssh`命令与树莓派建立连接，ssh配置参考：

[如何在Windows 10上启用SSH](http://jingyan.baidu.com/article/3c343ff7f9b6940d3779632f.html)

[点击此处下载openssh](http://www.mls-software.com/opensshd.html)

ssh命令如下：

```
ssh [用户名]@[IP地址或域名]
```

按下`enter`键，命令行会提示输入密码。树莓派raspberian系统的用户及密码为：

```
用户：pi
密码：raspberry
```

使用ssh远程操作指令如下：

```
~$ ssh pi@172.17.64.197
pi@172.17.64.197's password: raspberry
```

连上树莓派后，运行python文件获取呼吸的数据：

```
pi@raspberry ~ $ sudo python ./iHealth/iHealth-python/getBreaths_send.py
```

> PS：因调试原因，将 `getBreaths_send.py`文件拷贝了一份并修改了其中的代码命名为`zz_getBreaths_send.py`，将其数据存入`~/iHealth/iHealth-python/data-breath`文件夹，产生数据文件的名称为：`breath_年-月-日_时:分:秒.txt`

在点击`enter`键前，我们将与树莓派连接的气流感应器靠近鼻孔，自然的呼气，传感器如下图：

![将气流感应器靠近鼻孔自然地呼吸](http://upload-images.jianshu.io/upload_images/291600-f93e1ac66f1b5166.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

随着程序的运行以及自然呼吸，可以看到命令行出现如下图所示的数据：

![呼吸气流数据](http://upload-images.jianshu.io/upload_images/291600-d5ef98e89d806ce5.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

显示的格式如下：

```
{'breath': [气流大小]} [当前采样点标号]
```

但是txt数据文件的数据存储格式为：

![呼吸数据存储内容](http://upload-images.jianshu.io/upload_images/291600-e0daa867c9fc0e5c.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 远程获取呼吸数据文件

远程获取呼吸数据的文件，需要用到scp指令，指令格式如下：

```
scp [用户名]@[IP地址]:[文件路径]
```

获取`getBreath_send.py`文件，使用指令：

```
scp pi@172.17.64.197:~/iHealth/iHealth-python/data-breath/breath_2016-08-02_11\:19\:33.txt
```

`\:`的`\`为转移字符，表示`:`。

`scp`指令下载地址：
https://sourceforge.net/projects/winscp/files/WinSCP/5.9/WinSCP-5.9-Setup.exe/download