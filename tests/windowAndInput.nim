import ../engine/jibEngine, ../engine/jibGraphics, ../engine/jibInput, math

const 
  SCALE = 1
  WIDTH = 600
  HEIGHT = 600

proc init()
proc update()
proc quit()


var
  engine: Engine
  graphics: Graphics
  input: Input
  shouldQuit = false


init()

while not shouldQuit:
  input.update(SCALE)
  update()
  graphics.beginDrawing()
  # draw nothing
  graphics.endDrawing()

quit()



proc init() =
  engine.init()
  graphics.initWindow(WIDTH, HEIGHT, "Window test, press esc to exit!")
  graphics.initCanvas(SCALE)


proc update() =
  if input.pausePressed() or input.exitPressed():
    shouldQuit = true


proc quit() =
  graphics.quit()
  engine.quit()