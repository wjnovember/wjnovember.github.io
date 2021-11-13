---
title: 《Unity Shader入门精要》笔记（二）
categories:
  - TA不是他她它祂
date: 2021-11-13 12:49:44
tags:
  - Unity Shader
---

# 材质和Unity Shader

Unity Shader定义了渲染所需的各种代码、属性和指令；材质则允许我们调整这些属性，并将其最终赋给相应的模型。
通俗讲就是：Shader制定了渲染的规则，材质是让这个物体在这个规则下调整渲染效果。

材质的创建：
方法1：Unity菜单中选择Assets->Create->Material；
方法2：Project视图中右击->Create->Material；
Unity新建的材质，默认使用Standard Shader。

材质结合GameObject的`Mesh`或`Particle Systems`组件来工作：
![](img_01.png)

材质Inspector窗口：
![](img_02.png)

Unity Shader的创建：
方法1：Unity菜单中选择Assets->Create->Shader；
方法2：Project视图中右击->Create->Shader；

Unity提供了4种Unity Shader模板：
* Standard Surface Shader
产生一个包含标准光照模型的表面着色器。
* Unlit Shader
产生一个不包含光照（但包含雾效）的基本的定点/片元着色器。
* Image Effect Shader
屏幕后处理的基本模板。
* Compute Shader
特殊的Shader文件，利用GPU的并行性进行一些与常规渲染流水线无关的计算。

前期我们使用比较多的是**Unlit Shader**。

# Unity Shader的基础：ShaderLab

Unity Shader是Unity为开发者提供的高层级的渲染抽象层，为我们自定义渲染效果提供遍历，防止和很多文件、设置打交道。

![](img_03.png)

ShaderLab是编写Unity Shader的一种说明性语言，所有Unity Shader都是用ShaderLab编写的。它使用一些嵌套在花括号内部的**语义（syntax）**来描述Unity Shader文件的结构。

# Unity Shader结构

ShaderLab的语义有：Properties、SubShader、Fallback等，这些语义定义了Unity Shader的结构。

Unity Shader基础结构：
```C
Shader "ShaderName" {
    Properties {
        // 属性
    }
    
    SubShader {
        // 显卡A使用的子着色器
    }
    
    SubShader {
        // 显卡B使用的子着色器
    }
    
    Fallback "VertexLit"
}
```

## 给Shader命名

通过`Shader`语义指定当前Unity Shader的名字，名字由字符串定义，字符串内可添加斜杠（"/"）对Shader进行分组管理：
```C
Shader "Custom/MyShader" { }
```

Shader命名后，**材质**面板上可以找到当前Shader的位置：Shader->Custom->MyShader：
![](img_04.png)

## Properties

Properties语义块包含一系列属性（Property），这些属性是材质和Unity Shader连通的桥梁。好比：C#脚本里定义一些public变量，在Inspector面板上对应的脚本组件里可以看见并设置这些变量。
```C
Properties {
    Name ("display name", PropertyType) = DefaultValue
    Name ("display name", PropertyType) = DefaultValue
    // 更多属性
}
```

`Name`是Shader访问该属性的变量名，通常以一个下划线开始，比如：_Color、_MainTex等。
`display name`是Shader在材质面板上看到的属性名称，没有严格的命名规范，闻其名、知其意即可。
`PropertyType`是当前属性的类型，Unity Shader的属性类型，可以是：颜色、数值、范围值、向量、纹理等。
`DefaultValue`是当前属性的默认值，不同的PropertyType，其默认值的结构也不同。

![](img_05.png)

* Int、Float、Range的默认值是单独的数字；
* Color、Vector的默认值是圆括号包围的一个四维向量；
* 2D、Cube、3D的默认值是字符串+换括号，字符串可以是空的，也可以是内置的纹理名称，如："white"、"black"、"bump"等；花括号以前版本用来指定纹理属性的，如：TexGen CubeReflect、TexGen CubeNormal等固定管线坐标的生成，目前基本弃用，所以花括号里内容一般为空；

属性代码例子：
```C
Shader "Custom/ShaderLabProperties" {
    Properties {
        // Numbers and Sliders
        _Int ("Int", Int) = 2
        _Float ("Float", Float) = 1.5
        _Range ("Range", Range(0.0, 5.0)) = 3.0
        
        // Colors and Vectors
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Vector = ("Vector", Vector) = (2, 3, 6, 1)
        
        // Textures
        _2D ("2D", 2D) = "" {}
        _Cube ("Cube", Cube) = "white" {}
        _3D ("3D", 3D) = "black" {}
    }
}
```

对应材质面板的显示：
![](img_06.png)

## SubShader

每个Unity Shader里至少包含一个SubShader语义块，可以有多个SubShader。
Unity Shader可以定义不同的SubShader来适应不同平台的显卡，如：高性能显卡使用精度更大的变量、更多的渲染指令，低性能显卡使用精度较低的变量。

SubShader语义块：
```C
SubShader {
    // 可选的
    [Tags]
    
    // 可选的
    [RenderSetup]
    
    Pass {
    }
    
    // Other Passes
}
```

SubShader中可定义很多Pass和一些可选的状态（RenderSetup）和标签（Tags）。
每个Pass定义一次完整的渲染流程，Pass数量越多，渲染性能消耗越大。
状态和标签也可以在Pass中定义，但Pass中使用的标签是特定的，在SubShader中定义的状态会应用于里面的所有Pass。

常见渲染状态：
* Cull
Cull Back | Front | Off
设置剔除模式：剔除背面/正面/关闭剔除。
* ZTest
ZTest Less Greater | LEqual | GEqual | Equal | NotEqual | Always
深度测试函数比较配置。
* ZWrite
ZWrite On | Off
深度写入开启/关闭。
* Blend
Blend SrcFactor DstFactor
开启混合模式并设置混合因子。

配置在SubShader，则所有Pass都生效；
配置在Pass，则只有当前Pass生效。

SubShader的标签：
* Queue
控制渲染顺序，指定当前SubShader渲染的物体在哪个渲染队列。
* RenderType
对着色器进行分类，比如：不透明的着色器、透明的着色器。可被用于着色器替换功能。
* DisableBatching
控制是否禁用批处理，涉及模型空间计算时，需要禁用，因为批处理会让模型坐标丢失，比如：顶点动画。
* ForceNoShadowCasting
控制当前SubShader渲染的物体是否会向其他物体投射阴影。
* IgnoreProjector
控制当前SubShader渲染的物体是否不接受其他物体投射的阴影，通常用于半透明物体。
* CanUseSpriteAtlas
若当前SubShader用于精灵时，将标签设置为“False”。
* PreviewType
控制材质面板上显示的预览样式，默认球形，此外还可以设置为“Plane”、“SkyBox”。

写法例子：
```C
Tags {"Queue" = "Transparent" "RenderType" = "Opaque" "DisableBatching" = "True"}
```

Pass的标签：
* LightMode
定义当前Pass在Unity的渲染流水线中的角色，比如：“ForwardBase”、“ForwardAdd”。
* RequireOptions
用于指定当满足条件时才渲染该Pass，它的值是一个由空格分隔的字符串，目前Unity支持的选项有：“SoftVegetation”。

写法例子：
```C
Tags {"LightMode" = "ForwardBase"}
```

## Pass语义块

```C
Pass {
    [Name]
    [Tags]
    [RenderSetup]
    
    // Other code
}
```

【Name】通过Pass的名称，可以使用ShaderLab的UsePass命令来直接使用其他Unity Shader中的Pass，提高Shader代码复用性。如：
```C
UsePass "MyShader/MYPASSNAME"
```
Unity内部会将所有Pass名称转为大写。

【Tags】SubShader的Tags同样适用于Pass，但Pass的Tags不能用于SubShader。

一些特殊的Pass：
* UsePass
使用该指令，复用其他的Pass。
* GrabPass
该Pass负责抓取屏幕并将结果存储在一张纹理中，以用于后续的Pass处理。

## Fallback

```C
Fallback "Name"
// 或者
Fallback Off
```
若当前Shader的所有SubShader都不能在当前显卡上运行，则使用Fallback定义的Shader；若Fallback定义为Off，则没有后备的Shader支持，物体将显示为洋红色。

# Unity Shader的形式

Unity Shader的形式有：表面着色器、顶点着色器、片元着色器、固定函数着色器。

## 表面着色器

本质是顶点/片元着色器，是Unity内置的更高一层的抽象，Unity内部处理了很多光照细节，代码量更少，但渲染代价比较大。

表面着色器代码使用`CG/HLSL`编写，写在`CGPROGRAM`和`ENDCG`之间。

表面着色器的代码定义在SubShader语句块中，案例代码：
```C
Shader "Custom/Simple Surface Shader" {
    SubShader {
        Tags {"RenderType" = "Opaque"}

        CGPROGRAM
            
        #pragma surface surf Lambert

        struct Input {
            float4 color : COLOR;
        };

        void surf(Input IN, input SurfaceOutput o) {
            o.Albedo = 1;
        }
  
        ENDCG
    }

    Fallback "Diffuse"
}
```

## 顶点/片元着色器

定点着色器、片元着色器使用`CG/HLSL`编写，写在`CGPROGRAM`和`ENDCG`之间。
顶点/片元着色器的代码定义在Pass语句块中，案例代码：
```C
Shader "Custom/Simple VertexFragment Shader" {
    SubShader {
        Pass {
            CGPROGRAM
                
            #pragma vertex vert
            #pragma fragment frag
            
            float4 vert(float4 v : POSITION) : SV_POSITION {
                return mul(UNITY_MATRIX_MVP, v);
            }
            
            fixed4 frag() : SV_Target {
                return fixed4(1.0, 0.0, 0.0, 1.0);
            }
                
            ENDCG
        }
    }
}
```

## 固定函数着色器

固定函数着色器不像前两类着色器一样，它不支持可编程，用于比较老的，不支持可编程渲染管线着色器的设备中，目前基本被淘汰。案例代码：
```C
Shader "Tutorial/Basic" {
    Properties {
        _Color ("Main Color", Color) = (1, 0.5, 0.5, 1)
    }
    
    SubShader {
        Pass {
            Material {
                Diffuse [_Color]
            }
            Lighting On
        }
    }
}
```
从上面代码中可以看到，固定函数着色器仅支持使用ShaderLab的语法配置一些渲染命令，不支持使用`CG/HLSL`语言编写比较复杂的代码逻辑。

如果需要跟各种光源打交道，建议使用表面着色器，但是需要留意移动平台的性能；
其他情况下，建议使用顶点/片元着色器；
若需要更多自定义的渲染效果，也建议使用顶点/片元着色器。

# Unity Shader != 真正的Shader

Unity Shader实际指的是ShaderLab文件，以`.shader`作为后缀的文件。而ShaderLab是Unity对传统Shader的封装。传统的Shader需要编写冗长的代码来设置着色器的输入输出，需要处理很多的文件；而Unity中的Shader只需要处理一个ShaderLab文件就好。