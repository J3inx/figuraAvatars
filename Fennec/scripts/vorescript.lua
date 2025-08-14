local vo_events = require("lib.vorelib")

function vo_events.eat(_type)
    if _type == "ov"
    or _type == "Default" then
        pings.Belly()
    elseif _type == "cv" then
        pings.penislow()
    else
        print("[EAT] Unknown vore type: " .. tostring(votype))
    end
end

function vo_events.gut_empty(_type)
    if _type == "ov"
    or _type == "Default" then
        pings.Belly()
    elseif _type == "cv" then
        pings.penislow()
    else
        print("[EMPTY] Unknown vore type: " .. tostring(votype))
    end
end

function vo_events.burp(votype)
    pings.burp()
end