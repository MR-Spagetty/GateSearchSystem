local comp = require("component")
local math = require("math")
local mod = comp.modem
local event = require("event")
local pc = require("computer")
local term = require("term")
local serial = require("serialization")
local string = require("string")
local gpu = comp.gpu
local gate = comp.stargate
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

function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
     table.insert(Table,cap)
      end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
   end
   if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
   end
   return Table
end

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

function trilateration (v1, v2, v3, v4, e1, e2, e3, e4)
local s1, s2, s3, s4 = 0
if e1/4608 > 4000 then s1 = math.pow(5000, (e1/4608/5000)) else s1 = e1/4608 / (0.8) end
if e2/4608 > 4000 then s2 = math.pow(5000, (e2/4608/5000)) else s2 = e2/4608 / (0.8) end
if e3/4608 > 4000 then s3 = math.pow(5000, (e3/4608/5000)) else s3 = e3/4608 / (0.8) end
if e4/4608 > 4000 then s4 = math.pow(5000, (e4/4608/5000)) else s4 = e4/4608 / (0.8) end
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
  local xrot = new.x/(math.modf(new.x*2)/2)
  s1 = s1/xrot
  new.x = new.x / xrot
  --new.y = (s1*s1 - s3*s3 + v34.x*v34.x + v34.y*v34.y) / (2*v34.y) - new.x*(v34.x/v34.y)
  new.y = (s1*s1 - s3*s3 + (v34.x*v34.x+v34.y*v34.y)-2*v34.x*new.x) / (2*v34.y)
  local mayz = math.sqrt(math.abs(s1*s1-(new.x*new.x+new.y*new.y)))
    --if (math.abs(s4*s4-((new.x-v44.x)*(new.x-v44.x)+(new.y-v44.y)*(new.y-v44.y)+(mayz-v44.z)*(mayz-v44.z))) <= math.abs(s4*s4-((new.x-v44.x)*(new.x-v44.x)+(new.y-v44.y)*(new.y-v44.y)+(0-mayz-v44.z)*(0-mayz-v44.z)))) then
    if (math.abs(s4-math.sqrt(math.pow((new.x-v44.x), 2)+math.pow((new.y-v44.y), 2)+math.pow((mayz-v44.z),2))) <= math.abs(s4-math.sqrt(math.pow((new.x-v44.x), 2)+math.pow((new.y-v44.y), 2)+math.pow(((0-mayz)-v44.z),2)))) then
    new.z = mayz
    else
    new.z = 0-mayz
    end
  local newx = vangrotx(new, tricos3, trisin3)
  local newxz = vangrotz(newx, tricos2, trisin2)
  local newxyz = vreroty(newxz, tricos1, trisin1)
 -- local newxy = vreroty(newx, tricos1, trisin1)
 -- local newxyz = vangrotz(newxy, tricos2, trisin2)
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

mod.open(1000)
mod.setStrength(10)
print ("Get this gate coordinates")
local coor = term.read()
coor = coor:gsub("\n", "")
local vec = {}
vec = split(coor, ", ")
v4.x = tonumber(vec[1])
v4.y = tonumber(vec[2])
v4.z = tonumber(vec[3])
::slave1loop::
print ("Get slave1 address")
local str1 = term.read()
str1 = str1:gsub("\n","")
local adds1 = {}
adds1 = split(str1, ", ")
if gate.getEnergyRequiredToDial(adds1) == "address_malformed" then print("wrong address") goto slave1loop end
::slave2loop::
print ("Get slave2 address")
local str2 = term.read()
str2 = str2:gsub("\n","")
local adds2 = {}
adds2 = split(str2, ", ")
if gate.getEnergyRequiredToDial(adds2) == "address_malformed" then print("wrong address") goto slave2loop end
::slave3loop::
print ("Get slave3 address")
local str3 = term.read()
str3 = str3:gsub("\n","")
local adds3 = {}
adds3 = split(str3, ", ")
if gate.getEnergyRequiredToDial(adds3) == "address_malformed" then print("wrong address") goto slave3loop end
::targetloop::
print ("Get target address")
local strt = term.read()
strt = strt:gsub("\n","")
local addt = {}
addt = split(strt, ", ")
if gate.getEnergyRequiredToDial(addt) == "address_malformed" then print("wrong address") goto targetloop end
s4 = gate.getEnergyRequiredToDial(addt).open
gate.disengageGate()
print("Slave1 start dialing")
 for i = 1, 7 do
  while (gate.getGateStatus() ~= "idle") do
  os.sleep(0)
  end
  os.sleep(0.16)
  gate.engageSymbol(adds1[i])
 end
 while (gate.getGateStatus() ~= "idle") do
 os.sleep(0)
 end
os.sleep(0.16)
gate.engageGate()
while(gate.getGateStatus() ~= "open") do os.sleep(0) end
os.sleep(0)
mod.broadcast(1000, serial.serialize(addt))
local _, _, _, _, _, vec, ener = event.pull("modem_message")
print("Slave1 data get")
local v1 = serial.unserialize(vec)
s1 = tonumber(ener)
gate.disengageGate()
print("Slave2 start dialing")
 while (gate.getGateStatus() ~= "idle") do
 os.sleep(0)
 end
os.sleep(0.16)
 for i = 1, 7 do
  while (gate.getGateStatus() ~= "idle") do
  os.sleep(0)
  end
  os.sleep(0.16)
  gate.engageSymbol(adds2[i])
 end
 while (gate.getGateStatus() ~= "idle") do
 os.sleep(0)
 end
os.sleep(0.16)
gate.engageGate()
while(gate.getGateStatus() ~= "open") do os.sleep(0) end
os.sleep(0)
mod.broadcast(1000, serial.serialize(addt))
local _, _, _, _, _, vec, ener = event.pull("modem_message")
print("Slave2 data get")
local v2 = serial.unserialize(vec)
s2 = tonumber(ener)
gate.disengageGate()
print("Slave3 start dialing")
 while (gate.getGateStatus() ~= "idle") do
 os.sleep(0)
 end
os.sleep(0.16)
 for i = 1, 7 do
  while (gate.getGateStatus() ~= "idle") do
  os.sleep(0)
  end
  os.sleep(0.16)
  gate.engageSymbol(adds3[i])
 end
 while (gate.getGateStatus() ~= "idle") do
 os.sleep(0)
 end
os.sleep(0.16)
gate.engageGate()
while(gate.getGateStatus() ~= "open") do os.sleep(0) end
os.sleep(0)
mod.broadcast(1000, serial.serialize(addt))
local _, _, _, _, _, vec, ener = event.pull("modem_message")
print("Slave3 data get")
local v3 = serial.unserialize(vec)
s3 = tonumber(ener)
gate.disengageGate()
 while (gate.getGateStatus() ~= "idle") do
 os.sleep(0)
 end
os.sleep(0.16)
local vec1 = {}
local vec2 = {}
local vec3 = {}
local vec4 = {}
local vecmas = {}
local dis1, dis2, dis3, dis4 = 0
local ymed = (v1.y+v2.y+v3.y+v4.y)/4
local ymax = math.max(math.abs(ymed - v1.y), math.abs(ymed - v2.y), math.abs(ymed - v3.y), math.abs(ymed - v4.y))
local target = trilateration(v1, v2, v3, v4, s1, s2, s3, s4)
print (target.x, target.y, target.z)



--[[
test.lua
-264.5, 152.5, -321.5
Monoceros, Triangulum, Corona Australis, Leo Minor, Piscis Austrinus, Eridanus, Point of Origin
Libra, Orion, Triangulum, Cancer, Cetus, Gemini, Point of Origin
Bootes, Monoceros, Libra, Crater, Scorpius, Norma, Point of Origin
Andromeda, Aquarius, Gemini, Auriga, Pegasus, Eridanus, Point of Origin

component.modem.open(1000) component.modem.setStrength(40) while true do local _, _, rec, _, _, ad = event.pull("modem_message") os.sleep(0.16) add = serialization.unserialize(ad) local energy = component.stargate.getEnergyRequiredToDial(add).open local vec = {} vec.x = 0.5 vec.y = 0.5 vec.z = 0.5 component.modem.send(rec, 1000, serialization.serialize(vec), energy) end


]]
