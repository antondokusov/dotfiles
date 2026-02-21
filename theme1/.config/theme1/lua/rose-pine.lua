local M = {}
local config = require("rose-pine.config")

local function set_highlights()
	local utilities = require("rose-pine.utilities")
	local palette = require("rose-pine.palette")
	local styles = config.options.styles

	local groups = {}
	for group, color in pairs(config.options.groups) do
		groups[group] = utilities.parse_color(color)
	end

	local function make_border(fg)
		fg = fg or groups.border
		return {
			fg = fg,
			bg = (config.options.extend_background_behind_borders and not styles.transparency) and palette.surface
				or "NONE",
		}
	end

	local highlights = {}
	local default_highlights = {
		ColorColumn = { bg = palette.surface },
		Conceal = { bg = "NONE" },
		CurSearch = { fg = palette.base, bg = palette.gold },
		Cursor = { fg = palette.base, bg = palette.text },
		CursorColumn = { bg = palette.overlay },

		CursorLine = { bg = palette.overlay },
		CursorLineNr = { fg = palette.text, bold = styles.bold },

		DiffAdd = { fg = palette.text, bg = groups.git_add, blend = 20 },
		DiffChange = { fg = palette.text, bg = groups.git_change, blend = 20 },
		DiffDelete = { fg = palette.text, bg = groups.git_delete, blend = 20 },
		DiffText = { fg = palette.text, bg = groups.git_text, blend = 40 },
		diffAdded = { link = "DiffAdd" },
		diffChanged = { link = "DiffChange" },
		diffRemoved = { link = "DiffDelete" },
		Directory = { fg = palette.foam, bold = styles.bold },

		ErrorMsg = { fg = groups.error, bold = styles.bold },
		FloatBorder = make_border(),
		FloatTitle = { fg = palette.foam, bg = groups.panel, bold = styles.bold },
		FoldColumn = { fg = palette.muted },
		Folded = { fg = palette.text, bg = groups.panel },
		IncSearch = { link = "CurSearch" },
		LineNr = { fg = palette.muted },
		MatchParen = { fg = palette.pine, bg = palette.pine, blend = 25 },
		ModeMsg = { fg = palette.subtle },
		MoreMsg = { fg = palette.iris },
		NonText = { fg = palette.muted },
		Normal = { fg = palette.text, bg = palette.base },
		NormalFloat = { bg = groups.panel },
		NormalNC = { fg = palette.text, bg = config.options.dim_inactive_windows and palette._nc or palette.base },
		NvimInternalError = { link = "ErrorMsg" },
		Pmenu = { fg = palette.subtle, bg = groups.panel },
		PmenuExtra = { fg = palette.muted, bg = groups.panel },
		PmenuExtraSel = { fg = palette.subtle, bg = palette.overlay },
		PmenuKind = { fg = palette.foam, bg = groups.panel },
		PmenuKindSel = { fg = palette.subtle, bg = palette.overlay },
		PmenuSbar = { bg = groups.panel },
		PmenuSel = { fg = palette.text, bg = palette.overlay },
		PmenuThumb = { bg = palette.muted },
		Question = { fg = palette.gold },

		RedrawDebugClear = { fg = palette.base, bg = palette.gold },
		RedrawDebugComposed = { fg = palette.base, bg = palette.pine },
		RedrawDebugRecompose = { fg = palette.base, bg = palette.love },
		Search = { fg = palette.text, bg = palette.gold, blend = 20 },
		SignColumn = { fg = palette.text, bg = "NONE" },
		SpecialKey = { fg = palette.foam },
		SpellBad = { sp = palette.subtle, undercurl = true },
		SpellCap = { sp = palette.subtle, undercurl = true },
		SpellLocal = { sp = palette.subtle, undercurl = true },
		SpellRare = { sp = palette.subtle, undercurl = true },
		StatusLine = { fg = palette.subtle, bg = groups.panel },
		StatusLineNC = { fg = palette.muted, bg = groups.panel, blend = 60 },
		StatusLineTerm = { fg = palette.base, bg = palette.pine },
		StatusLineTermNC = { fg = palette.base, bg = palette.pine, blend = 60 },
		Substitute = { link = "IncSearch" },
		TabLine = { fg = palette.subtle, bg = groups.panel },
		TabLineFill = { bg = groups.panel },
		TabLineSel = { fg = palette.text, bg = palette.overlay, bold = styles.bold },
		Title = { fg = palette.foam, bold = styles.bold },
		VertSplit = { fg = groups.border },
		Visual = { bg = palette.iris, blend = 15 },

		WarningMsg = { fg = groups.warn, bold = styles.bold },

		WildMenu = { link = "IncSearch" },
		WinBar = { fg = palette.subtle, bg = groups.panel },
		WinBarNC = { fg = palette.muted, bg = groups.panel, blend = 60 },
		WinSeparator = { fg = groups.border },

		DiagnosticError = { fg = groups.error },
		DiagnosticHint = { fg = groups.hint },
		DiagnosticInfo = { fg = groups.info },
		DiagnosticOk = { fg = groups.ok },
		DiagnosticWarn = { fg = groups.warn },
		DiagnosticDefaultError = { link = "DiagnosticError" },
		DiagnosticDefaultHint = { link = "DiagnosticHint" },
		DiagnosticDefaultInfo = { link = "DiagnosticInfo" },
		DiagnosticDefaultOk = { link = "DiagnosticOk" },
		DiagnosticDefaultWarn = { link = "DiagnosticWarn" },
		DiagnosticFloatingError = { link = "DiagnosticError" },
		DiagnosticFloatingHint = { link = "DiagnosticHint" },
		DiagnosticFloatingInfo = { link = "DiagnosticInfo" },
		DiagnosticFloatingOk = { link = "DiagnosticOk" },
		DiagnosticFloatingWarn = { link = "DiagnosticWarn" },
		DiagnosticSignError = { link = "DiagnosticError" },
		DiagnosticSignHint = { link = "DiagnosticHint" },
		DiagnosticSignInfo = { link = "DiagnosticInfo" },
		DiagnosticSignOk = { link = "DiagnosticOk" },
		DiagnosticSignWarn = { link = "DiagnosticWarn" },
		DiagnosticUnderlineError = { sp = groups.error, undercurl = true },
		DiagnosticUnderlineHint = { sp = groups.hint, undercurl = true },
		DiagnosticUnderlineInfo = { sp = groups.info, undercurl = true },
		DiagnosticUnderlineOk = { sp = groups.ok, undercurl = true },
		DiagnosticUnderlineWarn = { sp = groups.warn, undercurl = true },
		DiagnosticVirtualTextError = { fg = groups.error, bg = groups.error, blend = 10 },
		DiagnosticVirtualTextHint = { fg = groups.hint, bg = groups.hint, blend = 10 },
		DiagnosticVirtualTextInfo = { fg = groups.info, bg = groups.info, blend = 10 },
		DiagnosticVirtualTextOk = { fg = groups.ok, bg = groups.ok, blend = 10 },
		DiagnosticVirtualTextWarn = { fg = groups.warn, bg = groups.warn, blend = 10 },

		Boolean = {},
		Character = {},
		Comment = {},
		Conditional = {},
		Constant = {},
		Debug = {},
		Define = {},
		Delimiter = {},
		Error = {},
		Exception = {},
		Float = {},
		Function = {},
		Identifier = {},
		Include = {},
		Keyword = {},
		Label = {},
		LspCodeLens = {},
		LspCodeLensSeparator = {},
		LspInlayHint = {},
		LspReferenceRead = { fg = palette.text, bg = palette.gold, blend = 20 },
		LspReferenceText = { fg = palette.text, bg = palette.gold, blend = 20 },
		LspReferenceWrite = { fg = palette.text, bg = palette.gold, blend = 20 },
		Macro = {},
		Number = {},
		Operator = {},
		PreCondit = {},
		PreProc = {},
		Repeat = {},
		Special = {},
		SpecialChar = {},
		SpecialComment = {},
		Statement = {},
		StorageClass = {},
		String = {},
		Structure = {},
		Tag = {},
		Todo = {},
		Type = {},
		TypeDef = {},
		Underlined = {},

		healthError = { fg = groups.error },
		healthSuccess = { fg = groups.info },
		healthWarning = { fg = groups.warn },

		["@diff.plus"] = { fg = palette.text, bg = groups.git_add, blend = 20 },
		["@diff.minus"] = { fg = palette.text, bg = groups.git_delete, blend = 20 },
		["@diff.delta"] = { fg = palette.text, bg = groups.git_change, blend = 20 },
		--- Plugins
		-- lewis6991/gitsigns.nvim
		GitSignsAdd = { fg = groups.git_add, bg = "NONE" },
		GitSignsChange = { fg = groups.git_change, bg = "NONE" },
		GitSignsDelete = { fg = groups.git_delete, bg = "NONE" },
		SignAdd = { fg = groups.git_add, bg = "NONE" },
		SignChange = { fg = groups.git_change, bg = "NONE" },
		SignDelete = { fg = groups.git_delete, bg = "NONE" },

		-- rcarriga/nvim-dap-ui
		DapUIBreakpointsCurrentLine = { fg = palette.gold, bold = styles.bold },
		DapUIBreakpointsDisabledLine = { fg = palette.muted },
		DapUIBreakpointsInfo = { link = "DapUIThread" },
		DapUIBreakpointsLine = { link = "DapUIBreakpointsPath" },
		DapUIBreakpointsPath = { fg = palette.foam },
		DapUIDecoration = { link = "DapUIBreakpointsPath" },
		DapUIFloatBorder = make_border(),
		DapUIFrameName = { fg = palette.text },
		DapUILineNumber = { link = "DapUIBreakpointsPath" },
		DapUIModifiedValue = { fg = palette.foam, bold = styles.bold },
		DapUIScope = { link = "DapUIBreakpointsPath" },
		DapUISource = { fg = palette.iris },
		DapUIStoppedThread = { link = "DapUIBreakpointsPath" },
		DapUIThread = { fg = palette.gold },
		DapUIValue = { fg = palette.text },
		DapUIVariable = { fg = palette.text },
		DapUIWatchesEmpty = { fg = palette.love },
		DapUIWatchesError = { link = "DapUIWatchesEmpty" },
		DapUIWatchesValue = { link = "DapUIThread" },

		-- github/copilot.vim
		CopilotSuggestion = { fg = palette.muted },

		-- sidekick.nvim
		SidekickSign = { fg = palette.muted },
		SidekickDiffContext = { bg = palette.surface },
		SidekickDiffDelete = { fg = palette.text, bg = groups.git_delete, blend = 20 },
		SidekickDiffAdd = { fg = palette.text, bg = groups.git_add, blend = 20 },
	}
	local transparency_highlights = {
		DiagnosticVirtualTextError = { fg = groups.error },
		DiagnosticVirtualTextHint = { fg = groups.hint },
		DiagnosticVirtualTextInfo = { fg = groups.info },
		DiagnosticVirtualTextOk = { fg = groups.ok },
		DiagnosticVirtualTextWarn = { fg = groups.warn },

		FloatBorder = { fg = palette.muted, bg = "NONE" },
		FloatTitle = { fg = palette.foam, bg = "NONE", bold = styles.bold },
		Folded = { fg = palette.text, bg = "NONE" },
		NormalFloat = { bg = "NONE" },
		Normal = { fg = palette.text, bg = "NONE" },
		NormalNC = { fg = palette.text, bg = config.options.dim_inactive_windows and palette._nc or "NONE" },
		Pmenu = { fg = palette.subtle, bg = "NONE" },
		PmenuKind = { fg = palette.foam, bg = "NONE" },
		SignColumn = { fg = palette.text, bg = "NONE" },
		StatusLine = { fg = palette.subtle, bg = "NONE" },
		StatusLineNC = { fg = palette.muted, bg = "NONE" },
		TabLine = { bg = "NONE", fg = palette.subtle },
		TabLineFill = { bg = "NONE" },
		TabLineSel = { fg = palette.text, bg = "NONE", bold = styles.bold },

		["@markup.raw.markdown_inline"] = { fg = palette.gold },
	}

	for group, highlight in pairs(default_highlights) do
		highlights[group] = highlight
	end
	if styles.transparency then
		for group, highlight in pairs(transparency_highlights) do
			highlights[group] = highlight
		end
	end

	-- Reconcile highlights with config
	if config.options.highlight_groups ~= nil and next(config.options.highlight_groups) ~= nil then
		for group, highlight in pairs(config.options.highlight_groups) do
			local existing = highlights[group] or {}
			-- Traverse link due to
			-- "If link is used in combination with other attributes; only the link will take effect"
			-- see: https://neovim.io/doc/user/api.html#nvim_set_hl()
			while existing.link ~= nil do
				existing = highlights[existing.link] or {}
			end
			local parsed = vim.tbl_extend("force", {}, highlight)

			if highlight.fg ~= nil then
				parsed.fg = utilities.parse_color(highlight.fg) or highlight.fg
			end
			if highlight.bg ~= nil then
				parsed.bg = utilities.parse_color(highlight.bg) or highlight.bg
			end
			if highlight.sp ~= nil then
				parsed.sp = utilities.parse_color(highlight.sp) or highlight.sp
			end

			if (highlight.inherit == nil or highlight.inherit) and existing ~= nil then
				parsed.inherit = nil
				highlights[group] = vim.tbl_extend("force", existing, parsed)
			else
				parsed.inherit = nil
				highlights[group] = parsed
			end
		end
	end

	for group, highlight in pairs(highlights) do
		if config.options.before_highlight ~= nil then
			config.options.before_highlight(group, highlight, palette)
		end

		if highlight.blend ~= nil and (highlight.blend >= 0 and highlight.blend <= 100) and highlight.bg ~= nil then
			highlight.bg = utilities.blend(highlight.bg, highlight.blend_on or palette.base, highlight.blend / 100)
		end

		highlight.blend = nil
		highlight.blend_on = nil

		vim.api.nvim_set_hl(0, group, highlight)
	end

	--- Terminal
	if config.options.enable.terminal then
		vim.g.terminal_color_0 = palette.overlay -- black
		vim.g.terminal_color_8 = palette.subtle -- bright black
		vim.g.terminal_color_1 = palette.love -- red
		vim.g.terminal_color_9 = palette.love -- bright red
		vim.g.terminal_color_2 = palette.pine -- green
		vim.g.terminal_color_10 = palette.pine -- bright green
		vim.g.terminal_color_3 = palette.gold -- yellow
		vim.g.terminal_color_11 = palette.gold -- bright yellow
		vim.g.terminal_color_4 = palette.foam -- blue
		vim.g.terminal_color_12 = palette.foam -- bright blue
		vim.g.terminal_color_5 = palette.iris -- magenta
		vim.g.terminal_color_13 = palette.iris -- bright magenta
		vim.g.terminal_color_6 = palette.rose -- cyan
		vim.g.terminal_color_14 = palette.rose -- bright cyan
		vim.g.terminal_color_7 = palette.text -- white
		vim.g.terminal_color_15 = palette.text -- bright white

		-- Support StatusLineTerm & StatusLineTermNC from vim
		vim.cmd([[
		augroup rose-pine
			autocmd!
			autocmd TermOpen * if &buftype=='terminal'
				\|setlocal winhighlight=StatusLine:StatusLineTerm,StatusLineNC:StatusLineTermNC
				\|else|setlocal winhighlight=|endif
			autocmd ColorSchemePre * autocmd! rose-pine
		augroup END
		]])
	end
end

---@param options Options
function M.setup(options)
	config.extend_options(options or {})

	vim.opt.termguicolors = true
	if vim.g.colors_name then
		vim.cmd("hi clear")
		vim.cmd("syntax reset")
	end
	vim.g.colors_name = "rose-pine"

	set_highlights()
end

return M
