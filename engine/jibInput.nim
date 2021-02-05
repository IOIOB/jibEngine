## jibInput, does... input

import sdl2

type
    Input* = object
        keyDown: array[6, bool]
        keyPressed: array[6, bool]
        mouseDown: array[3, bool]
        mousePressed: array[3, bool]
        mousePosition: tuple[x, y: int]
        pause: bool
        exit: bool

using
    input: var Input

proc init*(input)
proc update*(input; scale: int)
proc pausePressed*(input): bool {.inline.}
proc exitPressed*(input): bool {.inline.}
proc keyDown*(input; key: int): bool {.inline.}
proc keyPressed*(input; key: int): bool {.inline.}
proc mouseButtonDown*(input; key: int): bool {.inline.}
proc mouseButtonPressed*(input; key: int): bool {.inline.}
proc mouseX*(input): int {.inline.}
proc mouseY*(input): int {.inline.}
proc getMousePosition(scale: int): tuple[x, y: int]



proc init*(input) =
    if wasInit(INIT_EVENTS) == 0:
        let initCheck = initSubSystem(INIT_EVENTS)
        if initCheck != 0:
            echo("Error: Failed to initialise SDL events: ", getError())
            quit(1)

proc update(input; scale: int) =
    input.pause = false
    for i in 0..input.keyPressed.high:
        input.keyPressed[i] = false
    for i in 0..input.mousePressed.high:
        input.mousePressed[i] = false
    input.mousePosition = getMousePosition(scale)
    var event: Event
    while pollEvent(event):
        case event.kind:
            of KeyDown:
                let key = event.key()
                case key.keySym.sym:
                    of K_w, K_UP:
                        input.keyDown[0] = true
                        input.keyPressed[0] = true
                    of K_a, K_LEFT:
                        input.keyDown[1] = true
                        input.keyPressed[1] = true
                    of K_s, K_DOWN:
                        input.keyDown[2] = true
                        input.keyPressed[2] = true
                    of K_d, K_RIGHT:
                        input.keyDown[3] = true
                        input.keyPressed[3] = true
                    of K_i, K_C:
                        input.keyDown[4] = true
                        input.keyPressed[4] = true
                    of K_o, K_V:
                        input.keyDown[5] = true
                        input.keyPressed[5] = true
                    of K_ESCAPE:
                        input.pause = true
                    else:
                        discard
            of KeyUp:
                let key = event.key()
                case key.keySym.sym:
                    of K_w, K_UP:
                        input.keyDown[0] = false
                    of K_a, K_LEFT:
                        input.keyDown[1] = false
                    of K_s, K_DOWN:
                        input.keyDown[2] = false
                    of K_d, K_RIGHT:
                        input.keyDown[3] = false
                    of K_i, K_C:
                        input.keyDown[4] = false
                    of K_o, K_V:
                        input.keyDown[5] = false
                    else:
                        discard
            of MouseButtonDown:
                let mouseButton = event.button()
                case mouseButton.button:
                    of BUTTON_LEFT:
                        input.mouseDown[0] = true
                        input.mousePressed[0] = true
                    of BUTTON_RIGHT:
                        input.mouseDown[1] = true
                        input.mousePressed[1] = true
                    of BUTTON_MIDDLE:
                        input.mouseDown[2] = true
                        input.mousePressed[2] = true
                    else:
                        discard
            of MouseButtonUp:
                let mouseButton = event.button()
                case mouseButton.button:
                    of BUTTON_LEFT:
                        input.mouseDown[0] = false
                    of BUTTON_RIGHT:
                        input.mouseDown[1] = false
                    of BUTTON_MIDDLE:
                        input.mouseDown[2] = false
                    else:
                        discard
            of WindowEvent:
                let windowEvent = event.window.event
                case windowEvent:
                    of WindowEvent_Close:
                        input.exit = true
                    else:
                        discard
            else:
                discard

proc pausePressed*(input): bool =
    return input.pause

proc exitPressed*(input): bool =
    return input.exit

proc keyDown*(input; key: int): bool =
    return input.keyDown[key]

proc keyPressed*(input; key: int): bool =
    return input.keyPressed[key]

proc mouseButtonDown*(input; key: int): bool =
    return input.mouseDown[key]

proc mouseButtonPressed*(input; key: int): bool =
    return input.mousePressed[key]

proc mouseX*(input): int =
    return input.mousePosition.x

proc mouseY*(input): int =
    return input.mousePosition.y

proc getMousePosition(scale: int): tuple[x, y: int] =
    var x, y: cint
    pumpEvents()
    discard getMouseState(x, y)
    result = ((x.int / scale).int, (y.int / scale).int)