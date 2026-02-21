local options = require("rose-pine.config").options
local variants = {
	dawn = {
		_nc = "#f8f0e7",
		base = "#f7f7f7",
		surface = "#f7f7f7",
		overlay = "#e3e3e3",
		muted = "#9893a5",
		subtle = "#797593",
		text = "#242424",
		love = "#b4637a",
		gold = "#ea9d34",
		rose = "#d7827e",
		pine = "#286983",
		foam = "#56949f",
		iris = "#907aa9",
		leaf = "#6d8f89",
		highlight_low = "#f4ede8",
		highlight_med = "#dfdad9",
		highlight_high = "#cecacd",
		none = "NONE",
		diff_add = "#b8e0b8",
		diff_delete = "#f0b0b0",
		diff_change = "#e0d0a0",
		diff_text = "#d0c090",
	},
}

if options.palette ~= nil and next(options.palette) then
	-- handle variant specific overrides
	for variant_name, override_palette in pairs(options.palette) do
		if variants[variant_name] then
			variants[variant_name] = vim.tbl_extend("force", variants[variant_name], override_palette or {})
		end
	end
end

if variants[options.variant] ~= nil then
	return variants[options.variant]
end

return vim.o.background == "light" and variants.dawn or variants[options.dark_variant or "main"]
