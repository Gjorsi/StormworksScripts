ini,IR = false,false
zoom, cT, tX, tY, w, h = 0,0,0,0,0,0
switchA, switchB = true,true
n_cameras = 1
zF = 0.01
s={}
s.drf,s.dr,s.dtf,s.dt,s.dtb,s.sc=screen.drawRectF,screen.drawRect,screen.drawTriangleF,screen.drawText,screen.drawTextBox,screen.setColor

function onTick()
	if not ini then init()
	else
    tX = input.getNumber(3)
    tY = input.getNumber(4)
    click = input.getBool(1)
    screenClk(tX,tY,click)
	end
  
  output.setBool(1,IR)
  output.setBool(2,switchA)
  output.setBool(3,switchB)
  output.setNumber(1, zoom)
end

function addBtn(x,y,w,h,t,f,hold)
	local data = {
		['x']=(x or 0),
		['y']=(y or 0),
		['w']=(w or 0),
		['h']=(h or 0),
    ['t']=(t or ""),
		['f']=(f or nil),
    ['hold']=(hold or false),
    ['p']=(false)
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

function init()
  if input.getNumber(7) > 0 and w>0 then
    buttons={}
    n_cameras = input.getNumber(7)
    addBtn(0,0,12,7,"IR",function() IR = not IR end, true)
    addBtn(w-12,0,12,7,"->",function() switchCamera() end, true)
    addBtn(0,h-16,6,6,"+",function() zoom=math.min(1,zoom+zF) end, false)
    addBtn(0,h-8,6,6,"-",function() zoom=math.max(0,zoom-zF) end, false)
    ini = true
  end
end

function switchCamera()
  if n_cameras == 2 then switchA = not switchA
  elseif n_cameras == 3 then
    if not switchA and not switchB then switchA, switchB = true,true
    elseif switchA and switchB then switchA, switchB = false,true
    elseif not switchA and switchB then switchA, switchB = false,false
    end
  end
end


function onDraw()
	w = screen.getWidth()
	h = screen.getHeight()
  if not ini then return end
  
  for k,b in pairs(buttons) do
    if b.p then
      s.sc(255,255,255,255)
      s.drf(b.x,b.y,b.w,b.h)
      s.dr(b.x,b.y,b.w,b.h)
      s.sc(0,0,0)
      s.dtb(b.x+1,b.y+1,b.w,b.h,b.t,0,0)
    else
      s.sc(150,0,0,150)
      s.dtb(b.x+1,b.y+1,b.w,b.h,b.t,0,0)
    end
	end
end

function sdrf(x,y,rw,rh)
  screen.drawRectF(x,y,rw,rh)
end