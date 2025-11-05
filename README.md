# Dotfiles

Modern development environment configuration for Node.js/JavaScript/TypeScript stack with LazyVim.

## What's Included

### 🚀 Neovim/LazyVim Configuration
- Modern LazyVim setup with Lua configuration
- Full TypeScript/JavaScript support with LSP (tsserver, eslint)
- Auto-completion with nvim-cmp
- Syntax highlighting with Treesitter
- Code formatting with Prettier
- Fuzzy finding with Telescope
- Gruvbox color scheme
- Custom keybindings optimized for development

### 🐚 Shell Configuration
- `.zshrc` - Zsh configuration with modern aliases
- `.bashrc` - Bash configuration (alternative)
- Comprehensive Git aliases
- Node.js/npm/yarn/pnpm shortcuts
- Docker aliases
- Useful functions (mkcd, extract, killport, etc.)
- Support for nvm/fnm (commented out, enable as needed)

### 🔧 Git Configuration
- `.gitconfig` - Extensive Git aliases and settings
- `.gitignore_global` - Global gitignore for common files
- Conventional commit aliases (feat, fix, docs, etc.)
- Better diff and merge tools (vimdiff/nvimdiff)
- Useful shortcuts for daily Git operations

## Prerequisites

### Required
- **Neovim** >= 0.9.0 (for LazyVim)
- **Git** >= 2.30
- **Node.js** >= 18.0 (for LSP servers)
- **npm** or **yarn** (for installing language servers)

### Recommended
- **ripgrep** - for Telescope live grep
- **fd** - for Telescope file finding
- **fzf** - fuzzy finder
- **tmux** - terminal multiplexer (optional)
- **starship** - modern shell prompt (optional)
- **nvm**/**fnm**/**volta** - Node version manager (choose one)

### Installation Commands

#### macOS (Homebrew)
```bash
brew install neovim ripgrep fd fzf git node
brew install starship  # optional
brew install tmux      # optional
```

#### Ubuntu/Debian
```bash
sudo apt update
sudo apt install neovim ripgrep fd-find fzf git nodejs npm
```

#### Arch Linux
```bash
sudo pacman -S neovim ripgrep fd fzf git nodejs npm
```

## Installation

### Automated Installation

Run the installation script:

```bash
cd ~/dotfiles
chmod +x INSTALL.sh
./INSTALL.sh
```

The script will:
1. Backup existing configurations
2. Create symlinks to dotfiles
3. Install LazyVim plugins
4. Set up Neovim with all required language servers

### Manual Installation

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. **Create symlinks:**
   ```bash
   # Neovim
   ln -sf ~/dotfiles/.config/nvim ~/.config/nvim

   # Shell (choose one)
   ln -sf ~/dotfiles/.zshrc ~/.zshrc
   # or
   ln -sf ~/dotfiles/.bashrc ~/.bashrc

   # Git
   ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
   ln -sf ~/dotfiles/.gitignore_global ~/.gitignore_global
   ```

3. **Update Git configuration:**
   Edit `~/.gitconfig` and set your name and email:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

4. **Install Neovim plugins:**
   ```bash
   nvim
   # LazyVim will automatically install plugins on first launch
   # Wait for all plugins to install, then restart nvim
   ```

5. **Install language servers:**
   LazyVim will prompt you to install missing language servers.
   Alternatively, install manually:
   ```bash
   npm install -g typescript typescript-language-server
   npm install -g vscode-langservers-extracted  # for eslint
   npm install -g prettier
   ```

## Usage

### Neovim Keybindings

#### General
- `<Space>` - Leader key
- `,` - Local leader key
- `<Esc>` - Clear search highlighting
- `<C-s>` - Save file
- `<leader>q` - Quit
- `<leader>Q` - Quit all without saving

#### Navigation
- `<C-h/j/k/l>` - Move between windows
- `<S-h/l>` - Previous/next buffer
- `<leader>bd` - Close buffer

#### Telescope (Fuzzy Finder)
- `<C-p>` or `<leader>ff` - Find files
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Browse buffers
- `<leader>fh` - Help tags
- `<leader>fr` - Recent files

#### LSP
- `gd` - Go to definition
- `gr` - Find references
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol

#### Editing
- `<A-j/k>` - Move lines up/down
- `</>>` - Indent/unindent (visual mode)
- `gsa` - Add surrounding
- `gsd` - Delete surrounding
- `gcc` - Toggle comment line
- `gc` - Toggle comment (visual mode)

### Shell Aliases

#### Navigation
- `..`, `...`, `....` - Go up directories
- `~` - Go to home
- `-` - Go to previous directory

#### Git Shortcuts
- `gs` - git status
- `ga` - git add
- `gcm "message"` - git commit with message
- `gp` - git push
- `gl` - git log (pretty)
- `gco branch` - checkout branch
- `gcb branch` - create and checkout branch

#### Node/NPM
- `ni` - npm install
- `nr` - npm run
- `ns` - npm start
- `nt` - npm test
- `nb` - npm run build
- `dev` - npm run dev

#### Yarn
- `y` - yarn
- `yi` - yarn install
- `ya` - yarn add
- `ys` - yarn start

#### Utilities
- `v` / `vi` / `vim` - opens nvim
- `mkcd dirname` - create directory and cd into it
- `killport 3000` - kill process on port 3000
- `extract file.tar.gz` - extract any archive

## Customization

### Neovim

Add custom plugins in `~/.config/nvim/lua/plugins/`. Each file should return a table:

```lua
-- ~/.config/nvim/lua/plugins/my-plugin.lua
return {
  {
    "username/plugin-name",
    opts = {
      -- plugin options
    },
  },
}
```

### Shell

Add machine-specific configurations:
- For Zsh: `~/.zshrc.local`
- For Bash: `~/.bashrc.local`

These files are sourced automatically and won't be tracked by git.

### Git

Update your name and email in `.gitconfig`:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Troubleshooting

### Neovim Issues

**Plugins not loading:**
```bash
nvim --headless "+Lazy! sync" +qa
```

**LSP not working:**
```bash
:LspInfo  # Check LSP status
:Mason    # Install/update language servers
```

**TypeScript errors:**
```bash
npm install -g typescript typescript-language-server
```

### Shell Issues

**Aliases not working:**
```bash
source ~/.zshrc  # or ~/.bashrc
```

**Command not found:**
Make sure the required tools are installed and in your PATH.

## File Structure

```
dotfiles/
├── .config/
│   └── nvim/
│       ├── init.lua
│       └── lua/
│           ├── config/
│           │   ├── lazy.lua
│           │   ├── options.lua
│           │   ├── keymaps.lua
│           │   └── autocmds.lua
│           └── plugins/
│               ├── colorscheme.lua
│               ├── telescope.lua
│               ├── treesitter.lua
│               ├── lsp.lua
│               ├── ui.lua
│               └── coding.lua
├── .zshrc
├── .bashrc
├── .gitconfig
├── .gitignore_global
├── .gitignore
├── README.md
└── INSTALL.sh
```

## Archived Files

Old Vim configurations have been moved to the `archive/` directory for reference:
- `.vimrc`
- `.gvimrc`
- `.vim/`
- Old `init.vim`

## Contributing

Feel free to fork this repository and customize it for your needs!

## License

MIT License - Feel free to use and modify as needed.

## Resources

- [LazyVim Documentation](https://www.lazyvim.org/)
- [Neovim Documentation](https://neovim.io/doc/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Starship Prompt](https://starship.rs/)
