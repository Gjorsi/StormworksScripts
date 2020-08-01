tOut, clutch, ti = 0,0,0
minT = 0.1
deltaT = 0.002
deltaC = 0.0002
nGears, gearUp, gearDown = 0,0,0
handleGears = false
currentGear = 0

function onTick()
  nGears = math.min(input.getNumber(5), 4)
  handleGears = input.getBool(2)
  gearUp = input.getNumber(6)
  gearDown = input.getNumber(7)
  ti=ti+1
  if ti>600 then ti=100 end
  tIn = input.getNumber(1)
  rps = input.getNumber(2)
  deltaT = input.getNumber(3)
  deltaC = input.getNumber(4)
  
  if input.getBool(1) then
    tOut = 0
    clutch = 0
  elseif rps < 0.5 then
    tOut = 0
    clutch = 0
  else
    
    if math.abs(tIn) < 0.04 then
      clutch = 0
      if rps > 3.7 then
        tOut = math.max(tOut-deltaT, minT)
      elseif rps < 3.7 then
        tOut = math.min(tOut+deltaT, 1)
      end
      
    elseif tIn < 0.2 and tIn > -0.2 then
      
      if clutch < math.abs(tIn)*5 then 
        clutch = clutch + deltaC
      else
        clutch = clutch - deltaC
      end
      
      if clutch > 0.3 then
        if rps > 7 then
          tOut = math.max(tOut-deltaT*8, minT)
        elseif rps < 6.5 then
          tOut = math.min(tOut+deltaT*8, 1)
        end
      else
        if rps > 7 then
          tOut = math.max(tOut-deltaT, minT)
        elseif rps < 6.5 then
          tOut = math.min(tOut+deltaT, 1)
        end
      end
    else
      
      clutch = math.min(1, clutch + deltaC)
      if math.abs(tOut-tIn) > 0.004 then
        if tOut > math.abs(tIn) then
          tOut = tOut-8*deltaT
        else
          tOut = tOut+4*deltaT
        end
      end
      
    end
    
    if tIn < 0 then
      output.setBool(1, true)
    else
      output.setBool(1, false)
    end
    
    if rps < 6 then
      clutch = math.max(0, clutch-deltaC)
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