io={}
io.gN,io.sN,io.gB=input.getNumber,output.setNumber,input.getBool
s={}
s.drf,s.dr,s.dt,s.sc,s.dtb=screen.drawRectF,screen.drawRect,screen.drawText,screen.setColor,screen.drawTextBox
asc,desc=0.5,0.05
alt,dist=0,0
tarAlt, tarAltDelta=1.2,0.1
prevAlt = 1.2
throttle = 0
upB,downB=false,false
vertSpeed = 0
tick = 0
pid = {p=0,i=0,d=0,pE=0,dT=1,sCap=20,acc=0}

function onTick()
  
	alt,dist = io.gN(7),io.gN(8)
  effAlt = alt

  extUp, extDown, on = io.gB(3), io.gB(4), io.gB(5)
  click = io.gB(1)
  pid.p=io.gN(9)
  pid.i=io.gN(10)
  pid.d=io.gN(11)
  pid.sCap=io.gN(12)
  
  if extUp then 
    tarAlt = tarAlt+tarAltDelta
  elseif extDown then
    tarAlt = tarAlt-tarAltDelta
  end
  
	if buttons then
    tX,tY=io.gN(3),io.gN(4)
    screenClk(tX,tY,click)
  end
  
  throttle = updatePID(pid,effAlt,tarAlt)
  if on then io.sN(1,throttle) else io.sN(1,0) end
end

function updatePID(t, var, set)
  local err = set-var
  if (t.acc + err) <0 then t.acc = math.max((t.acc + err), -1*t.sCap)
  else t.acc = math.min((t.acc + err), t.sCap) end
  local der = (err-t.pE)/t.dT
  t.pE = err
  local out = (err*t.p)+(t.acc*t.i)+(der*t.d)
  return out
end

function clamp(i,min,max)
	return (i >= min and i<= max) and i or ((i > max) and max or min)
end

function initButtons()
  c={x=w/2, y=h/2}
	buttons = {}
  addBtn(w-10, c.y-10, 10,10, "+", function() tarAlt=tarAlt+tarAltDelta end, upB)
  addBtn(w-10, c.y, 10,10, "-", function() tarAlt=tarAlt-tarAltDelta end, downB)
end

function addBtn(x, y, w, h, t, f, p)
	local data = {
		['x'] = (x or 0),
		['y'] = (y or 0),
		['w'] = (w or 0),
		['h'] = (h or 0),
		['t'] = (t or "err"),
		['f'] = (f or nil),
    ['p'] = (p or false)
	}
	table.insert(buttons,data)
end

function inrange(cx, cy, x, y, w, h)
	return (cx >= x and cy >= y and cx <= (x + w) and cy <= (y + h)) and true or false
end

function screenClk(x, y,click)
	for k,b in pairs(buttons) do
		if inrange(x,y,b.x,b.y,b.w,b.h) and click then
      b.f()
      b.p=true
    else
      b.p=false
		end
	end
end

function onDraw()
	w = screen.getWidth()
	h = screen.getHeight()
  if not buttons then initButtons() end
  
  for k,b in pairs(buttons) do
		if b.p then
			s.sc(255,255,255)
			s.drf(b.x,b.y,b.w,b.h)
			s.dr(b.x,b.y,b.w,b.h)
			s.sc(0,0,0)
			s.dtb(b.x+1,b.y+1,b.w,b.h,b.t,0,0)
		else
      s.sc(255,0,0,150)
			s.dr(b.x,b.y,b.w,b.h)
			s.dtb(b.x+1,b.y+1,b.w,b.h,b.t,0,0)
		end
	end
  
  s.sc(255,0,0,150)
  s.dr(1,1,34,14)
  s.dtb(2,2,34,14,string.format("T.Alt:%.1f",tarAlt),0,0)
  s.dr(36,1,34,14)
  s.dtb(37,2,34,14,string.format("C.Alt:%.1f",effAlt),0,0)
  
end