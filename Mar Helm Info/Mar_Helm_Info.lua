initialized = false
w = nil
h = nil
speed, throttle, heading, headingD, rudder, battery, rAngle = 0,0,0,0,0,0,0
speedFactor, maxSpeed, maxThrottle = 0,0,0
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
	
	bW, bL, bTW, bTL = 6,10,4,2
	bXAnchor, bYAnchor = w-bW-1, h-bL-bTL-1
	b = {x1=bXAnchor, x2=bXAnchor+((bW-bTW)/2), x3=bXAnchor+((bW-bTW)/2)+bTW-1, x4=bXAnchor+bW-1, y1=bYAnchor, y2=bYAnchor+bTL, y3=bYAnchor+bTL+bL}
	
  rL = 8
  rXA = center.x
  rYA = center.y-7
  
	sW, sL = 6, h
	s = {x1=0, x2=0+sW, y1=h-sL, y2=h, z=h-sL+3*(sL/4)}
	
	initialized = true
end

function onDraw()
	
	w = screen.getWidth()
	h = screen.getHeight()
	
	if not initialized then initialize() end
	
	screen.setColor(0,200,0,255)
	
	--rudder
  rVec1 = vector(rXA, rYA, rAngle, rL)
  rVec2 = vector(rXA+1, rYA, rAngle, rL)
  screen.drawLine(rXA, rYA, rVec1.x, rVec1.y)
  screen.drawLine(rXA+1, rYA, rVec2.x, rVec2.y)
  screen.setColor(200,0,0,255)
  screen.drawLine(rXA-1, rYA, rXA-rL+1, rYA+rL-2)
  screen.drawLine(rXA+2, rYA, rXA+rL, rYA+rL-2)
  
  screen.setColor(0,200,0,255)
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
  if headingD < 10 then prefix = "00"
  elseif headingD < 100 then prefix = "0"
  else prefix = "" end
  screen.drawText(sW+2, 1, prefix..string.format("%.1f", headingD))
  
  --draw speed
  screen.drawLine(s.x2, s.y1, s.x2, s.y2)
  screen.drawLine(s.x1, s.z, s.x2, s.z)
  if speed >= 0 and speed < 10 then
    screen.drawText(s.x2+3, s.z-1, string.format("%.1f",speed))
  elseif speed > 10 then
    screen.drawText(s.x2+5, s.z-1, string.format("%.0f",speed))
  elseif speed < 0 and speed > -10 then
    screen.drawText(s.x2+3, s.z-1, string.format("%.1f",math.abs(speed)))
  else
    screen.drawText(s.x2+5, s.z-1, string.format("%.0f",math.abs(speed)))
  end
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