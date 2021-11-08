---
title: 一文入门游戏中的引导设计
categories:
  - 游戏开发
date: 2021-11-01 21:34:59
tags:
  - 游戏开发
  - 引导设计
---

> 一年多以前写了两篇从零开始设计游戏引导框架，第二篇写完后，发现写不下去了。游戏引擎形形色色，语言多种多样，如果继续写下去发现并不具有通用性，所以中断了。现在，引导的代码经过多个项目的打磨，有了一定的改进，想着简单分享一下引导的实现思路吧！
本文以Lua代码作为样例，重在思路分享，其他语言亦可实现。

# 1. 引导认知

## 1.1 引导分类
引导的分类可分为**新手引导**、**触发式引导**、**任务前往引导**。

### 1）新手引导
新注册的账号进入游戏后，出现立绘对话、交代游戏背景、告知玩家基础操作的引导，称为**新手引导**。一般新手引导持续至玩家可以自由操作时结束。

### 2）触发式引导
玩家自由操作过程中，因达到某种条件而触发的引导，称为**触发式引导**。大多数情况下，触发式引导会随着新系统的开启。

### 3）任务前往引导
点击任务前往按钮后，出现手指引导玩家按照任务实现流程去操作的过程，称为**任务前往引导**。

## 1.2 组别和步骤

### 1）组别
为方便后续内容达成统一认知，在此将一个个不同功能作用的引导以组别进行区分。比如：一进入游戏即出现的新手引导、英雄升星引导、文字版的抽卡引导等，每一个引导特定功能的引导都是一个组别。

### 2）步骤
在一个引导组别里，每一步引导的操作都成为**步骤**，比如：引导点击一个按钮、出现一个立绘对话、出现一个高亮框等，都是引导的步骤。

## 1.3 触发条件与触发点

**触发条件**和**触发点**，是引导**组别**的概念。
举个例子，文字版里有一个抽卡引导，条件是玩家通关1-4。那么对于抽卡这个组别的引导，通关1-4就是它的触发条件，而触发点就是每一个关卡通关那一刻。通俗来讲就是：

```
触发点：
什么时候判断

触发条件：
判断是否满足条件
```

## 1.4 操作
**操作**是引导**步骤**的概念。
举个例子，文字版抽卡引导的步骤流程是：
* 出现立绘对话，告知玩家“招仙台”系统已开启
* 点击主界面“道场”页签
* 点击“招仙台”按钮
* 提示免费单抽
* 点击“单抽”按钮

上面的每一个步骤都是**操作**。

操作根据表现形式可分为如下几类：
* 点击
* 拖动
* 立绘对话
* 提示文本
* 效果（高亮框等）

## 1.5 保存点
**保存点**的作用：为保证引导在玩家中途退出重进时依然能从中断点恢复。保存点需要上传记录到服务端。

结合以上几点，我们建立起对引导的认知：
在某个 ***触发点*** ，判断某个 ***组别*** 的引导满足 ***触发条件*** ，于是一个 ***步骤*** 一个步骤地引导玩家去完成最基础的系统流程的 ***操作*** ，并且支持退出游戏重进时能从中途的 ***保存点*** 恢复并继续引导。

# 2. 引导的配表
引导的配表可分为：**guide_group**表、**guide_step**表、**guide_text**表。

## 2.1 guide_group配表
guide_group表，主要控制某个组别的引导要不要触发，具体配置如下：

|ID|说明|起始步骤|触发条件|优先级|
|:--:|:--|:--:|:--|:--:|
|_id|_stepId|_triggerCond|_priority|
|I||I|[S|I|
|1|初始的新手引导||101|0|
|2|抽卡引导|201|{"scene":"MainScene","form":"","missionId":100004}|1|

## 2.2 guide_step配表
guide_step表，主要控制在某个组别的引导触发时，每一步操作具体是什么。相同组别引导的步骤ID连续，且ID不为100的倍数。具体配置如下：

|ID|说明|操作|数值|其他参数|保存步骤|
|:--:|:--|:--:|:--:|:--|:--:|
|_id||_action|_val|_param|_saveId|
|H||I|I|S|I|
|201|立绘对话|30001|1002||202|
|202|点击“道场”页签|10001|1||0|
|203|点击“招仙台”按钮|10002|1||0|
|204|提示免费单抽|40001|1002|{"form_show":105,"form":105,"node":"_btnLotteryOne","dir":"top"}|0|
|205|点击“单抽”按钮后关闭提示|10003|0|{"form":105,"node":"_btnLotteryOne"}|100|

**_action说明**：
> **10000+**：点击
> **10001** 点击主界面的页签 ，val 表示第几个页签
> **10002** 点击某个系统入口，val 表示哪个系统
> **10003** 按照代码变量名找到按钮进行点击
> 
> **20000+**：拖拽
> ...
>
> **30000+**：立绘对话
> **30001** 普通立绘对话
> 
> **40000+**：文本提示
> **40001** 普通文本提示

**_val说明**：
> 不同_action，对应_val表意不同
>  
> **10001** 主界面第几个页签
> **10002** 表示系统ID枚举
>  
> **30000+** 表示立绘对话的文本ID，从guide_text表里读取
> **40000+** 表示文本提示的文本ID，从guide_text表里读取

**_param说明**：
> 一些无法通过_val单个值表意的参数，用_param表意。使用Json字符串配置，扩展性较好，自由度大，可根据需求任意定义。
>  
> **form_show** 某个界面打开的时候执行操作，数值为：界面ID枚举
> **form** 执行当前操作需要在哪个界面，数值为：界面ID枚举
> **node** 关联某个node，通常与form配合使用，旨在找到目标节点，与不同_action关联，表意不同，与点击			关联，表示点击哪个按钮；与提示文本关联，表示文本框依附于哪个UI控件
> **dir** 表示文本框依附在UI控件的哪个方位，数值可以是："top"、"bottom"、"left"、"right"
> ...

**_saveId说明**：
> 在当前操作结束时，将_saveId保存到服务器，下次断线重连时，从保存点继续引导
> 
> **0** 不设置保存点，不做任何操作
> **100** 将当前引导保存点去掉，标记当前组别引导已完成
> **其他** 保存该步骤ID到服务器

## 2.3 guide_text表
guide_text表，主要配置立绘对话、文本提示等操作的一些文本内容。具体配置如下：

|ID|说明|文本内容|参数|
|:--:|:--|:--|:--|
|_id||_textSid|_param|
|I||D|S|
|1001|立绘对话|招仙台已开启，请道友移步入内，招募仙士。|{"role_index":1,"role_id":1}|
|1002|文本提示|每隔一段时间都会获得一次免费召唤机会||

**_param说明**：
> **role_index** 立绘的位置，1：左，2：中，3：右
> **role_id** 立绘角色ID

## 2.4 程序与策划的配合

### 1）添加新的引导时
策划出一份引导流程文档，程序根据负责添加引导的逻辑配表：guide_group、guide_step，策划配置负责配置引导的文案：guide_text。

### 2）修改引导时
如果仅涉及引导文案修改时，策划只需要维护guide_text表即可，如果仅涉及文案增删，策划也可在了解引导配表逻辑的基础上，维护guide_step表；
如果涉及逻辑改动，需要程序配合策划进行改表，程序负责guide_group、guide_step，策划负责guide_text。

可有效规避策划和程序改一份表，影响引导逻辑。

# 3. 引导代码的实现
根据：
> 在某个 ***触发点*** ，判断某个 ***组别*** 的引导满足 ***触发条件*** ，于是一个 ***步骤*** 一个步骤地引导玩家去完成最基础的系统流程的 ***操作*** ，并且支持退出游戏重进时能从中途的 ***保存点*** 恢复并继续引导。

代码需要实现的逻辑包括：
* 引导的触发
* 引导的操作
* 引导的保存点（结合在操作中）
* 引导步骤的连接（如何从当前步骤跳到下一步）

我们把引导的框架逻辑写在`GuideMgr.lua`里。
```Lua
local M = class("GuideMgr")

function M.tryStart() end

function M.start(groupConfig) end

function M.step(stepId) end

function M.finish() end

function M.saveGuideStep(stepId) end

return M
```

## 3.1 引导的触发
引导的触发，可分为：触发总入口、触发条件判定和正式触发。

### 1）触发总入口
```Lua
local M = class("GuideMgr")

...

-- 引导触发判定总入口
function M.tryStart()
    -- 引导禁用
    if M.isForbidGuide() then return end
    -- 正在引导，不触发判定
    if M.isGuiding() then return end
  
    -- 获取没有触发过的引导组别，判定是否满足触发条件
    local groupConfigs = M.getGroupConfigs()
  	for i = 1, #groupConfigs do
        local config = groupConfigs[i]
        -- 如果满足触发条件
    	if CondMgr.isConditionArrayMet(config._triggerCond) then
            -- 触发引导
            M.start(config)
      	    return true
        end
    end
end

-- 获取没有触发过的引导组别
function M.getGroupConfigs()
    local configs = M._groupConfigs
    if configs == nil then
        configs = {}
    		
    	for k, v in pairs(D._guideGroupConfig) do
      		-- 取没有触发过的引导组别
      	    if not M.isFinished(k) then
                configs[#configs + 1] = v
            end
        end
    
    	table.sort(configs, function(a, b) return a._priority < b._priority end)
    	M._groupConfigs = configs
    end
    return configs
end

...

return M
```

### 2）条件判定

|ID|说明|起始步骤|触发条件|优先级|
|:--:|:--|:--:|:--|:--:|
|_id||_stepId|_triggerCond|_priority|
|I||I|[S|I|
|2|抽卡引导|201|{"scene":"MainScene","form":"","missionId":100004}|1|

```Lua
local M = class("CondMgr")

...

--[[--
配表类型：[S
配表写法：{"form": 101, "hero_level": 20} | {"form":101, "vip_level":3}
在101界面，英雄等级达到20级或vip等级达到3级，触发引导

cond参数结构：
table数组
{
    {form = 101, hero_level = 20},
    {form = 101, vip_level = 3}
}

只要数组中其中一个条件满足即可
--]]--
function M.isConditionArrayMet(conds)
    for i = 1, #conds do
        if M.isConditionMet(conds[i]) then
      	    return true
      	end
    end
    return false
end

function M.isConditionMet(cond)
    for k, v in pairs(cond) do
        if not M.CondCheck[k](v) then return false end
    end
    return true
end

M.CondCheck = {
    ["form"] = function(val)
        local form = Form.getTop()
        return form and form._id == val
    end,
    ["hero_level"] = function(val)
        local lv = P._playerHero:getOwnedHeroMaxLevel()
        return lv >= val
    end,
    ["vip_level"] = function(val)
        return P:vipLevel() >= val
    end
}

...

return M
```

### 3）触发引导

```Lua
local M = class("GuideMgr")

...

function M.start(groupConfig)
    -- 如果有引导正在进行，结束所有引导，开始触发传入组别的引导
    M.finish()

    -- 保存当前正在触发的引导组别ID
    local groupId = groupConfig._id
    M.saveGuideGroup(groupId)
  
    local stepId = groupConfig._stepId
    M.saveGuideStep(stepId)
  
    -- 引导视图层准备工作
    M.prepareLayer()
  
    -- 开始当前引导组的第一步操作
    M._groupId = groupId
    M._stepId = stepId
    M.step(stepId)
end

-- 创建引导图层，后续的所有操作添加的元素都放在这里
function M.prepareLayer()
    local layer = M._layer
    if layer == nil then
        layer = class(nil, V).new(lc.CocosClass.ui_widget)
        layer:setContentSize(lc.ScrSize)
        lc.addChildToCenter(Scene._current, layer, V.ZOrder.guide)
        M._layer = layer

        layer:setTouchListener(function() end)
    end
end

function M.saveGuideGroup(groupId)
    -- TODO：保存到服务端
    ...
end

function M.saveGuideStep(stepId)
    -- TODO：保存到服务端
    ...
end

...

return M
```

## 3.2 引导的操作
引导的操作涉及：保存点逻辑、参数逻辑、具体操作（点击、对话等）。

### 1）引导步骤

```Lua
local M = class("GuideMgr")

...

function M.step(stepId)
    -- 保证step在引导中执行（由M.start发起）
    if not M.isGuiding() then return end

    --[[--
    stepId不为空，表示开始当前步骤操作；
    stepId为空，表示在M._stepId基础上，进入下一步操作；
    --]]--
    if stepId == nil then
        stepId = M._stepId
 
        -- 在当前步骤结束，准备进入下一步时，记录当前步骤的保存点
        local stepConfig = D._guideStepConfig[stepId]
        local saveId = stepConfig._saveId
        if saveId then
            if saveId == 100 then
                M.setGroupFinished(M._groupId)
                M.saveGuideStep()

            elseif saveId > 0 then
                M.saveGuideStep(saveId)
            end
        end

        stepId = stepId + 1
    end
  
    -- 传入的步骤ID不存在，结束引导
    local config = D._guideStepConfig[stepId]
    if config == nil then
        M.finish()
        return
    end
  
    M._stepId = stepId

    -- 清除所有引导元素
    M.clearLayer()

    -- 根据步骤参数做相应处理
    -- （后面继续）
    ...
end

function M.isGuiding()
    return M._stepId and D._guideStepConfig[M._stepId]
end

-- 清理所有layer上的引导元素，包括手指、高亮、立绘对话等
function M.clearLayer()
    local layer = M._layer
    if layer == nil then return end

    layer:setSwallowTouches(true)
    layer:setTouchListener(function() end)

    M.removeFinger()
    M.removeDilog()
    M.removeTipText()
    ...
end

...

return M
```

### 2）参数处理

|ID|说明|操作|数值|其他参数|保存步骤|
|:--:|:--|:--:|:--:|:--|:--:|
|_id||_action|_val|_param|_saveId|
|H||I|I|S|I|
|204||40001|1002|{"form_show":105,"form":105,"node":"_btnLotteryOne","dir":"top"}|0|
|205||10003|0|{"form":105,"node":"_btnLotteryOne"}|100|

```Lua
local M = class("GuideMgr")

...

function M.step(stepId)
    ...
  
    -- （接上面的代码）
    local config = D._guideStepConfig[stepId]

    -- 根据步骤参数做相应处理
    local param = M.getStepParam(config)
    if param then
        -- 允许玩家自由点击
        if param.free_op then
            M._layer:setSwallowTouches(false)
        end

        M._waitParam = nil

        if param.delay then
            M._waitParam = V.scheduleCall(function() M.doAction() end, param.delay)

        elseif param.event then
            _, M._waitParam = lc.event.once(param.event, function() M.doAction() end)

            if not param.free_op then
                M._layer:setTouchListener(function()
                    -- 提示当前无法点击
                end)
            end
      
        elseif param.form_show then
            local form = Form.getTop()
            if form == nil or form._id ~= param.form_show or not form._isShown then
                _, M._waitParam = lc.event.on("form.show", function(form)
                    if form._id == param.form_show then M.doAction() end
                end)
            end
      
      	elseif param.form_close then
            local form = Form.getTop()
            if form and form._id == param.form_close then
                _, M._waitParam = lc.event.on("form.close", function(formId)
                    if param.form_close == formId then M.doAction() end
                end)
            end
        end
    
        if M._waitParam == nil then
            M.doAction()
        end
    end
end

function M.getStepParam(stepConfig)
    stepConfig = stepConfig or D._guideStepConfig[M._stepId]
    return json.decode(stepConfig._param or "")
end

...

return M
```

### 3）执行操作

```Lua
local M = class("GuideMgr")

...

function M.doAction()
    if not M.isGuiding() then return end
  
    local config = D._guideStepConfig[M._stepId]
    M._waitParam = nil
  
    local layer = M._layer
    layer:setSwallowTouches(true)
  
    local action = config._action
    if action == 0 then
        -- 执行下一步操作
        M.step()

    else
        local func = M.ActionFuncs[action]
        if func then
            if not func(config) then
                M.finish()
            end
  
        else
            -- 交给外部处理
            V.scheduleCall(function() lc.event.emit("guide.step", config) end, lc.FrameInterval)
        end
    end
end

M.Action = {
    click_main_tab = 10001,
    click_sys_entrance = 10002,
    click_by_name = 10003,
    ...
    dialog = 30001,
    ...
    tip_text = 40001,
    ...
}

M.ActionFuncs = {
    [M.Action.click_main_tab] = function(config)
        local index = config._val
        local tab = table.walk(Scene._curent, "_tabs", index)
        if tab and tab:isVisible() then
            M.addTouchFinger(tab)
            return true
        end
    end,
    [M.Action.click_sys_entrance] = function(config) ... end,
    [M.Action.click_by_name] = function(config) ... end,
  
    [M.Action.role_dialog] = function(config)
        local textConfig = D._guideTextConfig[config._val]
        M.addDialog(textConfig)
        return true
    end,
  
    [M.Action.tip_text] = function(config)
        local textConfig = D._guideTextConfig[config._val]
        M.addTipText(textConfid._textSid, config._param)
        return true
    end
}

...

return M
```

**回顾**：
> **10000+**：点击
> **10001** 点击主界面的页签 ，val 表示第几个页签
> **10002** 点击某个系统入口，val 表示哪个系统
> **10003** 按照代码变量名找到按钮进行点击
> 
> **20000+**：拖拽
> ...
>
> **30000+**：立绘对话
> **30001** 普通立绘对话
> 
> **40000+**：文本提示
> **40001** 普通文本提示

## 3.3 引导的结束

引导的结束包括：引导数据处理、视图层移除、尝试继续触发下一组引导。所有逻辑囊括在GuideMgr.finish()方法里。

```Lua
local M = class("GuideMgr")
...

function M.finish()
    -- 数据层
    M.saveGuideGroup()
    M.saveGuideStep()

    if M._groupId then
        M.setGroupFinished(M._groupId)
    end
  
    M._groupId = 0
    M._stepId = 0

    -- 视图层
    M.clearLayer()
    M.removeLayer()

    local param = M._waitParam
    if param then
        -- 移除事件监听
        if param._event then
            lc.event.remove(param)
      	
        -- 移除延迟操作的定时器
      	else
            param:unschedule()
      	end
        M._waitParam = nil
    end
  
    -- 延迟一帧判断是否有新的引导可以触发
    V.scheduleCall(M.tryStart, lc.FrameInterval)
end

...

return M
```

## 3.4 步骤间的连接

步骤间的连接，也就是当前步骤如何跳到下一步骤，需要根据操作情景做特殊处理，这里以点击、立绘对话为例，做一下讲解。

### 1）点击

```Lua
local M = class("GuideMgr")
...

function M.addTouchFinger(node, ...)
    ...
    node._lastListener = node._listener
    node._listener = M.fingerTouchListener
    ...
end

function M.fingerTouchListener(...)
    ...
    if node._lastListener then
        node._lastListener(...)
        node._listener = node._lastListener
    end
  
    -- 按钮点击后，执行下一步
    M.step()
    ...
end

...
return M
```

### 2）立绘对话、文本

点击屏幕任意位置，执行下一步引导操作。

```Lua
local M = class("GuideMgr")
...

function M.addDialog()
    ...
  
    M._layer:setTouchListener(function()
        ...
        -- 设置layer点击事件
       M.step()
        ...
    end)
  
    ...
end

function M.addTipText()
    ...
  
    M._layer:setTouchListener(function()
        ...
        -- 设置layer点击事件
      	M.step()
      	...
    end)
  
    ...
end

...
return M
```