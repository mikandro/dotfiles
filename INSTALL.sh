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

for cmd in git nvim node npm; do
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

# Ask user what to install
echo ""
print_info "What would you like to install?"
echo "1) Everything (recommended)"
echo "2) Neovim only"
echo "3) Shell configs only"
echo "4) Git configs only"
read -p "Enter your choice (1-4): " choice

install_nvim=false
install_shell=false
install_git=false

case $choice in
    1)
        install_nvim=true
        install_shell=true
        install_git=true
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
if [ "$install_nvim" = true ]; then
    echo "  1. Run 'nvim' to finish plugin installation"
fi
if [ "$install_shell" = true ]; then
    if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "/bin/zsh" ]; then
        echo "  2. Run 'source ~/.zshrc' to reload your shell config"
    else
        echo "  2. Run 'source ~/.bashrc' to reload your shell config"
    fi
fi
if [ "$install_git" = true ]; then
    echo "  3. Set your Git user info (see warning above)"
fi

echo ""
print_info "For more information, see README.md"
echo ""
