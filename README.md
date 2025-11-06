# Dotfiles

Modern multi-language development environment configuration with LazyVim supporting **Node.js/TypeScript**, **Go**, and **Python**.

## What's Included

### 🚀 Neovim/LazyVim Configuration
- Modern LazyVim setup with Lua configuration
- **TypeScript/JavaScript** support with LSP (tsserver, eslint, prettier)
- **Go** support with LSP (gopls, golangci-lint, delve debugger)
- **Python** support with LSP (pyright, black, ruff, mypy)
- Auto-completion with nvim-cmp
- Syntax highlighting with Treesitter
- Fuzzy finding with Telescope
- Gruvbox color scheme
- Language-specific indentation (tabs for Go, 4 spaces for Python, 2 for JS/TS)
- Custom keybindings optimized for development

### 🐚 Shell Configuration
- `.zshrc` - Zsh configuration with modern aliases
- `.bashrc` - Bash configuration (alternative)
- Comprehensive Git aliases
- **Node.js**/npm/yarn/pnpm shortcuts (20+ aliases)
- **Go** development aliases (20+ aliases: gob, gor, got, golint, etc.)
- **Python** development aliases (30+ aliases: venv, pytest, black, ruff, etc.)
- Django and Flask shortcuts
- Docker aliases
- Useful functions (mkcd, extract, killport, gonew, venvnew, vfind, etc.)
- Support for nvm/fnm/pyenv (commented out, enable as needed)

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

### Language-Specific (install the ones you need)
- **Node.js** >= 18.0 + **npm** (for TypeScript/JavaScript development)
- **Go** >= 1.21 (for Go development)
- **Python** >= 3.11 + **pip3** (for Python development)

### Recommended Tools
- **ripgrep** - for Telescope live grep
- **fd** - for Telescope file finding
- **fzf** - fuzzy finder
- **tmux** - terminal multiplexer (optional)
- **starship** - modern shell prompt (optional)

### Version Managers (optional)
- **nvm**/**fnm**/**volta** - Node version manager
- **pyenv** - Python version manager
- **gvm** - Go version manager

### Installation Commands

#### macOS (Homebrew)
```bash
# Core tools
brew install neovim ripgrep fd fzf git

# Language runtimes (install what you need)
brew install node       # for TypeScript/JavaScript
brew install go         # for Go
brew install python@3   # for Python

# Optional
brew install starship tmux
```

#### Ubuntu/Debian
```bash
sudo apt update

# Core tools
sudo apt install neovim ripgrep fd-find fzf git

# Language runtimes (install what you need)
sudo apt install nodejs npm           # for TypeScript/JavaScript
sudo apt install golang-go            # for Go
sudo apt install python3 python3-pip  # for Python
```

#### Arch Linux
```bash
# Core tools
sudo pacman -S neovim ripgrep fd fzf git

# Language runtimes (install what you need)
sudo pacman -S nodejs npm      # for TypeScript/JavaScript
sudo pacman -S go              # for Go
sudo pacman -S python python-pip  # for Python
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

   **TypeScript/JavaScript:**
   ```bash
   npm install -g typescript typescript-language-server
   npm install -g vscode-langservers-extracted  # for eslint
   npm install -g prettier
   ```

   **Go:**
   ```bash
   go install golang.org/x/tools/gopls@latest
   go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
   go install github.com/go-delve/delve/cmd/dlv@latest
   ```

   **Python:**
   ```bash
   pip3 install --user pyright black isort ruff mypy debugpy
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

#### Go
- `gob` - go build
- `gor` - go run
- `got` - go test
- `gotv` - go test -v
- `gotc` - go test -cover
- `gom` - go mod
- `gomt` - go mod tidy
- `gof` - go fmt ./...
- `gov` - go vet ./...
- `golint` - golangci-lint run
- `golintfix` - golangci-lint run --fix
- `gocover` - run tests with coverage report
- `gorace` - run tests with race detector
- `gonew dirname` - create new Go module

#### Python
- `py` - python3
- `venv` - create virtual environment
- `vact` - activate venv
- `venvnew` - create and activate new venv
- `vfind` - find and activate venv in current/parent dirs
- `pipi` - pip3 install
- `pipr` - install from requirements.txt
- `pytest` - run pytest
- `pytestcov` - run pytest with coverage
- `black` - format with black
- `ruff` - lint with ruff
- `mypy` - type check with mypy
- `po` - poetry
- `poi` - poetry install
- `poa` - poetry add
- `dj` - python manage.py (Django)
- `djrun` - Django runserver
- `pyserve` - start Python HTTP server

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
│           │   ├── lazy.lua         # LazyVim setup with language extras
│           │   ├── options.lua      # Editor options + language-specific settings
│           │   ├── keymaps.lua      # Key bindings
│           │   └── autocmds.lua     # Auto commands
│           └── plugins/
│               ├── colorscheme.lua  # Gruvbox theme
│               ├── telescope.lua    # Fuzzy finder with ignore patterns
│               ├── treesitter.lua   # Syntax highlighting
│               ├── lsp.lua          # LSP configs (TS, Go, Python)
│               ├── ui.lua           # UI enhancements
│               └── coding.lua       # Coding plugins
├── .zshrc                   # Zsh config with all aliases
├── .bashrc                  # Bash config with all aliases
├── .gitconfig               # Git configuration
├── .gitignore_global        # Global gitignore (Node, Go, Python)
├── .editorconfig            # Cross-editor consistency
├── .golangci.yml            # Go linter config template
├── pyproject.toml           # Python project config template
├── .gitignore               # Repository gitignore
├── README.md                # This file
└── INSTALL.sh               # Automated installation script
```

## Configuration Templates

The dotfiles include language-specific configuration templates that you can copy to your projects:

### `.editorconfig`
Cross-editor configuration for consistent coding styles. Already configured for:
- JavaScript/TypeScript (2 spaces)
- Python (4 spaces)
- Go (tabs)
- And more...

Copy to your project root to maintain consistency across editors.

### `.golangci.yml`
Comprehensive Go linter configuration with 30+ linters enabled. Includes settings for:
- Code quality (gofmt, goimports, govet)
- Security (gosec)
- Complexity (gocyclo)
- Best practices (revive, staticcheck)

Copy to your Go project root and customize as needed.

### `pyproject.toml`
Modern Python project configuration template with settings for:
- Black (formatter)
- isort (import sorter)
- Ruff (fast linter)
- Mypy (type checker)
- Pytest (testing framework)
- Coverage reporting

Copy to your Python project root and update project metadata.

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
