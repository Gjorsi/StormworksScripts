ini,IR = false,false
zoom, cT, tX, tY = 0,0,0,0
switchA, switchB = true,true
n_cameras = 1

function onTick()
	if not ini then init()
	else
    if cT>6000 then cT=70 end
    tX = input.getNumber(3)
    tY = input.getNumber(4)

    
    if input.getBool(1) then
      if tCheck(0,0,7,7) and cT>60 then IR = not IR; cT=0 end
      if tCheck(w-7,0,w,7) and cT>60 then switchCamera(); cT=0 end
      if tCheck(0,h-h/8,w,h) then zoom=tX/w end
    end
    
	end
  
  output.setBool(1,IR)
  output.setBool(2,switchA)
  output.setBool(3,switchB)
  output.setNumber(1, zoom)
end

function addBtn(x,y,w,h,f)
	local data = {
		['x']=(x or 0),
		['y']=(y or 0),
		['w']=(w or 0),
		['h']=(h or 0),
		['f']=(f or nil)
	}
	table.insert(buttons,data)
end

function init()
  if input.getNumber(7) > 0 then
    n_cameras = input.getNumber(7)
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
  
  screen.setColor(150,0,0,100)
  sdrf(0,0,6,6)
  sdrf(w-6,0,6,6)
  sdrf(0,h-h/8,w*zoom,h)
  
  screen.setColor(0,0,0,200)
  if switchA then screen.drawText(2,10,"true") end
  if IR then screen.drawText(2,19,"true") end
end

function tCheck(x1,y1,x2,y2)
  return tX>x1 and tX<x2 and tY>y1 and tY<y2
end

function sdrf(x,y,rw,rh)
  screen.drawRectF(x,y,rw,rh)
end