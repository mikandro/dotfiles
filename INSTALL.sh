#!/bin/bash

# Dotfiles Installation Script
# This script will backup existing configs and create symlinks to dotfiles

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Detect OS
case "$(uname -s)" in
    Darwin*)    OS_TYPE="macos" ;;
    Linux*)     OS_TYPE="linux" ;;
    *)          OS_TYPE="unknown" ;;
esac

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to backup file or directory
backup_if_exists() {
    local file=$1
    if [ -e "$file" ]; then
        print_warning "Backing up existing $file"
        mkdir -p "$BACKUP_DIR"
        mv "$file" "$BACKUP_DIR/"
        print_success "Backed up to $BACKUP_DIR/"
    fi
}

# Function to create symlink
create_symlink() {
    local source=$1
    local target=$2

    # Backup existing file/directory
    backup_if_exists "$target"

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$target")"

    # Create symlink
    ln -sf "$source" "$target"
    print_success "Created symlink: $target -> $source"
}

echo ""
echo "======================================"
echo "  Dotfiles Installation Script"
echo "======================================"
echo ""

# Display detected OS
print_info "Detected OS: $OS_TYPE"
if [ "$OS_TYPE" == "unknown" ]; then
    print_warning "Unknown OS detected. Some features may not work correctly."
fi
echo ""

# Check if we're in the dotfiles directory
if [ ! -f "$DOTFILES_DIR/INSTALL.sh" ]; then
    print_error "Please run this script from the dotfiles directory"
    exit 1
fi

# Function to compare version numbers
version_ge() {
    [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" = "$2" ]
}

# Function to install Neovim on Linux
install_neovim_linux() {
    echo ""
    print_warning "Neovim >= 0.11.2 is required but not found or outdated"
    print_info "LazyVim requires Neovim >= 0.11.2"
    echo ""
    echo "Installation options:"
    echo "1) Bob (Neovim version manager) - Recommended"
    echo "2) AppImage (standalone binary)"
    echo "3) Snap package"
    echo "4) Skip (install manually later)"
    read -p "Choose installation method (1-4): " nvim_install_choice

    case $nvim_install_choice in
        1)
            print_info "Installing bob (Neovim version manager)..."
            if command -v cargo &> /dev/null; then
                cargo install bob-nvim
                print_success "Bob installed via cargo"
            else
                print_info "Installing bob without cargo..."
                if command -v wget &> /dev/null; then
                    wget -qO- https://raw.githubusercontent.com/MordechaiHadad/bob/master/install.sh | bash
                elif command -v curl &> /dev/null; then
                    curl -fsSL https://raw.githubusercontent.com/MordechaiHadad/bob/master/install.sh | bash
                else
                    print_error "Neither wget nor curl found. Cannot install bob."
                    return 1
                fi
            fi

            # Add bob to PATH for current session
            export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"

            print_info "Installing Neovim stable via bob..."
            bob install stable
            bob use stable
            print_success "Neovim installed via bob"
            print_info "Bob has been added to your PATH. Restart your shell or run:"
            echo "  export PATH=\"\$HOME/.local/share/bob/nvim-bin:\$PATH\""
            ;;
        2)
            print_info "Installing Neovim AppImage..."
            mkdir -p "$HOME/.local/bin"
            cd "$HOME/.local/bin" || exit 1

            if command -v wget &> /dev/null; then
                wget -q --show-progress https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -O nvim.appimage
            elif command -v curl &> /dev/null; then
                curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
            else
                print_error "Neither wget nor curl found. Cannot download AppImage."
                return 1
            fi

            chmod +x nvim.appimage
            ln -sf "$HOME/.local/bin/nvim.appimage" "$HOME/.local/bin/nvim"

            # Add to PATH if not already there
            if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
                export PATH="$HOME/.local/bin:$PATH"
                print_info "Added ~/.local/bin to PATH for current session"
                print_info "Add this to your shell config to make it permanent:"
                echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
            fi

            cd "$DOTFILES_DIR" || exit 1
            print_success "Neovim AppImage installed to ~/.local/bin/nvim"
            ;;
        3)
            print_info "Installing Neovim via snap..."
            if command -v snap &> /dev/null; then
                sudo snap install nvim --classic
                print_success "Neovim installed via snap"
            else
                print_error "Snap not found. Please install snapd first:"
                echo "  sudo apt install snapd"
                return 1
            fi
            ;;
        4)
            print_warning "Skipping Neovim installation"
            print_info "You can install Neovim manually using one of these methods:"
            echo "  1. Bob: https://github.com/MordechaiHadad/bob"
            echo "  2. AppImage: https://github.com/neovim/neovim/releases"
            echo "  3. Snap: sudo snap install nvim --classic"
            echo "  4. Build from source: https://github.com/neovim/neovim"
            return 1
            ;;
        *)
            print_error "Invalid choice"
            return 1
            ;;
    esac

    return 0
}

# Check for required commands
print_info "Checking for required commands..."
MISSING_COMMANDS=()

# Check git
if ! command -v git &> /dev/null; then
    MISSING_COMMANDS+=("git")
fi

# Check Neovim with version requirement
NVIM_REQUIRED="0.11.2"
NVIM_OK=false

if command -v nvim &> /dev/null; then
    NVIM_VERSION=$(nvim --version | head -n1 | sed 's/NVIM v\([0-9.]*\).*/\1/')
    print_info "Found Neovim version: $NVIM_VERSION"

    if version_ge "$NVIM_VERSION" "$NVIM_REQUIRED"; then
        NVIM_OK=true
        print_success "Neovim version is compatible (>= $NVIM_REQUIRED)"
    else
        print_warning "Neovim version $NVIM_VERSION is too old (requires >= $NVIM_REQUIRED)"
        if [ "$OS_TYPE" == "linux" ]; then
            read -p "Would you like to upgrade Neovim? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                if install_neovim_linux; then
                    NVIM_OK=true
                fi
            fi
        else
            print_info "Please upgrade Neovim manually:"
            echo "  - macOS: brew upgrade neovim"
            echo "  - Linux: See https://github.com/neovim/neovim/releases"
        fi
    fi
else
    print_warning "Neovim not found"
    if [ "$OS_TYPE" == "linux" ]; then
        read -p "Would you like to install Neovim? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if install_neovim_linux; then
                NVIM_OK=true
            fi
        fi
    fi
fi

if [ "$NVIM_OK" = false ]; then
    MISSING_COMMANDS+=("nvim")
fi

if [ ${#MISSING_COMMANDS[@]} -ne 0 ]; then
    print_warning "Missing or incompatible commands: ${MISSING_COMMANDS[*]}"
    print_info "Please install them before continuing"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check for tree-sitter CLI (required by LazyVim)
print_info "Checking for tree-sitter CLI..."
if ! command -v tree-sitter &> /dev/null; then
    print_warning "tree-sitter CLI not found (required by LazyVim)"
    print_info "LazyVim will attempt to install it automatically"
    print_info "If automatic installation fails, install manually:"
    echo "  npm install -g tree-sitter-cli"
    echo "  OR: cargo install tree-sitter-cli"
else
    print_success "tree-sitter CLI found"
fi

# Check for C compiler (required for tree-sitter)
print_info "Checking for C compiler..."
if command -v gcc &> /dev/null || command -v clang &> /dev/null; then
    print_success "C compiler found"
else
    print_warning "No C compiler found (gcc or clang)"
    print_info "Tree-sitter requires a C compiler. Install one:"
    if [ "$OS_TYPE" == "linux" ]; then
        echo "  Debian/Ubuntu: sudo apt install build-essential"
        echo "  Fedora: sudo dnf install gcc gcc-c++ make"
        echo "  Arch: sudo pacman -S base-devel"
    elif [ "$OS_TYPE" == "macos" ]; then
        echo "  macOS: xcode-select --install"
    fi
fi

# Check for optional language tools
print_info "Checking for language tooling..."
HAS_NODE=false
HAS_GO=false
HAS_PYTHON=false

if command -v node &> /dev/null && command -v npm &> /dev/null; then
    HAS_NODE=true
    print_success "Node.js found: $(node --version)"
fi

if command -v go &> /dev/null; then
    HAS_GO=true
    print_success "Go found: $(go version | awk '{print $3}')"
fi

if command -v python3 &> /dev/null && command -v pip3 &> /dev/null; then
    HAS_PYTHON=true
    print_success "Python found: $(python3 --version)"
fi

if [ "$HAS_NODE" = false ] && [ "$HAS_GO" = false ] && [ "$HAS_PYTHON" = false ]; then
    print_warning "No language tooling found (Node.js, Go, or Python)"
    print_info "Language servers won't be installed"
fi

# Check for tmux
HAS_TMUX=false
if command -v tmux &> /dev/null; then
    HAS_TMUX=true
    print_success "Tmux found: $(tmux -V)"
fi

# Ask user what to install
echo ""
print_info "What would you like to install?"
echo "1) Everything (recommended)"
echo "2) Neovim only"
echo "3) Shell configs only"
echo "4) Git configs only"
echo "5) Tmux config only"
read -p "Enter your choice (1-5): " choice

install_nvim=false
install_shell=false
install_git=false
install_tmux=false

case $choice in
    1)
        install_nvim=true
        install_shell=true
        install_git=true
        install_tmux=true
        ;;
    2)
        install_nvim=true
        ;;
    3)
        install_shell=true
        ;;
    4)
        install_git=true
        ;;
    5)
        install_tmux=true
        ;;
    *)
        print_error "Invalid choice"
        exit 1
        ;;
esac

echo ""
print_info "Starting installation..."

# Install Neovim config
if [ "$install_nvim" = true ]; then
    echo ""
    print_info "Installing Neovim configuration..."
    create_symlink "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"
fi

# Install shell config
if [ "$install_shell" = true ]; then
    echo ""
    print_info "Installing shell configuration..."

    # Detect shell
    if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ]; then
        print_info "Detected Zsh"
        create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ] || [ "$SHELL" = "/bin/bash" ] || [ "$SHELL" = "/usr/bin/bash" ]; then
        print_info "Detected Bash"
        create_symlink "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
    else
        print_warning "Could not detect shell. Please manually symlink .zshrc or .bashrc"
        echo "Which shell config do you want to install?"
        echo "1) Zsh (.zshrc)"
        echo "2) Bash (.bashrc)"
        echo "3) Both"
        read -p "Enter your choice (1-3): " shell_choice

        case $shell_choice in
            1)
                create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
                ;;
            2)
                create_symlink "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
                ;;
            3)
                create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
                create_symlink "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
                ;;
            *)
                print_warning "Skipping shell configuration"
                ;;
        esac
    fi

    # Offer to copy OS-specific local config template
    echo ""
    print_info "OS-specific configuration template available"
    if [ "$OS_TYPE" == "macos" ]; then
        template="$DOTFILES_DIR/.zshrc.local.macos.example"
    elif [ "$OS_TYPE" == "linux" ]; then
        template="$DOTFILES_DIR/.zshrc.local.linux.example"
    else
        template=""
    fi

    if [ -n "$template" ] && [ -f "$template" ]; then
        if [ ! -f "$HOME/.zshrc.local" ]; then
            read -p "Copy OS-specific template to ~/.zshrc.local? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                cp "$template" "$HOME/.zshrc.local"
                print_success "Created ~/.zshrc.local from template"
                print_info "Edit ~/.zshrc.local to customize for your machine"
            fi
        else
            print_info "~/.zshrc.local already exists, skipping template"
        fi
    fi
fi

# Install Git config
if [ "$install_git" = true ]; then
    echo ""
    print_info "Installing Git configuration..."
    create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
    create_symlink "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"

    echo ""
    print_warning "Don't forget to set your Git user info:"
    echo "  git config --global user.name \"Your Name\""
    echo "  git config --global user.email \"your.email@example.com\""
fi

# Install Tmux config
if [ "$install_tmux" = true ]; then
    echo ""
    print_info "Installing Tmux configuration..."

    if [ "$HAS_TMUX" = false ]; then
        print_warning "Tmux not found. Configuration will be installed but tmux needs to be installed separately."
        read -p "Continue? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Skipping tmux configuration"
            install_tmux=false
        fi
    fi

    if [ "$install_tmux" = true ]; then
        create_symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
        create_symlink "$DOTFILES_DIR/.tmux" "$HOME/.tmux"

        # Install TPM (Tmux Plugin Manager) if not already installed
        if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
            echo ""
            print_info "Installing Tmux Plugin Manager (TPM)..."
            git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
            print_success "TPM installed"

            print_info "To install tmux plugins, run:"
            echo "  1. Start tmux: tmux"
            echo "  2. Press prefix (Ctrl+a) + I (capital i) to install plugins"
        else
            print_success "TPM already installed"
        fi
    fi
fi

# Install Neovim plugins
if [ "$install_nvim" = true ]; then
    echo ""
    print_info "Installing Neovim plugins..."
    print_info "This may take a few minutes..."

    if command -v nvim &> /dev/null; then
        nvim --headless "+Lazy! sync" +qa
        print_success "Neovim plugins installed successfully"

        # Check if language servers need to be installed
        print_info "Checking for language servers..."
        if ! npm list -g typescript-language-server &> /dev/null; then
            print_warning "typescript-language-server not found"
            read -p "Install TypeScript language server? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                npm install -g typescript typescript-language-server
                print_success "TypeScript language server installed"
            fi
        fi

        if ! npm list -g vscode-langservers-extracted &> /dev/null; then
            print_warning "vscode-langservers-extracted (eslint) not found"
            read -p "Install ESLint language server? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                npm install -g vscode-langservers-extracted
                print_success "ESLint language server installed"
            fi
        fi

        if ! command -v prettier &> /dev/null; then
            print_warning "prettier not found"
            read -p "Install Prettier? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                npm install -g prettier
                print_success "Prettier installed"
            fi
        fi

        # Install Go language servers
        if [ "$HAS_GO" = true ]; then
            echo ""
            print_info "Installing Go language servers..."

            if ! command -v gopls &> /dev/null; then
                print_warning "gopls (Go language server) not found"
                read -p "Install gopls? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    go install golang.org/x/tools/gopls@latest
                    print_success "gopls installed"
                fi
            fi

            if ! command -v golangci-lint &> /dev/null; then
                print_warning "golangci-lint not found"
                read -p "Install golangci-lint? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
                    print_success "golangci-lint installed"
                fi
            fi

            if ! command -v dlv &> /dev/null; then
                print_warning "delve (Go debugger) not found"
                read -p "Install delve? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    go install github.com/go-delve/delve/cmd/dlv@latest
                    print_success "delve installed"
                fi
            fi

            print_info "Additional Go tools (optional)..."
            read -p "Install additional Go tools (gomodifytags, impl, gotests)? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                go install github.com/fatih/gomodifytags@latest
                go install github.com/josharian/impl@latest
                go install github.com/cweill/gotests/...@latest
                print_success "Additional Go tools installed"
            fi
        fi

        # Install Python language servers
        if [ "$HAS_PYTHON" = true ]; then
            echo ""
            print_info "Installing Python language servers..."

            if ! pip3 list 2>/dev/null | grep -q pyright; then
                print_warning "pyright (Python language server) not found"
                read -p "Install pyright? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    pip3 install --user pyright
                    print_success "pyright installed"
                fi
            fi

            if ! pip3 list 2>/dev/null | grep -q black; then
                print_warning "black (Python formatter) not found"
                read -p "Install black? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    pip3 install --user black
                    print_success "black installed"
                fi
            fi

            if ! pip3 list 2>/dev/null | grep -q isort; then
                print_warning "isort (Python import sorter) not found"
                read -p "Install isort? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    pip3 install --user isort
                    print_success "isort installed"
                fi
            fi

            if ! pip3 list 2>/dev/null | grep -q ruff; then
                print_warning "ruff (Python linter) not found"
                read -p "Install ruff? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    pip3 install --user ruff
                    print_success "ruff installed"
                fi
            fi

            if ! pip3 list 2>/dev/null | grep -q mypy; then
                print_warning "mypy (Python type checker) not found"
                read -p "Install mypy? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    pip3 install --user mypy
                    print_success "mypy installed"
                fi
            fi

            if ! pip3 list 2>/dev/null | grep -q debugpy; then
                print_warning "debugpy (Python debugger) not found"
                read -p "Install debugpy? (y/n) " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    pip3 install --user debugpy
                    print_success "debugpy installed"
                fi
            fi
        fi
    else
        print_warning "Neovim not found. Please install Neovim and run 'nvim' to install plugins"
    fi
fi

echo ""
echo "======================================"
print_success "Installation complete!"
echo "======================================"
echo ""

if [ -d "$BACKUP_DIR" ]; then
    print_info "Your old configs have been backed up to: $BACKUP_DIR"
fi

echo ""
print_info "Next steps:"
STEP=1
if [ "$install_nvim" = true ]; then
    echo "  $STEP. Run 'nvim' to finish plugin installation"
    STEP=$((STEP + 1))
fi
if [ "$install_shell" = true ]; then
    if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "/bin/zsh" ]; then
        echo "  $STEP. Run 'source ~/.zshrc' to reload your shell config"
    else
        echo "  $STEP. Run 'source ~/.bashrc' to reload your shell config"
    fi
    STEP=$((STEP + 1))
fi
if [ "$install_git" = true ]; then
    echo "  $STEP. Set your Git user info (see warning above)"
    STEP=$((STEP + 1))
fi
if [ "$install_tmux" = true ] && [ "$HAS_TMUX" = true ]; then
    echo "  $STEP. Start tmux and press Ctrl+a then I to install tmux plugins"
    echo "     Or run: tmux source ~/.tmux.conf"
    STEP=$((STEP + 1))
fi

echo ""
print_info "Quick start with tmux:"
echo "  tm              # Start or attach to tmux session"
echo "  tmuxdev myapp   # Create development layout"
echo "  tmuxtest myapp  # Create test layout"

echo ""
print_info "For more information, see README.md"
echo ""
