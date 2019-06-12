ini,IR = false,false
mSp, head, sp, headD, spV, zoom = 0,0,0,0,0,0
vX, vY, cX, cY, cT = 0,0,0,0,0
state = "menu"

function onTick()
	
	if ini then
    if cT>600 then cT=70 end
    tX = input.getNumber(3)
    tY = input.getNumber(4)
    if state == "menu" then
      if input.getBool(1) then
        if tCheck(2,21,c.x-1,32) then
          state = "navD"
        end
        if tCheck(c.x,21,w-2,32) then
          state = "navN"
        end
        if tCheck(11,46,24,56) then
          state = "cam"
          output.setNumber(1,1)
        end
        if tCheck(25,46,38,56) then
          state = "cam"
          output.setNumber(1,2)
        end
        if tCheck(39,46,52,56) then
          state = "cam"
          output.setNumber(1,3)
        end
      end
    elseif state == "navD" or state == "navN" then
      
      gX = input.getNumber(7)
      gY = input.getNumber(8)
      mSp = input.getNumber(9)
      sp = input.getNumber(10)
      head = input.getNumber(11)
      zoom = 20.1-(zT/zF)/10
    
      if input.getBool(1) then
        
        if tY > h-h/8 then 
          zT = tX
        end
      end
      
      spV = sp/mSp
    
      if head < 0 then headD = (math.abs(head))*360
      else headD = 360-head*360 end
      
      spV=spV*(h/2)
      vX=math.sin(math.rad(headD))
      vY=math.cos(math.rad(headD))
      vX=vX*spV
      vY=vY*spV
      
      cX=gX+(vX*zoom^1.5)+(vX*10*zoom)+(0.5*vX)
      cY=gY+(vY*zoom^1.5)+(vY*10*zoom)+(0.5*vY)
      
    elseif state == "cam" then
      if input.getBool(1) and tCheck(0,0,7,7) and cT>60 then IR = not IR; cT=0 end
    end
    
    if state ~= "menu" then
      if input.getBool(1) and tCheck(c.x-10,0,c.x+10,8) then
        state = "menu"
        output.setNumber(1,0)
      end
    end
	end
  output.setBool(1,IR)
  cT=cT+1
end

function init()
	zT = w/2
	zF = w/200
	ini = true
  c={x=w/2,y=h/2}
end

function onDraw()
	w = screen.getWidth()
	h = screen.getHeight()
	
	if not ini then init() end
	
  if state ~= "menu" then
    screen.setColor(150,0,0,100)
    screen.drawText(c.x-9, 1, "MENU")
  end
  
  if state == "menu" then
    screen.setColor(150,0,0,100)
    screen.drawText(c.x-9, 3, "Menu")
    screen.drawText(c.x-6, 14, "NAV")
    screen.drawRect(c.x-9, 12, 18, 9)
    sdrf(2, 21, w-4, 11)
    screen.drawText(c.x-6, 37, "CAM")
    screen.drawRect(c.x-9, 35, 18, 9)
    screen.drawRect(10, 44, w-20, 12)
    sdrf(12, 46, 13, 9)
    sdrf(26, 46, 13, 9)
    sdrf(40, 46, 13, 9)
    screen.setColor(0,0,0,255)
    screen.drawText(17,48, "1")
    screen.drawText(31,48, "2")
    screen.drawText(45,48, "3")
    screen.drawText(10, 24, "DAY")
    screen.drawText(c.x+5, 24, "NIGHT")
    
  elseif state == "navD" or state == "navN" then
    if state == "navD" then mapC(true) else mapC(false) end
    screen.drawMap(cX,cY,zoom)
    screen.setColor(150,0,0,100)
    sdrf(0, h-h/12, zT, h/12)
    screen.setColor(0, 0, 0, 220)
    pixelX, pixelY = map.mapToScreen(cX, cY, zoom, w, h, gX, gY)
    screen.drawCircleF(pixelX,pixelY,2)
    screen.setColor(255, 0, 0, 150)
    screen.drawLine(pixelX, pixelY, pixelX+vX, pixelY-vY)
  elseif state == "cam" then
    screen.setColor(150,0,0,100)
    sdrf(0,0,6,6)
  end
end

function tCheck(x1,y1,x2,y2)
  if tX>x1 and tX<x2 and tY>y1 and tY<y2 then return true else return false end
end

function mapC(day)
  if day then
    screen.setMapColorOcean(32,142,252,150)
    screen.setMapColorShallows(161,208,255,150)
    screen.setMapColorLand(246,200,122,150)
    screen.setMapColorGrass(246,200,122,150)
    screen.setMapColorSand(246,200,122,150)
    screen.setMapColorSnow(250,250,250,150)
  else
    screen.setMapColorOcean(5,5,5,100)
    screen.setMapColorShallows(36,26,185,100)
    screen.setMapColorLand(102,96,8,100)
    screen.setMapColorGrass(102,96,8,100)
    screen.setMapColorSand(102,96,8,100)
    screen.setMapColorSnow(115,114,121,100)
  end
end

function sdrf(x,y,rw,rh)
  screen.drawRectF(x,y,rw,rh)
end