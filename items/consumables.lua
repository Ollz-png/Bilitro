

SMODS.Sound:register_global()

SMODS.Atlas{
    key = 'UnknownFood',           -- Unique key name for this atlas
    path = 'UnknownFood.png',      -- Path to the image file
    px = 71,             -- Width of one card in the atlas
    py = 95              -- Height of one card in the atlas
}

SMODS.Atlas{
    key = 'Banana',           -- Unique key name for this atlas
    path = 'Banana.png',      -- Path to the image file
    px = 71,             -- Width of one card in the atlas
    py = 95              -- Height of one card in the atlas
}

SMODS.ConsumableType{
    key = 'FoodConsumableType',
    collection_rows = {4,5},
    primary_colour = G.C.RED,
    secondary_colour = G.C.GOLD,

    loc_txt = {
        collection = 'Food',
        name = 'Food',
        undiscovered = {
            name = 'Food',
            text = {'Who knows what this is?', 'It\'s probably food.'}
        },
    },
    shop_rate = 10
}

SMODS.UndiscoveredSprite{
    key = 'FoodConsumableType',
    atlas = 'UnknownFood',
    pos = {x = 0, y = 0},
}


SMODS.Consumable{
    key = 'Banana',
    set = 'FoodConsumableType',
    atlas = 'Banana',
    pos = {x = 0, y = 0},
    loc_txt = {
        name = 'Banana',
        text = {'KRIS GET THE BANANA', '{C:attention}+1{} hand size'},
    },

    can_use = function(self, card)
        if G and G.hand then
            return true
        end
        return false
    end,

    use = function(self, card, area, copier)
        if G and G.hand then
            -- Increase the hand size by 1
            G.hand:change_size(1)

            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                attention_text({
                    text = "potassium",
                    scale = 1.3, 
                    hold = 1.4,
                    major = used_tarot,
                    backdrop_colour = G.C.SECONDARY_SET.Tarot,
                    align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                    offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                    silent = true
                    })
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function() return true end}))
                    play_sound('bill_krisgetthebanana', 1, 0.4)
            return true end }))
        end
    end,
}