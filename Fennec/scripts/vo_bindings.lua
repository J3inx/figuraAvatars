vo_events = {
    eat = "figura:eat",
    release = "figura:release", 
    burp = "figura:burp",
    gurgle = "figura:gurgle",
    rub_self = "figura:rub_self",
    rub_receive = "figura:rub_receive",
    rub_receive_inner = "figura:rub_receive_inner",
    slap = "figura:slap",
    struggle = "figura:struggle",
    digest_start = "figura:digest_start",
    digest_finish = "figura:digest_finish",
    gut_empty = "figura:gut_empty",
}

function events.CHAT_RECEIVE_MESSAGE(raw, text)
    for key,value in pairs(vo_events) do
        if value == raw then
            return false;
        end
    end
end