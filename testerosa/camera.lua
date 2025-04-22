--[[
you need to add these lines to your script
camera = require("camera")
camera.setCamera(insertscale)
if you want to offset the camera for anims and such do
camera.setCamera(nil, insertoffset)

you can also disable the keybind for the toggle to add your camera toggle or just disable it (you dont want to have no toggle tho) then do
camera.keybindEnable = false

if you want to manually control the enabling/disabling of the camera do
camera.cameraEnable = true
and
camera.cameraEnable = false

]]--

local cameraScale = 1
local cameraOffset = 0

local returntbl = {
	setCamera =function(scale,offset)
		if scale ~= nil then cameraScale = scale end
		if offset ~= nil then cameraOffset = offset end
	end,
	keybindEnable = true,
	cameraEnable = true
}

function events.render()
	if not host:isHost() then return end
	
	offsetY = -player:getEyeHeight() + (player:getEyeHeight() + cameraOffset) * cameraScale
	offsetZ = 4 * (cameraScale - 1)
	
	if player:getPose() == "SLEEPING" then
		offsetY = offsetY + 0.3 * cameraScale
	end	
	
	if returntbl["cameraEnable"] == true then
		if renderer:isFirstPerson() then
		renderer:setCameraPos(0, 0, 0)
		renderer:offsetCameraPivot(0, offsetY, 0)
		else
		renderer:setCameraPos(0, 0, offsetZ)
		renderer:offsetCameraPivot(0, offsetY, 0)
		
		end
	else
		renderer:setCameraPos(0, 0, 0)
		renderer:offsetCameraPivot(0, 0, 0)
	end

end


local key_toggle_camera = keybinds:newKeybind("Toggle Camera", "key.keyboard.x")

key_toggle_camera.press = function()
if not returntbl["keybindEnable"] then return end
returntbl["cameraEnable"] = not returntbl["cameraEnable"]
log("Camera toggled = " .. tostring(returntbl["cameraEnable"]))
end


return returntbl