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

### 🖥️ Tmux Configuration
- `.tmux.conf` - Professional tmux setup with vi-mode bindings
- **Seamless Neovim integration** - unified navigation between vim splits and tmux panes
- **Smart prefix key** (Ctrl+a instead of Ctrl+b)
- **Intuitive pane splitting** (| for vertical, - for horizontal)
- **Mouse support** for pane resizing and selection
- **Development layouts** - pre-configured for coding, testing, and debugging
- **Session management** functions (tm, tmuxdev, tmuxtest, tmuxproject)
- **Plugin support** via TPM (resurrect, continuum, yank, vim-tmux-navigator)
- **Vi-mode copy** with system clipboard integration
- Beautiful status bar with session info

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
- **tmux** >= 3.0 - terminal multiplexer (highly recommended for development)
- **starship** - modern shell prompt (optional)

### Version Managers (optional)
- **nvm**/**fnm**/**volta** - Node version manager
- **pyenv** - Python version manager
- **gvm** - Go version manager

### Installation Commands

#### macOS (Homebrew)
```bash
# Core tools
brew install neovim ripgrep fd fzf git tmux

# Language runtimes (install what you need)
brew install node       # for TypeScript/JavaScript
brew install go         # for Go
brew install python@3   # for Python

# Optional
brew install starship
```

#### Ubuntu/Debian
```bash
sudo apt update

# Core tools
sudo apt install neovim ripgrep fd-find fzf git tmux

# Language runtimes (install what you need)
sudo apt install nodejs npm           # for TypeScript/JavaScript
sudo apt install golang-go            # for Go
sudo apt install python3 python3-pip  # for Python
```

#### Arch Linux
```bash
# Core tools
sudo pacman -S neovim ripgrep fd fzf git tmux

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

### Tmux Workflows

#### Quick Start
- `tm` - smart tmux: attach to existing session or create new one
- `tm myproject` - attach to "myproject" session or create it
- `tmuxdev myapp` - create development layout (editor 70% | terminal 30%)
- `tmuxtest myapp` - create test layout (editor 70% | tests/logs 30%)
- `tmuxproject` - create/attach session named after current directory

#### Key Bindings

**Prefix Key:** `Ctrl+a` (instead of default Ctrl+b)

**Session Management:**
- `Ctrl+a c` - create new window
- `Ctrl+a ,` - rename window
- `Ctrl+a w` - list windows
- `Ctrl+a &` - kill window

**Pane Management:**
- `Ctrl+a |` - split pane vertically
- `Ctrl+a -` - split pane horizontally
- `Ctrl+a x` - kill current pane
- `Ctrl+a z` - zoom pane (toggle fullscreen)
- `Ctrl+a S` - toggle synchronize-panes (send to all panes)

**Navigation (works seamlessly with Neovim):**
- `Ctrl+h/j/k/l` - navigate between panes/vim splits
- `Ctrl+a Ctrl+h/j/k/l` - resize pane (repeatable)
- `Alt+1..5` - switch to window 1-5

**Copy Mode (Vi-style):**
- `Ctrl+a [` - enter copy mode
- `v` - begin selection
- `y` - copy selection (to system clipboard)
- `Ctrl+a p` - paste

**Layouts:**
- `Ctrl+a D` - load development layout
- `Ctrl+a T` - load test layout

**Other:**
- `Ctrl+a r` - reload tmux config
- `Ctrl+a I` - install tmux plugins (TPM)
- `Ctrl+a U` - update tmux plugins

#### Development Workflow Example

```bash
# Start a new project session
cd ~/projects/myapp
tmuxdev myapp

# Inside tmux:
# - Left pane: nvim for editing
# - Right pane: terminal for running commands

# Navigate seamlessly between nvim and terminal with Ctrl+h/l
# Run tests in terminal while editing code

# Detach from session
Ctrl+a d

# Later, reattach
tm myapp
```

#### Tmux Aliases
- `t` - tmux
- `ta session` - attach to session
- `tad session` - attach to session (detach others)
- `ts session` - new session
- `tl` - list sessions
- `tkss session` - kill session
- `tksv` - kill tmux server
- `tmuxconf` - edit tmux config

#### Plugin Features

**vim-tmux-navigator:** Seamless navigation between tmux and nvim
**tmux-resurrect:** Save/restore tmux sessions
**tmux-continuum:** Auto-save sessions every 15 minutes
**tmux-yank:** Better clipboard integration

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

## Cross-Platform Support (macOS & Linux)

The dotfiles are designed to work seamlessly on both macOS and Linux (Debian/Ubuntu). OS-specific differences are handled automatically.

### Automatic OS Detection

The shell configs automatically detect your OS and adapt:

**macOS:**
- Uses `ls -G` for colored output (BSD ls)
- `update` alias runs `brew update && brew upgrade`
- Tmux clipboard uses `pbcopy/pbpaste`

**Linux (Debian/Ubuntu):**
- Uses `ls --color=auto` for colored output (GNU ls)
- `update` alias runs `sudo apt update && sudo apt upgrade -y`
- Tmux clipboard uses `xclip`

**Other Linux distros:**
- Fedora/RHEL: `update` uses `dnf`
- Arch: `update` uses `pacman`

### OS-Specific Local Configurations

For machine-specific customizations, use local config files:

**macOS:**
```bash
# Copy the macOS template
cp ~/dotfiles/.zshrc.local.macos.example ~/.zshrc.local
# Edit for your needs
nvim ~/.zshrc.local
```

Includes macOS-specific aliases and functions for:
- Finder (show/hide hidden files)
- Quick Look (`ql` command)
- DNS flushing
- iTerm2 integration
- Homebrew path setup

**Linux:**
```bash
# Copy the Linux template
cp ~/dotfiles/.zshrc.local.linux.example ~/.zshrc.local
# Edit for your needs
nvim ~/.zshrc.local
```

Includes Linux-specific aliases and functions for:
- Package management helpers
- System info commands
- Service management (systemctl)
- Desktop environment helpers
- Clipboard aliases (pbcopy/pbpaste equivalents)

### Known Platform Differences

| Feature | macOS | Linux |
|---------|-------|-------|
| **ls colors** | `-G` flag | `--color=auto` flag |
| **Clipboard** | pbcopy/pbpaste | xclip/xsel |
| **Package manager** | Homebrew | apt/dnf/pacman |
| **Tmux install** | `brew install tmux` | `apt install tmux` |
| **Python** | Usually `python3` | Usually `python3` |
| **Open command** | `open` (built-in) | `xdg-open` |

### Installation Script

The `INSTALL.sh` script detects your OS automatically:
- Displays detected OS at startup
- Offers OS-specific local config template
- Provides OS-appropriate installation instructions
- Handles OS-specific tool paths

### Tips for Multi-Machine Setup

If using these dotfiles on both macOS and Linux:

1. **Use .zshrc.local for OS-specific settings**
   - Keep dotfiles repo clean and cross-platform
   - Machine-specific configs in local files

2. **Install matching tools on both systems**
   - Same Neovim version (>= 0.9.0)
   - Same tmux version (>= 3.0)
   - Language runtimes as needed

3. **Tool locations might differ**
   - Use `command -v` to check: `command -v nvim`
   - PATH is set up to work on both systems

4. **Git configs are portable**
   - Username/email set per-machine
   - Everything else works everywhere

5. **Sync via Git**
   - Commit and push dotfiles from one machine
   - Pull on the other to sync changes
   - Local configs stay machine-specific

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
│               ├── tmux.lua         # Tmux integration (vim-tmux-navigator)
│               ├── ui.lua           # UI enhancements
│               └── coding.lua       # Coding plugins
├── .tmux/
│   └── layouts/
│       ├── dev.conf         # Development layout
│       └── test.conf        # Testing layout
├── .tmux.conf               # Tmux configuration
├── .zshrc                   # Zsh config with all aliases & tmux functions
├── .bashrc                  # Bash config with all aliases & tmux functions
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
