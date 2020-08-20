## 修改3D物体透明度

```Lua
-- 无法通过改color.a来修改透明度
local spriteRenderer = go:GetComponent("SpriteRenderer")
spriteRenderer.color = Color.New(r, g, b, a)
```

## 修改2D物体透明度

```Lua
local canvasGroup = go:GetComponent("CanvasGroup")
self._canvasGroup.alpha = alpha
```

## 图片扇形效果

```Lua
-- Image的Image Type设置为Filled
-- Fill Method设置为Radial 360
-- 修改Fill Amount即可
local image = gl:GetComponent("Image")
image.fillAmount = progress
```