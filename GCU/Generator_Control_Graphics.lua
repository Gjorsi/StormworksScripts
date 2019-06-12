io={}
io.gN,io.sN,io.gB,io.sB=input.getNumber,output.setNumber,input.getBool,output.setBool
s={}
s.drf,s.dr,s.dt,s.sc,s.dtb,s.dl=screen.drawRectF,screen.drawRect,screen.drawText,screen.setColor,screen.drawTextBox,screen.drawLine
mRPS=20
pow={0,0,0}
bat=0
manual=true
maxPow=600

function onTick()
  click = io.gB(1)
  bat=io.gN(13)
  for i=1,3 do
    pow[i]=io.gN(14+i)
  end
  
  if ge then
    for i=1,6 do
      ge[i].g=io.gN(17+math.ceil(i/2))
      ge[i].rps=io.gN(i+6)
      io.sB(i,ge[i].on)
    end
  end
  
  io.sB(7,manual)
  mRPS=io.gN(14)
  
	if buttons then
    tX,tY=io.gN(3),io.gN(4)
    screenClk(tX,tY,click)
  end
end

function toggleGen(genN)
  ge[genN].on = not ge[genN].on
end

function initGenerators()
  s.sc(7,9,27)
  screen.drawClear()
  c={x=w/2, y=h/2}
  f=h/32
  aX,aY=11*f,17*f
  gW,gH,ggW,ggH=4*f,8*f,f,2*f-2
  ge = {}
  for i=1, 6 do
    addGen(aX+(i-1)*(gW+ggW+1), aY, gW, gH)
  end
end

function addGen(x,y,w,h,g)
	local data = {
		['x']=(x or 0),
		['y']=(y or 0),
		['w']=(w or 0),
		['h']=(h or 0),
    ['on']=(false),
    ['rps']=(0),
    ['g']=(g or 0),
    ['s']=(false)
	}
	table.insert(ge,data)
end

function initButtons()
	buttons = {}
  for i=1, 6 do
    addBtn(aX+(i-1)*(gW+ggW+1), aY+gH+1, gW, gW+ggW+1, i, function(b) toggleGen(i); b.e = not b.e end, false, true, false)
  end
  addBtn(f,f,17,8,"MAN",function(b) manual = not manual;b.e = not b.e end,false,true,true)
end

function addBtn(x, y, w, h, t, f, p, hold,e)
	local data = {
		['x']=(x or 0),
		['y']=(y or 0),
		['w']=(w or 0),
		['h']=(h or 0),
		['t']=(t or "err"),
		['f']=(f or nil),
    ['p']=(p or false),
    ['hold']=(hold or false),
    ['e']=(e or false)
	}
	table.insert(buttons,data)
end

function inrange(cx, cy, x, y, w, h)
	return (cx >= x and cy >= y and cx <= (x + w) and cy <= (y + h)) and true or false
end

function screenClk(x, y,click)
	for k,b in pairs(buttons) do
		if inrange(x,y,b.x,b.y,b.w,b.h) and click then
      if b.hold and not b.p then
        b.f(b)
      elseif not b.hold then
        b.f(b)
      end
      b.p=true
    else
      b.p=false
		end
	end
end

function onDraw()
	w = screen.getWidth()
	h = screen.getHeight()
  if not ge then initGenerators() end
  if not buttons then initButtons() end
  
  for k,b in pairs(buttons) do
		if b.p then
			s.sc(255,255,255)
			s.drf(b.x,b.y,b.w,b.h)
			s.dr(b.x,b.y,b.w,b.h)
			s.sc(0,0,0)
			s.dtb(b.x+1,b.y+1,b.w,b.h,b.t,0,0)
    elseif b.e then
      s.sc(0,150,0,150)
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
  
  for k,g in pairs(ge) do
    
    -- temp
    if g.on then s.dt(1,4+6*k,k..":on") end
    -- temp end
    
    s.sc(255,255,255,150)
    s.dr(g.x,g.y,g.w,g.h)
    
    if g.rps>0.1 then
      rpsF=g.rps/mRPS
      s.sc(math.max(rpsF*305-50,0),math.min(400-rpsF*350,255),0,200)
      nY=g.y+(1-rpsF)*(g.h)+1
      nH=math.max(0,g.h*rpsF-1)
      s.drf(g.x+1,nY,g.w-1,nH)
    end
    if g.on then
      s.sc(0,200,0,150)
    else
      s.sc(150,150,150,150)
    end
    s.dl(g.x+(g.w/2),g.y-1,g.x+(g.w/2),g.y-2*f)
    if (k%2==0) then
      s.dl(g.x+(g.w/2),g.y-2*f,g.x,g.y-2*f)
    else
      s.dl(g.x+(g.w/2),g.y-2*f,g.x+g.w,g.y-2*f)
    end
  end
  
  for i=1,5,2 do
    if ge[i].on or ge[i+1].on then  
      s.sc(0,200,0,150)
    else
      s.sc(150,150,150,150)
    end
    g=ge[i]
    bx,by=g.x+g.w-1,g.y-6*f
    
    s.dr(bx+1,by,f+1,4*f)
    
    s.dl(bx+f,by-1,bx+f,by-2*f)
    s.dr(bx-f,by-8*f,4*f,6*f)
    s.sc(0,200,0,150)
    s.drf(bx-f+1, by-2*f, 4*f-1, -1*(pow[math.ceil(i/2)]/600)*6*f)
    
    s.sc(255,0,0,150)
    for j=1,4 do
      if g.g >= j then
        s.drf(g.x+g.w+1, (g.y-6*f+1)+(j-1)*f,f,f-1)
      end
    end
  end
end