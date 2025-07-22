

SMODS.Sound:register_global()

--[[

    ░█████   ░██████   ░██     ░██ ░██████████ ░█████████    ░██████   
      ░██   ░██   ░██  ░██    ░██  ░██         ░██     ░██  ░██   ░██  
      ░██  ░██     ░██ ░██   ░██   ░██         ░██     ░██ ░██         
      ░██  ░██     ░██ ░███████    ░█████████  ░█████████   ░████████  
░██   ░██  ░██     ░██ ░██   ░██   ░██         ░██   ░██           ░██ 
░██   ░██   ░██   ░██  ░██    ░██  ░██         ░██    ░██   ░██   ░██  
 ░██████     ░██████   ░██     ░██ ░██████████ ░██     ░██   ░██████   
                                                                       
 This Lua file controls all the jokers in the Bilitro mod!

POSSIBLE MODIFIERS (for chips/mult):

-- ADDERS
mult_mod   : Adds to multiplier
chips_mod  : Adds to chips count

-- MULTIPLIERS
xmult_mod  : Multiplies current multiplier by value
x_chips    : Multiplies current chips count by value

CALCULATE OUTCOMES:

if context.cardarea == G.play and context.individual then
    --This triggers when a playing card is scored!
end

if context.joker_main then
    --This triggers when we are scoring the jokers!
end


]]--


--Joker: J

-- Register a new atlas (sprite sheet) for Joker card art
-- This is where the game finds the image for your custom joker
SMODS.Atlas{
    key = 'J',           -- Unique key name for this atlas
    path = 'J.png',      -- Path to the image file
    px = 71,             -- Width of one card in the atlas
    py = 95              -- Height of one card in the atlas
}

-- Define a new Joker card with the key 'J'
SMODS.Joker{
    key = 'J',
    rarity = 1,

    -- How much this joker costs to buy in the shop
    cost = 5,

    -- Localised display text shown in-game
    loc_txt = {
        name = 'J',
        text = {
            -- Text shown on the card (with colouring)
            'When {C:attention}Blind{} Selected,',
            'create a {C:attention}Joker{}.'
        }
    },

    -- Link this joker to the atlas defined above
    atlas = 'J',
    pos = {x = 0, y = 0}, -- Which sprite in the atlas to use (top-left corner)

    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    -- Main behaviour: what happens when certain game events occur
    calculate = function(self, card, context)
        -- Check if the player has just selected a Blind
        if context.setting_blind then
            -- Count how many Jokers are currently in the player's hand
            local current = #G.jokers.cards

            -- Maximum number of Jokers allowed (usually 5)
            local limit = G.jokers.config.card_limit or 5

            -- Only create a new Joker if there's room for it
            if current < limit then
                local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_joker')
                new_card:add_to_deck()       -- Add it to the player's deck
                G.jokers:emplace(new_card)   -- Place it in the Joker bar
                -- Roll a random number from 1 to 10
                local roll = math.random(1, 10)

                if roll == 1 then
                    -- 1 in 10 chance to play PHONK TO FALL ASLEEP TO
                    play_sound('bill_phonk', 1, 1)
                else
                    -- Otherwise play the normal fart sound
                    play_sound('bill_fart', 1, 1)
                end

                return {
                    message = "+1 Joker",
                }
            else
                -- Optional: add an effect or message when the joker limit is reached
                -- e.g., G.EManager:add(EventText("Joker limit reached!"))
                play_sound('bill_nope', 1, 1)
                return {
                    message = "No room!",
                }
            end
        end
    end
}

--Joker: Energy Ball

SMODS.Atlas{
    key = "EnergyBall",
    path = "EnergyBall.png",
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = "EnergyBall",
    rarity = 3,
    cost = 5,
    loc_txt = {
        name = "Energy Ball",
        text = {
            '"Sources the power of playing cards."',
            "When {C:attention}Playing Card{} scored,",
            "Gains {X:mult,C:white}+0.25{} Mult.",
            "{C:inactive}(Currently {X:mult,C:white}+#1#{} {C:inactive}Mult){}"
        }
    },
    atlas = "EnergyBall",
    pos = {x = 0, y = 0},

    config = { extra = {
        PMult = 0
    }
    },

    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.PMult}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual then
            card.ability.extra.PMult = (card.ability.extra.PMult) + 0.25
            return {
                extra = { focus = card, message = "Boosted!" },
                card = card,
                colour = G.C.MULT,
            }
        end

    -- Apply the multiplier in final joker scoring stage
        if context.joker_main then
          return {
            card = card,
            mult_mod = card.ability.extra.PMult,
            message = "+" .. card.ability.extra.PMult,
            colour = G.C.MULT,
          }
        end
    end
}