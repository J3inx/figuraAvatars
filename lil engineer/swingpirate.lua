local swingPirate = {}

local RESISTANCE = 0.9
local BOUNCE = 0.5
local GRAVITY = 9.81

local h_vel = 0
local v_vel = 0
local f_vel = 0
local s_vel = 0
local dir_vel = vec(0,0,0)

local look_vel = 0
local old_look

local body_look_vel = 0
local old_body_rot

local look_vel_vert = 0
local old_look_vert = 0

--creates new swinging object
--param1: (modelPart) modelPart to swinging
--param2: (array[function or string] or string) array of forces to apply containing strings or functions OR a string for a default preset
	--functions in the array will be called every tick with the handler passed in and are expected to return a vector3 of acelleration for the tick
	--strings will be converted to default force functions. Valid strings: 
		--"gravity": makes object fall
		--"velocity": applies player movement velocity, causing object to swing out
		--"centrifugal_head": causes the object to swing out and sideways when turning head
		--"centrifugal_body": causes the object to swing out and sideways when turning head
		--	"wind": pushes object around slightly based on world time
	--Valid preset strings (pass in one of these strings instead of an array):
		--"default_head": contains: {force_gravity, force_plr_move, force_centrifugal_head, force_wind}
		--"default_body": contains: {force_gravity, force_plr_move, force_centrifugal_body, force_wind}
--param3: (array[number]) array of max angles in format {maxX, minX, maxY, minY, maxZ, minZ}
--param4: (table[any]) table of handler vars. can contain any values that force functions may use, but must at least contain:
	--resistance: (number 0-9) value that velocity gets multiplyed by every tick, simulates friction
	--bounce: (number) value for how much velocity is deflected back the other direction upon hitting bounds. 0 means no bounce, 1 is no velocity loss
	--and any other values. force functions should acess values here, as they are unique per-handler
--param5: (handler) if this is a chain, place the handler of the object this is directly connected to here
--returns: (table) a handler for acessing functions and variables related to the swinging object

function swingPirate.SwingPhysics(part, startforces, startbounds, startvars, root)
	local velocity = vec(0,0,0)
	
	startvars = startvars or {
			resistance = RESISTANCE,
			bounce = BOUNCE,
			weight = 1,
			windflow = 0
		}
		
	startforces = startforces or {force_gravity, force_plr_move, force_centrifugal_head, force_wind}
	
	startbounds = startbounds or {90, -90, 90, -90, 90, -90}
	
	local startforces_done = {}
	
	if type(startforces) == "string" then
		if startforces == "default_head" then
			startforces_done = {force_gravity, force_plr_move, force_centrifugal_head, force_wind}
		elseif startforces == "default_body" then
			startforces_done = {force_gravity, force_plr_move, force_centrifugal_body, force_wind}
		else
			error("Argument 2 invalid preset string type: " .. startforces .. "\nShould be one of: default_head, default_body")
		end
	elseif type(startforces) == "table" then
		for i,v in ipairs(startforces) do
			if type(v) == "string" then
				if v == "gravity" then
					startforces_done[i] = force_gravity
				elseif v == "velocity" then
					startforces_done[i] = force_plr_move
				elseif v == "centrifugal_head" then
					startforces_done[i] = force_centrifugal_head
				elseif v == "centrifugal_body" then
					startforces_done[i] = force_centrifugal_body
				elseif v == "wind" then
					startforces_done[i] = force_wind
				else
					error("Invalid force string type: " .. v .. "\nShould be one of: gravity, velocity, centrifugal_head, centrifugal_body, wind")
				end
			elseif type(v) == "function" then
				startforces_done[i] = v
			else
				error("Invalid force data type: " .. type(v) .. "\nMust be function or string")
			end
		end
	else
		error("Argument 2 invalid data type: " .. type(v) .. "\nMust be function or string")
	end
	
	local handler = {
		enabled = true,
		vars = startvars,
		offset = vec(0,0,0),
		bounds = startbounds,
		forces = startforces_done,
		
		currentRot = vec(0,0,0),
		oldRot = vec(0,0,0),
		oldoffset = vec(0,0,0),
		
		oldExtraOffset = part:getRot(),
		
		rootOffset = vec(0,0,0), --offset of this object's root
		branchOffset = vec(0,0,0) --offset for objects conected to this
	}
	
	if not startbounds then
		handler.bounds = nil
	end
	
	function events.tick()
		if not handler.enabled then return end
		
		local total_offset = part:getRot()
		local offset_delta
		
		if root then
			offset_delta = handler.offset + part:getRot() + root.currentRot - handler.oldoffset - root.oldRot - handler.oldExtraOffset
		else
			offset_delta = handler.offset + part:getRot() - handler.oldoffset - handler.oldExtraOffset
		end		
		
		for i, v in ipairs(handler.forces) do
			velocity = velocity + v(handler)
		end
		
		velocity = velocity*handler.vars.resistance
		
		handler.oldRot = handler.currentRot
		handler.currentRot = handler.currentRot + velocity - offset_delta*0.9
		
		--clamp
		if handler.bounds then
			local currentRot = handler.currentRot
		
			if currentRot.x > handler.bounds[1] then
				currentRot.x = handler.bounds[1]
				velocity.x = -velocity.x*handler.vars.bounce
			elseif currentRot.x < handler.bounds[2] then
				currentRot.x = handler.bounds[2]
				velocity.x = -velocity.x*handler.vars.bounce
			end
		
			if currentRot.y > handler.bounds[3] then
				currentRot.y = handler.bounds[3]
				velocity.y = -velocity.y*handler.vars.bounce
			elseif currentRot.y < handler.bounds[4] then
				currentRot.y = handler.bounds[4]
				velocity.y = -velocity.y*handler.vars.bounce
			end
			
			if currentRot.z > handler.bounds[5] then
				currentRot.z = handler.bounds[5]
				velocity.z = -velocity.z*handler.vars.bounce
			elseif currentRot.z < handler.bounds[6] then
				currentRot.z = handler.bounds[6]
				velocity.z = -velocity.z*handler.vars.bounce
			end
		end
		
		if root then
			handler.branchOffset = root.branchOffset - handler.currentRot
			handler.rootOffset = root.branchOffset
		else	
			handler.branchOffset = handler.currentRot
		end
		
		handler.oldoffset = handler.offset
		handler.oldExtraOffset = total_offset
	end
	
	function events.render(delta)
		if not handler.enabled then return end
		part:setOffsetRot(math.lerp(handler.oldRot, handler.currentRot, delta)+math.lerp(handler.oldoffset, handler.offset, delta))
	end
	--methods
	
	--resets velocity and position while stopping/starting swinging physics
	function handler:setEnabled(value)
		self.enabled = value
		if self.enabled then
			part:setOffsetRot(0,0,0)
			velocity = vec(0,0,0)
		else
			oldRot = vec(0,0,0)
			currentRot = vec(0,0,0)
			part:setOffsetRot(0,0,0)
		end
	end
	
	--stops swinging physics but keeps object in place
	function handler:freeze()
		self.enabled = false
	end
	
	return handler
end

--default forces
function force_gravity(handler)
	return vec(
		-GRAVITY * math.sin(math.rad(handler.currentRot.x-handler.rootOffset.x)),
		0,
		-GRAVITY * math.sin(math.rad(handler.currentRot.z-handler.rootOffset.z))
		)/5
end

function force_plr_move(handler)
	if player:isGliding() or player:isVisuallySwimming() then
		return vec(0,0,0)
	else
		return (-dir_vel*5 + vec(v_vel*5,0,0))/handler.vars.weight
	end
end

function force_centrifugal_head(handler)
	local glide_effect = 0

	if player:isLoaded() then
		if player:isGliding() or player:isVisuallySwimming() then
			glide_effect = vec(look_vel_vert*10,0,0)/handler.vars.weight
		end
	end

	return (vec(-math.abs(look_vel/32/handler.vars.weight),0,look_vel/16)/handler.vars.weight) * (player:isGliding() and 5 or 1) + glide_effect
end

function force_centrifugal_body(handler)
	local glide_effect = 0

	if player:isLoaded() then
		if player:isGliding() or player:isVisuallySwimming() then
			glide_effect = vec(look_vel_vert*10,0,0)/handler.vars.weight
		end
	end
	
	return (vec(-math.abs(body_look_vel/32/handler.vars.weight),0,body_look_vel/16)/handler.vars.weight) * (player:isGliding() and 5 or 1) + glide_effect
end

function force_wind(handler)
	
	if world:getTime()%120 == 0 then
		--recalculate windflow
		handler.vars.windflow = 0
		
		if raycast:block(player:getPos(), player:getPos()+vec(0,10,0)):getID() == "minecraft:air" then --up
			handler.vars.windflow = handler.vars.windflow+1
		end
		if raycast:block(player:getPos()+vec(0,1,0), player:getPos()+vec(5,0,0)):getID() == "minecraft:air" then --east
			handler.vars.windflow = handler.vars.windflow+1
		end
		if raycast:block(player:getPos()+vec(0,1,0), player:getPos()+vec(5,0,5)):getID() == "minecraft:air" then --southest
			handler.vars.windflow = handler.vars.windflow+1
		end
		if raycast:block(player:getPos()+vec(0,1,0), player:getPos()+vec(0,0,5)):getID() == "minecraft:air" then --south
			handler.vars.windflow = handler.vars.windflow+1
		end
		if raycast:block(player:getPos()+vec(0,1,0), player:getPos()+vec(-5,0,5)):getID() == "minecraft:air" then --southwest
			handler.vars.windflow = handler.vars.windflow+1
		end
		if raycast:block(player:getPos()+vec(0,1,0), player:getPos()+vec(-5,0,0)):getID() == "minecraft:air" then --west
			handler.vars.windflow = handler.vars.windflow+1
		end
		if raycast:block(player:getPos()+vec(0,1,0), player:getPos()+vec(-5,0,-5)):getID() == "minecraft:air" then --northwest
			handler.vars.windflow = handler.vars.windflow+1
		end
		if raycast:block(player:getPos()+vec(0,1,0), player:getPos()+vec(0,0,-5)):getID() == "minecraft:air" then --north
			handler.vars.windflow = handler.vars.windflow+1
		end
		if raycast:block(player:getPos()+vec(0,1,0), player:getPos()+vec(5,0,-5)):getID() == "minecraft:air" then --northeast
			handler.vars.windflow = handler.vars.windflow+1
		end
	end
	
	if handler.vars.windflow ~= 0 and player:getPos().y > 0 then
		handler.vars.windflow = handler.vars.windflow or 0
	
		local tick = world:getTime()
	
		--noise-ish waveform
		local wind = vec(
			math.sin(tick/23)*0.23+math.sin(tick/54)*0.34+math.sin(tick/1238)*0.78,
			math.sin((tick+6)/17)*0.18+math.sin((tick-31)/72)*0.26+math.sin((tick-1278)/1108)*0.63
			)*0.5
			
		local wind_strength = ((player:getPos().y^0.9-40)*0.08+1)*(handler.vars.windflow/9)*(1+world.getRainGradient()*0.2)
		
		if world.isThundering() then
			wind_strength = wind_strength*1.1
		end
		
		local theta = math.rad(player:getRot().y);

		local cs = math.cos(-theta);
		local sn = math.sin(-theta);
		
		local out = vec(
			wind.x*cs-wind.y*sn,
			0,
			wind.x*sn+wind.y*cs)
	
		return out*wind_strength/handler.vars.weight
	else
		return vec(0,0,0) -- no wind :(
	end
end

--other functions
--sets offset to make object act as expected on head while it rotates. should be called every tick
--param1: (handler) put the swing object handler here
--param2: (number) horizontal distace from center pivot point of head
--param3: (boolean) if true, tries to simulate collision with player body
--param4: (number) distance of body from center head pivot point
--param5: (number) x offset to add to final number
--param6: (number) maximum offset allowed
--param7: (number) minium offset allowed
function swingPirate.AnchorHead(handler, bodyColide, distance, bodySize, length, offset, maxOffset, minOffset)
	if not player:isLoaded() then return end

	offset = offset or 0
	maxOffset = maxOffset or 90
	minOffset = minOffset or -90

	local degrees = vanilla_model.HEAD:getOriginRot().x
	
	--local hor_deg = math.atan2(player:getLookDir()[1], player:getLookDir()[3]) * 180/math.pi+180
	
	local colider = 0	
	
	if bodyColide then
		local alpha = -degrees+90
	
		function arcsine(value)
			return math.deg(math.asin(value))
		end
		function sine(value)
			return math.sin(math.rad(value))
		end
		local maxAngle = arcsine(sine(alpha)*((distance-bodySize)/length))
		
		colider = handler.bounds
		colider[3] = maxAngle
		
		--[[if degrees > maxAngle then
			degrees = maxAngle
		end]]
		handler:setBounds(colider)
	end
		
	local out = -degrees+offset
	
	if out > maxOffset then
		out = maxOffset
	elseif out < minOffset then
		out = minOffset
	end
		
	handler.offset = vec(out,handler.offset.y,handler.offset.z)
	
end

function events.tick()
	--calculate velocities
	local plr_vel = player:getVelocity()
	local lookdir = player:getLookDir()
		
	v_vel = plr_vel[2]
	h_vel = vec(plr_vel[1], plr_vel[2])
	
	f_vel = plr_vel:dot((lookdir.x_z):normalize())
	
	local rotate_lookdir = vec(lookdir.z, lookdir.y, -lookdir.x)
	s_vel = plr_vel:dot((rotate_lookdir):normalize())
	
	dir_vel = vec(f_vel, 0, -s_vel)
	
	local rot = player:getRot().y
	
	old_look = old_look or rot	
	look_vel = rot - old_look
	old_look = rot
	
	local body_rot = player:getBodyYaw()
	
	old_body_rot = old_body_rot or body_rot
	body_look_vel = body_rot - old_body_rot
	old_body_rot = body_rot
	
	old_look_vert = old_look_vert or lookdir.y
	
	look_vel_vert = lookdir.y - old_look_vert
	old_look_vert = lookdir.y
end

return swingPirate