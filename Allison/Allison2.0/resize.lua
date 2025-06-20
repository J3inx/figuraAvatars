config = require("config")

--change scale to X
local defaultScale = config.defaultScale
--a saved secondary size to be used in action wheel
local savedScale = config.savedScale

local ResizePage = action_wheel:newPage("ResizePage")

local returntbl = {
	scale = defaultScale,
	camera_adjust = config.camera_adjust,
	resize = function(size) pings.updateScale(size) end,
	page = ResizePage,
	pagename = "ResizePage"
}




--action wheel starts here
local scaletable = {0.01,0.05,.1,.25,.5,1}
local scaleindex = 3


if config.action_wheel then
	action_wheel:setPage(ResizePage)
end


ResizePage:newAction()
:title("Default Size §7(leftclick)§r\nSaved Size §7(rightclick)")
:item("milk_bucket")
:onLeftClick(function() log("size Set "..defaultScale) pings.updateScale(defaultScale) end)
:onRightClick(function() log("size Set "..savedScale) pings.updateScale(savedScale) end)

ResizePage:newAction()
:title("Save Current Scale")
:item("shulker_box")
:onLeftClick(function() savedScale = scale end)

RateControl = ResizePage:newAction()
:title("Change the Rate of Scale Change §7(Scroll)§b\n\nScale Rate: "..scaletable[scaleindex])
:item("sugar")
:onScroll(function(dir)
scaleindex = math.clamp(scaleindex + dir, 1 , #scaletable)
RateControl:title("Change the Rate of Scale Change §7(Scroll)§b\n\nScale Rate: "..scaletable[scaleindex])

end)

ScaleControl = ResizePage:newAction()
:title("Increase and Decrease Player Scale §7(Scroll)§b\n\nCurrent Scale: "..defaultScale)
:item("red_mushroom")
:onScroll(function(dir)
	scale = math.max(scale + (dir * scaletable[scaleindex]),0.05)
	ScaleControl:title("Increase and Decrease Player Scale §7(Scroll)§b\n\nCurrent Scale: "..scale)
	pings.updateScale(scale)
	
end)


--code starts here
camera = require("camera")

vanilla_model.ALL:setVisible(false)
vanilla_model.HELD_ITEMS:setVisible(true)
vanilla_model.HELMET_ITEM:setVisible(false)



scale = defaultScale
models:setScale(scale,scale,scale)
camera.setCamera(scale*returntbl["camera_adjust"])

if scale >= 1 then
	nameplate.ENTITY:setScale(scale,scale,scale)
else
	local tinyscale = math.max(scale,.2)*2
	nameplate.ENTITY:setScale(tinyscale,tinyscale,tinyscale)
end

nameplate.ENTITY:setPos(0, (scale*returntbl["camera_adjust"] - 1)*2.2, 0)



function Resize(arg)
pings.updateScale(arg)
end
function pings.updateScale(arg)
scale = arg
returntbl.scale = arg
models:setScale(scale,scale,scale)
	if scale >= 1 then
		nameplate.ENTITY:setScale(scale,scale,scale)
	else
		local tinyscale = math.max(scale,.2)*2
		nameplate.ENTITY:setScale(tinyscale,tinyscale,tinyscale)
	end

nameplate.ENTITY:setPos(0, (scale*returntbl["camera_adjust"] - 1)*2.2, 0)
camera.setCamera(scale*returntbl["camera_adjust"])
end


local timer = 200
events.TICK:register(function()

if player:getPose() == "CROUCHING" then
	models:setPos(0,2,0)
	nameplate.ENTITY:setPos(0, (scale*returntbl["camera_adjust"] - 1)*2.2 + 4/16, 0)
else
	models:setPos(0,0,0)
	nameplate.ENTITY:setPos(0, (scale*returntbl["camera_adjust"] - 1)*2.2, 0)
end


if host:isHost() then
	if timer > 0 then
		timer = timer - 1

	else

		pings.updateScale(scale)
		timer = 200
	end
end


end)

function events.render(delta, type)
if type == "FIRST_PERSON" or type == "RENDER" then return end

models:setScale(1,1,1)

end

function events.post_render(delta, type)
if type == "FIRST_PERSON" or type == "RENDER" then return end

models:setScale(scale,scale,scale)

end

return returntbl
