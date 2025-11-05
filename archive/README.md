# Archive

This directory contains old Vim configurations that have been replaced by the modern LazyVim setup.

## Archived Files

- `.vimrc` - Old Vim configuration
- `.gvimrc` - Old gVim configuration
- `.vim/` - Old Vim plugin directory
- `vim-colors/` - Large collection of vim color schemes

These files are kept for reference but are no longer actively used.

## Why Archived?

The dotfiles have been modernized to use:
- **LazyVim** instead of vim-plug
- **Lua configuration** instead of VimScript
- **Native LSP** instead of ALE + deoplete
- **Modern plugins** optimized for Neovim

If you need to reference the old configuration, you can find it here.

## Migration Notes

### Old Setup
- Plugin manager: vim-plug
- Completion: deoplete + Tsuquyomi
- Linting: ALE with tsserver + tslint (deprecated)
- Formatting: Prettier via vim-prettier

### New Setup
- Plugin manager: lazy.nvim (LazyVim)
- Completion: nvim-cmp with native LSP
- Linting: ESLint via native LSP
- Formatting: conform.nvim with Prettier
- Syntax: Treesitter (much faster than regex-based)

### Key Improvements
1. **Performance**: Native LSP is much faster than ALE
2. **Modern**: Using maintained tools (no tslint)
3. **Better completion**: nvim-cmp is more powerful
4. **Treesitter**: Better syntax highlighting and text objects
5. **LazyVim extras**: Pre-configured TypeScript/JavaScript support
