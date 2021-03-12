local comp = require("component")
local math = require("math")
local mod = require("modem")
local event = require("event")
local pc = require("computer")

function vprojxy (vec)
  local new = vec
  new["z"] = 0
  return new
  end

function vprojyz (vec)
  local new = vec
  new["x"] = 0
  return new
  end

function vprojxz (vec)
  local new = vec
  new["y"] = 0
  return new
  end

function vlen(vec)
  local new
  new = math.sqrt(vec["x"]*vec["x"]+vec["y"]*vec["y"]+vec["z"]*vec["z"])
  return new
  end

function vcosab (a, b)
  local cos
  cos = (a["x"]*b["x"]+a["y"]*b["y"])/(vlen(a)*vlen(b))
  return cos
  end

function vsinab (a, b)
  local sin
  sin = math.sqrt(1-math.pow(vcosab(a, b), 2))
  return sin
  end

function vadd (a, b)
  local new = a
  new["x"] = a["x"] + b["x"]
  new["y"] = a["y"] + b["y"]
  new["z"] = a["z"] + b["z"]
  return new
  end

function vsub (a, b)
  local new = a
  new["x"] = a["x"] - b["x"]
  new["y"] = a["y"] - b["y"]
  new["z"] = a["z"] - b["z"]
  return new
  end

function vmul (vec, num)
  local new = vec
  new["x"] = vec["x"] * num
  new["y"] = vec["y"] * num
  new["z"] = vec["z"] * num
  return new
  end

function vdiv (vec, num)
  local new = vec
  new["x"] = vec["x"] / num
  new["y"] = vec["y"] / num
  new["z"] = vec["z"] / num
  return new
  end

function vrotx (vec, ang)
  local new = vec
  new["y"] = vec["y"]*math.cos(ang)-vec["z"]*math.sin(ang)
  new["z"] = vec["y"]*math.sin(ang)+vec["z"]*math.cos(ang)
  return new
  end

function vroty (vec, ang)
  local new = vec
  new["x"] = vec["x"]*math.cos(ang)+vec["z"]*math.sin(ang)
  new["z"] = vec["z"]*math.cos(ang)-vec["x"]*math.sin(ang)
  return new
  end

function vrotz (vec, ang)
  local new = vec
  new["x"] = vec["x"]*math.cos(ang)-vec["y"]*math.sin(ang)
  new["y"] = vec["x"]*math.sin(ang)+vec["y"]*math.cos(ang)
  return new
  end
