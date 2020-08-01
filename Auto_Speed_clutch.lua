tOut, clutch, ti, tIn, rps, deltaT, deltaC = 0,0,0,0,0,0,0
minT, preferredRPS, sp, maxSp = 0.1,0,0,0
nGears, gearUp, gearDown = 0,0,0
handleGears = false
currentGear = 0

function onTick()
  ti=ti+1
  if ti>600 then ti=100 end
  
  readInputs()
  
  if input.getBool(1) then --killswitch
    tOut = 0
    clutch = 0
  elseif rps < 0.5 then --engine is stopped
    tOut = 0
    clutch = 0
  else
    
    if tIn < 0.02 and tIn > -0.02 then
      targetSp = 0
      clutch = 0
    else
      targetSp = math.abs(tIn*maxSp)
    end
    
    if sp < targetSp then
      incSpeed(targetSp-sp)
    elseif sp >= targetSp then
      redSpeed(sp-targetSp)
    end
    
    -- Anti-stalling feature
    if rps < 3 then 
      clutch = 0
    end
    
    -- Stop high-revving
    if rps > preferredRPS*1.2 and clutch < 1 then
      tOut = math.max(tOut-deltaT*2, 0)
    elseif rps < 4 then
      tOut = math.max(tOut+deltaT, minT)
    end
    
    if handleGears and ti>30 then
      ti = 0
      if rps > gearUp and currentGear < nGears and clutch > 0.99 then
        currentGear = currentGear+1
      elseif rps < gearDown and currentGear > 0 then
        currentGear = currentGear-1
      end

    end
    
  end
  
  setGears()
  output.setNumber(1, tOut)
  output.setNumber(2, clutch)
  output.setBool(1, tIn < -0.02)
end

function incSpeed(d)
  if clutch < 0.45 and rps > preferredRPS*0.85 then
    clutch = math.min(clutch+deltaC*8*d, 1)
  elseif clutch < 1 and rps > preferredRPS*0.85 then
    clutch = math.min(clutch+deltaC*d, 1)
  end
  
  if rps < preferredRPS*0.95 then
    tOut = math.min(tOut+deltaT*d, 1)
  elseif clutch > 0.97 then
    tOut = math.min(tOut+deltaT*d, 1)
  end
end

function redSpeed(d)
  if currentGear == 0 then
    if clutch > 0.45 and rps < preferredRPS*0.95 then
      clutch = math.max(clutch-deltaC*4*d, 0)
    elseif clutch > 0 and rps < preferredRPS*0.95 then
      clutch = math.max(clutch-deltaC*2*d, 0)
    end
    
    tOut = math.max(tOut-deltaT*d, minT)
  else
    tOut = math.max(tOut-deltaT, minT)
  end
end

function readInputs()
  tIn = input.getNumber(1)
  rps = input.getNumber(2)
  deltaT = input.getNumber(3)
  deltaC = input.getNumber(4)
  nGears = math.min(input.getNumber(5), 4)
  handleGears = input.getBool(2)
  gearUp = input.getNumber(6)
  gearDown = input.getNumber(7)
  preferredRPS = input.getNumber(8)
  sp = math.abs(input.getNumber(9))
  maxSp = input.getNumber(10)
  minT = input.getNumber(11)
end

function setGears()
  for i=2,nGears+2 do
    if currentGear+1 >= i then
      output.setBool(i, true)
    else
      output.setBool(i, false)
    end
  end
end

function onDraw()
end