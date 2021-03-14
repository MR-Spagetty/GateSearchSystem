local comp = require("component")
local math = require("math")
local mod = comp.modem
local event = require("event")
local pc = require("computer")
local term = require("term")
local serial = require("serialization")
local string = require("string")

function vprojxy (vx, vy, vz)
  local vec = {}
  vec.x = vx
  vec.y = vy
  vec.z = vz
  local new = vec
  new.z = 0
  return new
  end

function vprojyz (vx, vy, vz)
  local vec = {}
  vec.x = vx
  vec.y = vy
  vec.z = vz
  local new = vec
  new.x = 0
  return new
  end

function vprojxz (vx, vy, vz)
  local vec = {}
  vec.x = vx
  vec.y = vy
  vec.z = vz
  local new = vec
  new.y = 0
  return new
  end

function vlen(vx, vy, vz)
  local vec = {}
  vec.x = vx
  vec.y = vy
  vec.z = vz
  local new
  new = math.sqrt(vec.x*vec.x+vec.y*vec.y+vec.z*vec.z)
  return new
  end

function vcosab (ax, ay, az, bx, by, bz)
  local cos
  cos = (ax*bx+ay*by+az*bz)/(vlen(ax, ay, az)*vlen(bx, by, bz))
  return cos
  end

function vsinab (ax, ay, az, bx, by, bz)
  local sin
  sin = math.sqrt(1-math.pow(vcosab(ax, ay, az, bx, by, bz), 2))
  return sin
  end

function vadd (ax, ay, az, bx, by, bz)
  local new = {}
  new.x = ax + bx
  new.y = ay + by
  new.z = az + bz
  return new
  end

function vsub (ax, ay, az, bx, by, bz)
  local new = {}
  new.x = ax - bx
  new.y = ay - by
  new.z = az - bz
  return new
  end

function vmul (vx, vy, vz, num)
  local vec = {}
  vec.x = vx
  vec.y = vy
  vec.z = vz
  local new = {}
  new.x = vec.x * num
  new.y = vec.y * num
  new.z = vec.z * num
  return new
  end

function vdiv (vx, vy, vz, num)
  local vec = {}
  vec.x = vx
  vec.y = vy
  vec.z = vz
  local new = {}
  new.x = vec.x / num
  new.y = vec.y / num
  new.z = vec.z / num
  return new
  end

function vrotx (vx, vy, vz, cosang)
  local vec = {}
  vec.x = vx
  vec.y = vy
  vec.z = vz
  local new = vec
  new.y = vec.y*cosang-vec.z*math.sqrt(1-cosang*cosang)
  new.z = vec.y*math.sqrt(1-cosang*cosang)+vec.z*cosang
  return new
  end

function vrerotx (vx, vy, vz, cosang)
  local vec = {}
  vec.x = vx
  vec.y = vy
  vec.z = vz
  local new = vec
  new.y = vec.z*math.sqrt(1-cosang*cosang)-vec.y*cosang
  new.z = vec.z*cosang-vec.y*math.sqrt(1-cosang*cosang)
  return new
  end

function vroty (vx, vy, vz, cosang)
  local vec = {}
  vec.x = vx
  vec.y = vy
  vec.z = vz
  local new = vec
  new.x = vec.x*cosang+vec.z*math.sqrt(1-cosang*cosang)
  new.z = vec.z*cosang-vec.x*math.sqrt(1-cosang*cosang)
  return new
  end

function vreroty (vx, vy, vz, cosang)
  local vec = {}
  vec.x = vx
  vec.y = vy
  vec.z = vz
  local new = vec
  new.x = vec.x*math.sqrt(1-cosang*cosang)-vec.z*cosang
  new.z = vec.x*cosang-vec.z*math.sqrt(1-cosang*cosang)
  return new
  end

function vrotz (vx, vy, vz, cosang)
  local vec = {}
  vec.x = vx
  vec.y = vy
  vec.z = vz
  local new = vec
  new.x = vec.x*cosang-vec.y*math.sqrt(1-cosang*cosang)
  new.y = vec.x*math.sqrt(1-cosang*cosang)+vec.y*cosang
  return new
  end

function vrerotz (vx, vy, vz, cosang)
  local vec = {}
  vec.x = vx
  vec.y = vy
  vec.z = vz
  local new = vec
  new.x = vec.y*cosang-vec.x*math.sqrt(1-cosang*cosang)
  new.y = vec.y*math.sqrt(1-cosang*cosang)-vec.x*cosang
  return new
  end

function trialateration (v1x, v1y, v1z, v2x, v2y, v2z, v3x, v3y, v3z, v4x, v4y, v4z, s1, s2, s3, s4)
  local v1 = {}
  v1.x = v1x
  v1.y = v1y
  v1.z = v1z
  local v2 = {}
  v2.x = v2x
  v2.y = v2y
  v2.z = v2z
  local v3 = {}
  v3.x = v3x
  v3.y = v3y
  v3.z = v3z
  local v4 = {}
  v4.x = v4x
  v4.y = v4y
  v4.z = v4z
  local new = {}
  local v11 = vsub(v1.x, v1.y, v1.z, v1.x, v1.y, v1.z) -- make a sphere with 0.0.0 center
  local v21 = vsub(v2.x, v2.y, v2.z, v1.x, v1.y, v1.z)
  local v31 = vsub(v3.x, v3.y, v3.z, v1.x, v1.y, v1.z)
  local v41 = vsub(v4.x, v4.y, v4.z, v1.x, v1.y, v1.z)
  
  
  
  return new
  end

local v1 = {}
local v2 = {}
local v3 = {}
local v4 = {}
local s1, s2, s3, s4 = 0
local str 
print("Write starting point (SP) #1 coordinates.")
print ("Comma+space is a number separator. Dot is the fractional part separator.")
print("Example: 1, 1.53, -23")
str = term.read()
str = tostring(str)
if (string.find(str, "n") ~= nil) then str = str:sub(1, str:find("n")-2) end
v1.x = tonumber(str:sub(1, str:find(",")-1))
str = str:sub(str:find(",")+2, #str)
v1.y = tonumber(str:sub(1, str:find(",")-1))
str = str:sub(str:find(",")+2, #str)
v1.z = tonumber(str)
--[[print("Write SP #2 coordinates.")
print ("Comma+space is a number separator. Dot is the fractional part separator.")
print("Example: 1, 1.53, -23")
str = term.read()
str = tostring(str)
if (string.find(str, "n") ~= nil) then str = str:sub(1, str:find("n")-2) end
v2.x = tonumber(str:sub(1, str:find(",")-1))
str = str:sub(str:find(",")+2, #str)
v2.y = tonumber(str:sub(1, str:find(",")-1))
str = str:sub(str:find(",")+2, #str)
v2.z = tonumber(str)
print("Write SP #3 coordinates.")
print ("Comma+space is a number separator. Dot is the fractional part separator.")
print("Example: 1, 1.53, -23")
str = term.read()
str = tostring(str)
if (string.find(str, "n") ~= nil) then str = str:sub(1, str:find("n")-2) end
v3.x = tonumber(str:sub(1, str:find(",")-1))
str = str:sub(str:find(",")+2, #str)
v3.y = tonumber(str:sub(1, str:find(",")-1))
str = str:sub(str:find(",")+2, #str)
v3.z = tonumber(str)
print("Write SP #4 coordinates.")
print ("Comma+space is a number separator. Dot is the fractional part separator.")
print("Example: 1, 1.53, -23")
str = term.read()
str = tostring(str)
if (string.find(str, "n") ~= nil) then str = str:sub(1, str:find("n")-2) end
v4.x = tonumber(str:sub(1, str:find(",")-1))
str = str:sub(str:find(",")+2, #str)
v4.y = tonumber(str:sub(1, str:find(",")-1))
str = str:sub(str:find(",")+2, #str)
v4.z = tonumber(str)
print("Write distances between target point and SP #1-4.")
print ("Comma+space is a number separator. Dot is the fractional part separator.")
print("Example: 1, 1.53, 23, 48.89")
str = term.read()
str = tostring(str)
if (string.find(str, "n") ~= nil) then str = str:sub(1, str:find("n")-2) end
s1 = tonumber(str:sub(1, str:find(",")-1))
str = str:sub(str:find(",")+2, #str)
s2 = tonumber(str:sub(1, str:find(",")-1))
str = str:sub(str:find(",")+2, #str)
s3 = tonumber(str:sub(1, str:find(",")-1))
str = str:sub(str:find(",")+2, #str)
s4 = tonumber(str)]]
print(v1.x, v1.y, v1.z)
print(vprojxy(v1.x, v1.y, v1.z).x, vprojxy(v1.x, v1.y, v1.z).y, vprojxy(v1.x, v1.y, v1.z).z)
print(vrotx(v1.x, v1.y, v1.z, 0.5))
