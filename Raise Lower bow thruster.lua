ti = 0
hatch_pos, bt_pos, hatch_open_pos, bt_open_pos = 0,0,0,0
opening, closing = false,false

function onTick()
  
  readInputs()
  
  ti = ti+1
  if ti > 2000 then ti = 361 end
  
  if input.getBool(1) and ti > 360 then
    ti=0
    opening = true
  end
  
  if input.getBool(2) and ti > 360 then
    ti=0
    closing = true
  end
  
  if ti == 360 then
    opening, closing = false,false
  end

  output.setBool(1, hatch_open_pos-hatch_pos<0.05)
  output.setBool(2, bt_open_pos-bt_pos<0.05)
  output.setBool(3, opening and ti<180)
  output.setBool(4, closing and ti>180)
  output.setBool(5, opening and ti>180)
  output.setBool(6, closing and ti<180)
end

function readInputs()
  hatch_pos = input.getNumber(1)
  bt_pos = input.getNumber(2)
  hatch_open_pos = input.getNumber(3)
  bt_open_pos = input.getNumber(4)
end

function onDraw()
end