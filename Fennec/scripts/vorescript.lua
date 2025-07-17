-- Import the vorelib event table
local vo_events = require("lib.vorelib")








function vo_events.eat(ov)
    pings.bellyon()
 
     end --Works
 function vo_events.release(ov)
    pings.bellyoff()
 
     end --Works
 function vo_events.gut_empty(ov)
     pings.bellyoff()
 
     end --need to check
 
 function pings.bellyon()
   models.model.root.Body.belly:setVisible(true)
 end --set stomach on
 
 function pings.bellyoff()
   models.model.root.Body.belly:setVisible(false)
 end --set stomach off

-- Ping functions to show/hide models and print status
function pings.bellyFull()
    models.model.root.Body.belly:setVisible(true)
    print("[BELLY] Full")
end

function pings.bellyEmpty()
    models.model.root.Body.belly:setVisible(false)
    print("[BELLY] Emptied")
end

function pings.ballsFull()
    models.model.penislow:setVisible(true)
    models.model.penissheathed:setVisible(false)
    print("[BALLS] Full")
end

function pings.ballsEmpty()
    models.model.penislow:setVisible(false)
    models.model.penissheathed:setVisible(true)
    print("[BALLS] Emptied")
end

function pings.burp()
    print("[BURP] Sound played")
end

-- Override vorelib events with real functions

function vo_events.eat(votype)
    if votype == "ov" then
        pings.bellyFull()
    elseif votype == "cv" then
        pings.ballsFull()
    else
        print("[EAT] Unknown vore type: " .. tostring(votype))
    end
end

function vo_events.gut_empty(votype)
    if votype == "ov" then
        pings.bellyEmpty()
    elseif votype == "cv" then
        pings.ballsEmpty()
    else
        print("[EMPTY] Unknown vore type: " .. tostring(votype))
    end
end

function vo_events.burp(votype)
    pings.burp()
end
