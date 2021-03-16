local comp = require("component")
local math = require("math")
local mod = comp.modem
local event = require("event")
local pc = require("computer")
local term = require("term")
local serial = require("serialization")
local string = require("string")
local gpu = comp.gpu
local rounder = 1000000000

local vi = {}
local vj = {}
local vk = {}
vi.x = 1
vi.y = 0
vi.z = 0
vj.x = 0
vj.y = 1
vj.z = 0
vk.x = 0
vk.y = 0
vk.z = 1

function vround(vec)
local new = {}
new = valtround(vec.x, vec.y, vec.z)
return new
end

function valtround(vx, vy, vz)
local new = {}
new.x = vx
new.y = vy
new.z = vz
local t1, t2 = 0
t1, t2 = math.modf(vx)
t2 = t2 - math.fmod(t2*rounder, 1)/rounder
new.x = t1+t2
t1, t2 = math.modf(vy)
t2 = t2 - math.fmod(t2*rounder, 1)/rounder
new.y = t1+t2
t1, t2 = math.modf(vz)
t2 = t2 - math.fmod(t2*rounder, 1)/rounder
new.z = t1+t2
return new
end

function vprojxy(vec)
local new = {}
new = valtprojxy(vec.x, vec.y, vec.z)
return new
end

function valtprojxy (vx, vy, vz)
  local vec = {}
  vec.x = vx
  vec.y = vy
  vec.z = vz
  local new = vec
  new.z = 0
  return new
  end

function vprojyz(vec)
local new = {}
new = valtprojyz(vec.x, vec.y, vec.z)
return new
end

function valtprojyz (vx, vy, vz)
  local vec = {}
  vec.x = vx
  vec.y = vy
  vec.z = vz
  local new = vec
  new.x = 0
  return new
  end

function vprojxz(vec)
local new = {}
new = valtprojxz(vec.x, vec.y, vec.z)
return new
end

function valtprojxz (vx, vy, vz)
  local vec = {}
  vec.x = vx
  vec.y = vy
  vec.z = vz
  local new = vec
  new.y = 0
  return new
  end

function vlen(vec)
local new = 0
new = valtlen(vec.x, vec.y, vec.z)
return new
end

function valtlen(vx, vy, vz)
  local new
  new = math.sqrt(vx*vx+vy*vy+vz*vz)
  return new
  end

function vmulvec(a, b)
local new = {}
new = valtmulvec(a.x, a.y, a.z, b.x, b.y, b.z)
return new
end

function valtmulvec(ax, ay, az, bx, by, bz)
local new = {}
new.x = ax*bx
new.y = ay*by
new.z = az*bz
return new
end
  
function vcosab(a, b)
local new = 0
new = valtcosab(a.x, a.y, a.z, b.x, b.y, b.z)
return new
end

function valtcosab (ax, ay, az, bx, by, bz)
  local cos
  cos = (ax*bx+ay*by+az*bz)/(valtlen(ax, ay, az)*valtlen(bx, by, bz))
  return cos
  end
  
function vsinab(a, b)
local new = 0
new = valtsinab(a.x, a.y, a.z, b.x, b.y, b.z)
return new
end

function valtsinab (ax, ay, az, bx, by, bz)
  local sin
  sin = math.sqrt(1 - valtcosab(ax, ay, az, bx, by, bz)*valtcosab(ax, ay, az, bx, by, bz))
  if (bx == 1 and ay < 0) or (by == 1 and az < 0) or (bz == 1 and ax < 0) then sin = 0-sin end
  return sin
  end

function vadd(a, b)
  local new = {}
  new = valtadd(a.x, a.y, a.z, b.x, b.y, b.z)
  return new
  end

function valtadd (ax, ay, az, bx, by, bz)
  local new = {}
  new.x = ax + bx
  new.y = ay + by
  new.z = az + bz
  return new
  end

function vsub(a, b)
  local new = {}
  new = valtsub(a.x, a.y, a.z, b.x, b.y, b.z)
  return new
  end

function valtsub (ax, ay, az, bx, by, bz)
  local new = {}
  new.x = ax - bx
  new.y = ay - by
  new.z = az - bz
  return new
  end

function vmul(vec, num)
  local new = {}
  new = valtmul(vec.x, vec.y, vec.z, num)
  return new
  end

function valtmul (vx, vy, vz, num)
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

function vdiv(vec, num)
  local new = {}
  new = valtdiv(vec.x, vec.y, vec.z, num)
  return new
  end

function valtdiv (vx, vy, vz, num)
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

function vrotx(vec)
local new = {}
new.x = vec.x
new.y = 0
new.z = math.sqrt(vec.y*vec.y+vec.z*vec.z)
local cosang = vec.z/(math.sqrt(vec.y*vec.y+vec.z*vec.z))
local sinang = math.sqrt(1 - cosang*cosang) * (vec.y/math.abs(vec.y))
return new, cosang, sinang
end

function vrerotx(vec, cos, sin)
local new = {}
new.x = vec.x
new.z = vec.z * cos
new.y = vec.z * sin
return new
end

--[[function vroty(vec)
local new = {}
new.x = vec.x
new.y = 0
new.z = math.sqrt(vec.y*vec.y+vec.z*vec.z)
local cosang = vec.z/(math.sqrt(vec.y*vec.y+vec.z*vec.z))
local sinang = math.sqrt(1 - cosang*cosang) * (vec.y/math.abs(vec.y))
return new, cosang, sinang
end

function vreroty(vec, cos, sin)
local new = {}
new.x = vec.x
new.z = vec.z * cos
new.y = vec.z * sin
return new
end

function vrotz(vec)
local new = {}
new.x = vec.x
new.y = 0
new.z = math.sqrt(vec.y*vec.y+vec.z*vec.z)
local cosang = vec.z/(math.sqrt(vec.y*vec.y+vec.z*vec.z))
local sinang = math.sqrt(1 - cosang*cosang) * (vec.y/math.abs(vec.y))
return new, cosang, sinang
end

function vrerotz(vec, cos, sin) 
local new = {}
new.x = vec.x
new.z = vec.z * cos
new.y = vec.z * sin
return new
end]]

function trialateration (v1, v2, v3, v4, s1, s2, s3, s4)
  local new = {}
  local v11 = vsub(v1, v1) -- make a sphere with 0.0.0 center
  local v21 = vsub(v2, v1)
  local v31 = vsub(v3, v1)
  local v41 = vsub(v4, v1)
  
  
  
  return new
  end

local v1 = {}
local v2 = {}
local v3 = {}
local v4 = {}
local s1, s2, s3, s4 = 0
local str 
--[[print("Write starting point (SP) #1 coordinates.")
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
print("Write SP #2 coordinates.")
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
term.clear()
for i = 1, 16 do
if math.fmod(i,2) == 1 then gpu.setBackground(0, true) gpu.setForeground(15, true) else gpu.setForeground(0, true) gpu.setBackground(15, true) end
v1.x = math.random(-1*math.pow(10, math.fmod(i-1, 5)+1), math.pow(10, math.fmod(i-1, 5)+1))
v1.y = math.random(-1*math.pow(10, math.fmod(i-1, 5)+1), math.pow(10, math.fmod(i-1, 5)+1))
v1.z = math.random(-1*math.pow(10, math.fmod(i-1, 5)+1), math.pow(10, math.fmod(i-1, 5)+1))
gpu.set(1,3*i-2,"Original")
gpu.set(21, 3*i-2, tostring(v1.x))
gpu.set(41, 3*i-2, tostring(v1.y))
gpu.set(61, 3*i-2, tostring(v1.z))
local testvec, testcos, testsin = vrotx(v1)
gpu.set(1,3*i-1,"Rotate")
gpu.set(21, 3*i-1, tostring(testvec.x))
gpu.set(41, 3*i-1, tostring(testvec.y))
gpu.set(61, 3*i-1, tostring(testvec.z))
gpu.set(1,3*i,"Rotate and rerotate")
gpu.set(21, 3*i, tostring(vrerotx(testvec, testcos, testsin).x))
gpu.set(41, 3*i, tostring(vrerotx(testvec, testcos, testsin).y))
gpu.set(61, 3*i, tostring(vrerotx(testvec, testcos, testsin).z))
end
