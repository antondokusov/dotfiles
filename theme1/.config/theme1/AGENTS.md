# Agent Guidelines for rose-pine/neovim

## Build/Lint/Test Commands
- No build step required (Lua plugin)
- No automated tests present
- Manual testing: Install plugin and run `:colorscheme rose-pine` in Neovim

## Code Style

### Language & Format
- Pure Lua (no external dependencies)
- Tab indentation
- Single file implementation (lua/rose-pine.lua)

### Structure
- Simple module pattern: `local M = {}` with `return M`
- Single `setup()` function that sets all highlights
- Direct color definitions (no palette system)

### Colors
- Minimalistic: white background, near-black text
- Essential colors only: error (red), warning (orange), info (blue)
- Diff colors: green (add), red (delete), beige (change)
- UI colors: gray for secondary elements, yellow for search

### Naming
- Use clear, direct variable names
- Keep color definitions at the top of setup()
