-- Honestly, im using these to also teach myself how to set shit

function everythingRedSteelKing()
	for _, card in ipairs(G.playing_cards) do
		card.base.value = "King"
		card.base.face_nominal = 0.4
		card.base.suit_nominal_original = 0.04
		card.nominal = 10
		card:set_seal('Red')
		card.config.card.value = "King"
		card:set_ability("m_steel")
	end
end