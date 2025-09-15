#!/bin/bash

# WSL Ubuntu Web Development Environment Setup Script
# This script installs and configures essential tools for web development

set -e  # Exit on any error

echo "🚀 Starting WSL Ubuntu Web Development Environment Setup..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
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

# Update system packages
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
print_status "Installing essential packages..."
sudo apt install -y curl wget git build-essential software-properties-common apt-transport-https ca-certificates gnupg lsb-release zsh unzip zip

# Install Oh My Zsh
print_status "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed successfully"
else
    print_warning "Oh My Zsh already installed"
fi

# Change default shell to zsh
print_status "Setting zsh as default shell..."
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    chsh -s $(which zsh)
    print_success "Default shell changed to zsh (restart terminal to take effect)"
else
    print_warning "Zsh is already the default shell"
fi

# Install NVM (Node Version Manager)
print_status "Installing NVM..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    
    # Add NVM to zshrc
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.zshrc
    
    # Install latest LTS Node.js
    nvm install --lts
    nvm use --lts
    nvm alias default node
    print_success "NVM and Node.js LTS installed successfully"
else
    print_warning "NVM already installed"
fi

# Install Docker
print_status "Installing Docker..."
if ! command -v docker &> /dev/null; then
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Add Docker repository
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update package index and install Docker
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    
    print_success "Docker installed successfully"
else
    print_warning "Docker already installed"
fi

# Install Docker Compose
print_status "Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    # Get latest version of docker-compose
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    print_success "Docker Compose installed successfully"
else
    print_warning "Docker Compose already installed"
fi

# Install pyenv (Python Version Manager)
print_status "Installing pyenv (Python Version Manager)..."
if [ ! -d "$HOME/.pyenv" ]; then
    # Install dependencies for pyenv
    sudo apt install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev
    
    # Install pyenv
    curl https://pyenv.run | bash
    
    # Add pyenv to profile files for proper initialization
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
    echo 'eval "$(pyenv init --path)"' >> ~/.profile
    
    # Add pyenv to zprofile
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zprofile
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zprofile
    echo 'eval "$(pyenv init --path)"' >> ~/.zprofile
    
    # Add pyenv to zshrc for interactive shells
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
    
    # Load pyenv for current session
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    
    # Install latest stable Python
    print_status "Installing latest stable Python..."
    PYTHON_VERSION=$(pyenv install --list | grep -E "^\s*[0-9]+\.[0-9]+\.[0-9]+$" | tail -1 | xargs)
    pyenv install $PYTHON_VERSION
    pyenv global $PYTHON_VERSION
    
    print_success "pyenv and Python $PYTHON_VERSION installed successfully"
else
    print_warning "pyenv already installed"
fi

# Configure Git (basic setup)
print_status "Configuring Git..."
if [ -z "$(git config --global user.name)" ]; then
    echo "Please enter your Git username:"
    read -r git_username
    git config --global user.name "$git_username"
fi

if [ -z "$(git config --global user.email)" ]; then
    echo "Please enter your Git email:"
    read -r git_email
    git config --global user.email "$git_email"
fi

# Set some useful Git defaults
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.autocrlf input

print_success "Git configured successfully"

# Install GitHub CLI
print_status "Installing GitHub CLI..."
if ! command -v gh &> /dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install -y gh
    print_success "GitHub CLI installed successfully"
else
    print_warning "GitHub CLI already installed"
fi

# Install SDKMAN! (Software Development Kit Manager)
print_status "Installing SDKMAN! (Software Development Kit Manager)..."
if [ ! -d "$HOME/.sdkman" ]; then
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    
    # Add SDKMAN to zshrc
    echo '' >> ~/.zshrc
    echo '# SDKMAN Configuration' >> ~/.zshrc
    echo 'export SDKMAN_DIR="$HOME/.sdkman"' >> ~/.zshrc
    echo '[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"' >> ~/.zshrc
    
    print_success "SDKMAN! installed successfully"
else
    print_warning "SDKMAN! already installed"
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Install Java 21 using SDKMAN! (compatible with CapacitorJS)
print_status "Installing Java 21 using SDKMAN! (CapacitorJS compatible)..."
# Source SDKMAN! for this session to use sdk command
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Check if Java 21 is already installed
if ! bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && sdk list java" | grep -q "21.*installed"; then
    # Install Amazon Corretto 21 (recommended for Android development)
    bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && sdk install java 21.0.4-amzn"
    bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && sdk default java 21.0.4-amzn"
    print_success "Java 21 (Amazon Corretto) installed and set as default"
else
    print_warning "Java 21 already installed via SDKMAN!"
    bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && sdk default java 21.0.4-amzn" 2>/dev/null || true
fi

# Install Android SDK and set up Android development environment
print_status "Setting up Android SDK for development..."

# Install Android SDK command line tools
print_status "Installing Android SDK Command Line Tools..."
ANDROID_HOME="$HOME/Android/Sdk"
mkdir -p "$ANDROID_HOME"

# Download and install command line tools
cd /tmp
wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
unzip commandlinetools-linux-9477386_latest.zip
mkdir -p "$ANDROID_HOME/cmdline-tools/latest"
mv cmdline-tools/* "$ANDROID_HOME/cmdline-tools/latest/"
rm -rf cmdline-tools commandlinetools-linux-9477386_latest.zip

# Set up Android environment variables
echo '' >> ~/.zshrc
echo '# Android SDK Configuration' >> ~/.zshrc
echo 'export ANDROID_HOME="$HOME/Android/Sdk"' >> ~/.zshrc
echo 'export ANDROID_SDK_ROOT="$ANDROID_HOME"' >> ~/.zshrc
echo 'export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"' >> ~/.zshrc
echo 'export PATH="$ANDROID_HOME/platform-tools:$PATH"' >> ~/.zshrc
echo 'export PATH="$ANDROID_HOME/build-tools:$PATH"' >> ~/.zshrc
echo 'export PATH="$ANDROID_HOME/emulator:$PATH"' >> ~/.zshrc
echo '# JAVA_HOME will be automatically set by SDKMAN!' >> ~/.zshrc

# Load Android environment for current session
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/build-tools:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"
# JAVA_HOME will be set by SDKMAN! when sourced

# Accept Android SDK licenses
yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses >/dev/null 2>&1

# Install essential Android SDK components
print_status "Installing essential Android SDK components..."
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platform-tools" "build-tools;34.0.0" "platforms;android-34" "system-images;android-34;google_apis;x86_64"

# Create symbolic link to Windows Android Studio SDK (if exists)
WINDOWS_ANDROID_SDK="/mnt/c/Users/$USER/AppData/Local/Android/Sdk"
if [ -d "$WINDOWS_ANDROID_SDK" ]; then
    print_status "Found Windows Android Studio SDK, creating symbolic links..."
    
    # Create backup of WSL Android directory
    if [ -d "$ANDROID_HOME" ]; then
        mv "$ANDROID_HOME" "${ANDROID_HOME}.backup"
    fi
    
    # Create symbolic link to Windows SDK
    ln -sf "$WINDOWS_ANDROID_SDK" "$ANDROID_HOME"
    
    print_success "Android SDK synchronized with Windows Android Studio"
    print_warning "Note: You can switch back to WSL-only SDK by removing the symlink:"
    print_warning "rm $ANDROID_HOME && mv ${ANDROID_HOME}.backup $ANDROID_HOME"
else
    print_warning "Windows Android Studio SDK not found at $WINDOWS_ANDROID_SDK"
    print_success "Using WSL-only Android SDK installation"
fi

# Install Gradle (for Android builds)
print_status "Installing Gradle..."
if ! command -v gradle &> /dev/null; then
    wget https://services.gradle.org/distributions/gradle-8.4-bin.zip -P /tmp
    sudo unzip -d /opt/gradle /tmp/gradle-8.4-bin.zip
    echo 'export GRADLE_HOME="/opt/gradle/gradle-8.4"' >> ~/.zshrc
    echo 'export PATH="$GRADLE_HOME/bin:$PATH"' >> ~/.zshrc
    export GRADLE_HOME="/opt/gradle/gradle-8.4"
    export PATH="$GRADLE_HOME/bin:$PATH"
    print_success "Gradle installed successfully"
else
    print_warning "Gradle already installed"
fi

print_success "Android SDK and development environment configured successfully"

# Install some useful zsh plugins
print_status "Installing useful Oh My Zsh plugins..."

# zsh-autosuggestions
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# zsh-syntax-highlighting
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Update .zshrc with plugins
sed -i 's/plugins=(git)/plugins=(git node npm docker docker-compose python pyenv zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

print_success "Oh My Zsh plugins installed and configured"

# Create useful aliases
print_status "Adding useful aliases to .zshrc..."
cat >> ~/.zshrc << 'EOF'

# Custom aliases for web development
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# File and directory management aliases
alias md='mkdir -p'
alias rd='rmdir'
alias rf='rm -rf'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias touch='touch'
alias find='find . -name'
alias grep='grep --color=auto'
alias tree='tree -C'
alias du='du -h'
alias df='df -h'
alias size='du -sh'
alias count='find . -type f | wc -l'
alias back='cd $OLDPWD'
alias home='cd ~'
alias root='cd /'
alias mkcd='function _mkcd(){ mkdir -p "$1" && cd "$1"; }; _mkcd'

# File permissions
alias chx='chmod +x'
alias 755='chmod 755'
alias 644='chmod 644'

# File viewing and editing
alias cat='cat -n'
alias less='less -R'
alias more='more'
alias head='head -n 20'
alias tail='tail -n 20'
alias tf='tail -f'

# Archive management
alias tarzip='tar -czf'
alias untar='tar -xzf'
alias zip='zip -r'
alias unzip='unzip'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# Docker aliases
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dsp='docker system prune'
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcb='docker-compose build'

# Node/npm aliases
alias nrs='npm run start'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'

# SDKMAN! aliases
alias sdk-list='sdk list'
alias sdk-current='sdk current'
alias sdk-use='sdk use'
alias sdk-install='sdk install'
alias sdk-uninstall='sdk uninstall'
alias sdk-default='sdk default'
alias sdk-update='sdk update'
alias java-version='java -version'
alias javac-version='javac -version'

# Android development aliases
alias adb-devices='adb devices'
alias adb-logcat='adb logcat'
alias adb-install='adb install'
alias adb-uninstall='adb uninstall'
alias adb-shell='adb shell'
alias adb-push='adb push'
alias adb-pull='adb pull'
alias adb-restart='adb kill-server && adb start-server'
alias emulator-list='emulator -list-avds'
alias emulator-start='emulator -avd'
alias gradle-clean='./gradlew clean'
alias gradle-build='./gradlew build'
alias gradle-debug='./gradlew assembleDebug'
alias gradle-release='./gradlew assembleRelease'
alias gradle-install='./gradlew installDebug'
alias react-android='npx react-native run-android'
alias flutter-devices='flutter devices'
alias flutter-run='flutter run'
alias flutter-build='flutter build apk'
alias flutter-clean='flutter clean'
alias sdk-manager-update='sdkmanager --update'
alias sdk-manager-list='sdkmanager --list'

EOF

print_success "Useful aliases added to .zshrc"

# Final message
echo ""
echo "🎉 WSL Ubuntu Web Development Environment Setup Complete!"
echo ""
print_success "Installed tools:"
echo "  ✅ Oh My Zsh with useful plugins"
echo "  ✅ NVM with Node.js LTS"
echo "  ✅ Docker with Docker Compose"
echo "  ✅ pyenv with latest stable Python"
echo "  ✅ Git (configured)"
echo "  ✅ GitHub CLI"
echo "  ✅ SDKMAN! (Software Development Kit Manager)"
echo "  ✅ Java 21 (Amazon Corretto) - CapacitorJS compatible"
echo "  ✅ Android SDK with command line tools"
echo "  ✅ Gradle build system"
echo "  ✅ Useful aliases and configurations"
echo ""
print_warning "Important notes:"
echo "  🔄 Please restart your terminal or run 'exec zsh' to apply all changes"
echo "  🐳 You may need to restart WSL for Docker to work properly: wsl --shutdown && wsl"
echo "  🔐 Run 'gh auth login' to authenticate with GitHub"
echo "  🤖 Android SDK synchronized with Windows Android Studio (if found)"
echo "  📱 Use 'adb devices' to check connected Android devices"
echo "  ☕ Use 'sdk list java' to see available Java versions"
echo "  � Java 21 is CapacitorJS compatible and set as default"
echo "  �🐍 Python version: $(python --version 2>/dev/null || echo 'Restart terminal first')"
echo "  📦 Node version: $(node --version 2>/dev/null || echo 'Restart terminal first')"
echo "  ☕ Java version: $(java -version 2>&1 | head -1 || echo 'Restart terminal first')"
echo ""
print_status "Happy coding! 🚀"
