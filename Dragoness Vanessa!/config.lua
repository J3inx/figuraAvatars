--configuration options for resizable avatar

--your default scale value
defaultScale = 1

--secondary scale value used in action wheel
savedScale = 0.4
--true if using your own model, false if you just want a vanilla avatar
custom_model = true

--if you are using a custom model then choose the camera adjustment you need (for shorter/taller characters, keep 1 if normal sized)
camera_adjust = 1

--decide if you want the action wheel page set already or not (choose false if making your own action wheel with paging logic)
action_wheel_enable = true

--additional notes
--[[
if you want to change scale ingame without action wheel do /figura run Resize(X)
where X is the scale you want

resize.lua can be required in order to get the current scale and to change the camera_adjust value
you can also manually set the scale by calling the resize function through the require and giving it your desired scale

]]--


return {
	defaultScale 	= defaultScale,
	savedScale 		= savedScale,
	custom_model 	= custom_model,
	camera_adjust	= camera_adjust,
	action_wheel 	= action_wheel_enable,
	
}