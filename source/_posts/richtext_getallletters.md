---
title: RichText仿Label::getLetter()获取所有文字
categories:
  - 站在巨人的肩膀上
date: 2019-10-17 20:18:53
tags:
  - Cocos-2dx
---

# 前情提要

今天在开发游戏引导框架时，遇到这样的需求：人物对话文本支持**打字机效果**，且需要**个别文字高亮**。如果仅仅是前者的需求，是挺好实现的，创建一个`Label`，通过`getLetter(index)`获取每个字，调用`setVisible(isVisible)`即可；但是个别文字高亮是RichText才有的功能，于是难点变成了**如何获取RichText里的每个字**？

# 代码分析

话不多说，看源代码，从`UIRichText.cpp`文件的`formatText`方法中，我们发现`RichText`的本质就是多个`Label`的拼接：

```CPP
void RichText::formatText(bool isForce)
{
  ...
        _elementRenders.clear();
            ...
            for (ssize_t i=0; i<_richElements.size(); i++)
            {
                RichElement* element = _richElements.at(i);
                Node* elementRenderer = nullptr;
                switch (element->_type)
                {
                    case RichElement::Type::TEXT:
                    {
                        RichElementText* elmtText = static_cast<RichElementText*>(element);
                        Label* label;
                        if (FileUtils::getInstance()->isFileExist(elmtText->_fontName))
                        {
                             label = Label::createWithTTF(elmtText->_text, elmtText->_fontName, elmtText->_fontSize);
                        }
                        else
                        {
                            label = Label::createWithSystemFont(elmtText->_text, elmtText->_fontName, elmtText->_fontSize);
                        }
                        ...
                        elementRenderer = label;
                        break;
                    }
                    case RichElement::Type::IMAGE:
                    {
                      ...
                    }
                    case RichElement::Type::CUSTOM:
                    {
                      ...
                    }
                    case RichElement::Type::NEWLINE:
                    {
                      ...
                    }
                    default:
                        break;
                }

                if (elementRenderer)
                {
                    Label * pLabel = dynamic_cast<Label *>(elementRenderer);
                    if (pLabel)
                    {
                        pLabel->setTextColor(Color4B(element->_color, element->_opacity));
                    }
                    else
                    {
                        elementRenderer->setColor(element->_color);
                        elementRenderer->setOpacity(element->_opacity);
                    }

                    pushToContainer(elementRenderer);
                }
            }
        }
        else
        {
          // 与前一段if结构基本一致
          ...
        }
        formarRenderers();
        _formatTextDirty = false;
    }
}
```

这段代码的逻辑是通过读取`insertElement()`方法传入的`RichElement`，根据RichElement类别的不同，创建`Label`、`Sprite`、`Node`等，放入RichText这个容器中，因为在当前情境下，只有`Label`被创建，所以其他不在考虑范围。

有了`Label`就可以拿到每个文字了，那么`Label`从哪里获取呢？我们把上面代码再精简下：

```CPP
void RichText::formatText(bool isForce)
{
    _elementRenders.clear();
    Node* elementRender = Label::create...
    pushToContainer(elementRender);
    formarRenderers();
}
```

发现`Label`被传进了`pushToContainer(render)`方法中，这个方法的代码很简单：

```CPP
void RichText::pushToContainer(cocos2d::Node *renderer)
{
    if (_elementRenders.size() <= 0)
    {
        return;
    }
    _elementRenders[_elementRenders.size()-1]->pushBack(renderer);
}
```

所以思路就变成了**如何从`_elementRenders`中获取所有的`Label`**？

# 逻辑编写

基于上述梳理，编写获取`RichText`中所有文字的逻辑如下：

```CPP
void RichText::getAllLetters()
{
    Vector<Sprite*> letters;

    for (auto& element : _elementRenders)
    {
        Vector<Node*>* row = element;
        for (ssize_t i = 0; i<row->size(); i++)
        {
            Node* pNode = row->at(i);
            Label * pLabel = dynamic_cast<Label*>(pNode);
            if (pLabel)
            {
                int len = pLabel->getStringLength();
                for (int j = 0; j < len; j++)
                {
                    Sprite* letter = pLabel->getLetter(j);
                    if (letter)
                        letters.pushBack(letter);
                }
            }
        }
    }

    return letters;
}
```

编写完成，将`CPP`转为`Lua`，看一下效果！

```
代码：
local ret = richText:getAllLetters()

输出：
ret: {}
```

为什么会出现这样的情况呢？

打断点，进入`getAllLetters()`，傻眼了，`_elementRenders`是个空数组。原因是`formatText()`方法的最后，RichText调用了`formarRenderers()`方法，我们来简单地看一下`formarRenderers`的逻辑：

```CPP
void RichText::formarRenderers()
{
    // 此处省略一大坨代码...
    
    size_t length = _elementRenders.size();
    for (size_t i = 0; i<length; i++)
	  {
        Vector<Node*>* l = _elementRenders[i];
        l->clear();
        delete l;
	  }    
    _elementRenders.clear();
    
    updateContentSizeWithTextureSize(_contentSize);
}
```

前面做了什么逻辑我们不关心，我们关心的是方法的最后调用了`_elementRenders.clear()`，也就是说：每次执行`formatText()`后，`_elementRenders`都会被清空，它只是一个临时变量，所以接下来要做的就是**在`_elementRenders`被清掉前，遍历获取每一个Letter并存下来**。

于是代码变成了这样：

```CPP
UIRichText.h

class CC_GUI_DLL RichText : public Widget
{
public:
    Vector<Sprite*>& getAllLetters();

protected:
    Vector<Sprite*> _letters;
};

--------------------------------------------------

UIRichText.CPP

void RichText::updateLetters()
{
    _letters.clear();

    for (auto& element : _elementRenders)
    {
        Vector<Node*>* row = element;
        for (ssize_t i = 0; i<row->size(); i++)
        {
            Node* pNode = row->at(i);
            Label * pLabel = dynamic_cast<Label*>(pNode);
            if (pLabel)
            {
                int len = pLabel->getStringLength();
                for (int j = 0; j < len; j++)
                {
                    Sprite* letter = pLabel->getLetter(j);
                    if (letter)
                        _letters.pushBack(letter);
                }
            }
        }
    }
}

Vector<Sprite*>& RichText::getAllLetters()
{
    return _letters;
}

void RichText::formarRenderers()
{
    // 此处省略一大坨代码...

    // ------------------
    // 添加的代码
    updateLetters();
    // ------------------
    
    size_t length = _elementRenders.size();
    for (size_t i = 0; i<length; i++)
	  {
        Vector<Node*>* l = _elementRenders[i];
        l->clear();
        delete l;
	  }    
    _elementRenders.clear();
    
    updateContentSizeWithTextureSize(_contentSize);
}
```

终于，CPP层间的逻辑算是实现了。但这时候，又有新的问题出现了。

# 解决LabelLetter无法转Lua问题

按照新的逻辑，从Lua层面调用`getAllLetters()`方法，发现获取的结果依然是空table；但是在CPP层面，却是可以获取到数据的。那么问题就出在`toLua`的过程。

> **说明**：tolua是cocos2d-x提供的lua-binding工具，位于项目tools/tolua目录下。

继续断点调试，将问题定位在了下面这个方法：

```CPP
/**
 * Push a table converted from a cocos2d::Vector object into the Lua stack.
 * The format of table as follows: {userdata1, userdata2, ..., userdataVectorSize}
 * The object in the cocos2d::Vector which would be pushed into the table should be Ref type.
 *
 * @param L the current lua_State.
 * @param inValue a cocos2d::Vector object.
 */
template <class T>
void ccvector_to_luaval(lua_State* L,const cocos2d::Vector<T>& inValue)
{
    lua_newtable(L);

    if (nullptr == L)
        return;

    int indexTable = 1;
    for (const auto& obj : inValue)
    {
        if (nullptr == obj)
            continue;


        if (nullptr != dynamic_cast<cocos2d::Ref *>(obj))
        {
            std::string typeName = typeid(*obj).name();
            auto iter = g_luaType.find(typeName);
            if (g_luaType.end() != iter)
            {
                lua_pushnumber(L, (lua_Number)indexTable);
                int ID = (obj) ? (int)obj->_ID : -1;
                int* luaID = (obj) ? &obj->_luaID : NULL;
                toluafix_pushusertype_ccobject(L, ID, luaID, (void*)obj,iter->second.c_str());
                lua_rawset(L, -3);
                ++indexTable;
            }
        }
    }
}
```

问题的症结出在了`g_luaType`这里，在这个数组里，找不到`LabelLetter`类，虽然`getAllLetters()`返回的是`Sprite`的数组，但本质上，`Label::getLetter()`中返回的Sprite是通过`LabelLetter`创建的，而`LabelLetter`是在`CCLabel.cpp`里面定义的，`g_luaType`根本不知道`LabelLetter`的存在。

既然如此，就一改到底吧！

```CPP
template <class T>
void ccvector_to_luaval(lua_State* L,const cocos2d::Vector<T>& inValue)
{
    lua_newtable(L);

    if (nullptr == L)
        return;

    int indexTable = 1;
    for (const auto& obj : inValue)
    {
        if (nullptr == obj)
            continue;


        if (nullptr != dynamic_cast<cocos2d::Ref *>(obj))
        {
            std::string typeName = typeid(*obj).name();

            // --------------------------------------------
            // 添加的代码
            if (typeName == "class cocos2d::LabelLetter")
            {
                typeName = "class cocos2d::Sprite";
            }
            // --------------------------------------------

            auto iter = g_luaType.find(typeName);
            if (g_luaType.end() != iter)
            {
                lua_pushnumber(L, (lua_Number)indexTable);
                int ID = (obj) ? (int)obj->_ID : -1;
                int* luaID = (obj) ? &obj->_luaID : NULL;
                toluafix_pushusertype_ccobject(L, ID, luaID, (void*)obj,iter->second.c_str());
                lua_rawset(L, -3);
                ++indexTable;
            }
        }
    }
}
```

在获取typeName以后，判断typeName的类别，若是`class cocos2d::LabelLetter`，则将其强行改为`class cocos2d::Sprite`。

至此，RichText可算可以调用`getAllLetters()`拿到所有的文字了，本教程也算告一段落。

# 写在最后

本文的逻辑重在实现思路，其实其中也存在有多待优化的东西，如：富文本存在表情图片时如何支持打字机效果？又如：后面转Lua裸写类别名的判断不够优雅。还有诸如：不需要打字机效果的文本存_letters会造成内存浪费等。感兴趣的读者欢迎在本文的基础上进行优化修改！感谢阅读~