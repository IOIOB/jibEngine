## Main jibEngine module, all it does is initialise SDL for now

import sdl2

type
    Engine* = object
        ## Does nothing

using
    engine: var Engine


proc init*(engine)
proc quit*(engine)


proc init(engine) =
    ## Initialises SDL
    let initCheck = init(0)
    if not initCheck:
        echo("Error: Could not initialise SDL: ", getError())

proc quit(engine) =
    ## Deinitialises SDL
    sdl2.quit()
