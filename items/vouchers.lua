SMODS.Atlas{
	key = "CopyPaste",
	path = "CopyPaste.png",
	px = 71,
	py = 95,
}

SMODS.Voucher {
    key = 'CopyPaste',
    name = 'Copy/Paste',
    pos = {x = 0, y = 0}, -- Position in sprite sheet
    cost = 20, -- Pretty expensive since this is powerful
    loc_txt = {
        name = 'Copy/Paste',
        text = {
            "All {C:attention}Jokers{} trigger",
            "an additional time"
        }
    },
    atlas = 'CopyPaste',
    
    -- This runs when purchased - no immediate effect needed
    redeem = function(self, card)
        -- Show purchase effect
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = "Jokers Doubled!",
            colour = G.C.FILTER
        })
    end,
    
    -- This handles the actual retrigger effect
    calculate = function(self, card, context)
        -- Check if we're in joker calculation context
        if context.retrigger_joker_check and context.other_card and context.other_card.config.center.set == 'Joker' then
            -- Return 1 additional retrigger for all jokers
            return {
                message = localize('k_again_ex'),
                repetitions = 1,
                card = card
            }
        end
    end
}