itemAnim = {}

function itemAnim.generic(idle, equip, unequip)

end

function itemAnim.usable(idle, equip, unequip, using)

end

function itemAnim.usable_once(idle, equip, unequip, use)

end

function itemAnim.crossbow(equip, idle, draw, loadedidle, shoot)
	local handler = {
		equip = equip,
		idle = idle,
		draw = draw,
		loadedidle = loadedidle,
		shoot = shoot,
		
		state = 0,
		--0 = disabled
		--1 = idle
		--2 = loading
		--3 = loadedidle
		--4 = shoot
		counter = 0
	}	
	
	if equip then
		equip:setPriority(2)
	end
	shoot:setPriority(2)
	
	function events.tick()
		local holding_crossbow = player:getItem(1).id:find("crossbow") ~= nil
		local charged
		if client:compareVersions(client:getVersion(), "1.21") >= 0 then
			if player:getItem(1).tag["minecraft:charged_projectiles"] ~= nil then -- check if holding crossbow
				charged = player:getItem(1).tag["minecraft:charged_projectiles"][1] ~= nil -- check if it contains an arrow
			else
				charged = false
			end
		else
			charged = player:getItem(1).tag["Charged"] == 1
		end
		
		if holding_crossbow then
			if handler.state == 0 and equip then
				if equip then equip:play() end
			end
		
			if player:getActiveItem():getUseAction() == "CROSSBOW" then
				handler.state = 2
				if equip then equip:setPlaying(false) end
				shoot:setPlaying(false)
			else
				if charged then
					handler.state = 3
					handler.counter = 1
				elseif handler.counter == 1 and not charged then
					shoot:play()
					handler.state = 4
					handler.counter = 0
				elseif handler.state == 4 and shoot:isPlaying() then
					--we good, state stay 4
				else
					handler.state = 1
				end
			end
		elseif handler.state ~= 0 then
			handler.state = 0
			shoot:setPlaying(false)
			if equip then
				equip:setPlaying(false)
			end
			handler.counter = 0
		end
		
		
		if idle then
			idle:setPlaying(handler.state == 1 or handler.state == 4)
		end
		draw:setPlaying(handler.state == 2)
		loadedidle:setPlaying(handler.state == 3)
	end
	
	return handler
end

function itemAnim.bow(equip, idle, draw, drawidle, shoot)
	local handler = {
		equip = equip,
		idle = idle,
		draw = draw,
		drawidle = drawidle,
		shoot = shoot,
		
		state = 0,
		--0 = disabled
		--1 = idle
		--2 = draw
		--3 = drawidle
		--4 = shoot
		counter = 0
	}	
	
	equip:setPriority(2)
	shoot:setPriority(2)
	
	function events.tick()
		local holding_bow = player:getItem(1).id:find("bow") ~= nil
		
		if holding_bow then
			if handler.state == 0 then
				if equip then equip:play() end
			end
		
			if player:getActiveItem():getUseAction() == "BOW" then
				if handler.counter > 20 then
					handler.state = 3
				else
					handler.state = 2
					if shoot then shoot:setPlaying(false) end
					if equip then equip:setPlaying(false) end
					handler.counter = handler.counter + 1
				end
			else
				if handler.counter > 2 then
					if shoot then shoot:play() end
					handler.state = 4
					handler.counter = 0
				elseif handler.state == 4 and shoot:isPlaying() then
					--we good, state stay 4
				else
					handler.state = 1
				end
			end
		elseif handler.state ~= 0 then
			handler.state = 0
			if shoot then shoot:setPlaying(false) end
			if equip then equip:setPlaying(false) end
			handler.counter = 0
		end
		
		
		
		if idle then idle:setPlaying(handler.state == 1 or handler.state == 4) end
		if draw then draw:setPlaying(handler.state == 2) end
		if drawidle then drawidle:setPlaying(handler.state == 3) end
	end
	
	return handler
end

return itemAnim