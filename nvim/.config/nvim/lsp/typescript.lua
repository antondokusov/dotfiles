return {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_dir = vim.fs.dirname(vim.fs.find({ 'tsconfig.json', 'package.json' }, { upward = true })[1]),
}
