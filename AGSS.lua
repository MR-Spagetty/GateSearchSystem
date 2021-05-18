--libraries--
local comp = require("component")
local event = require("event")
local pc = require("computer")
local math = require("math")
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
local term = require("term")
local serial = require("serialization")
local math = require("math")
local string = require("string")
local gate = comp.stargate
--libraries--

--global variables--
local rounder = 1000000000000
local iomessage = ""
local iocheck = true
local iolength = 0
local unf = {"Glyph 1", "Glyph 2", "Glyph 3", "Glyph 4", "Glyph 5", "Glyph 6", "Glyph 7", "Glyph 8", "Glyph 9", "Glyph 10", "Glyph 11", "Glyph 12", "Glyph 13", "Glyph 14", "Glyph 15", "Glyph 16", "Glyph 17", "Glyph 18", "Glyph 19", "Glyph 20", "Glyph 21", "Glyph 22", "Glyph 23", "Glyph 24", "Glyph 25", "Glyph 26", "Glyph 27", "Glyph 28", "Glyph 29", "Glyph 30", "Glyph 31", "Glyph 32", "Glyph 33", "Glyph 34", "Glyph 35", "Glyph 36"}
local pgf = {"Acjesis", "Lenchan", "Alura", "Ca Po", "Laylox", "Ecrumig", "Avoniv", "Bydo", "Aaxel", "Aldeni", "Setas", "Arami", "Danami", "Poco Re", "Robandus", "Recktic", "Zamilloz", "Subido", "Dawnre", "Salma", "Hamlinto", "Elenami", "Tahnan", "Zeo", "Roehi", "Once El", "Baselai", "Sandovi", "Illume", "Amiwill", "Sibbron", "Gilltin", "Abrin", "Ramnon", "Olavii", "Hacemill"}
local add = {}
local card, mode
card = ""
local stype = ""
local linklist = {}
local sortmode
local vi = {}
local vj = {}
vi.x = 1
vi.y = 0
vi.z = 0
vj.x = 0
vj.y = 1
vj.z = 0
--global variables--

--string split--
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
--string split--

--checking master/slaves books--
function fopen()
local book
book = io.open("master.ff", "r")
if (book == nil) then
    book = io.open("master.ff", "w")
    book:close()
end
book:close()
book = io.open("slaves.ff", "r")
if (book == nil) then
    book = io.open("slaves.ff", "w")
    book:close()
end
book:close()
end

fopen()
--checking master/slaves books--

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
dofile("sort.ff")
end

sortchoose()

if(sort == 1) then dofile("MWGS.ff") elseif(sort == 2) then dofile("MWDS.ff") else dofile("MWAS.ff") end
--Milkyway glyph sorting method choose--

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
--calculation functions--

--gate coordinates check--
function coord(check)
local book
book = io.open("master.ff", "r")
if (book == nil or book:seek("end") == 0 or check == true) then
 book = io.open("master.ff", "w")
 book:write("mastercrd = {}\n")
 ::xwrong::
 term.clear()
 term.write("Stargate coordinates.\nPlease, write the corresponding coordinates of stargate's core.\n How to get gate core:\n1. Stand in the center on top of core block\n2. Press \"F3\"\n3. Find coordinates of your player (left side of the screen).\n4. Use only the integer part of the coordinates (like 3, -5, 14325 but not 23.5673 or -45.45435)\n5. Gate core coordinates can be found like this: Xcore = Xplayer - 0.5, Ycore = Yplayer - 0.5, Zcore = Zplayer - 0.5\n Xcore = ")
 while (true) do
 local _, mx = pcall(io.read)
  if (tonumber(mx) == nil) then
  term.write("Wrong value!\n")
  os.sleep(0.4)
  goto xwrong
  else
  book:write(string.format("mastercrd.x = %s\n", mx))
  break
  end
 end
 ::ywrong::
 term.clear()
 term.write("Stargate coordinates.\nPlease, write the corresponding coordinates of stargate's core.\n How to get gate core:\n1. Stand in the center on top of core block\n2. Press \"F3\"\n3. Find coordinates of your player (left side of the screen).\n4. Use only the integer part of the coordinates (like 3, -5, 14325 but not 23.5673 or -45.45435)\n5. Gate core coordinates can be found like this: Xcore = Xplayer - 0.5, Ycore = Yplayer - 0.5, Zcore = Zplayer - 0.5\n Ycore = ")
 while (true) do
 local _, my = pcall(io.read)
  if (tonumber(my) == nil) then
  term.write("Wrong value!\n")
  os.sleep(0.4)
  goto ywrong
  else
  book:write(string.format("mastercrd.y = %s\n", my))
  break
  end
 end
 term.clear()
 ::zwrong::
 term.clear()
 term.write("Stargate coordinates.\nPlease, write corresponding coordinates of stargate's core.\n How to get gate core coordinates:\n1. Stand in center on top side of core block\n2. Press \"F3\"\n3. Find coordinates of your player (left side of the screen, line \"XYZ\").\n4. Use only integer part of coordinates (like 3, -5, 14325 but not 23.5673 or -45.45435)\n5. Gate core coordinates can be found like this: Xcore = Xplayer - 0.5, Ycore = Yplayer - 0.5, Zcore = Zplayer - 0.5\n Zcore = ")
 while (true) do
 local _, mz = pcall(io.read)
  if (tonumber(mz) == nil) then
  term.write("Wrong value!\n")
  os.sleep(0.4)
  goto zwrong
  else
  book:write(string.format("mastercrd.z = %s\n", mz))
  break
  end
 end
 book:close()
 else
 book:seek("set")
end
dofile("master.ff")
end

coord()
--gate coordinates check--

--gate list create--
function slavelist(check)
local book
book = io.open("slaves.ff", "r")
if (book == nil or book:seek("end") == 0 or check == true) then
book = io.open("slaves.ff", "w")
book:write("slave = {}\n")
::s1wrong::
term.clear()
term.write("Slave gate address #1.\nPlease, write the corresponding address of slave gate.\nThis gate will be used as a reference point for calculations.\nThere will be three such points.\n Each glyph should be separated with \", \". Space required.\n\"Point of Origin\" or \"Glyph 17\"\\\"G17\" are required.\n Slave #1 address: ")
while (true) do
local _, mx = pcall(io.read)
local mxt = split(mx, ", ")
  for i, v in ipairs(mxt) do
  if gate.getGateType() == "MILKIWAY" then 
   for ind, val in ipairs(mwf) do
	if v == val then
	goto s1cont1
    end
   term.clear()
   term.write("Wrong address.\nIncorrectly entered glyphs or address is not supported.\nPlease, try again.")
   os.sleep(3)
   goto s1wrong
   ::s1cont1::
   end
  elseif gate.getGateType() == "UNIVERSE" then
   for ind, val in ipairs(unf) do
	if v == val then
	goto s1cont2
    end
   term.clear()
   term.write("Wrong address.\nIncorrectly entered glyphs or address is not supported.\nPlease, try again.")
   os.sleep(3)
   goto s1wrong
   ::s1cont2::
   end
  end
 end
 if gate.getEnergyRequiredToDial(mxt) == "address_malformed" or gate.getEnergyRequiredToDial(mxt) == "not_merged" then
   term.clear()
   term.write("Wrong address.\nIncorrectly entered address.\nPlease, try again.")
   os.sleep(3)
   goto s1wrong
   else
   book:write("slave[1] = {")
   for _, v in ipairs(mxt) do
   book:write(string.format("\"%s\", ", v))
   end
   book:write("}\n")
   goto s2wrong
 end
end
::s2wrong::
term.clear()
term.write("Slave gate address #2.\nPlease, write the corresponding address of slave gate.\nThis gate will be used as a reference point for calculations.\nThere will be three such points.\n Each glyph should be separated with \", \". Space required.\n\"Point of Origin\" or \"Glyph 17\"\\\"G17\" are required.\n Slave #2 address: ")
while (true) do
local _, mx = pcall(io.read)
local mxt = split(mx, ", ")
  for i, v in ipairs(mxt) do
  if gate.getGateType() == "MILKIWAY" then 
   for ind, val in ipairs(mwf) do
	if v == val then
	goto s2cont1
    end
   term.clear()
   term.write("Wrong address.\nIncorrectly entered glyphs or address is not supported.\nPlease, try again.")
   os.sleep(3)
   goto s2wrong
   ::s2cont1::
   end
  elseif gate.getGateType() == "UNIVERSE" then
   for ind, val in ipairs(unf) do
	if v == val then
	goto s2cont2
    end
   term.clear()
   term.write("Wrong address.\nIncorrectly entered glyphs or address is not supported.\nPlease, try again.")
   os.sleep(3)
   goto s2wrong
   ::s2cont2::
   end
  end
 end
 if gate.getEnergyRequiredToDial(mxt) == "address_malformed" or gate.getEnergyRequiredToDial(mxt) == "not_merged" then
   term.clear()
   term.write("Wrong address.\nIncorrectly entered address.\nPlease, try again.")
   os.sleep(3)
   goto s2wrong
   else
   book:write("slave[2] = {")
   for _, v in ipairs(mxt) do
   book:write(string.format("\"%s\", ", v))
   end
   book:write("}\n")
   goto s3wrong
 end
end
::s3wrong::
term.clear()
term.write("Slave gate address #3.\nPlease, write the corresponding address of slave gate.\nThis gate will be used as a reference point for calculations.\nThere will be three such points.\n Each glyph should be separated with \", \". Space required.\n\"Point of Origin\" or \"Glyph 17\"\\\"G17\" are required.\n Slave #3 address: ")
while (true) do
local _, mx = pcall(io.read)
local mxt = split(mx, ", ")
  for i, v in ipairs(mxt) do
  if gate.getGateType() == "MILKIWAY" then 
   for ind, val in ipairs(mwf) do
	if v == val then
	goto s3cont1
    end
   term.clear()
   term.write("Wrong address.\nIncorrectly entered glyphs or address is not supported.\nPlease, try again.")
   os.sleep(3)
   goto s3wrong
   ::s3cont1::
   end
  elseif gate.getGateType() == "UNIVERSE" then
   for ind, val in ipairs(unf) do
	if v == val then
	goto s3cont2
    end
   term.clear()
   term.write("Wrong address.\nIncorrectly entered glyphs or address is not supported.\nPlease, try again.")
   os.sleep(3)
   goto s3wrong
   ::s3cont2::
   end
  end
 end
 if gate.getEnergyRequiredToDial(mxt) == "address_malformed" or gate.getEnergyRequiredToDial(mxt) == "not_merged" then
   term.clear()
   term.write("Wrong address.\nIncorrectly entered address.\nPlease, try again.")
   os.sleep(3)
   goto s3wrong
   else
   book:write("slave[3] = {")
   for _, v in ipairs(mxt) do
   book:write(string.format("\"%s\", ", v))
   end
   book:write("}\n")
   goto slvend
 end
end
end
::slvend::
dofile("slaves.ff")
end

slavelist()
--gate list create--

--gate dial--
function dial (add)
for i, v in ipairs(add) do
while(gate.getGateStatus() ~= "idle") do os.sleep(0) end
os.sleep(0.16)
gate.engageSymbol(v)
if i>1 then term.write(string.format("Shevron %u, encoded\n", i-1)) end
end
while(gate.getGateStatus() ~= "idle") do os.sleep(0) end
term.write("Shevron 7, locked\n")
end
--gate dial--

--message send--
function messand (rec, msg)
  if msg == "link" then
  dofile("master.ff")
  modem.send(rec, 1000, serial.serialize(mastercrd))
  elseif msg == "find" then
  modem.send(rec, 1000, "###")
  end
end
--message send--

--mesage receive--
--mesage receive--

--slave mode--
--slave mode--

--main screen--
function mainscreen ()
gate.disengageGate()
gate.engageGate()
local v1 = {}
local v2 = {}
local v3 = {}
local v4 = {}
local s1, s2, s3, s4 = 0
local str 
local vtarg = {}
modem.open(1000)
modem.setStrength(20)
term.clear()
term.write("Change gate coordinates? Y - yes. Others - no\n")
local check1  = tostring(term.read())
if check1 == "Y" or check1 == "Y\n" then coord(true) end
term.clear()
term.write("Change slave gate's addresses? Y - yes. Others - no\n")
local check2  = term.read()
if check2 == "Y" or check2 == "Y\n" then slavelist(true) end
term.clear()
v4.x = tonumber(mastercrd.x)
v4.y = tonumber(mastercrd.y)
v4.z = tonumber(mastercrd.z)
::targetloop::
term.write ("Get target address\n")
local strt = term.read()
strt = strt:gsub("\n","")
local addt = {}
addt = split(strt, ", ")
if gate.getEnergyRequiredToDial(addt) == "address_malformed" then term.write("wrong address") goto targetloop end
s4 = gate.getEnergyRequiredToDial(addt).open
gate.disengageGate()
term.write("Slave1 start dialing\n")
dial(slave[1])
gate.engageGate()
while(gate.getGateStatus() ~= "open") do os.sleep(0) end
os.sleep(0)
modem.broadcast(1000, serial.serialize(addt))
local _, _, _, _, _, vec, ener = event.pull("modem_message")
term.write("Slave1 data get\n")
local v1 = serial.unserialize(vec)
s1 = tonumber(ener)
gate.disengageGate()
term.write("Slave2 start dialing\n")
dial(slave[2])
gate.engageGate()
while(gate.getGateStatus() ~= "open") do os.sleep(0) end
os.sleep(0)
modem.broadcast(1000, serial.serialize(addt))
local _, _, _, _, _, vec, ener = event.pull("modem_message")
term.write("Slave2 data get\n")
local v2 = serial.unserialize(vec)
s2 = tonumber(ener)
gate.disengageGate()
term.write("Slave3 start dialing\n")
dial(slave[3])
gate.engageGate()
while(gate.getGateStatus() ~= "open") do os.sleep(0) end
os.sleep(0)
modem.broadcast(1000, serial.serialize(addt))
local _, _, _, _, _, vec, ener = event.pull("modem_message")
term.write("Slave3 data get\n")
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
term.write ("X: ")
term.write (target.x)
term.write ("\nY: ")
term.write (target.y)
term.write ("\nZ: ")
term.write (target.z)
end

mainscreen()
--main screen--

--main--

--main--

-- This line should be runned on slave gate PC. Change vec.x, vec.y and vec.z on core coordinates.
-- component.modem.open(1000) component.modem.setStrength(40) while true do local _, _, rec, _, _, ad = event.pull("modem_message") os.sleep(0.16) add = serialization.unserialize(ad) local energy = component.stargate.getEnergyRequiredToDial(add).open local vec = {} vec.x = 0.5 vec.y = 0.5 vec.z = 0.5 component.modem.send(rec, 1000, serialization.serialize(vec), energy) end
