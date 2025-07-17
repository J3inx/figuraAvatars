---Splits the given string at given seperator
---@param s string
---@param sep string
---@return string[]
local function split(s, sep)
    local values = {}
    for v in string.gmatch(s, "([^"..sep.."]+)") do
        table.insert(values, v)
    end
    return values
end

---Checks if the given string starts with the compared string
---@param s string
---@param cmp string
---@return boolean
local function starts_with(s, cmp)
    return string.sub(s, 1, #cmp) == cmp
end

--
--   DEFINE TABLE AND DEFAULT EVENTS PRESETS
--
------------------------------

---Table containing all the functions associated with an action.
---
---Custom action can be created by declaring a new function
---within this table using the following syntax: `table.action_name(_type, ...)`, where
---`_type` is the currently used /votype and `...` is any additional arguments
---associated with it.
---
---@type { [string]: function }
local event_table = {}

---Run when eating a prey
---@param _type string
function event_table.eat(_type) end

---Run when releasing prey(s)
---@param _type string
function event_table.release(_type) end

---Run when burping
---@param _type string
function event_table.burp(_type) end

---Run when gurgling
---@param _type string
function event_table.gurgle(_type) end

---Run when you rubs your stomach
---@param _type string
function event_table.rub_self(_type) end

---Run when someone rubs your stomach
---@param _type string
function event_table.rub_receive(_type) end

---Run when someone inside rubs your stomach
---@param _type string
function event_table.rub_receive_inner(_type) end

---Run when your stomach is slapped
---@param _type string
function event_table.slap(_type) end

---Run when a prey struggles
---@param _type string
function event_table.struggle(_type) end

---Run when the digestion begins
---@param _type string
function event_table.digest_start(_type) end

---Run when a prey gets fully digested
---@param _type string
function event_table.digest_finish(_type) end

---Run when the last prey leaves the stomach (either by release or digestion)
---@param _type string
function event_table.gut_empty(_type) end

--
--   LISTEN AND EXECUTE THE ASSOCIATED FUNCTION IF EXISTS
--
------------------------------

function events.CHAT_RECEIVE_MESSAGE(raw, text)
    -- Checks before split: more optimized especially on very lengthy message
    if not starts_with(raw, "figura;") then
        return nil -- does nothing
    end

    -- Split arguments and checks if has at least 3 arguments.
    -- Expected syntax: `figura;<id>;<type>;<args...>`
    local args = split(raw, ";")
    if #args < 3 then
        return nil -- does nothing
    end

    -- Look up associated event and run it if exists
    for action, fn in pairs(event_table) do
        if action == args[2] then
            fn(table.unpack(args, 3, #args))
            break
        end
    end

    -- Voids message
    return false
end

return event_table
