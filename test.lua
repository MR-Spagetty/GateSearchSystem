local comp = require("component")
local math = require("math")
local mod = comp.modem
local event = require("event")
local pc = require("computer")
local term = require("term")
local serial = require("serialization")
local string = require("string")
local gpu = comp.gpu
local rounder = 1000000000000

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
term.clear()

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
  local new = {}
  new.x = vx
  new.y = vy
  new.z = 0
  return new
  end

function vprojyz(vec)
local new = {}
new = valtprojyz(vec.x, vec.y, vec.z)
return new
end

function valtprojyz (vx, vy, vz)
  local new = {}
  new.y = vy
  new.z = vz
  new.x = 0
  return new
  end

function vprojxz(vec)
local new = {}
new = valtprojxz(vec.x, vec.y, vec.z)
return new
end

function valtprojxz (vx, vy, vz)
  local new = {}
  new.x = vx
  new.z = vz
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
local sinang, cosang = 0
  if (vec.y == 0) then
  new = vec
  sinang = 0
  cosang = 1
  else
  new.x = vec.x
  new.y = 0
  new.z = math.sqrt(vec.y*vec.y+vec.z*vec.z)
  cosang = vec.z/(math.sqrt(vec.y*vec.y+vec.z*vec.z))
  sinang = math.sqrt(1 - cosang*cosang) * (vec.y/math.abs(vec.y))
  end
return new, cosang, sinang
end

function vangrotx(vec, cos, sin)
local new = {}
new.x = vec.x
new.y = vec.y*cos - vec.z*sin
new.z = vec.y*sin + vec.z*cos
return new
end

function vrerotx(vec, cos, sin)
local new = {}
new.x = vec.x
new.y = vec.z * sin + vec.y * cos
new.z = vec.z * cos - vec.y * sin
return new
end

function vroty(vec)
local new = {}
local sinang, cosang = 0
  if (vec.z == 0) then
  new = vec
  sinang = 0
  cosang = 1
  else
  new.x = math.sqrt(vec.x*vec.x+vec.z*vec.z)
  new.y = vec.y
  new.z = 0
  cosang = vec.x/(math.sqrt(vec.x*vec.x+vec.z*vec.z))
  sinang = math.sqrt(1 - cosang*cosang) * (vec.z/math.abs(vec.z))
  end
return new, cosang, sinang
end

function vangroty(vec, cos, sin)
local new = {}
new.x = vec.z * sin + vec.x * cos
new.y = vec.y
new.z = vec.z * cos - vec.x * sin
return new
end

function vreroty(vec, cos, sin)
local new = {}
new.x = vec.x * cos - vec.z * sin
new.y = vec.y
new.z = vec.x * sin + vec.z * cos
return new
end

function vrotz(vec)
local new = {}
local sinang, cosang = 0
  if (vec.x == 0) then
  new = vec
  sinang = 0
  cosang = 1
  else
  new.x = 0
  new.y = math.sqrt(vec.y*vec.y+vec.x*vec.x)
  new.z = vec.z
  cosang = vec.y/(math.sqrt(vec.y*vec.y+vec.x*vec.x))
  sinang = math.sqrt(1 - cosang*cosang) * (vec.x/math.abs(vec.x))
  end
return new, cosang, sinang
end

function vangrotz(vec, cos, sin)
local new = {}
new.x = vec.x * cos - vec.y * sin
new.y = vec.x * sin + vec.y * cos
new.z = vec.z
return new
end

function vrerotz(vec, cos, sin) 
local new = {}
new.x = vec.y * sin + vec.x * cos
new.y = vec.y * cos - vec.x * sin
new.z = vec.z
return new
end

function trilateration (v1, v2, v3, v4, s1, s2, s3, s4)
  local new = {}
  local v11 = vsub(v1, v1) -- make a sphere with 0.0.0 center
  local v21 = vsub(v2, v1)
  local v31 = vsub(v3, v1)
  local v41 = vsub(v4, v1)
  local v22, tricos1, trisin1 = vroty(v21) -- make a sphere with x.0.0 center
  local v32 = vangroty(v31, tricos1, trisin1)
  local v42 = vangroty(v41, tricos1, trisin1)
  local tricos2 = vcosab(vprojxy(v22), vi)
  local trisin2 = vsinab(vprojxy(v22), vi)
  local v23 = vrerotz(v22, tricos2, trisin2) 
  local v33 = vrerotz(v32, tricos2, trisin2)
  local v43 = vrerotz(v42, tricos2, trisin2)
  local vectimed = vprojyz(v33)
  local tricos3 = vcosab(vectimed, vj)
  local trisin3 = vsinab(vectimed, vj)
  local v34 = vrerotx(v33, tricos3, trisin3) -- make a sphere with x.y.0 center
  local v44 = vrerotx(v43, tricos3, trisin3)
  new.x = (s1*s1-s2*s2+v23.x*v23.x)/(2*v23.x)
  new.y = (s1*s1 - s3*s3 + v34.x*v34.x + v34.y*v34.y) / (2*v34.y) - new.x*v34.x/v34.y
  local mayz = math.sqrt(math.abs(s1*s1-(new.x*new.x+new.y*new.y)))
  local check = false
    if (math.abs(s4*s4-((new.x-v44.x)*(new.x-v44.x)+(new.y-v44.y)*(new.y-v44.y)+(mayz-v44.z)*(mayz-v44.z))) <= math.abs(s4*s4-((new.x-v44.x)*(new.x-v44.x)+(new.y-v44.y)*(new.y-v44.y)+(0-mayz-v44.z)*(0-mayz-v44.z)))) then
    check = true end
    if check then
    new.z = mayz
    else
    new.z = 0-mayz
    end
  local newx = vangrotx(new, tricos3, trisin3)
  local newxz = vangrotz(newx, tricos2, trisin2)
  local newxyz = vreroty(newxz, tricos1, trisin1)
  local newtarg = vadd(newxyz, v1)
  return newtarg
  end

local v1 = {}
local v2 = {}
local v3 = {}
local v4 = {}
local s1, s2, s3, s4 = 0
local str 
local vtarg = {}
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
s4 = tonumber(str)
trilateration(v1, v2, v3, v4, s1, s2, s3, s4)]]
for i = 1, 8 do
vtarg.x = math.random(-1*1000000, 1000000)
vtarg.y = math.random(-1*1000000, 1000000)
vtarg.z = math.random(-1*1000000, 1000000)
if math.fmod(i,2) == 1 then gpu.setBackground(0, true) gpu.setForeground(15, true) else gpu.setForeground(0, true) gpu.setBackground(15, true) end
v1.x = math.random(-1*math.pow(10, math.fmod(i-1, 5)+1), math.pow(10, math.fmod(i-1, 5)+1))
v1.y = math.random(-1*math.pow(10, math.fmod(i-1, 5)+1), math.pow(10, math.fmod(i-1, 5)+1))
v1.z = math.random(-1*math.pow(10, math.fmod(i-1, 5)+1), math.pow(10, math.fmod(i-1, 5)+1))
v2.x = math.random(-1*math.pow(10, math.fmod(i-1, 5)+1), math.pow(10, math.fmod(i-1, 5)+1))
v2.y = math.random(-1*math.pow(10, math.fmod(i-1, 5)+1), math.pow(10, math.fmod(i-1, 5)+1))
v2.z = math.random(-1*math.pow(10, math.fmod(i-1, 5)+1), math.pow(10, math.fmod(i-1, 5)+1))
v3.x = math.random(-1*math.pow(10, math.fmod(i-1, 5)+1), math.pow(10, math.fmod(i-1, 5)+1))
v3.y = math.random(-1*math.pow(10, math.fmod(i-1, 5)+1), math.pow(10, math.fmod(i-1, 5)+1))
v3.z = math.random(-1*math.pow(10, math.fmod(i-1, 5)+1), math.pow(10, math.fmod(i-1, 5)+1))
v4.x = math.random(-1*math.pow(10, math.fmod(i-1, 5)+1), math.pow(10, math.fmod(i-1, 5)+1))
v4.y = math.random(-1*math.pow(10, math.fmod(i-1, 5)+1), math.pow(10, math.fmod(i-1, 5)+1))
v4.z = math.random(-1*math.pow(10, math.fmod(i-1, 5)+1), math.pow(10, math.fmod(i-1, 5)+1))
--[[v1.x = 0
v1.y = 0
v1.z = 0
v2.x = 1000
v2.y = 0-5000+i*5000
v2.z = 0
v3.x = 1000
v3.y = 1000-5000+i*5000
v3.z = 0
v4.x = 1000
v4.y = 1000-5000+i*5000
v4.z = 1000]]

 
gpu.fill(1, 6*i-5, 80, 6, " ")
gpu.set(1,6*i-5,"Original 1")
gpu.set(21, 6*i-5, tostring(v1.x))
gpu.set(41, 6*i-5, tostring(v1.y))
gpu.set(61, 6*i-5, tostring(v1.z))
gpu.set(1,6*i-4,"Original 2")
gpu.set(21, 6*i-4, tostring(v2.x))
gpu.set(41, 6*i-4, tostring(v2.y))
gpu.set(61, 6*i-4, tostring(v2.z))
gpu.set(1,6*i-3,"Original 3")
gpu.set(21, 6*i-3, tostring(v3.x))
gpu.set(41, 6*i-3, tostring(v3.y))
gpu.set(61, 6*i-3, tostring(v3.z))
gpu.set(1,6*i-2,"Original 4")
gpu.set(21, 6*i-2, tostring(v4.x))
gpu.set(41, 6*i-2, tostring(v4.y))
gpu.set(61, 6*i-2, tostring(v4.z))
local tri = {}
tri = trilateration(v1, v2, v3, v4, vlen(vsub(vtarg, v1)), vlen(vsub(vtarg, v2)), vlen(vsub(vtarg, v3)), vlen(vsub(vtarg, v4)))
gpu.set(1,6*i-1,"Target point")
gpu.set(21, 6*i-1, tostring(vtarg.x))
gpu.set(41, 6*i-1, tostring(vtarg.y))
gpu.set(61, 6*i-1, tostring(vtarg.z))
gpu.set(1,6*i,"Calculated point")
gpu.set(21, 6*i, tostring(tri.x))
gpu.set(41, 6*i, tostring(tri.y))
gpu.set(61, 6*i, tostring(tri.z))
os.sleep(0)
end


