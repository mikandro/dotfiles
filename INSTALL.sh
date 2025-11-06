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

# Check if we're in the dotfiles directory
if [ ! -f "$DOTFILES_DIR/INSTALL.sh" ]; then
    print_error "Please run this script from the dotfiles directory"
    exit 1
fi

# Check for required commands
print_info "Checking for required commands..."
MISSING_COMMANDS=()

for cmd in git nvim; do
    if ! command -v $cmd &> /dev/null; then
        MISSING_COMMANDS+=("$cmd")
    fi
done

if [ ${#MISSING_COMMANDS[@]} -ne 0 ]; then
    print_warning "Missing required commands: ${MISSING_COMMANDS[*]}"
    print_info "Please install them before continuing"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
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
