import ../engine/jibEngine, ../engine/jibGraphics, ../engine/jibInput, ../engine/jibVector, math


const
  WIDTH = 128
  HEIGHT = 128
  SCALE = 4
  SPRITE_SIZE = 16


proc init()
proc update()
proc draw()
proc quit()


var
  engine: Engine
  graphics: Graphics
  input: Input
  shouldQuit = false
  spriteMap = [
    [10, 10, 10, 14, 10, 10, 10, 10],
    [ 7,  5,  5,  3,  6,  5,  5, 10],
    [ 7,  7,  5,  3,  3,  5,  5, 10],
    [ 7,  8,  9,  0,  3,  1,  5, 10],
    [ 8,  11, 13,  6,  3,  3,  3, 10],
    [12, 13,  7,  5,  3,  3,  3, 10],
    [ 7,  7,  7,  7,  5,  3,  2, 10],
    [10, 10, 10, 10, 10, 10, 10, 10]
  ]

init()

while not shouldQuit:
  input.update(SCALE)
  update()
  graphics.beginDrawing()
  draw()
  graphics.endDrawing()

quit()



proc init() =
  engine.init
  graphics.initWindow(WIDTH * SCALE, HEIGHT * SCALE, "Window test, press esc to exit!")
  graphics.initCanvas(SCALE)
  graphics.initSpriteSheet("sprites.png", SPRITE_SIZE)


proc update() =
  if input.pausePressed() or input.exitPressed():
    shouldQuit = true


proc draw() =
  for y, row in spriteMap:
    for x, spr in row:
      graphics.drawSprite(spr, x * SPRITE_SIZE, y * SPRITE_SIZE)


proc quit() =
  engine.quit()
  graphics.quit()