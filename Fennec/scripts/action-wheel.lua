local toggles = action_wheel:newPage()
local mainPage = action_wheel:newPage()
local transformation = action_wheel:newPage()
local debugging = action_wheel:newPage() --Used for debugging purposes only.
action_wheel:setPage(mainPage)

local togglename = toggles:newAction()
:title("Show Belly")
:toggleTitle("Hide Belly")
:item("crimson_button")
:setOnToggle(function(state)
    pings.Belly(state)
end)
function pings.Belly(state)
    if state then
        models.model.root.Body.belly:setVisible(true)
    else
        models.model.root.Body.belly:setVisible(false)
    end
end

local togglename = toggles:newAction()
:title("Show Sheath")
:toggleTitle("Turn Off NSFW")
:item("warped_button")
:setOnToggle(function(state)
    pings.Cock(state)
end)
function pings.Cock(state)
    if state then
        models.model.penissheathed:setVisible(true)
    else
        models.model.penissheathed:setVisible(false)
    end
end


local togglename = toggles:newAction()
:title("Show Penis")
:toggleTitle("Disable Penis")
:item("polished_blackstone_button")
:setOnToggle(function(state)
    pings.penislow(state)
end)


function pings.penislow(state)
    if state then
    models.model.penislow:setVisible(true)
  else
    models.model.penislow:setVisible(false)
  end
end

local togglename = toggles:newAction()
:title("Aroused")
:toggleTitle("Cool Off")
:item("polished_blackstone_button")
:setOnToggle(function(state)
    pings.penishigh(state)
end)


function pings.penishigh(state)
    if state then
    models.model.penishigh:setVisible(true)
  else
    models.model.penishigh:setVisible(false)
  end
end



mainPage:newAction()
:title("Debug")
:item("note_block")
:onLeftClick(function ()
  action_wheel:setPage(debugging)
end)
local togglename = debugging:newAction()
:title("return")
:item("glass")
:onLeftClick(function ()
  action_wheel:setPage(mainPage)
end)
local togglename = debugging:newAction()
:title("Transform! - Debug")
:toggleTitle("Revert Transformation")
:item("polished_blackstone_button")
:setOnToggle(function (state)
  pings.debug_state(state)
end)

function pings.debug_state(state)
  if state then
    models.model.root.Head.dragon:setVisible(true)
    models.model.root.Head.Eyes:setVisible(false)
  else
    models.model.root.Head.dragon:setVisible(false)
    models.model.root.Head.Eyes:setVisible(true)
  end
end
mainPage:newAction()
:title("Enter toggles")
:item("note_block")
:onLeftClick(function ()
  action_wheel:setPage(toggles)
end)
local togglename = toggles:newAction()
:title("return")
:item("glass")
:onLeftClick(function ()
  action_wheel:setPage(mainPage)
end)
mainPage:newAction()
:title("Enter transformations")
:item("note_block")
:onLeftClick(function ()
  action_wheel:setPage(transformation)
end)
local togglename = transformation:newAction()
:title("return")
:item("glass")
:onLeftClick(function ()
  action_wheel:setPage(mainPage)
end)
local togglename = transformation:newAction()
:title("Transform!")
:toggleTitle("Revert Transformation")
:item("polished_blackstone_button")
:setOnToggle(function(state)
    pings.transformation(state)
        pings.transformation(state)
end)


function pings.transformation(state)
    if state then
      animations.model.transformation:play()
      models.model.root.Body.wings:setVisible(true)
      vanilla_model.elytra:setVisible(false)
      pings.animation()
      models.model.root.Head.dragon:setVisible(true)
      models.model.root.Head.Eyes:setVisible(true)
        if animations.model.transformation:isStopped() then
          models.model.root.Head.Eyes:setVisible(false)
        end
  else
    models.model.root.Body.wings:setVisible(false)
    vanilla_model.elytra:setVisible(true)
    models.model.root.Head.Eyes:setVisible(true)
    models.model.root.Head.dragon:setVisible(false)
  end
end



--yap start
local shouldYap = config:load("shouldYap")
--log(config:load("shouldYap"))
function pings.shouldYap(toggle)
  shouldYap = toggle
  config:save("shouldYap",toggle)
end
pings.shouldYap(shouldYap)

local yap = {"sounds.Foxidle2", "sounds.Foxidle3"}
function pings.yap()
    if player:isLoaded() then
        --animations.model.talk:play() --talk animation, optional. comment out if unused.
        sounds:playSound(yap[math.random(#yap)] ,player:getPos(),1,1) --replace "audio.talk" with whatever sound you'd like
        --runLater(2,function ()
          --sounds:playSound("audio.talk",player:getPos(),0.3,math.random(2,3)/2) --replace "audio.talk" with whatever sound you'd like
        --end)
    end
end
function events.chat_send_message(msg)
    if not msg then return end
        if string.sub(msg, 1, 1) ~= "/" and shouldYap then
        pings.yap()    
        end
    return msg
end

local shouldYapAction = mainPage:newAction()
  :title("to yap or not to yap")
  :item("minecraft:jukebox")
  :hoverColor(0,1,1)
  :setToggled(shouldYap)
shouldYapAction:onToggle(pings.shouldYap)

-- incomprehensible barking