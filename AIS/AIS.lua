ini,IR,ce,day,chng,on = false,false,true,false,false,false
headD,spV,zoom,head=0,0,0.5,0
vX,vY,cX,cY,cT,d,zF,sp,mSp = 0,0,0,0,0,10,0.03,0,0
io={}
io.gN,io.gB,io.sN,io.sB=input.getNumber,input.getBool,output.setNumber,output.setBool
s={}
s.drf,s.dr,s.dtf,s.dt,s.dtb,s.sc,s.smco,s.smcs,s.smcn=screen.drawRectF,screen.drawRect,screen.drawTriangleF,screen.drawText,screen.drawTextBox,screen.setColor,screen.setMapColorOcean,screen.setMapColorShallows,screen.setMapColorSnow
m={ms=map.mapToScreen}

function onTick()
  
  on=io.gB(3)
  tX=io.gN(3)
  tY=io.gN(4)
  gX=io.gN(7)
  gY=io.gN(8)
  mSp=io.gN(9)
  sp=io.gN(10)
  head=io.gN(11)
  
	if ini and on then
    click=io.gB(1)
    
    if ce then cX=gX;cY=gY end
    
    if buttons then
    tX,tY=io.gN(3),io.gN(4)
    screenClk(tX,tY,click)
    end
    
    spV = sp/mSp
  
    if head < 0 then
			headD = (math.abs(head))*360
		elseif head == 0 then
      headD = 0
    else
			headD = 360-head*360
		end
    
    spV=spV*(h*2/5)
    vX=math.sin(math.rad(headD))
    vY=math.cos(math.rad(headD))
    vX=vX*spV;vY=vY*spV
    
    io.sN(1,cX)
    io.sN(2,cY)
    io.sN(3,zoom)
  end
end

function init()
	ini=true
  mapC(day)
  c={x=w/2,y=h/2}
  f=h/32
  buttons={}
  addBtn(0,c.y-2*f,7,7,"",function() ce=false;cX=cX-d*zoom end, false,false)
  addBtn(c.x-2*f,0,7,7,"",function() ce=false;cY=cY+d*zoom end, false,false)
  addBtn(w-7,c.y-2*f,7,7,"",function() ce=false;cX=cX+d*zoom end, false,false)
  addBtn(c.x-2*f,h-7,7,7,"",function() ce=false;cY=cY-d*zoom end, false,false)
  addBtn(w-f-7,h-f-7,5,6,"O",function() ce=true end, false,true)
  addBtn(0,h-8*f-1,6,6,"+",function() zoom=math.max(0.1,zoom-zF) end, false,false)
  addBtn(0,h-8*f+6,6,6,"-",function() zoom=math.min(20,zoom+zF) end, false,false)
  addBtn(1,1,15,6,"D/N",function() day=not day;chng=true end, false,true)
end

function addBtn(x, y, w, h, t, f, p, hold,d)
	local data = {
		['x']=(x or 0),
		['y']=(y or 0),
		['w']=(w or 0),
		['h']=(h or 0),
		['t']=(t or "err"),
		['f']=(f or nil),
    ['p']=(p or false),
    ['hold']=(hold or false),
    ['d']=(d or true)
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
  if not on then return end
	w = screen.getWidth()
	h = screen.getHeight()
	if chng then mapC(day);chng=false end
	if not ini then init() end
  
  
  screen.drawMap(cX,cY,zoom)
  
  s.sc(10, 78, 10,220)
  pX,pY=m.ms(cX,cY,zoom,w,h,gX,gY)
  s.dr(pX-1,pY-1,2,2)
  s.sc(150,0,0,150)
  screen.drawLine(pX, pY, pX+vX, pY-vY)
  
  -- map move arrows
  s.dtf(f,c.y,3*f,c.y-2*f,3*f,c.y+2*f)
  s.dtf(c.x-2*f+1,3*f,c.x,f,c.x+2*f,3*f)
  s.dtf(w-3*f,c.y+2*f,w-3*f,c.y-2*f,w-f,c.y)
  s.dtf(c.x,h-f+1,c.x-2*f,h-3*f,c.x+2*f+1,h-3*f)
  
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
end

function mapC(day)
  if day then
    s.smco(40,52,61,255)
    s.smcs(51,71,87,255)
    cL(47,41,28,255)
    s.smcn(250,250,250,255)
  else
    s.smco(5,5,5,100)
    s.smcs(36,26,185,100)
    cL(102,96,8,100)
    s.smcn(115,114,121,100)
  end
end

function cL(a,b,c,d)
  screen.setMapColorLand(a,b,c,d)
  screen.setMapColorGrass(a,b,c,d)
  screen.setMapColorSand(a,b,c,d)
end