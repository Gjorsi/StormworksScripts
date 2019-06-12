io={}
io.gN,io.sN,io.gB,io.sB=input.getNumber,output.setNumber,input.getBool,output.setBool
mRPS=20
pow={0,0,0}
manual=true
init = false
nGears=4
nGen=0
clutchDelta=0.05

function onTick()
  if not ge and nGen>0 then initGenerators() end
  if not gearThresholds and io.gN(12)>0 then setGearThresholds() end
  
  nGen=io.gN(22)
  manual = io.gB(7)
  mRPS = io.gN(8)
  
  if ge then
    
    if manual then
      for k,g in pairs(ge) do
        g.t=io.gN(15+k)
      end
    end
  
    for i=1,3 do
      pow[i]=io.gN(14+i)
      if gTimer[i] > 0 then gTimer[i] = gTimer[i]+1 end
      if gTimer[i] > 50 then gTimer[i] = 0 end
    end
  
    setGears()
    adjustClutches()
    
    for k,g in pairs(ge) do
      g.rps=io.gN(k)
      
      -- turn on or off according to input
      if g.on ~= io.gB(k) then
        toggleGen(k)
      end
      
      --generator k is in starting state
      if g.s then
        sTimer[k]=sTimer[k]+1
        if sTimer[k] > 50 then sTimer[k]=0;g.s=false end
      end
      io.sB(12+k, g.s) --output starter boolean values
      
      if g.on then io.sN(k, g.t) else io.sN(k,0) end --output generator throttle values
      io.sN(6+k, g.c) --output generator clutch values
      
      
      --output generator gear boolean values
      if k%2==0 then
        io.sN(12+k/2, gears[k/2]) --output gear values (to graphics script)
        for j=1,4 do
          if gears[k/2] >= j then io.sB(((k/2)-1)*4+j, true) else io.sB(((k/2)-1)*4+j, false) end
        end
      end
    end
  end
end

function setGears()
  for i=1,nGen,2 do
    if gTimer[math.ceil(i/2)]==0 then
      k=math.ceil(i/2)
      if (ge[i].on and ge[i].rps < 2.1) or (ge[i+1].on and ge[i+1].rps < 2.1) then 
        gears[k] = math.max(gears[k]-1, 0)
        gTimer[k] = 45
      elseif (gears[k] < nGears) and ((ge[i].on and ge[i].rps > gearThresholds[gears[k]+1]) or (ge[i+1].on and ge[i+1].rps > gearThresholds[gears[k]+1])) then 
        gears[k] = gears[k]+1
        gTimer[k]=1
      end
    end
  end
end


function adjustClutches()
  for k,g in pairs(ge) do
    if g.rps > 2.2 and g.on then
      g.c = math.min(g.c+clutchDelta, 1)
    else
      g.c = math.max(g.c-clutchDelta, 0)
    end
  end
end

function toggleGen(i)
  g=ge[i]
  g.on=io.gB(i)
  if g.on then
    g.s = true
    g.t = 0.1
  else
    g.s = false
    g.t=0
  end
end

function initGenerators()
  sTimer = {} --starting timer
  for i=1,nGen do
    sTimer[i]=0
  end
  
  gears = {} --current gear for line 1-nGen/2
  gTimer = {} --gear change timer
  for i=1,math.ceil(nGen/2) do
    gTimer[i]=0
    gears[i]=0
  end
  
  ge = {}
  for i=1,nGen do
    addGen()
  end
  init = true
end

function addGen()
	local data = {
    ['on']=(false),
    ['rps']=(0),
    ['s']=(false), --starting motor
    ['t']=(0), --throttle
    ['c']=(0) --clutch
	}
	table.insert(ge,data)
end

function setGearThresholds()
  gearThresholds={}
  for i=1,4 do
    gearThresholds[i]=io.gN(11+i)
  end
end

function onDraw()
	w = screen.getWidth()
	h = screen.getHeight()
  if init then
    screen.drawText(20,5,#ge)
    screen.drawText(20,12,nGen)
    for i=1,6 do
      g=ge[i]
      if g.on then screen.drawText(2,2+i*5,"on")
      else screen.drawText(2,2+i*5,"off")
      end
    end
  end
end