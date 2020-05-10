---
title: 从零开始设计游戏引导框架（二）
categories:
  - 网瘾少年的游戏开发之旅
date: 2020-04-19 13:11:50
tags:
  - 游戏开发
  - 引导设计
---

# 前情提要

上文主要讲解了引导设计的一些理论概念，包括：引导分段、引导步骤、引导的触发、引导的操作以及引导的保存点。其中引导的触发分为触发点和触发条件，此外还提到了引导的多条件判断；引导操作提到了操作的分类、操作定义和操作参数及扩展。本文将基于引导的理论概念，进行实操演练，主要包含配表和代码框架的初步编写。

# 配表

考虑到引导的触发和操作逻辑模块的不同，引导相关的表将分成两张，一张是引导的**触发表**，另一张是引导的**步骤表**。考虑到xlsx在合分支时的不便，这里使用csv格式进行配表。我们对上述两张表分别命名为：

* GuideTrigger.csv 引导触发表
* GuideStep.csv 引导步骤表

因为不同的团队会有自己的配表习惯，所以这里的配表格式仅以笔者的习惯为例，读者们主要了解配表分哪几列，每列配表的数据结构如何即可。

## 步骤表

{% asset_img img_guide_step_01.png %}

上图是基于前一篇文章里提到的卡牌卡牌进阶引导进行了基本的配表操作，接下来对每一列的配置作详细说明。

### ID

ID表示引导步骤的唯一标识，为数字类型，通常同一段引导里的步骤ID以连续的数字相连。上图中展示的是卡牌进阶引导的所有步骤，一共分为8步。

步骤表是要配置当前游戏所有的引导步骤的，那么不同分段的引导的步骤如何区分呢？

这里需要对ID的范围进行划分，笔者习惯以100作为一段引导的ID区间，如何理解呢？比如这里除了进阶引导外，还有一个卡牌重置引导，那么卡牌重置引导步骤的id范围可以规定在101~200之间，我们可以将这个引导的起始id设置为从101开始，配到表里面大概是这样的：

{% asset_img img_guide_step_02.png %}

绿框里的内容表示卡牌进阶引导，红框里的内容表示卡牌重置引导。若后续还有其他引导，可以从201开始，以此类推。

### 类别

类别表示操作的分类，按照前文《理论篇》提到的分类方法，在类别这一列填写类别定义的数字。

```
// 操作类别定义
1. 立绘对话
2. 点击
3. 拖动
```

操作类别可根据需求自己定义。

### 操作

操作表示当前步骤具体做什么事，每一个具体的操作都需要做详细的定义，参考前文《理论篇》的定义，如下：

```
0. 无操作

// 点击操作定义
201. 点击自己卡池里满足进阶条件的一张卡牌
202. 点击卡牌详情界面的进阶按钮
203. 点击进阶面板的进阶按钮

// 拖动操作定义
301. 在进阶面板拖动第1张材料卡到进阶消耗框

```

定义后，将定义中操作内容对应的数字填写到表中“操作”一列中。操作的定义数字最好是类别定义的数字乘以100加X，这样方便知晓对应的操作属于哪一类别，方便抽象和扩展.

```
操作 = 类别 * 100 + X
```

### 操作参数

操作参数是对操作的补充，对做相同事情但操作对象有略微差别的一种说明。以卡牌进阶引导中，拖动卡池里的材料卡为例。假如卡牌进阶需要消耗两张卡池中的同名卡，这时候需要有两步引导操作，分别是：

* 拖动卡池中第一张材料卡到待消耗区域
* 拖动卡池中第二张材料卡到待消耗区域

这两步引导做的是相同的事情，但是拖动的卡牌略有不同，这时可以将“拖动卡池中的材料卡到待消耗区域”定义成一种操作，加上操作参数：第几张卡。

考虑到操作的补充参数可能不止一种，这里使用Json格式的字符串填写，方便扩展。

### 对话内容

对话内容只要用于立绘对话形式的引导步骤，直接填写对话文本即可，没有立绘对话的引导步骤可不填或填0表示内容为空。

### 说话人物

说话人物用于立绘对话形式的引导步骤，表示不同的说话人物。与操作定义类似，说话人物也需要定义，若说话人物使用的是本身游戏中的角色，可直接填写角色的id，填0表示无人物。

### 保存点

保存点的必要性在前文《理论篇》已经提及，保存点的逻辑操作是，在当前步的操作已经做完，即将进入下一步前，往服务端发送一个引导ID，表示下一次重新登录时，引导从那一步ID开始。填0表示不往服务端发送保存点。

那为什么表里面会配置100？100这个引导ID并没有在表里出现呀？而且为什么引导走到了第7步还要往服务端发送引导ID为1的点呢？

其实这里的保存点不是引导ID，而是一个**差值**，填1表示将当前步的下一步引导ID发送给服务端保存，填2表示当前步骤的后面第2不的引导ID发送到服务端保存，而100则表示结束当前引导分段，并标记当前分段引导已完成，后续不再触发。

之所以填**差值**而不直接填**引导ID**的值，是因为引导的需求是在不断地变化的，很可能一段很长的引导，在前面步骤插入了一步，那么后续的引导ID都将往后+1，这样保存点也要跟着变动，保存点多的情况下很容易出现漏改的情况，因此使用**差值**可以减少变动。

一般情况下，引导保存点在当前步骤以后，所以默认引导保存点的值只有大于0的时候才有意义。

## 触发表

{% asset_img img_guide_trigger_01.png %}

上图是集成了卡牌进阶引导和卡牌重置引导的引导触发表，接下来对触发表的各列配置进行说明。

### ID

引导触发表的ID，无实际意义，仅表示序列。

### 分段ID

分段ID是引导分段的唯一标识，结合步骤表的引导ID以100作为区间规则，我们默认：1\~100的引导分段ID是0，101\~200的分段ID是1，后续引导分段以此类推。

### 触发点、触发点参数

触发点的概念在前文《理论篇》中已做详细讲解，这里补充一下触发点参数及定义。与操作参数类似，触发点参数是对触发点逻辑的补充，有了参数的补充，触发点可以做一些逻辑上的抽象，定义如下：

```
// 触发点及参数的定义
1. 英雄等级达到N级时，判断引导触发条件
参数：
level：英雄等级

例子：
{'level':20}
当英雄升级到20级时，判断引导是否满足触发条件

2. 当打开某个场景时，判断引导触发条件
参数：
scene：场景名字

例子：
{'scene':'HeroesScene'}
当进入卡池场景时，判断引导是否满足触发条件

3. 卡牌重置功能解锁时，判断引导是否满足触发条件
```

### 触发条件、触发条件参数

触发条件的概念在前文《理论篇》中也做过讲解，这里也仅做补充说明。触发条件的填写与触发点类似，唯一不同的是：触发条件的配置是数组，需要支持多条件的填写，数字定义以`|`隔开，参数的填写也同理，多个Json字符串之间用`|`隔开，当不需要参数时，在参数列填0即可。多个触发条件之间是**并**的关系。定义如下：

```
// 触发条件及参数的定义
0. 无需条件，即可触发引导

1. 当前在某个场景中
参数：
scene：场景名字

例子：
{'scene':'HeroesScene'}
引导满足当前场景在卡池界面时触发

2. 卡池中有卡牌等级达到N级，且同名卡数量达到一定张数
参数：
level：卡牌等级
num：同名卡数量

例子：
{'level':20,'num':2}
当卡池中有卡牌等级达到20级，且同名卡数量至少有2张时，触发引导
```

了解了触发表的各列含义，我们将其串联起来理解，便是：

```
卡牌进阶引导的触发（_groupId为0）：
触发一：
当有卡牌等级升到了20级时，判断当前场景在卡池界面，且有等级超过20级的卡牌有2张同名卡，触发引导。
触发二：
当进入卡池场景时，判断卡池中有卡牌等级达到20级且有至少2张同名卡，触发引导。

卡牌重置引导的触发（_groupId为1）：
触发一：
当卡牌重置功能解锁时，即触发引导。
```

# 编码

> 友情提示：请读者们将思维切换到编码思维。

创建一个引导类，命名为GuideMgr.lua（Guide Manager）。

引导是分段触发的，所以需要有触发的判断和当前段引导的终止：

```Lua
function GuideMgr.checkTrigger()

end

function GuideMgr.finish()

end
```

引导分步骤，所以需要有当前步的开始和下一步：

```Lua
function GuideMgr.start()

end

function GuideMgr.next()

end
```

引导需要知晓当前在哪一步，以及记录哪些引导是已经走过的：

```Lua
GuideMgr._guideId
GuideMgr._finished = {}
```

这两个值一般在客户端收到登录包时，从服务器拿数据并解析得到。GuideMgr._finished的数据结构大概是这样的：

```Lua
GuideMgr._finished = {
    [1] = true,
    [3] = true,
    [11] = true
}
```

其中的1、3、11表示引导的分段ID，每当有新的引导完成时，该引导分段ID都将记录在这个结构里。

记录了引导ID以后，需要留一个接口，用来获取引导步骤表里面的对应步骤信息：

```Lua
function GuideMgr.getInfo()

end
```

定义了上述几个方法后，就可以开始搭建引导的框架了：

```Lua
GuideMgr = class("GuideMgr")

GuideMgr._guideId = nil
GuideMgr._finished = {}

function GuideMgr.checkTrigger()
end

function GuideMgr.finish()
end

function GuideMgr.start()
end

function GuideMgr.next()
end

function GuideMgr.getInfo()
end
```

## 触发判断

先从触发的判断开始吧！触发的判断逻辑思维主要是传入对应的触发点，以及想要触发的引导分段id，然后在`GuideMgr.checkStart`方法里判断是否满足条件，若满足条件则调用`GuideMgr.start`方法开始分段引导的第一步。

```Lua
function GuideMgr.checkTrigger(point, group)
    -- No point, no trigger.
    if point == nil then
        return false
    end

    -- Do not trigger a new guide when guiding.
    if GuideMgr.isGuiding() then
        return false
    end

    -- Init the candidate infos.
    local candidateInfos
    if group == nil then
        candidateInfos = GuideMgr.getAllInfos()

    elseif type(group) == "number" or type(group) == "table" then
        candidateInfos = GuideMgr.getInfosByGroup(group)
    end

    if candidateInfos == nil then
        return false
    end

    -- Filter infos by finished.
    candidateInfos = GuideMgr.getUnfinishedInfos(candidateInfos)

    -- Filter infos by trigger point.
    candidateInfos = GuideMgr.getPointValidInfos(point, candidateInfos)

    -- Filter infos by trigger condition.
    candidateInfos = GuideMgr.getConditionValidInfos(candidateInfos)

    -- Check candidate infos empty.
    if #candidateInfos == 0 then
        return false
    end

    -- Sort by priority and group id.
    table.sort(candidateInfos, function(ele1, ele2)
        if ele1._priority == ele2._priority then
            return ele1._groupId < ele2._groupId
        else
            return ele1._priority > ele2._priority
        end
    end)

    -- Start first guide step.
    local info = candidateInfos[1]
    local triggerGroupId = info._groupId
    local guideId = triggerGroupId * 100 + 1
    GuideMgr.start(guideId)
    return true
end
```

`GuideMgr.isGuiding`方法判断目前是否在引导中，通过GuideMgr._guideId是否大于0来区分，因为每走一步引导，GuideMgr._guideId都会被赋值，而这个值就是引导步骤表GuideStep.csv的`_id`一列的值。当引导结束时，GuideMgr._guideId会被赋值为0。代码如下：

```Lua
function GuideMgr.isGuiding()
    return GuideMgr._guideId and GuideMgr._guideId > 0
end
```

其中`GuideMgr.getAllInfos`方法是从GuideTrigger.csv中获取每一行触发信息，以数组的形式返回。不同的项目组有不同的读表逻辑，这里就不贴出详细代码了。

`GuideMgr.getInfosByGroup`方法是从GuideTrigger.csv中通过`_groupId`一列的值，筛选出指定引导分段的触发信息，以数组的形式返回。

`GuideMgr.getUnfinishedInfos`方法是为了过滤掉已经触发过的引导，一般引导只会走一次，所以已经走过的引导不再触发。思路是从触发表中拿到`_groupId`的值，与GuideMgr._finished进行比对，若存在该值，则表示引导已经触发过。代码如下：

```Lua
function GuideMgr.getUnfinishedInfos(infos)
    if infos == nil then
        return
    end

    local ret = {}
    for i = 1, #infos do
        local info = infos[i]
        if not GuideMgr.isFinished(info._groupId) then
            ret[#ret + 1] = info
        end
    end
    return ret
end

function GuideMgr.isFinished(groupId)
    return GuideMgr._finished[groupId] == true
end
```

`GuideMgr.getPointValidInfos`方法是在触发信息中筛选出相同**触发点**的信息，以数组形式返回。详细的触发点信息判断在`GuideMgr.isTriggerPointValid`方法中处理。传入的触发点变量可以是`number`类别，仅表示触发点；也可以是`table`类别，内包含触发点和触发点参数，结构如下：

```Lua
{
    _point = GuideMgr.Point.enter_scene,
    _param = {
        _sceneId = Data.SceneId.main_scene
    }
}
```

`GuideMgr.getPointValidInfos`和`GuideMgr.isTriggerPointValid`详细代码如下：

```Lua
function GuideMgr.getPointValidInfos(point, infos)
    local ret = {}
    for i = 1, #infos do
        local info = infos[i]
        if GuideMgr.isTriggerPointValid(info, point) then
            ret[#ret + 1] = info
        end
    end
    return ret
end

function GuideMgr.isTriggerPointValid(info, point)
    local param

    -- Parse param.
    if type(point) == "table" then
        param = point._param
        point = point._point
    end

    -- Different trigger point.
    if info._point ~= point then
        return false
    end

    -- Special handling.
    if point == GuideMgr.Point.enter_scene then
        -- Compare with the info in GuideTrigger.csv.
        local sceneName = info._pointParam.scene
        return Data.SceneId[sceneName] == param._sceneId

    else
        -- More point param check.
        -- ...
    end

    return true
end
```

筛选出满足触发点的触发信息后，继续通过`GuideMgr.getConditionValidInfos`方法筛选出**触发条件**满足的信息。详细判断逻辑在`GuideMgr.isConditionValid`方法中，通过传入`触发条件定义`和`触发条件参数`，具体逻辑具体判断。代码如下：

```Lua
function GuideMgr.getConditionValidInfos(infos)
    local ret = {}
    for i = 1, #infos do
        local isValid = true
        local info = infos[i]
        -- Array already parsed.
        local conds = info._conds
        -- Parse param array.
        local params = string.split(info._params, "|")

        for j = 1, #conds do
            if not GuideMgr.isConditionValid(conds[j], params[j]) then
                isValid = false
                break
            end
        end

        if isValid then
            ret[#ret + 1] = info
        end
    end
    return ret
end

function GuideMgr.isConditionValid(condition, param)
    if condition == GuideMgr.Cond.current_scene then
        -- Get current scene.
        local scene = ...
        return Data.SceneId[param.scene] == scene._sceneId

    elseif condition == GuideMgr.Cond.hero_by_num_level then
        -- Check condition validation.
        -- ...
    end

    return false
end
```

过滤出满足触发点和触发条件的触发信息后，对信息按照优先级进行排序，排序后取第一条触发信息里的引导分段ID（_groupId），将分段ID转为当前分段引导的第一步引导ID，传入`GuideMgr.start`方法中开始当前分段的引导。

## 开始引导

触发判断筛选出符合要求的引导分段后开始引导，`GuideMgr.start`方法通过传入引导步骤ID，做当前步骤的引导操作，如：立绘说话、引导点击、其他引导效果等。`GuideMgr.starat`代码如下：

```Lua
function GuideMgr.start(guideId)
    guideId = guideId or M._guideId

    if guideId == nil then
        return false
    end

    -- Check guide info validation.
    local info = GuideMgr.getInfo(guideId)
    if info == nil then
        -- Guide info not exists.
        GuideMgr.finish()
        return false
    end

    -- Set guide id.
    GuideMgr._guideId = guideId

    -- Set view
    GuideMgr.setView(info)
    return true
end
```

`GuideMgr.start`传入的参数——引导步骤ID（下称“引导ID”），当没有传参时，默认使用之前记录的引导ID。通过引导ID判断对应的引导步骤信息是否存在，若存在，将引导ID记录下来，并将对应的引导步骤信息传入视图层，做进一步的操作。

`GuideMgr.getInfo`方法通过传入引导ID，从步骤表GuideStep.csv中读取对应`_id`的信息，若没有传参，则默认使用当前已记录的引导ID。代码如下：

```Lua
function GuideMgr.getInfo(guideId)
    guideId = guideId or M._guideId
    if guideId == nil then
        return
    end

    -- Get info in GuideStep.csv by _id.
    -- ...
end
```

## 下一步引导

`GuideMgr.next`是引导从当前步走向下一步的逻辑方法。

首先判断当前步骤的引导信息是否存在，不存在则结束当前引导，这个逻辑是一个容错，一般情况下不会存在：调用`GuideMgr.next`时，当前步骤信息不存在的情况。

然后判断当前步骤是否存在保存点，存在则将保存点对应的引导ID保存到服务端。

最后引导ID加1，传入`GuideMgr.start`方法中，开始下一步引导。

代码如下：

```Lua
function GuideMgr.next()
    -- Check current step info validation.
    local info = GuideMgr.getInfo()
    if info == nil then
        GuideMgr.finish()
        return false
    end

    -- Check saving guide id.
    GuideMgr.checkSave(info)

    -- Next guide step id.
    local guideId = M._guideId + 1
    return GuideMgr.start(guideId)
end
```

保存点的逻辑是读取GuideStep.csv的`_saveId`一列，若对应的值大于0，则将该值加上当前步骤的ID（`_saveId`填的数值是相对值）所得的值，传入服务器进行保存。代码如下：

```Lua
function GuideMgr.checkSave(info)
    if info == nil then
        return false
    end

    local saveId = info._saveId
    if saveId > 0 then
        saveId = info._id + saveId
        -- Save the id to the server.
        GuideMgr.saveGuideId(saveId)
    end
end
```

`GuideMgr.saveGuideId`方法做的逻辑是将传入的id发送到服务端进行保存。

## 结束引导

结束引导主要做重置数据、移除视图的操作，先看下代码：

```Lua
function GuideMgr.finish()
    -- Guide is not started.
    if not GuideMgr.isGuiding() then
        return false
    end

    --[[ Reset data ]]--
    -- Save guide group.
    local guideId = GuideMgr._guideId
    local groupId = math.floor(guideId / 100)
    GuideMgr.saveGuideGroup(groupId)

    -- Reset guide id.
    GuideMgr.saveGuideId(0)
    GuideMgr._guideId = 0

    --[[ Remove view ]]--
    GuideMgr.removeView()
    return true
end
```

`GuideMgr.saveGuideGroup`往服务端保存一个引导分段ID，表示当前分段的引导已经完成，后面不再触发；实际的逻辑操作类似于把分段ID加到服务端的GuideMgr._finished结构里。

`GuideMgr.removeView`做视图的移除操作，考虑到篇幅的限制，视图相关的逻辑将在下一篇文章中讲解。

# 下篇预告

下一篇文章将继续本文的**实操篇**进行视图逻辑的讲解，主要包含：引导手指、高亮框、文本框的添加，点击、触摸限制逻辑的判断等，读者们看完下篇文章，基本可以自己写一个引导了。考虑到工作的原因，文章更新会比较慢，还请大家海涵！