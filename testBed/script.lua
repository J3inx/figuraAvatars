-- Auto generated script file --
--variables
local selected = 0
--0 = none
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

--action wheel setup
local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)
--entity init event, used for when the avatar entity is loaded for the first time
function events.entity_init()
  --player functions goes here
end
function pings.scrolling(dir)
  --log(dir)
  if dir > 0 then
      if selected == 5 then
        selected = 0
      else
        selected = selected +1
      end
      log(selected)
  else
      
      if selected == 0 then
        selected = 5
      else
        selected = selected -1
      end
      log(selected)
  end
end
mainPage:newAction()
    :title("select sound §7(scroll)§r")
    :item("jukebox")
    :setOnScroll(pings.scrolling)
mainPage:newAction()
    :title("play sound §7(left click)§r")
    :item("arrow")
    :setOnLeftClick(function() 
      if selected == 0 then
        log("no sound selected")
        
      elseif selected == 1 then
        sounds:playSound("testSound", player:getPos())
        log("played sound 1")
      elseif selected == 2 then 
        sounds:playSound("testSound", player:getPos())
        log("played sound 2")
      elseif selected == 3 then 
        sounds:playSound("testSound", player:getPos())
        log("played sound 3")
      elseif selected == 4 then 
        sounds:playSound("testSound", player:getPos())
        log("played sound 4")
      elseif selected == 5 then 
        sounds:playSound("testSound", player:getPos())
        log("played sound 5")

      
    
  end
    end)

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
