local data, cvals = {}, {}
local init, tog = true, false
local buttons
local fx, fy, mx, my, tx, ty, px, py, fxs, fys
local zoom = 20, zooms_smooth
local sh, sw = 0, 0
local deg_in, deg_diff
local ap, out, tout, ap_speed = false, 0, 0, 0

IO = {}
IO.gN, IO.gB, IO.sN, IO.sB = input.getNumber, input.getBool, output.setNumber, output.setBool
sn = screen

function clamp(i,min,max)
	return (i >= min and i<= max) and i or ((i > max) and max or min)
end

function inrange(cx, cy, x, y, w, h)
	return (cx >= x and cy >= y and cx <= (x + w) and cy <= (y + h)) and true or false
end

function addBtn(x, y, w, h, t, f, tog)
	local data = {
		['x'] = (x or 0),
		['y'] = (y or 0),
		['w'] = (w or 0),
		['h'] = (h or 0),
		['t'] = (t or "Oops"),
		['f'] = (f or nil),
		['tog'] = (tog or false)
	}
	
	table.insert(buttons,data)
end

function initButtons()
	buttons = {}
	addBtn(sw - 14, 4, 10, 10, "+", function() zoom=clamp(zoom-(zoom/2),1,50) end)
	addBtn(sw - 14, 14, 10, 10, "-", function() zoom=clamp(zoom+(zoom/2),1,50) end)
	addBtn(4, sh - 14, 12, 10, "AP", function(b) ap = b.active end, true)
	addBtn(4, sh/2 - 7, 10, 14, "<", function() fx=fx-(100*zoom) end)
	addBtn(sw - 14, sh/2 - 7, 10, 14, ">", function() fx=fx+(100*zoom) end)
	addBtn(sw /2 - 7, 4, 14, 10, "U", function() fy=fy+(100*zoom) end)
	addBtn(sw /2 - 7, sh - 14, 14, 10, "D", function() fy=fy-(100*zoom) end)
end


function changed(name, val)
	local c = (cvals[name] ~= val) and true or false
	if c then cvals[name] = val end
	
	return c
end

function screenClk(x, y, down)
	local ab = false
	
	for k,b in pairs(buttons) do
		if inrange(x,y,b.x,b.y,b.w,b.h) then
			ab = true
			if down then
				if b.tog then
					b.active = not b.active
				else
					b.active = true
				end
				if b.f then b.f(b) end
			elseif not b.tog then
				b.active = false
			end
		end
	end
	
	if ab==false then
		if not init then
			tx, ty = map.screenToMap(fx, fy, zoom_smooth, sw, sh, x, y)
		end
		init = false
	end
end

function onTick()
	if buttons then
		if IO.gB(32) then
			ap = false
		end
		
		buttons[3].active = ap
	
		local touch = IO.gB(1)
	
		local x, y = IO.gN(3), IO.gN(4)
	
		mx, my = IO.gN(5), IO.gN(6)
		
		if (not fx or not fy) or ap then
			fx = (fx) and (fx + (mx - fx)/10) or mx
			fy = (fy) and (fy + (my - fy)/10) or my
		end
		
		fxs = (fxs) and (fxs + (fx - fxs)/10) or fx
		fys = (fys) and (fys + (fy - fys)/10) or fy
		
		
		deg_in = IO.gN(7) * 360

		if changed("touch", touch) then
			screenClk(x, y, touch)
		end
	end
	
	ap_speed = IO.gN(8)
	
	IO.sN(1,out)
	IO.sN(2,tout)
	IO.sB(1,ap)
end


function onDraw()
	sw, sh = sn.getWidth(), sn.getHeight()

	if not buttons then
		initButtons()
	end

	zoom_smooth = (zoom_smooth) and (zoom_smooth + (zoom - zoom_smooth) /10) or zoom

	sn.drawMap(fxs,fys,zoom_smooth)
	
	--Curpos
	smx, smy = map.mapToScreen(fxs, fys, zoom_smooth, sw, sh, mx, my)
	
	--Targ
	if tx and ty then
		px, py = map.mapToScreen(fxs, fys, zoom_smooth, sw, sh, tx, ty)
		sn.setColor(255,0,0)
		sn.drawLine(px,py,smx,smy)
		
		sn.setColor(0,0,0)
		sn.drawCircleF(px,py,4)
		
		local xDiff, yDiff = tx - mx, ty - my
		local c_deg = math.deg(math.rad(deg_in) + math.pi)
		local deg = -(math.deg(math.atan(xDiff, yDiff) - math.pi));
		
		local dist = math.sqrt( (xDiff ^ 2) + (yDiff ^ 2) )
		local s = clamp((dist - ap_speed) / 100,0,1)
		
		local a, b = c_deg, deg
		local d = math.abs(a - b) % 360; 
		local r = (d > 180) and 360 - d or d;

		local sign = ((a - b >= 0 and a - b <= 180) or (a - b <=-180 and a- b>= -360)) and 1 or -1; 
		r = r * sign;
		
		if ap then
			out = r / 180
			tout = tout + (s - tout) / ap_speed
		else
			tout = tout + (0 - tout) / (ap_speed / 4)
		end

	end
	
	sn.setColor(255,0,0)
	sn.drawCircleF(smx,smy,4)
	

	
	for k,b in pairs(buttons) do
		if not b.active then
			sn.setColor(255,255,255)
			sn.drawRect(b.x,b.y,b.w,b.h)
			sn.drawTextBox(b.x+1,b.y+1,b.w,b.h,b.t,0,0)
		else
			sn.setColor(255,255,255)
			sn.drawRectF(b.x,b.y,b.w,b.h)
			sn.drawRect(b.x,b.y,b.w,b.h)
			sn.setColor(0,0,0)
			sn.drawTextBox(b.x+1,b.y+1,b.w,b.h,b.t,0,0)
		end
	end
end