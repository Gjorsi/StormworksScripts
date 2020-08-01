initialised = false
unlock_speed, open_speed, unlock_time, open_time = 0,0,0,0
pushed = false
state = 'closed'
unlocking_timer, opening_timer = 0,0
seal_state = false
states = {}

function onTick()
  if not initialised then initialise() end
  seal_state = input.getBool(2)
  if input.getBool(1) and not pushed then
    if state == 'opening' then opening_timer = opening_timer + 30 end
    state = states[state]
  end
  
  if state == 'unlocking' then
    unlocking_timer = unlocking_timer + 1
    if unlocking_timer == unlock_time*60 then state = 'opening' end
  elseif state == 'locking' then
    unlocking_timer = math.max(unlocking_timer-1, 0)
    if seal_state then state = 'closed' end
  elseif state == 'opening' then
    opening_timer = opening_timer + 1
    if opening_timer == open_time*60 then state = 'open' end
  elseif state == 'closing' then
    opening_timer = opening_timer - 1
    if opening_timer == 0 then state = 'locking' end
  end
  
  pushed = input.getBool(1)
  
  if state == 'unlocking' then u_sp = unlock_speed
  elseif state == 'locking' then u_sp = (-1)*unlock_speed
  else u_sp = 0 end

  if state == 'opening' then o_sp = open_speed
  elseif state == 'closing' then o_sp = (-1)*open_speed
  else o_sp = 0 end

  output.setNumber(1, u_sp)
  output.setNumber(2, o_sp)
  
  output.setBool(4, state == 'closed')
  output.setBool(1, state == 'opening' or state == 'unlocking')
  output.setBool(2, state == 'closing' or state == 'locking')
  output.setBool(3, state == 'closed')

end

function initialise()

  if input.getNumber(1) ~= 0 then 
    initialised = true
    unlock_speed = input.getNumber(1)
    open_speed = input.getNumber(2)
    unlock_time = input.getNumber(3)
    open_time = input.getNumber(4)
    
    states['closed'] = 'unlocking'
    states['unlocking'] = 'locking'
    states['locking'] = 'unlocking'
    states['opening'] = 'closing'
    states['closing'] = 'opening'
    states['open'] = 'closing'
  end
end

function onDraw()
end
