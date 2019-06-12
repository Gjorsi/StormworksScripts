ini,IR,ce,day,chng = false,false,true,false,false
mSp,head,sp,headD,spV,zoom,mT,ttl,ttlT,ru,ruD,acc,dec = 0,0,0,0,0,0.5,0,0,0,0,0,0,0
vX,vY,cX,cY,cT,d,zF,ti,hold,nWP = 0,0,0,0,0,10,0.03,0,0,0
ta={d=0,b=0}
wPb,AP=false,false
arr={}
io={}
io.gN,io.gB,io.sN,io.sB=input.getNumber,input.getBool,output.setNumber,output.setBool
s={}
s.drf,s.dtf,s.dt,s.sc=screen.drawRectF,screen.drawTriangleF,screen.drawText,screen.setColor

function onTick()
	if ini then
    ti=ti+1
    if ti>600 then ti=100 end
    if ti>1 then hold=0 end
    
    tX = io.gN(3)
    tY = io.gN(4)
      
    gX=io.gN(7)
    gY=io.gN(8)
    mSp=io.gN(9)
    sp=io.gN(10)
    head=io.gN(11)
    mT=io.gN(12)
    acc=io.gN(13)
    dec=io.gN(14)
    ruD=io.gN(15)
    
    if ce then cX=gX;cY=gY end
    
    if io.gB(1) then
      if tCheck(2*f,f,2*f+10,f+8) and ti>30 then day=not day;chng=true
      elseif tCheck(0,c.y-3*f,4*f,c.y+3*f) then ce=false;cX=cX-d*zoom
      elseif tCheck(c.x-3*f,0,c.x+3*f,4*f) then ce=false;cY=cY+d*zoom
      elseif tCheck(w-4*f,c.y-3*f,w,c.y+3*f) then ce=false;cX=cX+d*zoom
      elseif tCheck(c.x-3*f,h-4*f,c.x+3*f,h) then ce=false;cY=cY-d*zoom
      elseif tCheck(3*f,h-7,4*f+8,h) then zoom=math.min(20,zoom+zF)
      elseif tCheck(3*f+8,h-7,4*f+16,h) then zoom=math.max(0.1,zoom-zF)
      elseif tCheck(w-7*f,h-6*f,w-f,h-f) then ce=true
      elseif tCheck(w-23,0,w-10,8) and hold>50 then AP=not AP;ru=0;ttl=0;hold=0
      elseif tCheck(w-11,0,w-3,8) and hold>50 then nWP=0;hold=0;stop()
      elseif hold>60 then
        wPb=true;nWP=math.min(nWP+1,5)
        if nWP>0 and nWP<6 then arr[nWP].x,arr[nWP].y=map.screenToMap(cX,cY,zoom,w,h,tX,tY) end
        hold=0
      end
      hold=hold+1
      ti=0
    end
    
    spV = sp/mSp
  
    if head < 0 then headD = (math.abs(head))*360 else headD = 360-head*360 end
    
    spV=spV*(h/2)
    vX=math.sin(math.rad(headD))
    vY=math.cos(math.rad(headD))
    vX=vX*spV;vY=vY*spV
    
    if wPb then
      ta=bD(arr[1].x,arr[1].y)
      if t.d<50 and ti>30 then
        nWP=nWP-1
        for i=1,4 do
          arr[i].x=arr[i+1].x;arr[i].y=arr[i+1].y
        end
        if nWP==0 then stop() end
        ti=0
      end
    end
    
    if AP then
      setRu()
      setTh()
    end
    io.sB(1,AP)
    io.sN(1,ru)
    io.sN(2,ttl)
  end
end

function setRu()
  diffL=((headD-t.b+360)%360)
  diffR=((t.b-headD+360)%360)
  diff=math.min(diffL,diffR)
  if diffL<diffR then ru=ru-ruD
  else ru=ru+ruD end
  if ru<0 and ru<-diff/30 then ru=math.max(-diff/30,-1) end
  if ru>0 and ru>diff/30 then ru=math.min(diff/30,1) end
  if ru<-1 then ru=-1 elseif ru>1 then ru=1 end
end

function setTh()
  if nWP>1 then tuTh=math.max(mT-mT*(diff/75),mT/4)
  else tuTh=math.max(mT-mT*(diff/60),mT/8) end
  if t.d>250 then dTh=mT
  elseif t.d<=250 and t.d>50 then dTh=t.d*(mT/200)
  else dTh=0 end
  ttlT=math.min(tuTh, dTh)
  if ttl<ttlT then ttl=ttl+acc elseif ttl>ttlT then ttl=ttl-dec end
end

function stop()
  AP=false;wPb=false
  ttl=0;ru=0
end

function init()
	ini=true
  mapC(day)
  c={x=w/2,y=h/2}
  f=h/32
  for i=1,5 do
    arr[i]={x=0,y=0}
  end
end

function onDraw()
	w = screen.getWidth()
	h = screen.getHeight()
	if chng then mapC(day);chng=false end
	if not ini then init() end
  
  s.sc(150,0,0,100)
  s.dt(2*f, f, "D/N")
  screen.drawMap(cX,cY,zoom)
  s.sc(0, 0, 0, 220)
  pX, pY = map.mapToScreen(cX,cY,zoom,w,h,gX,gY)
  screen.drawCircleF(pX,pY,2)
  s.sc(255, 0, 0, 150)
  screen.drawLine(pX, pY, pX+vX, pY-vY)
  s.sc(150,0,0,150)
  s.dtf(f,c.y,3*f,c.y-2*f,3*f,c.y+2*f)--left
  s.dtf(c.x-2*f+1,3*f,c.x,f,c.x+2*f,3*f)--up
  s.dtf(w-3*f,c.y+2*f,w-3*f,c.y-2*f,w-f,c.y)--right
  s.dtf(c.x,h-f+1,c.x-2*f,h-3*f,c.x+2*f+1,h-3*f)--down
  s.dt(4*f, h-7, "- +")
  screen.drawCircle(w-5*f,h-4*f,2*f)
  screen.drawCircleF(w-5*f,h-4*f,1*f)
  s.dt(w-22,f,"AP")
  s.dt(w-10,f,"X")
  if wPb then
    for i=1,nWP do
      tarX,tarY=map.mapToScreen(cX,cY,zoom,w,h,arr[i].x,arr[i].y)
      s.dt(tarX-1,tarY-1,i)
      screen.drawCircle(tarX+1,tarY+1,4)
    end
    s.dt(1,c.y+7,string.format("%.0f",ta.d))
    s.dt(1,c.y+15,string.format("%.1f",ta.b))
  end
end

function bD(x,y)
  t={d=0,b=0}
  t.d=math.sqrt((x-gX)^2+(y-gY)^2)
  t.b=180*(math.atan(x-gX, y-gY))/math.pi
  if t.b<0 then t.b=360+t.b end
  return t
end

function tCheck(x1,y1,x2,y2)
  return (tX>x1 and tX<x2 and tY>y1 and tY<y2)
end

function mapC(day)
  if day then
    screen.setMapColorOcean(32,142,252,150)
    screen.setMapColorShallows(161,208,255,150)
    cL(246,200,122,150)
    screen.setMapColorSnow(250,250,250,150)
  else
    screen.setMapColorOcean(5,5,5,100)
    screen.setMapColorShallows(36,26,185,100)
    cL(102,96,8,100)
    screen.setMapColorSnow(115,114,121,100)
  end
end

function cL(a,b,c,d)
  screen.setMapColorLand(a,b,c,d)
  screen.setMapColorGrass(a,b,c,d)
  screen.setMapColorSand(a,b,c,d)
end