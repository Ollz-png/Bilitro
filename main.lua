if not Bilitro then
	Bilitro = {}
end
local global = {}

local mod_path = "" .. SMODS.current_mod.path
Bilitro.path = mod_path
Bilitro_config = SMODS.current_mod.config

SMODS.current_mod.optional_features = {
    retrigger_joker = true,
	post_trigger = true,
}


--Load item files
local files = NFS.getDirectoryItems(mod_path .. "items")
for _, file in ipairs(files) do
	print("[Bilitro] Loading lua file " .. file)
	local f, err = SMODS.load_file("items/" .. file)
	if err then
		error(err) 
	end
	f()
end