comp  = require("component")
term = require("term")
math = require("math")
pc = require("computer")
event = require("event")
serial = require("serialization")
local gpu
if (comp.isAvailable("gpu")) then
 gpu = comp.gpu
 if(gpu.maxDepth() < 4) then
 gpu.set(1,10,"Please, install Graphics Card tier 2 or higher") 
 pc.beep(40, 0.5)
 pc.beep(40, 0.5)
 os.sleep(2)
 os.exit(false)
 end
else
pc.beep(40, 1)
os.exit(false)
end
local modem
local mod = comp.isAvailable("modem")
if (mod) then
 modem = comp.modem
 if(comp.modem.isWireless() == false) then
 pc.beep(40, 0.5)
 pc.beep(40, 0.5)
 gpu.set(1,10,"Please, install Wireless Card level 2")
 os.sleep(2) 
 os.exit(false)
 elseif (comp.modem.setStrength(400) == 16) then
 pc.beep(40, 0.5)
 pc.beep(40, 0.5)
 gpu.set(1,10,"Please, install Wireless Card level 2")
 os.sleep(2)
 os.exit(false)
 end
else
pc.beep(40, 1)
os.exit(false)
end
local gate
local gch = comp.isAvailable("stargate")
if (gch) then
 pc.beep(40, 0.5)
 pc.beep(40, 0.5)
 gate = comp.stargate
 else
 gpu.set(1,10,"Stargate not connected")
 pc.beep(40, 1)
 os.exit(false)
end

modem.setStrength(50)
modem.open(1001)

local addx = 0
local addy = 0
local pmode
local x1, x2, x3, y1, y2, y3, z1, z2, z3
local addmod = 0
sortmode = -1
local glmass = {}
local add = {}
local linktest = false
local srec = ""
sladd = {}
slmod = {}
local slnum = 0
local tloop = true
local slener = {}
--local slaveonly = false
local ener = 0
local mwfcode = {"Andromeda", "Aquarius", "Aries", "Auriga", "Bootes", "Cancer", "Canis Minor", "Capricornus", "Centaurus", "Cetus", "Corona Australis", "Crater", "Equuleus", "Eridanus", "Gemini", "Hydra", "Leo", "Leo Minor", "Libra", "Lynx", "Microscopium", "Monoceros", "Norma", "Orion", "Pegasus", "Perseus", "Pisces", "Piscis Austrinus", "Sagittarius", "Scorpius", "Sculptor", "Scutum", "Serpens Caput", "Sextans", "Taurus", "Triangulum", "Virgo", ""} 
local unf = {"Glyph 1", "Glyph 2", "Glyph 3", "Glyph 4", "Glyph 5", "Glyph 6", "Glyph 7", "Glyph 8", "Glyph 9", "Glyph 10", "Glyph 11", "Glyph 12", "Glyph 13", "Glyph 14", "Glyph 15", "Glyph 16", "Glyph 18", "Glyph 19", "Glyph 20", "Glyph 21", "Glyph 22", "Glyph 23", "Glyph 24", "Glyph 25", "Glyph 26", "Glyph 27", "Glyph 28", "Glyph 29", "Glyph 30", "Glyph 31", "Glyph 32", "Glyph 33", "Glyph 34", "Glyph 35", "Glyph 36", ""}
local pgf = {"Acjesis", "Lenchan", "Alura", "Ca Po", "Laylox", "Ecrumig", "Avoniv", "Bydo", "Aaxel", "Aldeni", "Setas", "Arami", "Danami", "Poco Re", "Robandus", "Recktic", "Zamilloz", "Dawnre", "Salma", "Hamlinto", "Elenami", "Tahnan", "Zeo", "Roehi", "Once El", "Baselai", "Sandovi", "Illume", "Amiwill", "Sibbron", "Gilltin", "Abrin", "Ramnon", "Olavii", "Hacemill", ""}
--local pbalph = {"⣏","⣉","⣹","⣿"}
local pbe = "⣏⣉⣉⣉⣹"
--local pbf = "⣿⣿⣿⣿⣿"

--dial--
function dial(addr, int)
local pos = 28
if int == nil then int = 0 else gpu.set(9, pos+4*(int-1), "Starting dial       ") end
for i, val in ipairs(addr) do
 while(gate.getGateStatus() ~= "idle") do
  if int == 0 then
  os.sleep(0)
  else
  os.sleep(0.2)
  gpu.set(1,43, string.format("Current: %u RF", gate.getEnergyStored()))
  end
 end
os.sleep(0.16)
gate.engageSymbol(val)
 if int > 0 and i > 1 then 
 gpu.set(9, pos+4*(int-1), string.format("Shevron %u - engaged", i-1)) 
 pc.beep(150, 0.1)
 gpu.setForeground(0xFFFFFF)
 gpu.setBackground(0xAAAAAA)
 gpu.set(1+5*(i-2), pos+1+4*(int-1), pbe)
 gpu.setForeground(0xFFFFFF)
 gpu.setBackground(0x000000)
 end
end
while(gate.getGateStatus() ~= "idle") do os.sleep(0) end
gpu.set(9, pos+4*(int-1), "Shevron 7 - locked  ") 
pc.beep(180, 0.1)
gpu.setForeground(0xFFFFFF)
gpu.setBackground(0xAAAAAA)
gpu.set(31, pos+1+4*(int-1), pbe)
gpu.setForeground(0xFFFFFF)
gpu.setBackground(0x000000)
os.sleep(0.16)
end
--dial--

--calculation functions--
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
local vi = {}
local vj = {}
vi.x = 1
vi.y = 0
vi.z = 0
vj.x = 0
vj.y = 1
vj.z = 0
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
  new.y = (s1*s1 - s3*s3 + (v34.x*v34.x+v34.y*v34.y)-2*v34.x*new.x) / (2*v34.y)
  local mayz = math.sqrt(math.abs(s1*s1-(new.x*new.x+new.y*new.y)))
    if (math.abs(s4-math.sqrt(math.pow((new.x-v44.x), 2)+math.pow((new.y-v44.y), 2)+math.pow((mayz-v44.z),2))) <= math.abs(s4-math.sqrt(math.pow((new.x-v44.x), 2)+math.pow((new.y-v44.y), 2)+math.pow(((0-mayz)-v44.z),2)))) then
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
--calculation functions--

--split--
function split(pString, pPattern)
   local Table = {}
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
--split--

--Milkyway glyph sorting method choose--
function sortchoose()
term.clear()
sortmode = io.open("sort.ff", "r")
 if (sortmode == nil or sortmode:seek("end") == 0) then
 sortmode = io.open("sort.ff", "w")
 term.write("Milkyway glyph sorting.\nChoose one: 1 - gate clockwise sorting, 2 - DHD clockwise sorting, 3 - alphabet sorting.\n")
 while (true) do
 local _, choose = pcall(io.read)
  if (choose == "1" or choose == "2" or choose == "3") then
  sortmode:write(string.format("sort = %s", choose))
  sortmode:close()
  break
  else
  term.write("Wrong value!\n")
  end
 end
 else
 sortmode:seek("set")
end
sortmode:close()
dofile("sort.ff")
end

sortchoose()

if(sort == 1) then dofile("MWGS.ff") elseif(sort == 2) then dofile("MWDS.ff") else dofile("MWAS.ff") end
--Milkyway glyph sorting method choose--

--test link--
function testlink(_, _, rec, _, _, msg)
if msg == "link" then
 linktest = true
 srec = rec
 end
end
--test link--

--slave add screen touch--
function slavetouch(_, _, x, y)
local num = 0
 if (x > 161-addx and y > 5 and y < addy+5 and x ~= 160-addx+addmod and #add<6) then
  pc.beep(150, 0.1)
  if (x < 160-addx+addmod and glmass[y-5] ~= "") then
  num = y-5
  local check = true
   if #add > 0 then
    for i = 1, #add do
    if add[i] == glmass[num] then check = false break end
    end
    if check then
    add[#add+1] = glmass[num] 
    gpu.setBackground(0x666666)
    gpu.setForeground(0xFFC400)
    local str = glmass[num]
    while #str < addmod-2 do str = string.format("%s%s", str, " ") end
    gpu.set(162-addx, y, str)
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
    end
   else
   add[1] = glmass[num]
   gpu.setBackground(0x666666)
   gpu.setForeground(0xFFC400)
   local str = glmass[num]
   while #str < addmod-2 do str = string.format("%s%s", str, " ") end
   gpu.set(162-addx, y, str)
   gpu.setBackground(0x000000)
   gpu.setForeground(0xFFFFFF)
   end
  elseif (glmass[y-6+addy] ~= "") then
  num = y-6+addy
  local check = true
   if #add > 0 then
    for i = 1, #add do
    if add[i] == glmass[num] then check = false break end
    end
    if check then
    add[#add+1] = glmass[num]
	gpu.setBackground(0x666666)
    gpu.setForeground(0xFFC400)
	local str = glmass[num]
	while #str < addmod-2 do str = string.format("%s%s", str, " ") end
	gpu.set(161-addx+addmod, y, str)
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
	end
   else
   add[1] = glmass[num]
   gpu.setBackground(0x666666)
   gpu.setForeground(0xFFC400)
   local str = glmass[num]
   while #str < addmod-2 do str = string.format("%s%s", str, " ") end
   gpu.set(161-addx+addmod, y, str)
   gpu.setBackground(0x000000)
   gpu.setForeground(0xFFFFFF)
   end
  end
 local l = 0
 gpu.setForeground(0xFFFFFF)
  for line in GlyphImages[add[#add]]:gmatch("[^\r\n]+") do
  gpu.set((#add-1)*(addmod-2)+2, 6+l, line)
  l = l+1
  end
 elseif (x > 141 and x < 149 and y == addy+6) then
 pc.beep(120, 0.05)
 pc.beep(150, 0.05)
  add = {}
 gpu.setBackground(0x000000)
 gpu.setForeground(0xFFFFFF)
 if gate.getGateType() == "MILKYWAY" then
 addx = 34 addy = 20 addmod = 18 glmass = mwf
 elseif gate.getGateType() == "UNIVERSE" then
 addx = 18 addy = 19 addmod = 10 glmass = unf
 end
 for i = 0, addy do
 local str = ""
   if i == 0 then 
   for j = 1, addx do
    if j == 1 then str = "┌" elseif j == addmod then str = string.format("%s%s", str, "┬") else str = string.format("%s%s", str, "─") end end
   elseif i == addy then
   for j = 1, addx do
    if j == 1 then str = "└" elseif j == addmod then str = string.format("%s%s", str, "┴") else str = string.format("%s%s", str, "─") end end
   else
    str = string.format("%s%s", "│", glmass[i]) while #str < addmod+1 do str = string.format("%s%s", str, " ") end str = string.format("%s%s%s", str, "│", glmass[i+addy-1])  while #str < addx+4 do str = string.format("%s%s", str, " ") end
   end
   gpu.set(161-addx,i+5, str)
 end
 local adx, ady, admod
  if gate.getGateType() == "MILKYWAY" then
  adx = 9 ady = 97 admod = 16 dofile("MWG.ff")
  elseif gate.getGateType() == "UNIVERSE" then
  adx = 19 ady = 49 admod = 8 dofile("UNG.ff")
  end
  for i = 0, adx do
  local str = ""
   for j = 1, ady do
    if math.fmod(j-1, admod) == 0 then
     if i == 0 then 
     if j == 1 then str = "┌" elseif j == ady then str = string.format("%s%s", str, "┐") else str = string.format("%s%s", str, "┬") end
     elseif i == adx then
     if j == 1 then str = "└" elseif j == ady then str = string.format("%s%s", str, "┘") else str = string.format("%s%s", str, "┴") end
     else
     str = string.format("%s%s", str, "│")
     end
    else
    if i == 0 or i == adx then str = string.format("%s%s", str, "─") else str = string.format("%s%s", str, " ") end
    end
   end
   gpu.set(1,i+5, str)
  end
 elseif (x > 152 and y == addy+6) then
 pc.beep(180, 0.1)
  if #add == 6 then
   if (gate.getEnergyRequiredToDial(add) ~= "address_malformed" and gate.getEnergyRequiredToDial(add) ~= "not_merged") then
    if (gate.getEnergyRequiredToDial(add).open + gate.getEnergyRequiredToDial(add).keepAlive*10 < gate.getEnergyStored()) then
    gpu.set(9, 28, "Prepare for dialing") 
    gate.disengageGate()
	gate.engageGate()
     if gate.getGateType() == "MILKYWAY" then
     add[7] = "Point of Origin"
     elseif gate.getGateType() == "UNIVERSE" then
     add[7] = "Glyph 17"
	 end
     while(gate.getGateStatus() ~= "idle") do os.sleep(0.2) gpu.set(1,42, string.format("Address: %u RF", gate.getEnergyRequiredToDial(add).open + gate.getEnergyRequiredToDial(add).keepAlive*10)) end
     os.sleep(0.25)
     dial(add, 1)
     gate.engageGate()
	 while(gate.getGateStatus() ~= "open") do os.sleep(0.2) gpu.set(1,42, string.format("Address: %u RF", gate.getEnergyRequiredToDial(add).open + gate.getEnergyRequiredToDial(add).keepAlive*10)) end
     os.sleep(0.25)
     gpu.set(9, 28, "Data transmission   ") 
	 linktest = false
	 srec = ""
	 event.ignore("modem_message", testlink)
	 event.listen("modem_message", testlink)
	 modem.broadcast(1001, "link")
     for i = 1,10 do os.sleep(0.2) gpu.set(1,42, string.format("Address: %u RF", gate.getEnergyRequiredToDial(add).open + gate.getEnergyRequiredToDial(add).keepAlive*10)) end
     event.ignore("modem_message", testlink)
	 if (linktest) then
     gpu.set(9, 28, "Data received       ") 
	 gate.disengageGate()
	 slmod[slnum] = srec
	 sladd[slnum] = add
	 add = {}
	  if gate.getGateType() == "MILKYWAY" then
      sladd[slnum][7] = "Point of Origin"
      elseif gate.getGateType() == "UNIVERSE" then
      sladd[slnum][7] = "Glyph 17"
	  end
     tloop = false
	 else
     gpu.set(1,50,"PC not found. Please install PC/Server with this program and wireless card on the other side of gate link or close wormhole.")
     os.sleep(1)
     gpu.fill(1,50,160,1," ")	 
	 end
 	else
    gpu.set(1,50,string.format("Not enough energy. You need at least %u RF.", gate.getEnergyRequiredToDial(add).open + gate.getEnergyRequiredToDial(add).keepAlive*10))
    os.sleep(1)
    gpu.fill(1,50,160,1," ")
    end
  else
  add = {}
  local adx, ady, admod
   if gate.getGateType() == "MILKYWAY" then
   adx = 9 ady = 97 admod = 16 dofile("MWG.ff")
   elseif gate.getGateType() == "UNIVERSE" then
   adx = 19 ady = 49 admod = 8 dofile("UNG.ff")
   end
   for i = 0, adx do
   local str = ""
    for j = 1, ady do
     if math.fmod(j-1, admod) == 0 then
      if i == 0 then 
      if j == 1 then str = "┌" elseif j == ady then str = string.format("%s%s", str, "┐") else str = string.format("%s%s", str, "┬") end
      elseif i == adx then
      if j == 1 then str = "└" elseif j == ady then str = string.format("%s%s", str, "┘") else str = string.format("%s%s", str, "┴") end
      else
      str = string.format("%s%s", str, "│")
      end
     else
     if i == 0 or i == adx then str = string.format("%s%s", str, "─") else str = string.format("%s%s", str, " ") end
     end
    end
   gpu.set(1,i+5, str)
   end
  gpu.set(1,50,"Wrong address")
  os.sleep(1)
  gpu.fill(1,50,60,1," ")
  end
 else
 add = {}
 local adx, ady, admod
  if gate.getGateType() == "MILKYWAY" then
  adx = 9 ady = 97 admod = 16 dofile("MWG.ff")
  elseif gate.getGateType() == "UNIVERSE" then
  adx = 19 ady = 49 admod = 8 dofile("UNG.ff")
  end
  for i = 0, adx do
  local str = ""
   for j = 1, ady do
    if math.fmod(j-1, admod) == 0 then
     if i == 0 then 
     if j == 1 then str = "┌" elseif j == ady then str = string.format("%s%s", str, "┐") else str = string.format("%s%s", str, "┬") end
     elseif i == adx then
     if j == 1 then str = "└" elseif j == ady then str = string.format("%s%s", str, "┘") else str = string.format("%s%s", str, "┴") end
     else
     str = string.format("%s%s", str, "│")
     end
    else
    if i == 0 or i == adx then str = string.format("%s%s", str, "─") else str = string.format("%s%s", str, " ") end
    end
   end
  gpu.set(1,i+5, str)
  end
 gpu.set(1,50,"Wrong address")
 os.sleep(1)
 gpu.fill(1,50,60,1," ")
 end
end
end
--slave add screen touch--

--coordinates check--
function coordchk(check)
term.clear()
local book
local coo = {}
book = io.open("coord.ff", "r")
if (book == nil or book:seek("end") == 0 or check) then
    book = io.open("coord.ff", "w")
	print("Please enter the coordinates of the gate core:\n1) Press F3.\n2) Look at the gate core.\n3) Find the line \"Looking at:\".\n4) Add 0.5 to each coordinate (4 + 0.5 = 4.5, -25 + 0.5 = -24.5).\n5) Enter the resulting coordinates in \"x, y, z\" format. The separator \", \" is mandatory.\nExample: -25.5, 14.5, 6.5")
	local str = io.read()
	coo = split(str, ", ")
	book:write(string.format("x = %s\n", coo[1]))
	book:write(string.format("y = %s\n", coo[2]))
	book:write(string.format("z = %s\n", coo[3]))
    book:close()
end
book:close()
dofile("coord.ff")
end

coordchk(false)
--coordinates check--

--slaves check--
function slvchk(flag)
local book
 if gate.getGateType() == "MILKYWAY" then
 book = io.open("MWslaves.ff", "r")
 elseif gate.getGateType() == "UNIVERSE" then
 book = io.open("UNslaves.ff", "r")
 end
 if (book == nil or book:seek("end") == 0 or flag) then
  if gate.getGateType() == "MILKYWAY" then
  book = io.open("MWslaves.ff", "w")
  elseif gate.getGateType() == "UNIVERSE" then
  book = io.open("UNslaves.ff", "w")
  end
for i = 1, 3 do
term.clear()
os.sleep(0.5)
gpu.setForeground(0xFFFFFF)
term.setCursor(1,1)
term.write("Please, write address of slave gates (without PoO or G17).")
term.setCursor(1,4)
term.write(string.format("Slave #%u address:", i))
gpu.set(1, 27, "Current gate")
gpu.set(1, 28, "Status: Idle")
gpu.set(1, 29, string.format("%s%s%s%s%s%s%s", pbe, pbe, pbe, pbe, pbe, pbe, pbe))
gpu.fill(1,26,50,1,"─")
gpu.fill(1,30,50,1,"─")
gpu.fill(51,27,1,3,"│")
gpu.set(51,26,"┐")
gpu.set(51,30,"┘")
gpu.set(61,48,"┐")
gpu.fill(1,48,60,1,"─")
gpu.fill(61,49,1,2,"│")
gpu.set(51,40,"┐")
gpu.set(51,44,"┘")
gpu.fill(1,40,50,1,"─")
gpu.fill(1,44,50,1,"─")
gpu.fill(51,41,1,3,"│")
gpu.set(1,41, "Energy requirements:")
gpu.set(1,42, "Address: Unknown")
gpu.set(1,49,"System message:")
local adx, ady, admod
if gate.getGateType() == "MILKYWAY" then
adx = 9 ady = 97 admod = 16 dofile("MWG.ff")
elseif gate.getGateType() == "UNIVERSE" then
adx = 19 ady = 49 admod = 8 dofile("UNG.ff")
end
for i = 0, adx do
local str = ""
 for j = 1, ady do
 if math.fmod(j-1, admod) == 0 then
  if i == 0 then 
   if j == 1 then str = "┌" elseif j == ady then str = string.format("%s%s", str, "┐") else str = string.format("%s%s", str, "┬") end
  elseif i == adx then
   if j == 1 then str = "└" elseif j == ady then str = string.format("%s%s", str, "┘") else str = string.format("%s%s", str, "┴") end
  else
   str = string.format("%s%s", str, "│")
  end
  else
   if i == 0 or i == adx then str = string.format("%s%s", str, "─") else str = string.format("%s%s", str, " ") end
 end
 end
 gpu.set(1,i+5, str)
end
if gate.getGateType() == "MILKYWAY" then
addx = 34 addy = 20 addmod = 18 glmass = mwf
elseif gate.getGateType() == "UNIVERSE" then
addx = 18 addy = 19 addmod = 10 glmass = unf
end
for i = 0, addy do
local str = ""
  if i == 0 then 
  for j = 1, addx do
   if j == 1 then str = "┌" elseif j == addmod then str = string.format("%s%s", str, "┬") else str = string.format("%s%s", str, "─") end end
  elseif i == addy then
  for j = 1, addx do
   if j == 1 then str = "└" elseif j == addmod then str = string.format("%s%s", str, "┴") else str = string.format("%s%s", str, "─") end end
  else
   str = string.format("%s%s", "│", glmass[i]) while #str < addmod+1 do str = string.format("%s%s", str, " ") end str = string.format("%s%s%s", str, "│", glmass[i+addy-1])
  end
  gpu.set(161-addx,i+5, str)
end
gpu.set(142,addy+6,"[CLEAR]    [ DIAL ]")
slnum = i
local ignor = true
while ignor do
ignor = event.ignore("touch", slavetouch)
end
event.listen("touch", slavetouch)
tloop = true
while tloop do os.sleep(0.2) gpu.set(1,43, string.format("Current: %u RF", gate.getEnergyStored())) end
end
book:write(string.format("slmod = {\"%s\", \"%s\", \"%s\"}\n", slmod[1], slmod[2], slmod[3]))
 for i = 1, 3 do
 local str = string.format("sladd[%u] = {", i)
 for int, val in ipairs(sladd[i]) do
 if int == 1 then str = string.format("%s\"%s\"", str, val) else str = string.format("%s, \"%s\"", str, val) end
 end
 str = string.format("%s}\n", str)
 book:write(str)
 end
 goto slaveend
else goto slaveend
end
::slaveend::
book:close()
 if gate.getGateType() == "MILKYWAY" then
 dofile("MWslaves.ff")
 elseif gate.getGateType() == "UNIVERSE" then
 dofile("UNslaves.ff")
 end
end
--slaves check--

--mode choose--
function modechoose()
term.clear()
book = io.open("pmode.ff", "r")
 if (book == nil or book:seek("end") == 0) then
 book = io.open("pmode.ff", "w")
 term.write("Please select an operating mode:\nMASTER MODE - in this mode the computer will connect the gate to the gate in \"SLAVE MODE\" mode, receive data from it and perform calculations.\nEnergy is mandatory for both the computer and the gate.\nIt is not necessary to load the chunk, as the chunks around the player will be loaded automatically.\nSLAVE MODE - in this mode the computer will operate as a \"calculating beacon\" and will only transmit data to the computer in MASTER MODE.\nThe computer will transmit data by itself in the background mode, so therefore no further control of the computer is possible.\nEnergy for the computer is mandatory, but for the gate it is not. These computers should be at least in 3 instances.\nBoth the gate and the computer should be in a loaded chunk.\n1 - Master mode, 0 - Slave mode.\nYou cannot change it until you delete file /AGSS/mode.ff\n")
 while (true) do
 local _, choose = pcall(io.read)
  if (choose == "1" or choose == "0") then
  book:write(string.format("%s", choose))
  book:close()
  break
  else
  term.write("Wrong value!\n")
  end
 end
 else
 book:seek("set")
end
book:close()
book = io.open("pmode.ff", "r")
pmode = book:read()
book:close()
term.clear()
end
--mode choose--

--main screen touch--
function maintouch(_, _, sx, sy)
local s1st = 0
local s2st = 0
local s3st = 0
local num = 0
dofile("coord.ff")
if (sx > 161-addx and sy > 5 and sy < addy+5 and sx ~= 160-addx+addmod and #add<6) then
 if #add == 0 then
 gpu.setBackground(0x000000)
 gpu.setForeground(0xFFFFFF)
  if gate.getGateType() == "MILKYWAY" then
  addx = 34 addy = 20 addmod = 18 glmass = mwf
  elseif gate.getGateType() == "UNIVERSE" then
  addx = 18 addy = 19 addmod = 10 glmass = unf
  end
  for i = 0, addy do
  local str = ""
   if i == 0 then 
    for j = 1, addx do
    if j == 1 then str = "┌" elseif j == addmod then str = string.format("%s%s", str, "┬") else str = string.format("%s%s", str, "─") end
	end
   elseif i == addy then
    for j = 1, addx do
    if j == 1 then str = "└" elseif j == addmod then str = string.format("%s%s", str, "┴") else str = string.format("%s%s", str, "─") end
	end
   else
    str = string.format("%s%s", "│", glmass[i]) while #str < addmod+1 do str = string.format("%s%s", str, " ") end str = string.format("%s%s%s", str, "│", glmass[i+addy-1])  while #str < addx+4 do str = string.format("%s%s", str, " ") end
   end
   gpu.set(161-addx,i+5, str)
  end
 end
 pc.beep(150, 0.1)
 if (sx < 160-addx+addmod and glmass[sy-5] ~= "") then
 num = sy-5
 local check = true
  if #add > 0 then
   for i = 1, #add do
   if add[i] == glmass[num] then check = false break end
   end
    if check then
	add[#add+1] = glmass[num] 
	gpu.setBackground(0x666666)
    gpu.setForeground(0xFFC400)
	local str = glmass[num]
	while #str < addmod-2 do str = string.format("%s%s", str, " ") end
	gpu.set(162-addx, sy, str)
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
    end
  else
  add[1] = glmass[num]
  gpu.setBackground(0x666666)
  gpu.setForeground(0xFFC400)
  local str = glmass[num]
  while #str < addmod-2 do str = string.format("%s%s", str, " ") end
  gpu.set(162-addx, sy, str)
  gpu.setBackground(0x000000)
  gpu.setForeground(0xFFFFFF)
  end
 elseif (glmass[sy-6+addy] ~= "") then
 num = sy-6+addy
 local check = true
  if #add > 0 then
   for i = 1, #add do
   if add[i] == glmass[num] then check = false break end
   end
    if check then
    add[#add+1] = glmass[num]
	gpu.setBackground(0x666666)
    gpu.setForeground(0xFFC400)
	local str = glmass[num]
	while #str < addmod-2 do str = string.format("%s%s", str, " ") end
	gpu.set(161-addx+addmod, sy, str)
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
	end
  else
  add[1] = glmass[num]
  gpu.setBackground(0x666666)
  gpu.setForeground(0xFFC400)
  local str = glmass[num]
  while #str < addmod-2 do str = string.format("%s%s", str, " ") end
  gpu.set(161-addx+addmod, sy, str)
  gpu.setBackground(0x000000)
  gpu.setForeground(0xFFFFFF)
  end
 end
local l = 0
gpu.setForeground(0xFFFFFF)
 for line in GlyphImages[add[#add]]:gmatch("[^\r\n]+") do
 gpu.set((#add-1)*(addmod-2)+2, 6+l, line)
 l = l+1
 end
elseif (sx > 152 and sy == addy+6) then
pc.beep(120, 0.05)
pc.beep(180, 0.05)
gpu.fill(123,48,60,3," ")
 for i = 1, 3 do
  local bool = {0, 0, 0, 0, 0, 0}
   for j = 1, 6 do 
   if add[j] == sladd[i][j] then bool[j] = 1 end
   end
  if bool[1] == bool[2] and bool[2] == bool[3] and bool[3] == bool[4] and bool[4] == bool[5] and bool[5] == bool[6] and bool[1] == 1 then
  add = {}
  gpu.set(1,50,"This gate slave/master gate")
  pc.beep(100, 0.5)
  pc.beep(100, 0.5)
  gate.disengageGate()
  gate.engageGate()
  break
  end
 end
 if #add == 6 and gate.getEnergyRequiredToDial(add) ~= "address_malformed" and gate.getEnergyRequiredToDial(add) ~= "not_merged" then
 local gatecrd = {}
 local gatedst = {}
 for i = 1, 4 do gatecrd[i] = {} gatedst[i] = 0 end
 gatecrd[1].x = x
 gatecrd[1].y = y
 gatecrd[1].z = z
 gatedst[1] = gate.getEnergyRequiredToDial(add).open + 0.5
 sradd = {}
 for i = 1, 3 do
 slener[i] = gate.getEnergyRequiredToDial(sladd[i]).open + gate.getEnergyRequiredToDial(sladd[i]).keepAlive*10
 end
 for i = 1, 6 do
  if gate.getGateType() == "MILKYWAY" then
   for j = 1, #mwfcode do
   if mwfcode[j] == add[i] then sradd[i] = j end
   end
  elseif gate.getGateType() == "UNIVERSE" then
   for j = 1, #unf do
   if mwf[j] == add[i] then sradd[i] = j end
   end
  end
 end
 seradd = serial.serialize(sradd)
 for i = 1, 3 do
  gpu.set(9, 28+4*(i-1), "Prepare for dialing") 
  gate.disengageGate()
  gate.engageGate()
  while(gate.getGateStatus() ~= "idle") do os.sleep(0) end
  os.sleep(0.25)
  while (slener[i] > gate.getEnergyStored()) do
  gpu.set(9, 28+4*(i-1), "Low energy. Waiting.")
  os.sleep(0.2)
  gpu.set(1,43, string.format("Current: %u RF", gate.getEnergyStored()))
  end
  dial(sladd[i], i)
  gate.engageGate()
  while(gate.getGateStatus() ~= "open") do os.sleep(0) end
  os.sleep(0.25)
  gpu.set(9, 28+4*(i-1), "Data transmission   ") 
  modem.send(slmod[i], 1001, "find", seradd)
  local _, _, _, _, _, crd, eng = event.pull("modem_message")
  gatecrd[i+1] = serial.unserialize(crd)
  gatedst[i+1] = tonumber(eng)
  gpu.set(9, 28+4*(i-1), "Data received       ") 
  gate.disengageGate()
  end
 local targ = trilateration(gatecrd[1], gatecrd[2], gatecrd[3], gatecrd[4], gatedst[1], gatedst[2], gatedst[3], gatedst[4])
 for i = 1, 3 do
 gpu.set(9, 28+4*(i-1), "Idle                ")
 gpu.set(1, 29+4*(i-1), string.format("%s%s%s%s%s%s%s", pbe, pbe, pbe, pbe, pbe, pbe, pbe))
 end
 gpu.set(90,48,tostring(targ.x))
 gpu.set(90,49,tostring(targ.y))
 gpu.set(90,50,tostring(targ.z))
 else
 add = {}
local adx, ady, admod
 if gate.getGateType() == "MILKYWAY" then
 adx = 9 ady = 97 admod = 16 dofile("MWG.ff")
 elseif gate.getGateType() == "UNIVERSE" then
 adx = 19 ady = 49 admod = 8 dofile("UNG.ff")
 end
 for i = 0, adx do
 local str = ""
  for j = 1, ady do
   if math.fmod(j-1, admod) == 0 then
    if i == 0 then 
    if j == 1 then str = "┌" elseif j == ady then str = string.format("%s%s", str, "┐") else str = string.format("%s%s", str, "┬") end
    elseif i == adx then
    if j == 1 then str = "└" elseif j == ady then str = string.format("%s%s", str, "┘") else str = string.format("%s%s", str, "┴") end
    else
    str = string.format("%s%s", str, "│")
    end
   else
   if i == 0 or i == adx then str = string.format("%s%s", str, "─") else str = string.format("%s%s", str, " ") end
   end
  end
 gpu.set(1,i+5, str)
 end
 gpu.set(1,50,"Wrong address")
 os.sleep(1)
 gpu.fill(1,50,60,1," ")
 end
elseif (sx > 141 and sx < 149 and sy == addy+6) then
pc.beep(120, 0.05)
pc.beep(150, 0.05)
add = {}
gpu.setBackground(0x000000)
gpu.setForeground(0xFFFFFF)
if gate.getGateType() == "MILKYWAY" then
addx = 34 addy = 20 addmod = 18 glmass = mwf
elseif gate.getGateType() == "UNIVERSE" then
addx = 18 addy = 19 addmod = 10 glmass = unf
end
for i = 0, addy do
local str = ""
  if i == 0 then 
  for j = 1, addx do
   if j == 1 then str = "┌" elseif j == addmod then str = string.format("%s%s", str, "┬") else str = string.format("%s%s", str, "─") end end
  elseif i == addy then
  for j = 1, addx do
   if j == 1 then str = "└" elseif j == addmod then str = string.format("%s%s", str, "┴") else str = string.format("%s%s", str, "─") end end
  else
   str = string.format("%s%s", "│", glmass[i]) while #str < addmod+1 do str = string.format("%s%s", str, " ") end str = string.format("%s%s%s", str, "│", glmass[i+addy-1])  while #str < addx+4 do str = string.format("%s%s", str, " ") end
  end
  gpu.set(161-addx,i+5, str)
end
local adx, ady, admod
 if gate.getGateType() == "MILKYWAY" then
 adx = 9 ady = 97 admod = 16 dofile("MWG.ff")
 elseif gate.getGateType() == "UNIVERSE" then
 adx = 19 ady = 49 admod = 8 dofile("UNG.ff")
 end
 for i = 0, adx do
 local str = ""
  for j = 1, ady do
   if math.fmod(j-1, admod) == 0 then
    if i == 0 then 
    if j == 1 then str = "┌" elseif j == ady then str = string.format("%s%s", str, "┐") else str = string.format("%s%s", str, "┬") end
    elseif i == adx then
    if j == 1 then str = "└" elseif j == ady then str = string.format("%s%s", str, "┘") else str = string.format("%s%s", str, "┴") end
    else
    str = string.format("%s%s", str, "│")
    end
   else
   if i == 0 or i == adx then str = string.format("%s%s", str, "─") else str = string.format("%s%s", str, " ") end
   end
  end
  gpu.set(1,i+5, str)
 end
elseif(sx > 129 and sx < 139 and sy == addy+6 and gate.getGateType() == "MILKYWAY") then
pc.beep(180, 0.05)
pc.beep(150, 0.05)
add = {}
gpu.setBackground(0x000000)
gpu.setForeground(0xFFFFFF)
addx = 34 addy = 20 addmod = 18 glmass = mwf
for i = 0, addy do
local str = ""
  if i == 0 then 
  for j = 1, addx do
   if j == 1 then str = "┌" elseif j == addmod then str = string.format("%s%s", str, "┬") else str = string.format("%s%s", str, "─") end end
  elseif i == addy then
  for j = 1, addx do
   if j == 1 then str = "└" elseif j == addmod then str = string.format("%s%s", str, "┴") else str = string.format("%s%s", str, "─") end end
  else
   str = string.format("%s%s", "│", glmass[i]) while #str < addmod+1 do str = string.format("%s%s", str, " ") end str = string.format("%s%s%s", str, "│", glmass[i+addy-1])  while #str < addx+4 do str = string.format("%s%s", str, " ") end
  end
  gpu.set(161-addx,i+5, str)
end
local adx, ady, admod
adx = 9 ady = 97 admod = 16 dofile("MWG.ff")
 for i = 0, adx do
 local str = ""
  for j = 1, ady do
   if math.fmod(j-1, admod) == 0 then
    if i == 0 then 
    if j == 1 then str = "┌" elseif j == ady then str = string.format("%s%s", str, "┐") else str = string.format("%s%s", str, "┬") end
    elseif i == adx then
    if j == 1 then str = "└" elseif j == ady then str = string.format("%s%s", str, "┘") else str = string.format("%s%s", str, "┴") end
    else
    str = string.format("%s%s", str, "│")
    end
   else
   if i == 0 or i == adx then str = string.format("%s%s", str, "─") else str = string.format("%s%s", str, " ") end
   end
  end
  gpu.set(1,i+5, str)
 end
local diadd = gate.dialedAddress
diadd = diadd:sub(2, #diadd-1)
add = split(diadd, ", ")
if #add > 6 then gpu.set(1,50,"Unsupportable address") add = {} end
local num = 0
 for _, val in ipairs(add) do
  for i, v in ipairs(mwf) do
   if v == val then 
   local str = v
   while #str < 16 do str = string.format("%s%s", str, " ") end
   gpu.setBackground(0x666666)
   gpu.setForeground(0xFFC400)
   gpu.set(128+(math.floor((i-1)/19)*17), math.fmod(i-1, 19)+6, str)
   gpu.setBackground(0x000000)
   gpu.setForeground(0xFFFFFF)
   local l = 0
    for line in GlyphImages[v]:gmatch("[^\r\n]+") do
    gpu.set(num*16+2, 6+l, line)
    l = l+1
    end
	num = num+1
   end
  end
 end
elseif (sx > 121 and sx < 141 and sy == 39) then
pc.beep(150, 0.05)
pc.beep(150, 0.05)
coordchk(true)
mainscreen()
elseif (sx > 145 and sy == 39) then
pc.beep(120, 0.05)
pc.beep(120, 0.05)
slvchk(true)
mainscreen()
end
end
--main screen touch--

--mainscreen--
function mainscreen()
slvchk(false)
 if gate.getGateType() == "MILKYWAY" then
 dofile("MWslaves.ff")
 elseif gate.getGateType() == "UNIVERSE" then
 dofile("UNslaves.ff")
 end
for i = 1, 3 do
slener[i] = gate.getEnergyRequiredToDial(sladd[i]).open + gate.getEnergyRequiredToDial(sladd[i]).keepAlive*10
end 
term.clear()
os.sleep(0.5)
gpu.setForeground(0xFFFFFF)
term.setCursor(1,1)
term.write("Welcome to Aunis Gate Search System.\nNote: AGSS works only for gates in same dimension.")
term.setCursor(1,4)
term.write("Current search address:")
local adx, ady, admod
if gate.getGateType() == "MILKYWAY" then
adx = 9 ady = 97 admod = 16 dofile("MWG.ff")
elseif gate.getGateType() == "UNIVERSE" then
adx = 19 ady = 49 admod = 8 dofile("UNG.ff")
end
for i = 0, adx do
local str = ""
 for j = 1, ady do
 if math.fmod(j-1, admod) == 0 then
  if i == 0 then 
   if j == 1 then str = "┌" elseif j == ady then str = string.format("%s%s", str, "┐") else str = string.format("%s%s", str, "┬") end
  elseif i == adx then
   if j == 1 then str = "└" elseif j == ady then str = string.format("%s%s", str, "┘") else str = string.format("%s%s", str, "┴") end
  else
   str = string.format("%s%s", str, "│")
  end
  else
   if i == 0 or i == adx then str = string.format("%s%s", str, "─") else str = string.format("%s%s", str, " ") end
 end
 end
 gpu.set(1,i+5, str)
end
if gate.getGateType() == "MILKYWAY" then
addx = 34 addy = 20 addmod = 18 glmass = mwf
elseif gate.getGateType() == "UNIVERSE" then
addx = 18 addy = 19 addmod = 10 glmass = unf
end
for i = 0, addy do
local str = ""
  if i == 0 then 
  for j = 1, addx do
   if j == 1 then str = "┌" elseif j == addmod then str = string.format("%s%s", str, "┬") else str = string.format("%s%s", str, "─") end end
  elseif i == addy then
  for j = 1, addx do
   if j == 1 then str = "└" elseif j == addmod then str = string.format("%s%s", str, "┴") else str = string.format("%s%s", str, "─") end end
  else
   str = string.format("%s%s", "│", glmass[i]) while #str < addmod+1 do str = string.format("%s%s", str, " ") end str = string.format("%s%s%s", str, "│", glmass[i+addy-1])
  end
  gpu.set(161-addx,i+5, str)
end
 if gate.getGateType() == "MILKYWAY" then
 gpu.set(129,addy+6,"[GET DHD]    [CLEAR]    [ FIND ]")
 elseif gate.getGateType() == "UNIVERSE" then
 gpu.set(142,addy+6,"[CLEAR]    [ FIND ]")
 end
gpu.set(121,39,"[CHANGE COORDINATES]     [CHANGE SLAVES]")
gpu.fill(1,26,50,1,"─")
gpu.fill(1,38,50,1,"─")
gpu.fill(1,44,50,1,"─")
gpu.fill(51,27,1,17,"│")
gpu.set(51,26,"┐")
gpu.set(51,38,"┤")
gpu.set(51,44,"┘")
gpu.set(61,48,"┐")
gpu.fill(1,48,60,1,"─")
gpu.fill(61,49,1,2,"│")
gpu.fill(85,46,80,1,"─")
gpu.fill(85,40,80,1,"─")
gpu.fill(84,41,1,10,"│")
gpu.set(84,46,"├")
gpu.set(84,40,"┌")
gpu.set(85,41,"Impotrant note:")
gpu.set(85,42,"Obtained result is not accurate. The accuracy of the calculations depends")
gpu.set(85,43,"on the distances between the Master and Slaves gates (more is better).")
gpu.set(85,44,"However, even in the most accurate calculations, the gate may be")
gpu.set(85,45,"about 100-200 blocks away from the obtained coordinates.")
gpu.set(1,49,"System message:")
gpu.set(85,47,"Search result:")
gpu.set(85,48,"X: ")
gpu.set(85,49,"Y: ")
gpu.set(85,50,"Z: ")
gpu.set(1, 27, "Slave #1")
gpu.set(1, 28, "Status: Idle")
gpu.set(1, 31, "Slave #2")
gpu.set(1, 32, "Status: Idle")
gpu.set(1, 35, "Slave #3")
gpu.set(1, 36, "Status: Idle")
for i = 1, 3 do gpu.set(1, 29+(i-1)*4, string.format("%s%s%s%s%s%s%s",pbe,pbe,pbe,pbe,pbe,pbe,pbe)) end
gpu.set(1,39, "Energy requirements:")
for i = 1, 3 do gpu.set(1,39+i, string.format("Gate %u: %u RF", i, slener[i])) end
local ignor = true
while ignor do
ignor = event.ignore("touch", maintouch)
end
event.listen("touch", maintouch)
while true do os.sleep(0.2) gpu.set(1,43, string.format("Current: %u RF", gate.getEnergyStored())) end
end
--mainscreen--

--slave message send--
function slavemessage(_, recev, snd, _, _, msg, msgadd)
os.sleep(1)
 if msg == "link" then
 modem.send(snd, 1001, "link")
 os.sleep(0.2)
 modem.send(snd, 1001, "link")
 os.sleep(0.2)
 modem.send(snd, 1001, "link")
 elseif msg == "find" then
 local numadd = serial.unserialize(msgadd)
 local add = {}
  if gate.getGateType() == "MILKYWAY" then
  for i = 1, 6 do add[i] = mwfcode[numadd[i]] end
  elseif gate.getGateType() == "UNIVERSE" then
  for i = 1, 6 do add[i] = unf[numadd[i]] end
  end
 local energy = gate.getEnergyRequiredToDial(add).open + 0.5
 local vec = {} vec.x = x vec.y = y vec.z = z
 local servec = serial.serialize(vec)
 modem.send(snd, 1001, servec, energy)
 os.sleep(0.2)
 modem.send(snd, 1001, servec, energy)
 os.sleep(0.2)
 modem.send(snd, 1001, servec, energy)
 end
end
--slave message send--

--slavescreen--
function slavescreen()
term.clear()
local ignor = true
while ignor do
ignor = event.ignore("modem_message", slavemessage)
end
event.listen("modem_message", slavemessage)
dofile("BG.ff")
local l = 0
for line in BG:gmatch("[^\r\n]+") do
gpu.set(38,6+l,line)
l = l+1
end
gpu.set(75, 50, "SLAVE MODE")
while true do os.sleep(10) end
end
--slavescreen--

modechoose()
if tonumber(pmode) == 1 then mainscreen() elseif tonumber(pmode) == 0 then slavescreen() end
