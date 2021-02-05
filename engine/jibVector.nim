## Basic vector stuff

import math


type
    Vector2* = tuple[x, y: float]


proc length*(v: Vector2): float
proc distS*(v1, v2: Vector2): float
proc dist*(v1, v2: Vector2): float
proc unit*(v: Vector2): Vector2

proc `+`*(v1, v2: Vector2): Vector2
proc `+=`*(v1: var Vector2, v2: Vector2) {.inline.}
proc `-`*(v1, v2: Vector2): Vector2
proc `-=`*(v1: var Vector2, v2: Vector2) {.inline.}
proc `*`*(v: Vector2, n: float): Vector2
proc `*=`*(v: var Vector2, n: float) {.inline.}
proc `/`*(v: Vector2, n: float): Vector2
proc `/=`*(v: var Vector2, n: float) {.inline.}





proc length(v: Vector2): float =
    return sqrt(v.x^2 + v.y^2)

proc distS(v1, v2: Vector2): float =
    let
        dx = v2.x - v1.x
        dy = v2.y - v1.y
    result = dx*dx + dy*dy

proc dist(v1, v2: Vector2): float =
    result = distS(v1, v2).sqrt()

proc unit(v: Vector2): Vector2 =
    let vLen = v.length
    result.x = v.x / vLen
    result.y = v.y / vLen


proc `+`(v1, v2: Vector2): Vector2 =
    result.x = v1.x + v2.x
    result.y = v1.y + v2.y

proc `+=`(v1: var Vector2, v2: Vector2) =
    v1 = v1 + v2

proc `-`(v1, v2: Vector2): Vector2 =
    result.x = v1.x - v2.x
    result.y = v1.y - v2.y

proc `-=`(v1: var Vector2, v2: Vector2) =
    v1 = v1 - v2

proc `*`(v: Vector2, n: float): Vector2 =
    result.x = v.x * n
    result.y = v.y * n

proc `*=`(v: var Vector2, n: float) =
    v = v * n

proc `/`(v: Vector2, n: float): Vector2 =
    result.x = v.x / n
    result.y = v.y / n

proc `/=`(v: var Vector2, n: float) =
    v = v / n