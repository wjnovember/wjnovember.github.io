---
title: 游戏开发编码规范
categories:
  - 游戏人生
date: 2021-11-09 23:31:52
tags:
  - 游戏开发
  - 代码规范
---

最近梳理了下公司游戏开发的编码规范，考虑到平时开发主要以Lua语言为主，所以本文也以Lua代码作为案例，除了Lua语言自身的特性，其他规范思路其他语言亦可适用。
本文主要从命名规范、格式规范以及性能相关三个方面进行规范的说明，后续开发过程中若有新的规范制定，持续更新本文内容。

# 命名规范
大规则：命名需做到“闻其名、知其意”，在不影响其表意的基础上精简命名长度。

## local变量命名
以“小驼峰命名法”作为命名规范，如：myKingdom、userInfo等。

若对视图层变量进行命名，可以“视图类型+表意”方式命名，可参考：
```Lua
-- 确认按钮
local btnConfirm = V.createButton()

-- 描述文本
local lblDesc = V.createLabel()

-- 王国名称输入框
local editKingdomName = V.createInputBox()
```

亦可以“表意+视图用处”方式命名，可参考：
```Lua
-- 名字下方的背景图
local nameBg = lc.createSprite("g_bg_01")

-- 资源区域
local resArea = lc.createNode(500, 200)

-- 奖励条目
local bonusItem = self:createItem(...)

-- 聊天列表
local chatList = lcList.create(...)

-- 聊天面板
local chatPanel = ChatPanel.create(...)

-- 主要内容区域
local contentContainer = lc.createNode(...)
```

为了和方法内局部变量做区分，全文件范围的local变量在上述规则基础上，以下划线开始，如：
```Lua
local M = class("ChatForm", Form)

-->>>>> 以下划线开始的文件范围局部变量的命名规范
local _animInterval = 0.5

local _tabId = {
    world_chat 			= 1,
    kingdom_chat 		= 2,
}

function M:init(...)
    -- 方法内局部变量命名，不以下划线开始
    local form = M.super.init(self, ...)
    form:setTabId(_tabId.world_chat)
end
```

table中的key，以小写字母+下划线命名，比如：
```Lua
M.TabId = {
    world_chat    = 1,
    kingdom_chat  = 2,
}
```

有时为了简化书写、简化阅读，从成员变量中取视图变量，赋值给local变量的时候，命名可以简写为“视图用途”或“视图类型”，如：
```Lua
function M:updateTopArea()
    -- topArea简写为area
    local area = self._topArea
    area:setContentSize(...)
  
    -- btnAdd简写为btn
    local btn = area._btnAdd
    btn:setLabel(...)
    btn:setPosition(...)

    -- 但是

    -- 当存在多个获取不同button的情况，建议使用全写（btnAdd、btnCancel）
    -- 因为相同命名时，代码位置调整可能导致逻辑错乱
    local btnAdd = area._btnAdd
    btnAdd:setLabel(...)
    btnAdd:setPosition(...)

    local btnCancel = area._btnCancel
    btnCancel:setLabel(...)
    btnCancel:setPosition(...)
end
```

## 成员变量命名
lua中成员变量一般指存储在self里的变量，其命名规则为：在local变量命名规范基础上，以下划线开始，如：
```Lua
local topArea = lc.createNode(...)
lc.addChildToPos(self._form, topArea, lc.p(...))
-- 存储成员变量
self._topArea = topArea

local btnConfirm = V.createButton()
lc.addChildToPos(topArea, btnConfirm, lc.p(...))
-- 存储成员变量
self._btnConfirm = btnConfirm
```

存在类里（比如：M类）的变量，其命名同样以下划线开始，如：
```Lua
function M:initDefines()
    M._defs = {...}
end
```

## 方法命名
方法的命名大小写规范，一般以小驼峰命名，如：
```Lua
function M:updateTopArea()
end
```

但是考虑到C#转Lua导致一些Unity内置方法名必须是大驼峰命名，为了保持一致，可以考虑项目中的所有方法以大驼峰方式命名，如：
```Lua
local M = class("InfoPanel")

-->>>>> 内置方法
function M:Awake()
end

function M:Start()
end

function M:OnEnable()
end

--<<<<< 自定义方法
function M:UpdateTopArea()
end
```

方法命名格式，一般是“动词+名词”，可参考如下：
```Lua
-->>>>> 创建某个组件或初始化某块区域，以create、init开头

-- 创建一个节点
function M:createNode()
end

-- 创建一个按钮
function M:createButton()
end

-- 初始化顶部区域
function M:initTopArea()
    -- 当这个方法里只要一个表示区域的变量，可以考虑简写，规则同“成员变量命名”的规则
    -- 比如这里局部变量写area，而非topArea
    local area = self:createNode()
    lc.addChildToPos(self._form, area, lc.p(...))
    self._topArea = area
  
    local btnConfirm = self:createButton()
    lc.addChildToPos(area, btnConfirm, lc.p(...))
    area._btnConfirm = btnConfirm
  
    local btnCancel = self:createButton()
    lc.addChildToPos(area, btnCancel, lc.p(...))
    area._btnCancel = btnCancel
end

-->>>>> 以update开头作为视图刷新方法的开头

-- 更新顶部的区域
function M:updateTopArea()
end

-->>>>> 更改、获取数值的方法分别以set、get开头

-- 设置道具数量
function M:setItemNum(...)
end

-- 获取道具数量
function M:getItemNum()
end

-->>>>> 以is、can、should等作为返回布尔值的判断方法的开头

-- 判断技能模块是否解锁
function M:isUnlockSkill()
end

-- 判断玩家能否成为海盗
function M:canBePirate()
end

-- 判断是否应该检查刷新该区域
function M:shouldCheckUpdateTopArea()
end

-->>>>> 以check作为开头，用于将判断方法和更新方法包起来

-- 判断并刷新顶部区域
function M:checkUpdateTopArea()
    if not self:shouldCheckUpdateTopArea() then return end
  
    self:updateTopArea()
end
```

# 格式规范
如果把一个代码文件想象成一个房间，房间里的东西应该是近似强迫症一样地整齐摆放好，而不是像杂货堆，这是本小节规范格式需要达到的效果——“整齐、清爽、不杂糅”。对于不艰涩的逻辑，全篇代码甚至可以一行注释都不加就能读懂，类似这样：
```Lua
local M = class("OptionForm", Form)

function M:init()
    self:initTopArea()
    self:initBottomArea()

    self:syncData(V.SyncFlag.init)
end

function M:initTopArea()
    local area = lc.createNode()
    lc.addChildToPos(self._form, area, lc.p(x1, y1))
    self._topArea = area

    local lblName = V.createLabel()
    lc.addChildToPos(area, lblName, lc.p(x2, y2))
    area._lblName = lblName

    local lblDesc = V.createLabel()
    lc.addChildToPos(area, lblDesc, lc.p(x3, y3))
    area._lblDesc = lblDesc
end

function M:initBottomArea()
    local area = lc.createNode()
    lc.addChildToPos(self._form, area, lc.p(x1, y1))
    self._midArea = area

    local lblOption = V.createLabel()
    lc.addChildToPos(area, lblOption, lc.p(x2, y2))
    area._lblOption = lblOption
  
    local btnConfirm = V.createButton(function() self:onBtnConfirm() end)
    lc.addChildToPos(area, btnConfirm, lc.p(x3, y3))
    area._btnConfirm = btnConfirm
  
    local btnCancel = V.createButton(function() self:onBtnCancel() end)
    lc.addChildToPos(area, btnCancel, lc.p(x4, y4))
    area._btnCancel = btnCancel
end

function M:syncData(flag)
    M.super.syncData(self, flag)
  
    self:updateData()
    self:updateTopArea()
    self:updateBottomArea()
end

function M:updateData()
    self._data = P:getOptionData()
end

function M:updateTopArea()
    local area = self._topArea
    local data = self._data
    
    local lblName = area._lblName
    local user = data._user
    lblName:setString(user._name)
    lblName:setTextColor(user._isNpc and V.Color.gray or V.Color.white)
  
    area._lblDesc:setString(data._desc)
end

function M:updateBottomArea()
    local lblOption = self._bottomArea._lblOption
    lblOption:setString(self._data._option)
    lblOption:setPosition(x1, y1)
end

function M:onEnter()
    M.super.onEnter(self)
  
    self:addListener(Event.Player.name_change, function(evt) self:onPlayerNameChange(evt._param) end)
    self:addListener(Event.Option.dirty, function(evt) self:onOptionDirty(evt._param) end)
    self:addListener(Event.Option.remove, function() self:hide() end)
end

function M:onPlayerNameChange(user)
    local data = self._data
    if data == nil then return end
    if data._user._id ~= user._id then return end
  
    self:updateTopArea()
end

function M:onOptionDirty(option)
    local data = self._data
    if data == nil then return end
    if data._optionId ~= option._id then return end
  
    self:syncData(V.SyncFlag.update)
end

function M:onBtnConfirm()
    self._data._user:setConfirmOption()
  	self:hide()
end

function M:onBtnCancel()
    self._data._user:setDenyOption()
    self:hide()
end
```

## 空格规范
逗号后面留空格，比如：
```Lua
-- 正例
local btnConfirm, btnCancel

-- 反例
local btnConfirm,btnCancel
```

运算符、等号两边留空格，比如：
```Lua
-- 正例
local a = b > c and b or (c - b) * 2

-- 反例
local a=b>c and b or (c-b)*2
```

小括号内侧不留空格，比如：
```Lua
-- 正例
local a = (b - c) * 2

-- 反例
local a = ( b - c ) * 2
```

### 条件、循环语句
`if`语句块内侧，开始和结束不要留空行，比如：
```Lua
-- 正例
local data = self._data
if data._id > 0 then
    lblName:setString(data._name)
end

-- 反例
local data = self._data
if data._id > 0 then

    lblName:setString(data._name)

end
```

`if`语句块前留空行，比如：
```Lua
-- 正例
local data = self._data
local isVisible = (data._id > 0)

local lblName = self._lblName
lblName:setVisible(isVisible)

if isVisible then
    lblName:setString(data._name)
end

-- 反例
local data = self._data
local isVisible = (data._id > 0)
local lblName = self._lblName
lblName:setVisible(isVisible)
if isVisible then
    lblName:setString(data._name)
end
```

如果`if`前面存在单独一行代码，且这行代码与判断逻辑本身存在密切关联，`if`前面可以不留空行，比如：
```Lua
local data = self._data
self._lblDesc:setString(data._desc)

local user = data._user
if user._isNpc then
    self._lblNpcName:setString(user._name)
end
```

`elseif`语句块前面留空行，比如：
```Lua
-- 正例
local user = data._user
if user._isNpc then
    self._lblNpcName:setString(user._name)

elseif user._id == myId then
    self._lblMyName:setString(user._name)
end

-- 反例
local user = data._user
if user._isNpc then
    self._lblNpcName:setString(user._name)
elseif user._id == myId then
    self._lblMyName:setString(user._name)
end
```

`else`语句块是否留空行取决于前面的`if`或`elseif`。
如果前面是`elseif`，则`else`前面必留空行，比如：
```Lua
-- 正例
local user = data._user
if user._isNpc then
    self._lblNpcName:setString(user._name)

elseif user._id == myId then
    self._lblMyName:setString(user._name)
  
else
    self._lblOtherName:setString(user._name)
end

-- 反例
local user = data._user
if user._isNpc then
    self._lblNpcName:setString(user._name)

elseif user._id == myId then
    self._lblMyName:setString(user._name)
else
    self._lblOtherName:setString(user._name)
end
```

如果前面是`if`，且`if`语句块是多行，则`else`前面必留空行，比如：
```Lua
-- 正例
local data = self._data
local lblName = self._lblName

if user._isNpc then
    lblName:setString(data._npcName)
    lblName:setTextColor(V.Color.gray)

else
    lblName:setString(data._playerName)
    lblName:setTextColor(V.Color.white)
end

-- 反例
local data = self._data
local lblName = self._lblName

if user._isNpc then
    lblName:setString(data._npcName)
    lblName:setTextColor(V.Color.gray)
else
    lblName:setString(data._playerName)
    lblName:setTextColor(V.Color.white)
end
```

如果前面`if`语句块是单行，且`else`语句块也是单行，则`else`前面可以不留空行，比如：
```Lua
local data = self._data
local lblName = self._lblName

if user._isNpc then
    lblName:setString(data._npcName)
else
    lblName:setString(data._playerName)
end
```

如果前面`if`语句块是单行，但`else`语句块是多行，则`else`前面需要留空行，比如：
```Lua
-- 正例
local data = self._data
local lblName = self._lblName

if user._isNpc then
    lblName:setString(data._npcName)

else
    lblName:setString(data._playerName)
    self._lblNpcDesc:setString(data._npcDesc)
end

-- 反例
local data = self._data
local lblName = self._lblName

if user._isNpc then
    lblName:setString(data._npcName)
else
    lblName:setString(data._playerName)
    self._lblNpcDesc:setString(data._npcDesc)
end
```

上面`else`留空行的规则可以简单理解为：只允许`if`和`else`里都只有一行代码时，可以不留空行，其他情况均需要留空行。

`while`、`do ... while`、`for`循环语义块前面留空行规则与`if`相同。

### 方法定义
每个定义的方法之间需要留空行，比如：
```Lua
-- 正例
function M:initTopArea()
    ...
end

function M:initBottomArea()
    ...
end

-- 反例
function M:initTopArea()
    ...
end
function M:initBottomArea()
    ...
end
```

方法定义内部，开始和结束不留空行，比如：
```Lua
-- 正例
function M:initTopArea()
    local area = lc.createNode()
    lc.addChildToPos(self._form, area, lc.p(x1, y1))
  
    local lblTitle = V.createLabel()
    lc.addChildToPos(area, lblTitle, lc.p(x2, y2))
end

-- 反例
function M:initTopArea()

    local area = lc.createNode()
    lc.addChildToPos(self._form, area, lc.p(x1, y1))
  
    local lblTitle = V.createLabel()
    lc.addChildToPos(area, lblTitle, lc.p(x2, y2))

end
```

### 视图的创建与刷新
不同组件的创建、刷新逻辑之间以空行分隔，比如：
```Lua
-- 正例
local area = lc.createNode()
lc.addChildToPos(self._form, area, lc.p(x1, y1))
self._midArea = area

local lblOption = V.createLabel()
lc.addChildToPos(area, lblOption, lc.p(x2, y2))
area._lblOption = lblOption

local btnConfirm = V.createButton(function() self:onBtnConfirm() end)
lc.addChildToPos(area, btnConfirm, lc.p(x3, y3))
area._btnConfirm = btnConfirm

local btnCancel = V.createButton(function() self:onBtnCancel() end)
lc.addChildToPos(area, btnCancel, lc.p(x4, y4))
area._btnCancel = btnCancel

-- 反例1
local area = lc.createNode()
lc.addChildToPos(self._form, area, lc.p(x1, y1))
self._midArea = area
local lblOption = V.createLabel()
lc.addChildToPos(area, lblOption, lc.p(x2, y2))
area._lblOption = lblOption
local btnConfirm = V.createButton(function() self:onBtnConfirm() end)
lc.addChildToPos(area, btnConfirm, lc.p(x3, y3))
area._btnConfirm = btnConfirm
local btnCancel = V.createButton(function() self:onBtnCancel() end)
lc.addChildToPos(area, btnCancel, lc.p(x4, y4))
area._btnCancel = btnCancel

-- 反例2
local area = lc.createNode()
local lblOption = V.createLabel()
local btnConfirm = V.createButton(function() self:onBtnConfirm() end)
local btnCancel = V.createButton(function() self:onBtnCancel() end)

lc.addChildToPos(self._form, area, lc.p(x1, y1))
lc.addChildToPos(area, lblOption, lc.p(x2, y2))
lc.addChildToPos(area, btnConfirm, lc.p(x3, y3))
lc.addChildToPos(area, btnCancel, lc.p(x4, y4))

self._midArea = area
area._lblOption = lblOption
area._btnConfirm = btnConfirm
area._btnCancel = btnCancel
```

上述代码，反例2虽然看起来也很整齐，但是一旦涉及相关代码删除，或是添加新的组件创建代码，就需要上下移动光标到指定位置修改3个地方代码，且我们没法保证所有的节点创建只有`create`、`lc.addChildToPos`和`self._xxx = xxx`三个部分，所有节点没法做到统一，为了方便维护，还是建议不同的组件以空行分开。

### 其他
上述规则没有提及的部分，暂时没有硬性规定，但是在书写的过程中，还是需要我们凭借**语感**来判定是否需要用空行分开，何为语感：
就是当我写了一坨很厚的代码，review起来感觉有点费力时，用空行将其分开后，再看这坨代码，感觉舒服多了，这就是语感。

## 合并行规范

###  local变量声明
有时我们需要在一开始声明并赋值多个local变量，但是这些变量存在着一定关联，可以将多个变量合并为一行：
```Lua
-- 多行声明local变量
function M:updateActivity()
    -- 分多行声明
    local btnActivity = self._btnActivity
    local btnWelfare = self._btnWelfare

    local isVisible = self:isVisible()
    btnActivity:setVisible(isVisible)
    btnWelfare:setVisible(isVisible)
    
    if isVisible then
        return
    end
  
    -- 分多行声明
    local data = {}
    local rawData = P._playerActivity:getData()

    for i = 1, #rawData do
        local info = rawData[i]
        if self:isValid() then
            data[#data + 1] = info
        end
    end
  
    ...
end

-- 单行声明local变量
function M:updateActivity()
    -- 单行声明
    local btnActivity, btnWelfare = self._btnActivity, self._btnWelfare
    local isVisible = self:isVisible()

    btnActivity:setVisible(isVisible)
    btnWelfare:setVisible(isVisible)
    
    if isVisible then
        return
    end
  
    -- 单行声明
    local data, rawData = {}, P._playerActivity:getData()
    for i = 1, #rawData do
        local info = rawData[i]
        if self:isValid() then
            data[#data + 1] = info
        end
    end
  
    ...
end
```

### 条件语句
有时条件语句里面没有包含过多的逻辑代码，比如只有：`break`、`return`等，我们允许这些关键词和`if`条件判断放到同一行，比如：
```Lua
function M:checkUpdateTopArea()
    local area = self._topArea
    if area == nil then return end

    local rawData = P:getRawData()
    for i = 1, #rawData do
        if rawData[i]._isNpc then break end
    end
  
    ...
end
```

但是当`if`条件后跟着`elseif`、`else`时，不建议将`break`等关键字写在同一行，这样会让代码结构看起来很难看，比如：
```Lua
-- 正例
local data, rawData ={}, P:getRawData()
for i = 1, #rawData do
    if rawData[i]._isNpc then
        break
    else
        data[#data + 1] = rawData[i]
    end
end

-- 反例1
local data, rawData ={}, P:getRawData()
for i = 1, #rawData do
    -- 这样代码看起来排布太密，有点窒息的感觉
    if rawData[i]._isNpc then break
    else data[#data + 1] = rawData[i]
    end
end

-- 反例2
local data, rawData ={}, P:getRawData()
for i = 1, #rawData do
    -- 不建议一行代码里包含超过2个逻辑，且断点调试不太方便
    if rawData[i]._isNpc then break else data[#data + 1] = rawData[i] end
end
```

## 缩进规范
大规则：所有的`Tab`由制表符改为4个空格。
VS Code里可设置，如下图：

![](img_01.png)

之所以如此改，是考虑一份代码文件里，缩进有时用制表符，有时会用空格。而不同平台下，解析制表符得到的缩进和4个空格的缩进宽度是不一致的，所以干脆将`Tab`按键由制表符统一为4个空格。

基于此规则，下面提到的“缩进”表示“缩进4个空格”。

### 长条件语句
我们经常会遇到`if`语句太长，超出一屏的情况，这时会考虑将if语句写成多行，而换行后的条件判断，建议以2个**缩进**书写，比如：
```Lua
-- 单行if语句
if data._type ~= D.Type.world_chat and data._type ~= D.Type.area_chat and data._user._id ~= P._id and data._content ~= "" then
    ...
end

-- 改写成多行if语句
if data._type ~= D.Type.world_chat and data._type ~= D.Type.area_chat
        and data._user._id ~= P._id and data._content ~= "" then
    ...
end
```

两个缩进的好处是：明显与`if`语句里的逻辑代码区分开，很容易知晓这个缩进是`if`条件判断。

### 方法作为参数传入
比如按钮的创建封装，会经常把回调方法传进去，而调用这个封装方法时，会传入回调方法，可以有这么几种写法：
```Lua
-- 按钮的创建封装方法定义
function V.createButton(bgName, callback)
    ...
end

-- 调用这个封装方法，对于回调方法的传入，有诸多写法

-- 参考1：方法主体不做额外缩进
local btnConfirm = V.createButton("g_bg_01", function()
    local ...
end, btnW, btnH)

-- 参考2：方法主体缩进2个单位（8个空格）
local btnConfirm = V.createButton("g_bg_01", function()
            local ...
        end, btnW, btnH)

-- 参考3：function关键词换行缩进2个单位（8个空格），方法主体与function缩进齐平
local btnConfirm = V.createButton("g_bg_01",
        function()
            local ...
        end,
        btnW,
        btnH)
```

其他代码逻辑走传统缩进规则即可。

## 提前return代替嵌套
有时因为逻辑需要，会涉及到很多的if条件嵌套，针对这种情况，建议走`not`条件，提前return，比如：
```Lua
-- 嵌套写法
function M:checkUpdateTopArea()
    if cond1() then
        ...
        if cond2() then
            ...
            if cond3() then
                self:updateTopArea()
            end
        end
    end
end

-- 提前return写法
function M:checkUpdateTopArea()
    if not cond1() then return end
    if not cond2() then return end
    if not cond3() then return end
  
    self:updateTopArea()
end
```
这样的写法是不是更加优雅？

# 性能相关
性能优化是一款游戏上线后必做的事，但是性能瓶颈有很大程度是代码书写不规范导致的，因此有必要在这里提一提影响性能的代码书写。

## 事件分发与接收
避免在循环中分发事件，比如：
```Lua
-- 正例
local params = {}
local data = self._data

for i = 1, #data do
    local info = data[i]
    if self:isValid(info) then
        params[info._id] = info
    end
end
lc.sendEvent(eventName, params)

-- 反例
local data = self._data
for i = 1, n do
    local info = data[i]
    if cond() then
        lc.sendEvent(eventName, info)
    end
end
```

如果可以预见有些事件会在同一帧分发多次，建议在收事件的地方用dirty延迟刷新代替立即刷新，比如：
```Lua
-- 正例
self:addListener(eventName, function(evt) self._viewDirty = true end)

function M:onSchedule()
    if self._viewDirty then
        self:updateView()
    end
end

-- 反例
self:addListener(eventName, function() self:updateView() end)
```

事件接收的监听回调需要做好严格筛选、层层把关，防止出现不必要的刷新：
```Lua
-- 正例
self:addListener(eventName, function(evt) self:onEvent(evt._param) end)

function M:onEvent(param)
    if not cond1(param) then return end
    if not cond2(param) then return end
    if not cond3(param) then return end
    if not cond4(param) then return end
  
    self:updateView()
end

-- 反例
self:addListener(eventName, function() self:updateView() end)
```

逻辑筛选一般没有视图刷新来得复杂。

能做局部刷新，尽量不要全局刷新：
```Lua
function M:updateView()
    self:updateArea1()
    self:updateArea2()
    self:updateArea3()
    self:updateArea4()
    self:updateArea5()
end

-- 正例
self:addListener(eventName, function()
    self:updateArea3()
    self:updateArea5()
end)

-- 反例
self:addListener(eventName, function() self:updateView() end)
```

## 频繁调用的方法需要格外注意
在定时器这类每帧都调用的回调方法中，避免做遍历逻辑，尤其是无效的遍历，如果实在无法规避遍历的坑，建议将数组遍历改为Map索引：
```Lua
-- 正例
function M:onSchedule()
    local target = map[targetId]
    if target then
        -- do something
    end
end

-- 反例
function M:onSchedule()
    local target
    for i = 1, #array do
        if array[i]._id == targetId then
            target = array[i]
        end
    end
  
    if target then
        -- do something
    end
end
```

避免在频繁调用的方法里做复杂的计算，比如：
```Lua
-- 之前做的一款2D游戏，客人消费后往地上扔银币
-- 客人可能会一次性扔3~10个银币

-- 在每帧都会调用的Update方法，在里面做模拟银币抛物线扔到地上的位置计算
function M:Update()
    local progress = ...
    local pos = Vector3.zero
    pos.x = startPos + spdX * progress
  
    if progress < 0.3 then
        pos.y = startY + progress * 0.3
    
    elseif progress >= 0.3 and progress < 0.5 then
        pos.y = startY + (progress - 0.3) * 0.2 * factor1
    
    elseif progress >= 0.5 and progress < 0.7 then
       pos.y = startY + (0.7 - progress) * 0.2 * factor2
    
    elseif progress >= 0.7 then
       pos.y = startY + (1 - progress) * factor3
    end
  
    object.transform.localPosition = pos
end

-- 优化后，改成用Spine代替实时位置计算
```

引入缓存机制，避免做重复且结果不变的计算：
```Lua
function M:onSchedule()
    local isSupport = Buff.getVal(buffId) > 0
    if isSupport then
        -- do something
    end
end

-- 正例
function Buff.getVal(buffId)
    if cache[buffId] then return cache[buffId] end
    
    local val = 0
    ...
    cache[buffId] = val
    return val
end

-- 反例：没有缓存机制
function Buff.getVal(buffId)
    local val = 0
    ...
    return val
end
```

## 关于local变量和全局变量
在Lua里，访问局部变量比访问全局变量的速度快，而Lua里全局变量使用较多的则是self变量以及全局类名。在平时的调用中，在一段代码块里，若出现使用self获取相同的变量超过2次（包含2次），建议将self变量先赋值给local变量，再调用，比如：
```Lua
-- 正例
function M:updateTopArea()
    local btnAct = self._btnAct
    btnAct:setLabel(...)
    btnAct:setPosition(...)
end

-- 反例
function M:updateTopArea()
    self._btnAct:setLabel(...)
    self._btnAct:setPosition(...)
end
```

如果存在全局的类，调用多次，也建议先赋值给local变量，比如：
```Lua
-- WorldGrid是一个类，记录在全局变量里

-- 正例
local WorldGrid = WorldGrid
local grids = {}

for i = 1, 200 do
    grids[#grids + 1] = WorldGrid.create(...)
end

-- 反例
local grids = {}
for i = 1, 200 do
    grids[#grids + 1] = WorldGrid.create(...)
end
```

尤其不要在循环中使用多重索引，比如：
```Lua
-- 正例
local WorldGrid = WorldGrid
local group = self._grids._group
for i = 1, 200 do
    local gridData = WorldGrid.create(rawData[i])
    gridData._index = i
    group[#group + 1] = gridData
end

-- 反例
for i = 1, 200 do
  self._grids._group[#self._grids._group + 1] = WorldGrid.create(self._rawData[i])
  self._grids._group[#self._grids._group]._index = i
end
```

本文内容至此，若有不正确之处，欢迎评论区留言指正！