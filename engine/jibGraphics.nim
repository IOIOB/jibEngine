## jibEngine graphics module, does drawing

import sdl2
from sdl2/image import load


type
  Graphics* = object
    window: WindowPtr
    canvas: RendererPtr
    spriteSheet: TexturePtr
    spriteSize: int
    spriteSheetSize*: tuple[w, h: int]
    scale: int
    colors: seq[tuple[r, g, b, a: int]]

using
  graphics: var Graphics


# General graphics stuff
proc initWindow*(graphics; width, height: int; title: string)
proc initCanvas*(graphics; scaling: int)
proc initSpriteSheet*(graphics; spriteSheetPath: string; spriteSize: int)
proc setSpriteSize*(graphics; size: int)
proc scissor*(graphics; x, y, w, h: int)
proc scissor*(graphics)
proc beginDrawing*(graphics)
proc endDrawing*(graphics)
proc quit*(graphics)

# Sprite drawing
proc drawSprite*(graphics; sx, sy, px, py: int)
proc drawSprite*(graphics; n, px, py: int) {.inline.}

# Color stuff
proc setPalette*(graphics; colors: seq[tuple[r, g, b, a: int]])
proc setColor*(graphics; n: int)
proc setColor*(graphics; col: tuple[r: int; g: int; b: int; a: int])
proc setColor*(graphics; r, g, b, a: int) {.inline.}

# Primitives stuff
proc drawPixel*(graphics; x, y: int) {.inline.}
proc drawLine*(graphics; x1, y1, x2, y2: int) {.inline.}
proc drawRect*(graphics; x, y, w, h: int) {.inline.}
proc drawRectFill*(graphics; x, y, w, h: int) {.inline.}
proc drawCircle*(graphics; cx, cy, r: int) {.inline.}
proc drawCircleFill*(graphics; cx, cy, r: int) {.inline.}

# Simple useful functions
proc sprn*(n, w: int): (int, int) {.inline.}
proc spriteSize*(graphics): int {.inline.}
proc getSpriteSheetSize(graphics): (int, int)
proc initRect(x, y, w, h: int): Rect {.inline.}




proc initWindow(graphics; width, height: int; title: string) =
  if wasInit(INIT_VIDEO) == 0:
    let initCheck = initSubSystem(INIT_VIDEO)
    if initCheck != 0:
      echo("Error: Failed to initialise SDL VIDEO: ", getError())
      quit(1)
  graphics.window = createWindow(title, SDL_WINDOWPOS_UNDEFINED,
      SDL_WINDOWPOS_UNDEFINED, width.cint, height.cint, SDL_WINDOW_SHOWN)
  if graphics.window == nil:
    echo("Error: Failed to create window: ", getError())
    quit(1)

proc initCanvas(graphics; scaling: int) =
  graphics.canvas = createRenderer(graphics.window, -1,
      Renderer_Accelerated or Renderer_PresentVsync)
  if graphics.canvas == nil:
    echo("Error: Failed to create renderer: ", getError())
    quit(1)
  var windowWidth, windowHeight: cint
  graphics.window.getSize(windowWidth, windowHeight)
  let checkLogicalSize = setLogicalSize(graphics.canvas, (
      windowWidth/scaling).cint, (windowHeight/scaling).cint)
  graphics.scale = scaling
  if checkLogicalSize != 0:
    echo("Error: Failed to set logical size: ", getError())
    quit(1)

proc initSpriteSheet(graphics; spriteSheetPath: string; spriteSize: int) =
  graphics.setSpriteSize(spriteSize)
  let setHintCheck = setHint(HINT_RENDER_SCALE_QUALITY, "0")
  if not setHintCheck:
    echo("Error: Failed to set hint: ", getError())
    quit(1)
  let spriteSheetSurface: SurfacePtr = load(spriteSheetPath)
  if spriteSheetSurface == nil:
    echo("Error: Failed to load image: ", getError())
    quit(1)
  graphics.spriteSheet = createTextureFromSurface(graphics.canvas, spriteSheetSurface)
  if graphics.spriteSheet == nil:
    echo("Error: Failed to create spriteSheet texture from surface: ",
        getError())
    quit(1)
  freeSurface(spriteSheetSurface)
  graphics.spriteSheetSize = graphics.getSpriteSheetSize()

proc setSpriteSize(graphics; size: int) =
  graphics.spriteSize = size

proc scissor(graphics; x, y, w, h: int) =
  var rect = initRect(x, y, w, h)
  let clipCheck = setClipRect(graphics.canvas, rect.addr)
  if clipCheck != 0:
    echo("Error: Failed to set scissor: ", getError())
    quit(1)

proc scissor(graphics) =
  let clipCheck = setClipRect(graphics.canvas, nil)
  if clipCheck != 0:
    echo("Error: Failed to set scissor: ", getError())
    quit(1)

proc beginDrawing(graphics) =
  graphics.canvas.clear()

proc endDrawing(graphics) =
  graphics.canvas.present()

proc quit(graphics) =
  destroy graphics.window
  destroy graphics.canvas
  destroy graphics.spriteSheet
  sdl2.quit()




proc drawSprite(graphics; sx, sy, px, py: int) =
  var source = initRect(sx*graphics.spriteSize, sy*graphics.spriteSize,
              graphics.spriteSize, graphics.spriteSize)
  var dest = initRect(px, py, graphics.spriteSize, graphics.spriteSize)
  graphics.canvas.copy(graphics.spriteSheet, source.addr, dest.addr)

proc drawSprite(graphics; n, px, py: int) =
  let (sx, sy) = sprn(n, graphics.spriteSheetSize.w div graphics.spriteSize)
  drawSprite(graphics, sx, sy, px, py)


proc setPalette(graphics; colors: seq[tuple[r, g, b, a: int]]) =
  graphics.colors = colors

proc setColor*(graphics; n: int) =
  setColor(graphics, graphics.colors[n])

proc setColor(graphics; col: tuple[r: int; g: int; b: int; a: int]) =
  setDrawColor(graphics.canvas, (col.r.uint8, col.g.uint8, col.b.uint8, col.a.uint8))

proc setColor(graphics; r, g, b, a: int) =
  setColor(graphics, (r, g, b, a))




proc drawPixel(graphics; x, y: int) =
  drawPoint(graphics.canvas, x.cint, y.cint)

proc drawLine*(graphics; x1, y1, x2, y2: int) =
  if x1 == x2 and y1 == y2:
    return

  let
    dx = x2 - x1
    dy = y2 - y1

  var
    xStep, yStep: float

  if dx.abs > dy.abs:
    xStep = if dx >= 0: 1.0 else: -1.0
    yStep = dy / dx * xStep
  else:
    yStep = if dy >= 0: 1.0 else: -1.0
    xStep = dx / dy * yStep

  var 
    x = x1.toFloat
    y = y1.toFloat

  while x.toInt != x2 or y.toInt != y2:
    graphics.drawPixel(x.toInt, y.toInt)
    x += xStep
    y += yStep

  graphics.drawPixel(x2, y2)

proc drawRect*(graphics; x, y, w, h: int) =
  var rect = initRect(x, y, w, h)
  drawRect(graphics.canvas, rect)

proc drawRectFill*(graphics; x, y, w, h: int) =
  var rect = initRect(x, y, w, h)
  fillRect(graphics.canvas, rect)

# SDL doesn't come with a circle function lol
proc drawCircle*(graphics; cx, cy, r: int) =
  var
    x = r
    y = 0
    p = 1 - r
  drawPoint(graphics.canvas, (x+cx).cint, (y+cy).cint)

  if r > 0:
    drawPoint(graphics.canvas, (cx+r).cint, (cy).cint)
    drawPoint(graphics.canvas, (cx-r).cint, (cy).cint)
    drawPoint(graphics.canvas, (cx).cint, (cy+r).cint)
    drawPoint(graphics.canvas, (cx).cint, (cy-r).cint)

  while x > y:
    y += 1

    if p <= 0:
      p = p + 2 * y + 1
    else:
      x -= 1
      p = p + 2 * y - 2 * x + 1

    if x < y:
      break
    drawPoint(graphics.canvas, (x+cx).cint, (y+cy).cint)
    drawPoint(graphics.canvas, (-x+cx).cint, (y+cy).cint)
    drawPoint(graphics.canvas, (x+cx).cint, (-y+cy).cint)
    drawPoint(graphics.canvas, (-x+cx).cint, (-y+cy).cint)

    if x != y:
      drawPoint(graphics.canvas, (y+cx).cint, (x+cy).cint)
      drawPoint(graphics.canvas, (-y+cx).cint, (x+cy).cint)
      drawPoint(graphics.canvas, (y+cx).cint, (-x+cy).cint)
      drawPoint(graphics.canvas, (-y+cx).cint, (-x+cy).cint)

proc drawCircleFill*(graphics; cx, cy, r: int) =
  var
    x = r
    y = 0
    p = 1 - r

  drawLine(graphics, cx, cy+r, cx, cy-r)

  while x > y:
    y += 1

    if p <= 0:
      p = p + 2 * y + 1
    else:
      x -= 1
      p = p + 2 * y - 2 * x + 1
      
    if x < y:
      break

    drawLine(graphics, x+cx, y+cy, x+cx, -y+cy)
    drawLine(graphics, -x+cx, y+cy, -x+cx, -y+cy)

    if x != y:
      drawLine(graphics, y+cx, x+cy, y+cx, -x+cy)
      drawLine(graphics, -y+cx, x+cy, -y+cx, -x+cy)



proc sprn(n, w: int): (int, int) =
  result[0] = n mod w
  result[1] = n div w

proc spriteSize*(graphics): int =
  graphics.spriteSize

proc getSpriteSheetSize(graphics): (int, int) =
  var w: cint = 0
  var h: cint = 0
  let queryCheck = queryTexture(graphics.spriteSheet, nil, nil, w.addr, h.addr)
  if not queryCheck:
    echo("Error: Failed spriteSheet query: ", getError())
    quit(1)
  result = (w.int, h.int)

proc initRect(x, y, w, h: int): Rect =
  result = (x.cint, y.cint, w.cint, h.cint)
