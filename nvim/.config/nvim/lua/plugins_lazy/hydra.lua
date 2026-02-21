return {
  {
    'nvimtools/hydra.nvim',
    dependencies = {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      local hydra = require 'hydra'
      local dap = require 'dap'

      local dap_hydra = hydra {
        config = {
          color = 'pink',
          invoke_on_body = true,
          on_enter = function() require('dap-view').open() end,
          on_exit = function() require('dap-view').close() end,
        },
        name = 'dap',
        mode = { 'n', 'x' },
        body = '<leader>d',
        heads = {
          { 'n', dap.step_over,                                                           { silent = true } },
          { 'i', dap.step_into,                                                           { silent = true } },
          { 'o', dap.step_out,                                                            { silent = true } },
          { 'c', dap.run_to_cursor,                                                       { silent = true } },
          { 's', dap.continue,                                                            { silent = true } },
          { 'x', dap.terminate,                                                           { silent = true } },
          { 'R', function() dap.session():request 'hotRestart' end,                       { silent = true } },
          { 'r', function() dap.session():request 'hotReload' end,                        { silent = true } },
          { 'b', dap.toggle_breakpoint,                                                   { silent = true } },
          { 'w', function() require('dap-view').add_expr() end,                           { silent = true } },
          { '.', function() require('dap-view').navigate { count = 1, wrap = true } end,  { silent = true } },
          { ',', function() require('dap-view').navigate { count = -1, wrap = true } end, { silent = true } },
          { 'q', function() end,                                                          { exit = true, nowait = true } },
          { 'd', require('util.flutter_util').select_flutter_device,                      { silent = false } },
        },
      }


      hydra.spawn = function(head)
        if head == 'dap-hydra' then dap_hydra:activate() end
      end

      vim.keymap.set('n', '<leader>d', "<cmd>lua require('hydra').spawn('dap-hydra')<cr>")
    end,
  },
}
