-- Auto generated script file --

--hide vanilla model
vanilla_model.PLAYER:setVisible(false)

--hide vanilla armor model
vanilla_model.ARMOR:setVisible(false)
--re-enable the helmet item
vanilla_model.HELMET_ITEM:setVisible(true)

--hide vanilla cape model
vanilla_model.CAPE:setVisible(false)

--hide vanilla elytra model
vanilla_model.ELYTRA:setVisible(false)

--entity init event, used for when the avatar entity is loaded for the first time
function events.entity_init()
  --player functions goes here
end

--tick event, called 20 times per second
function events.tick()
  --code goes here
end

--render event, called every time your avatar is rendered
--it have two arguments, "delta" and "context"
--"delta" is the percentage between the last and the next tick (as a decimal value, 0.0 to 1.0)
--"context" is a string that tells from where this render event was called (the paperdoll, gui, player render, first person)
function events.render(delta, context)
  --code goes here
end

function pings.SitToggle(x)
  animations.bunnymodel2.sit:setPlaying(x)
  	if host:isHost() then
	  if x == true then
		camera.setCamera(nil, -0.5)
	  else
		camera.setCamera(nil, 0)
	  end
	end
end

function pings.LeanSitToggle(x)
  animations.bunnymodel2.leansit:setPlaying(x)
   	if host:isHost() then
	  if x == true then
		camera.setCamera(nil, -0.5)
	  else
		camera.setCamera(nil, 0)
	  end
	end
end

-- Set Up ActionWheelPages (Kcin's Scroll Thru Wheels function)

	action_pages = {"Toggles"}

	-- make the pages
	for key, i in pairs(action_pages) do
		_G[i] = action_wheel:newPage(i)
	end

	-- insert Pages here
	table.insert(action_pages, "ResizePage")

	-- Set Page to 1
	action_wheel:setPage(action_pages[1])

	--Set up scrolling Vars
	pageCount = #action_pages
	selectedPage = 1

	
    --Scroll Through Action Pages Function
    function action_wheel.scroll(dir)
        if action_wheel:getSelected() == 0 then
            selectedPage = selectedPage + -math.sign(dir)
            if selectedPage == 0 then selectedPage = pageCount end
            if selectedPage > pageCount then selectedPage = 1 end
            action_wheel:setPage(action_pages[selectedPage])
        end
    end 
	
-- Sit Toggle
	Toggles:newAction()
	:title("Sit")
	:item("oak_stairs")
	:onToggle(function(state) pings.SitToggle(state) end)
	:toggleColor(vec(1, 1, 0))
	
	-- Lean Sit Toggle
	Toggles:newAction()
	:title("Lean Sit")
	:item("birch_stairs")
	:onToggle(function(state) pings.LeanSitToggle(state) end)
	:toggleColor(vec(1, 1, 0))