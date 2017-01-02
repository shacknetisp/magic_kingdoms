local huds = {}
local timer = 0

minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer < 0.1 then return end
    timer = 0
    
    for _, player in pairs(minetest.get_connected_players()) do
        local name = player:get_player_name()
        local pos = vector.round(player:getpos())
        local pkingdom = kingdoms.player.kingdom(name)
        local akingdom = kingdoms.bypos(pos)
        kingdoms.spm(false)
        local infostrings = {
            akingdom and ("This area is owned by %s"):format(akingdom.longname) or "This area is neutral.",
            pkingdom and ("You are a member of %s"):format(pkingdom.longname) or "You are neutral with "..kingdoms.utils.s("invite", #kingdoms.db.invites[name])..".",
            kingdoms.is_protected(pos, name) and "You cannot dig here." or "You can dig here.",
        }
        kingdoms.spm(true)
        local infostring = table.concat(infostrings, "\n")
        local hud = huds[name]
        if not hud then
            hud = {}
            huds[name] = hud
            hud.id = player:hud_add({
                hud_elem_type = "text",
                name = "Kingdoms",
                number = 0xFFFFFF,
                position = {x=0, y=1},
                offset = {x=8, y=-8},
                text = infostring,
                scale = {x=200, y=60},
                alignment = {x=1, y=-1},
            })
            hud.oldinfo = infostring
            return
        elseif hud.oldinfo ~= infostring then
            player:hud_change(hud.id, "text", infostring)
            hud.oldinfo = infostring
        end
    end
end)