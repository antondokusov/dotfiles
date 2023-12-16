return {
	{

		'L3MON4D3/LuaSnip',
		config = function()
			local luasnip = require 'luasnip'
			luasnip.add_snippets('dart', {
				luasnip.parser.parse_snippet(
					'fre',
					[[
  import 'package:freezed_annotation/freezed_annotation.dart';

  part '${TM_FILENAME_BASE}.freezed.dart';
  part '${TM_FILENAME_BASE}.g.dart';

  @freezed
  class $1 with _\$$1 {
    const factory $1($2) = _$0;

    factory $1.fromJson(Map<String, dynamic> json) =>
        _\$$1FromJson(json);
  }
  ]]
				),
				luasnip.parser.parse_snippet(
					'bl',
					[[
  class $1Bloc extends Cubit<$1State> {
    $1() : super($0);
  }
  ]]
				),
				luasnip.parser.parse_snippet(
					'gg',
					[[
  getIt.get<$0>(),
  ]]
				),
				luasnip.parser.parse_snippet(
					'ana',
					[[
  import 'package:gameram/utils/analytics/analytics_event.dart';

  class $1 extends AnalyticsEvent with FirebaseEvent, AmplitudeEvent {
    $1()
        : super(
            name: '$0',
          );
  }
  ]]
				),
			})
		end,
	},

	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-nvim-lsp-signature-help',
			'hrsh7th/cmp-nvim-lsp-document-symbol',
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
		},
		config = function()
			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
			end

			local cmp = require 'cmp'
			local luasnip = require 'luasnip'

			cmp.setup {
				snippet = {
					expand = function(args) require('luasnip').lsp_expand(args.body) end,
				},

				mapping = cmp.mapping.preset.insert {
					['<C-k>'] = cmp.mapping.select_prev_item(),
					['<C-j>'] = cmp.mapping.select_next_item(),
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete {},
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm { select = true },

					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { 'i', 's' }),

					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				},

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				sources = cmp.config.sources {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'buffer' },
					{ name = 'nvim_lsp_signature_help' },
				},
			}

			require('cmp').setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'cmdline' },
				},
			})

			require('cmp').setup.cmdline('/', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'nvim_lsp_document_symbol' },
					{ name = 'buffer' },
				},
			})
		end,
	},
}
