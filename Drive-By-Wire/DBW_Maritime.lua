io={}
io.gN,io.sN,io.gB,io.sB=input.getNumber,output.setNumber,input.getBool,output.setBool
maxThrottle = 1
throttle, rudder = 0,0

function onTick()
  
  maxThrottle = property.getNumber("max throttle")
  minThrottle = property.getNumber("min throttle")
  throttleIn = io.gN(1)
  rudderIn = io.gN(2)
  tDelta = io.gN(3)
  rDelta = io.gN(4)
  
  if throttleIn > 0 then changeThrottle(tDelta)
  elseif throttleIn < 0 then changeThrottle(-tDelta) end

  if rudderIn > 0 then changeRudder(rDelta)
  elseif rudderIn < 0 then changeRudder(-rDelta) end
  
  if io.gB(1) then throttle = 0; rudder = 0 end
  
  io.sN(1,throttle)
  io.sN(2,rudder)
  
end

function changeThrottle(delta)
  if delta > 0 then
    throttle = math.min(maxThrottle, throttle+delta)
  else
    throttle = math.max(minThrottle, throttle+delta)
  end
end

function changeRudder(delta)
  if delta > 0 then
    rudder = math.min(1, rudder+delta)
  else
    rudder = math.max(-1, rudder+delta)
  end
end

function onDraw()
end