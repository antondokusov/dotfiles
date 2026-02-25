local M = {}

local function set_highlights()
	local utilities = require("theme1.utilities")
	local p = require("theme1.palette")

	local highlights = {}

	local default_highlights = {
		-- Core
		Normal = { fg = p.text, bg = p.bg },
		NormalFloat = { bg = "NONE" },
		NormalNC = { fg = p.text, bg = p.bg },
		Cursor = { fg = p.bg, bg = p.text },
		CursorLine = { bg = p.surface },
		CursorLineNr = { fg = p.text },
		LineNr = { fg = p.muted },
		SignColumn = { bg = "NONE" },
		NonText = { fg = p.muted },

		-- Selection & search
		Visual = { bg = p.blue, blend = 15 },
		CurSearch = { fg = p.bg, bg = p.yellow },
		IncSearch = { link = "CurSearch" },
		Substitute = { link = "CurSearch" },
		Search = { bg = p.yellow, blend = 25 },
		MatchParen = { bg = p.yellow, blend = 25 },

		-- Messages
		ErrorMsg = { fg = p.red },
		WarningMsg = { fg = p.yellow },
		ModeMsg = { fg = p.subtle },
		MoreMsg = { fg = p.subtle },
		Question = { fg = p.yellow },

		-- Popup menu
		Pmenu = { fg = p.subtle, bg = p.surface },
		PmenuSel = { fg = p.text, bg = p.muted, blend = 30 },
		PmenuSbar = { bg = p.surface },
		PmenuThumb = { bg = p.muted },

		-- Floating windows
		FloatBorder = { fg = p.muted, bg = "NONE" },
		FloatTitle = { fg = p.text },

		-- Status & bars
		StatusLine = { fg = p.subtle, bg = p.surface },
		StatusLineNC = { fg = p.muted, bg = p.surface },
		WinSeparator = { fg = p.muted },
		WinBar = { fg = p.subtle },
		WinBarNC = { fg = p.muted },
		TabLine = { fg = p.muted },
		TabLineSel = { fg = p.text, bold = true },
		TabLineFill = {},

		-- Misc UI
		Folded = { fg = p.muted, bg = p.surface },
		FoldColumn = { fg = p.muted },
		ColorColumn = { bg = p.surface },
		Conceal = { bg = "NONE" },
		Title = { fg = p.text, bold = true },
		Directory = { fg = p.text, bold = true },
		SpellBad = { sp = p.red, undercurl = true },

		-- Diagnostics
		DiagnosticError = { fg = p.red },
		DiagnosticWarn = { fg = p.yellow },
		DiagnosticInfo = { fg = p.blue },
		DiagnosticHint = { fg = p.blue },
		DiagnosticOk = { fg = p.green },
		DiagnosticUnderlineError = { sp = p.red, undercurl = true },
		DiagnosticUnderlineWarn = { sp = p.yellow, undercurl = true },
		DiagnosticUnderlineInfo = { sp = p.blue, undercurl = true },
		DiagnosticUnderlineHint = { sp = p.blue, undercurl = true },
		DiagnosticUnderlineOk = { sp = p.green, undercurl = true },
		DiagnosticVirtualTextError = { fg = p.red, bg = p.red, blend = 10 },
		DiagnosticVirtualTextWarn = { fg = p.yellow, bg = p.yellow, blend = 10 },
		DiagnosticVirtualTextInfo = { fg = p.blue, bg = p.blue, blend = 10 },
		DiagnosticVirtualTextHint = { fg = p.blue, bg = p.blue, blend = 10 },
		DiagnosticVirtualTextOk = { fg = p.green, bg = p.green, blend = 10 },

		-- Diffs
		DiffAdd = { bg = p.green, blend = 15 },
		DiffDelete = { bg = p.red, blend = 15 },
		DiffChange = { bg = p.yellow, blend = 15 },
		DiffText = { bg = p.yellow, blend = 30 },
		["@diff.plus"] = { bg = p.green, blend = 15 },
		["@diff.minus"] = { bg = p.red, blend = 15 },
		["@diff.delta"] = { bg = p.yellow, blend = 15 },

		-- LSP
		LspReferenceRead = { bg = p.yellow, blend = 15 },
		LspReferenceText = { bg = p.yellow, blend = 15 },
		LspReferenceWrite = { bg = p.yellow, blend = 15 },
		LspCodeLens = {},
		LspInlayHint = {},

		-- Gitsigns
		GitSignsAdd = { fg = p.green },
		GitSignsChange = { fg = p.yellow },
		GitSignsDelete = { fg = p.red },

		-- Copilot
		CopilotSuggestion = { fg = p.muted },

		-- Sidekick
		SidekickSign = { fg = p.muted },
		SidekickDiffContext = { bg = p.surface },
		SidekickDiffAdd = { bg = p.green, blend = 15 },
		SidekickDiffDelete = { bg = p.red, blend = 15 },
	}

	for group, highlight in pairs(default_highlights) do
		highlights[group] = highlight
	end

	-- Clear all syntax groups to achieve monochrome text.
	-- nvim_set_hl(0, group, {}) marks a group as "set", preventing
	-- neovim's `highlight default` from applying built-in colors.
	local syntax_groups = {
		"Added", "Boolean", "Changed", "Character", "Comment", "Conditional",
		"Constant", "Debug", "Define", "Delimiter", "Error", "Exception",
		"Float", "Function", "Identifier", "Ignore", "Include", "Keyword",
		"Label", "Macro", "Number", "Operator", "PreCondit", "PreProc",
		"Removed", "Repeat", "Special", "SpecialChar", "SpecialComment",
		"Statement", "StorageClass", "String", "Structure", "Tag", "Todo",
		"Type", "Typedef", "Underlined",
	}
	for _, group in ipairs(syntax_groups) do
		if not highlights[group] then
			highlights[group] = {}
		end
	end

	-- Clear treesitter (@) and LSP semantic token (@lsp) groups
	for name, _ in pairs(vim.api.nvim_get_hl(0, {})) do
		if name:match("^@") and not highlights[name] then
			highlights[name] = {}
		end
	end

	for group, highlight in pairs(highlights) do
		if highlight.blend ~= nil and (highlight.blend >= 0 and highlight.blend <= 100) and highlight.bg ~= nil then
			highlight.bg = utilities.blend(highlight.bg, highlight.blend_on or p.bg, highlight.blend / 100)
		end

		highlight.blend = nil
		highlight.blend_on = nil

		vim.api.nvim_set_hl(0, group, highlight)
	end
end

function M.setup()
	vim.opt.termguicolors = true
	if vim.g.colors_name then
		vim.cmd("hi clear")
		vim.cmd("syntax reset")
	end
	vim.g.colors_name = "theme1"

	set_highlights()
end

return M
