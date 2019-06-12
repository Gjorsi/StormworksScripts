initialized = false
w = nil
h = nil
speed, throttle, heading, headingD, rudder, battery, rAngle = 0,0,0,0,0,0,0
speedFactor, maxSpeed, maxThrottle = 0,0,0
ship = nil
center = nil

function onTick()
	
	if initialized then
		speed = input.getNumber(7)
    throttle = input.getNumber(8)
		heading = input.getNumber(9)
		rudder = input.getNumber(10)
		battery = input.getNumber(11)
    maxSpeed = input.getNumber(12)
    maxThrottle = input.getNumber(13)
    
    speedFactor = speed/maxSpeed
    
    if rudder < 0 then
      rAngle = 360+(45*rudder)
    else
      rAngle = 45*rudder
    end
	
		if input.getBool(1) then
			touchX = input.getNumber(3)
			touchY = input.getNumber(4)

		end
	
		if heading < 0 then
			headingD = (math.abs(heading))*360
		elseif heading == 0 then
      headingD = 0
    else
			headingD = 360-heading*360
		end

	end
end

function initialize()
	center = {x = w/2, y = h/2}
	
	shipW, shipL, shipBL = 8, 50, 10
  shipXA, shipYA = center.x-shipW, center.y-(shipL/2)
	ship = {x1=shipXA, x2=shipXA+shipW, x3=shipXA+2*shipW, y1=shipYA-shipBL, y2=shipYA-1, y3=shipYA+shipL, r=shipYA+4*(shipL/5)}
	
	bW, bL, bTW, bTL = 8,18,4,3
	bXAnchor, bYAnchor = w-bW-4, h-bL-bTL-4
	b = {x1=bXAnchor, x2=bXAnchor+((bW-bTW)/2), x3=bXAnchor+((3/4)*bW), x4=bXAnchor+bW, y1=bYAnchor, y2=bYAnchor+bTL, y3=bYAnchor+bTL+bL}
	
	sW, sL = 20, h
	s = {x1=0, x2=0+sW, y1=h-sL, y2=h, z=h-sL+3*(sL/4)}
	
	initialized = true
end

function onDraw()
	
	w = screen.getWidth()
	h = screen.getHeight()
	
	if not initialized then initialize() end
	
	screen.setColor(255,0,0,120)
	
	--draw ship
	screen.drawTriangleF(ship.x2, ship.y1, ship.x1, ship.y2, ship.x3, ship.y2)
	screen.drawRectF(ship.x1, ship.y2, shipW*2, 2*(shipL/3))
  screen.drawRect(ship.x1, ship.y2, shipW*2, shipL)
	--rudder
  rVec1 = vector(ship.x2-1, ship.r, rAngle, 8)
  rVec2 = vector(ship.x2+1, ship.r, rAngle, 8)
  screen.drawLine(ship.x2-1, ship.r, rVec1.x, rVec1.y)
  screen.drawLine(ship.x2+1, ship.r, rVec2.x, rVec2.y)
  
	--draw battery
	screen.drawLine(b.x1, b.y2, b.x2, b.y2)
	screen.drawLine(b.x2, b.y2, b.x2, b.y1)
	screen.drawLine(b.x2, b.y1, b.x3, b.y1)
	screen.drawLine(b.x3, b.y1, b.x3, b.y2)
	screen.drawLine(b.x3, b.y2, b.x4, b.y2)
	screen.drawLine(b.x4, b.y2, b.x4, b.y3)
	screen.drawLine(b.x4, b.y3, b.x1, b.y3)
	screen.drawLine(b.x1, b.y3, b.x1, b.y2)
	bFill = battery*bL
	bLevel = b.y3-bFill
	screen.drawRectF(b.x1, bLevel, bW, bFill)
	
  --draw bearing
  screen.drawText(center.x-20, 1, string.format("BRNG:%.1f", headingD))
  
  --draw speed
  screen.drawLine(s.x2, s.y1, s.x2, s.y2)
  screen.drawLine(s.x1, s.z, s.x2, s.z)
  screen.drawText(s.x2+2, s.z-2, "0")
  screen.drawRectF(s.x1, s.z-speedFactor*3*(sL/4), s.x2, speedFactor*3*(sL/4))
  
  --draw throttle
  screen.setColor(200,150,0,120)
  screen.drawLine(s.x1, s.z-throttle*3*(sL/4), s.x2, s.z-throttle*3*(sL/4))
  
end

function vector(fromX, fromY, bearing, distance)
  rad = math.rad(bearing)
  target = {x=fromX+distance*math.sin(rad), y=fromY+distance*math.cos(rad)}
  return target
end