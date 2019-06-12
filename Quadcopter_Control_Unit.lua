initialized = false
w = nil
h = nil
speed, throttle, heading, headingD = 0,0,0,0

function onTick()
	
	if initialized then
		forTilt = input.getNumber(7)
    sidTilt = input.getNumber(8)
		alt = input.getNumber(9)
		speed = input.getNumber(10)
		desAlt = input.getNumber(11)
    desSp = input.getNumber(12)
    pidTicks = input.getNumber(13)
    pidP = input.getNumber(14)
    pidI = input.getNumber(15)
    pidD = input.getNumber(16)
	
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
	
	initialized = true
end

function onDraw()
	
	w = screen.getWidth()
	h = screen.getHeight()
	
	if not initialized then initialize() end
	
end

function vector(fromX, fromY, bearing, distance)
  rad = math.rad(bearing)
  target = {x=fromX+distance*math.sin(rad), y=fromY+distance*math.cos(rad)}
  return target
end

function updatePID(t, var, set)
  local err = set-var
  t.acc = math.min((t.acc + err), t.sCap)
  local der = (err-t.pE)/t.dT
  t.pE = err
  local out = (err*t.p)+(t.acc*t.i)+(der*t.d)
  return out
end