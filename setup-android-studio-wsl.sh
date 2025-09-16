#!/bin/bash

# Android Studio WSL2 Setup Script with GUI Support
# Este script instala o Android Studio no WSL2 com suporte completo a interface gráfica
# Inclui todas as dependências necessárias para integração com Windows 11

set -e  # Exit on any error

echo "🤖 Iniciando instalação do Android Studio no WSL2 com suporte GUI..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
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

print_header() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

print_note() {
    echo -e "${CYAN}[NOTE]${NC} $1"
}

# Check if running in WSL
check_wsl() {
    print_status "Verificando ambiente WSL..."
    if [[ ! -f /proc/version ]] || ! grep -qi "microsoft\|wsl" /proc/version; then
        print_error "Este script deve ser executado no WSL2!"
        print_error "Por favor, execute dentro do WSL Ubuntu."
        exit 1
    fi
    
    if grep -qi "wsl2" /proc/version || [ -n "$WSL_DISTRO_NAME" ]; then
        print_success "WSL2 detectado! Continuando instalação..."
    else
        print_warning "WSL1 detectado. Recomendamos WSL2 para melhor performance gráfica."
        read -p "Deseja continuar mesmo assim? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_status "Instalação cancelada. Atualize para WSL2 se possível."
            exit 1
        fi
    fi
}

# Update system and install basic dependencies
install_system_dependencies() {
    print_header "1. Instalando dependências básicas do sistema"
    
    print_status "Atualizando lista de pacotes..."
    sudo apt update -y
    
    print_status "Instalando pacotes essenciais..."
    sudo apt install -y \
        curl \
        wget \
        git \
        unzip \
        zip \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release \
        build-essential \
        libc6-dev \
        libstdc++6 \
        lib32stdc++6 \
        lib32z1
    
    print_success "Dependências básicas instaladas!"
}

# Install X11 and GUI dependencies for WSL2
install_gui_dependencies() {
    print_header "2. Instalando dependências gráficas para WSL2"
    
    print_status "Instalando servidor X11 e bibliotecas gráficas..."
    sudo apt install -y \
        xorg \
        xserver-xorg \
        x11-apps \
        x11-utils \
        x11-xserver-utils \
        dbus-x11 \
        ubuntu-desktop-minimal
    
    print_status "Instalando bibliotecas Mesa e OpenGL..."
    sudo apt install -y \
        mesa-utils \
        mesa-vulkan-drivers \
        libgl1-mesa-dev \
        libgl1-mesa-dri \
        libglu1-mesa-dev \
        libegl1-mesa-dev \
        libgles2-mesa-dev \
        mesa-va-drivers \
        mesa-vdpau-drivers
    
    print_status "Instalando bibliotecas Qt e GTK..."
    sudo apt install -y \
        libqt5gui5 \
        libqt5core5a \
        libqt5widgets5 \
        qt5-gtk-platformtheme \
        libgtk-3-0 \
        libgtk2.0-0 \
        gtk2-engines-murrine \
        gtk2-engines-pixbuf
    
    print_status "Instalando fontes e recursos visuais..."
    sudo apt install -y \
        fonts-liberation \
        fonts-dejavu \
        fonts-noto \
        fontconfig \
        libfontconfig1-dev \
        libfreetype6-dev
    
    print_status "Instalando bibliotecas de áudio (para emulador)..."
    sudo apt install -y \
        pulseaudio \
        alsa-utils \
        libasound2-dev \
        libpulse-dev \
        pavucontrol
    
    print_status "Instalando bibliotecas de vídeo e hardware acceleration..."
    sudo apt install -y \
        libxrandr2 \
        libxss1 \
        libxcursor1 \
        libxcomposite1 \
        libxdamage1 \
        libxtst6 \
        libxi6 \
        libxext6 \
        libxfixes3 \
        libnss3-dev \
        libdrm2 \
        libvulkan1 \
        vulkan-utils
    
    print_success "Dependências gráficas instaladas!"
}

# Install Java Development Kit
install_java() {
    print_header "3. Instalando Java Development Kit"
    
    # Check if SDKMAN is installed
    if [ -d "$HOME/.sdkman" ]; then
        print_status "SDKMAN detectado, usando para instalar Java..."
        source "$HOME/.sdkman/bin/sdkman-init.sh"
        sdk install java 17.0.9-tem
        sdk default java 17.0.9-tem
    else
        print_status "Instalando OpenJDK via apt..."
        sudo apt install -y openjdk-17-jdk openjdk-17-jre
        
        # Set JAVA_HOME
        export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
        echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
        echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
    fi
    
    print_success "Java instalado: $(java -version 2>&1 | head -n 1)"
}

# Download and install Android Studio
install_android_studio() {
    print_header "4. Baixando e instalando Android Studio"
    
    # Create directories
    mkdir -p ~/android-studio
    mkdir -p ~/Android/Sdk
    
    print_status "Baixando Android Studio (última versão estável)..."
    cd /tmp
    
    # Get latest Android Studio download URL
    ANDROID_STUDIO_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.1.1.28/android-studio-2023.1.1.28-linux.tar.gz"
    
    if [ ! -f "android-studio-linux.tar.gz" ]; then
        wget -O android-studio-linux.tar.gz "$ANDROID_STUDIO_URL"
    fi
    
    print_status "Extraindo Android Studio..."
    tar -xzf android-studio-linux.tar.gz -C ~/
    
    print_status "Configurando Android Studio..."
    # Move to proper location if needed
    if [ -d ~/android-studio-*/ ]; then
        mv ~/android-studio-*/ ~/android-studio/
    fi
    
    # Create desktop entry
    mkdir -p ~/.local/share/applications
    cat > ~/.local/share/applications/android-studio.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Android Studio
Icon=$HOME/android-studio/bin/studio.png
Exec=$HOME/android-studio/bin/studio.sh
Comment=The official Android IDE
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-studio
StartupNotify=true
EOF
    
    # Make executable
    chmod +x ~/.local/share/applications/android-studio.desktop
    chmod +x ~/android-studio/bin/studio.sh
    
    print_success "Android Studio instalado em ~/android-studio/"
}

# Install Android SDK and tools
install_android_sdk() {
    print_header "5. Instalando Android SDK e ferramentas"
    
    export ANDROID_HOME=$HOME/Android/Sdk
    export ANDROID_SDK_ROOT=$ANDROID_HOME
    
    print_status "Baixando Android Command Line Tools..."
    cd /tmp
    
    if [ ! -f "commandlinetools-linux.zip" ]; then
        wget -O commandlinetools-linux.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
    fi
    
    print_status "Instalando Command Line Tools..."
    unzip -q commandlinetools-linux.zip
    mkdir -p $ANDROID_HOME/cmdline-tools/latest
    mv cmdline-tools/* $ANDROID_HOME/cmdline-tools/latest/
    rm -rf cmdline-tools
    
    # Set up environment
    export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
    export PATH=$ANDROID_HOME/platform-tools:$PATH
    export PATH=$ANDROID_HOME/emulator:$PATH
    export PATH=$ANDROID_HOME/build-tools:$PATH
    
    print_status "Configurando variáveis de ambiente..."
    cat >> ~/.bashrc << EOF

# Android SDK Configuration
export ANDROID_HOME=\$HOME/Android/Sdk
export ANDROID_SDK_ROOT=\$ANDROID_HOME
export PATH=\$ANDROID_HOME/cmdline-tools/latest/bin:\$PATH
export PATH=\$ANDROID_HOME/platform-tools:\$PATH
export PATH=\$ANDROID_HOME/emulator:\$PATH
export PATH=\$ANDROID_HOME/build-tools:\$PATH

# Graphics and Display for WSL2
export DISPLAY=:0
export LIBGL_ALWAYS_INDIRECT=1
export GDK_SCALE=1
export QT_SCALE_FACTOR=1
EOF
    
    # If zsh is available, add to .zshrc too
    if [ -f ~/.zshrc ]; then
        cat >> ~/.zshrc << EOF

# Android SDK Configuration
export ANDROID_HOME=\$HOME/Android/Sdk
export ANDROID_SDK_ROOT=\$ANDROID_HOME
export PATH=\$ANDROID_HOME/cmdline-tools/latest/bin:\$PATH
export PATH=\$ANDROID_HOME/platform-tools:\$PATH
export PATH=\$ANDROID_HOME/emulator:\$PATH
export PATH=\$ANDROID_HOME/build-tools:\$PATH

# Graphics and Display for WSL2
export DISPLAY=:0
export LIBGL_ALWAYS_INDIRECT=1
export GDK_SCALE=1
export QT_SCALE_FACTOR=1
EOF
    fi
    
    # Reload environment
    source ~/.bashrc
    
    print_status "Aceitando licenças do Android SDK..."
    yes | sdkmanager --licenses >/dev/null 2>&1
    
    print_status "Instalando componentes essenciais do SDK..."
    sdkmanager --install \
        "platform-tools" \
        "platforms;android-34" \
        "platforms;android-33" \
        "build-tools;34.0.0" \
        "build-tools;33.0.2" \
        "emulator" \
        "system-images;android-34;google_apis;x86_64" \
        "system-images;android-33;google_apis;x86_64"
    
    print_success "Android SDK instalado e configurado!"
}

# Create Android Virtual Device
create_avd() {
    print_header "6. Criando Android Virtual Device (AVD)"
    
    export ANDROID_HOME=$HOME/Android/Sdk
    export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
    
    AVD_NAME="Pixel_7_API_34_WSL"
    
    print_status "Criando AVD: $AVD_NAME"
    
    # Create AVD with hardware acceleration disabled for WSL2 compatibility
    echo no | avdmanager create avd \
        -n "$AVD_NAME" \
        -k "system-images;android-34;google_apis;x86_64" \
        -d "pixel_7" \
        --force
    
    # Configure AVD for WSL2 (disable hardware acceleration)
    AVD_DIR="$HOME/.android/avd/$AVD_NAME.avd"
    if [ -d "$AVD_DIR" ]; then
        print_status "Configurando AVD para WSL2..."
        
        # Update config.ini for better WSL2 compatibility
        cat >> "$AVD_DIR/config.ini" << EOF

# WSL2 Optimizations
hw.gpu.enabled=yes
hw.gpu.mode=swiftshader_indirect
hw.ramSize=2048
vm.heapSize=512
hw.keyboard=yes
hw.dPad=no
hw.audioInput=yes
hw.audioOutput=yes
hw.camera.back=webcam0
hw.camera.front=webcam0
disk.dataPartition.size=6442450944
EOF
        
        print_success "AVD '$AVD_NAME' criado e configurado para WSL2!"
    else
        print_error "Falha ao criar AVD. Verifique se o system-image foi instalado corretamente."
    fi
}

# Setup display for WSL2
configure_display() {
    print_header "7. Configurando display para WSL2"
    
    print_status "Configurando variáveis de display..."
    
    # Configure display environment
    cat >> ~/.bashrc << 'EOF'

# WSL2 Display Configuration
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
export LIBGL_ALWAYS_INDIRECT=1
export GDK_SCALE=1
export QT_SCALE_FACTOR=1

# Pulse Audio for WSL2
export PULSE_HOST=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
export PULSE_PORT=4713
EOF

    if [ -f ~/.zshrc ]; then
        cat >> ~/.zshrc << 'EOF'

# WSL2 Display Configuration
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
export LIBGL_ALWAYS_INDIRECT=1
export GDK_SCALE=1
export QT_SCALE_FACTOR=1

# Pulse Audio for WSL2
export PULSE_HOST=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}')
export PULSE_PORT=4713
EOF
    fi
    
    print_success "Configuração de display adicionada!"
    
    print_note "Para habilitar GUI no WSL2, você precisa de um servidor X no Windows."
    print_note "Recomendações:"
    print_note "1. VcXsrv (gratuito): https://sourceforge.net/projects/vcxsrv/"
    print_note "2. X410 (pago): Microsoft Store"
    print_note "3. MobaXterm (gratuito/pago): https://mobaxterm.mobatek.net/"
}

# Create launcher scripts
create_launchers() {
    print_header "8. Criando scripts de lançamento"
    
    mkdir -p ~/.local/bin
    
    # Android Studio launcher
    cat > ~/.local/bin/android-studio << 'EOF'
#!/bin/bash
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
export LIBGL_ALWAYS_INDIRECT=1
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/emulator:$PATH

echo "🚀 Iniciando Android Studio..."
echo "📱 Certifique-se de que um servidor X está rodando no Windows"
echo "💡 Servidor X recomendado: VcXsrv ou X410"
echo ""

$HOME/android-studio/bin/studio.sh "$@" &
EOF
    
    # Emulator launcher
    cat > ~/.local/bin/android-emulator << 'EOF'
#!/bin/bash
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
export LIBGL_ALWAYS_INDIRECT=1
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$ANDROID_HOME/emulator:$PATH

AVD_NAME=${1:-"Pixel_7_API_34_WSL"}

echo "📱 Iniciando emulador Android: $AVD_NAME"
echo "💡 Certifique-se de que um servidor X está rodando no Windows"
echo "⚠️  O emulador pode ser lento no WSL2 - considere usar o Windows para emuladores"
echo ""

$ANDROID_HOME/emulator/emulator -avd "$AVD_NAME" -no-snapshot-load -gpu swiftshader_indirect &
EOF
    
    # AVD manager launcher
    cat > ~/.local/bin/android-avd << 'EOF'
#!/bin/bash
export ANDROID_HOME=$HOME/Android/Sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH

echo "📱 Gerenciador de AVDs Android"
echo ""
echo "AVDs disponíveis:"
avdmanager list avd
echo ""
echo "Para criar novo AVD:"
echo "avdmanager create avd -n NOME -k 'system-images;android-34;google_apis;x86_64'"
echo ""
echo "Para iniciar emulador:"
echo "android-emulator NOME_DO_AVD"
EOF

    # Make scripts executable
    chmod +x ~/.local/bin/android-studio
    chmod +x ~/.local/bin/android-emulator
    chmod +x ~/.local/bin/android-avd
    
    # Add to PATH
    if ! echo $PATH | grep -q "$HOME/.local/bin"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        if [ -f ~/.zshrc ]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
        fi
    fi
    
    print_success "Scripts de lançamento criados!"
    print_note "Use 'android-studio' para abrir o Android Studio"
    print_note "Use 'android-emulator' para iniciar o emulador"
    print_note "Use 'android-avd' para gerenciar AVDs"
}

# Create useful aliases
create_aliases() {
    print_header "9. Criando aliases úteis"
    
    # Add to bashrc
    cat >> ~/.bashrc << 'EOF'

# Android Development Aliases
alias as='android-studio'
alias emu='android-emulator'
alias avd='android-avd'
alias adb-reset='adb kill-server && adb start-server'
alias adb-devices='adb devices -l'
alias adb-logs='adb logcat'
alias sdk-update='sdkmanager --update'
alias sdk-list='sdkmanager --list'
alias gradle-clean='./gradlew clean'
alias gradle-build='./gradlew build'
alias gradle-install='./gradlew installDebug'
alias flutter-doctor='flutter doctor'
alias react-android='npx react-native run-android'

# Display aliases for WSL2
alias display-check='echo $DISPLAY && xclock'
alias display-test='xeyes'
alias gpu-info='glxinfo | grep -E "(OpenGL vendor|OpenGL renderer|OpenGL version)"'
EOF
    
    # Add to zshrc if it exists
    if [ -f ~/.zshrc ]; then
        cat >> ~/.zshrc << 'EOF'

# Android Development Aliases
alias as='android-studio'
alias emu='android-emulator'
alias avd='android-avd'
alias adb-reset='adb kill-server && adb start-server'
alias adb-devices='adb devices -l'
alias adb-logs='adb logcat'
alias sdk-update='sdkmanager --update'
alias sdk-list='sdkmanager --list'
alias gradle-clean='./gradlew clean'
alias gradle-build='./gradlew build'
alias gradle-install='./gradlew installDebug'
alias flutter-doctor='flutter doctor'
alias react-android='npx react-native run-android'

# Display aliases for WSL2
alias display-check='echo $DISPLAY && xclock'
alias display-test='xeyes'
alias gpu-info='glxinfo | grep -E "(OpenGL vendor|OpenGL renderer|OpenGL version)"'
EOF
    fi
    
    print_success "Aliases criados com sucesso!"
}

# Test GUI functionality
test_gui() {
    print_header "10. Testando funcionalidade gráfica"
    
    print_status "Verificando se o display está configurado..."
    if [ -z "$DISPLAY" ]; then
        export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
    fi
    
    print_note "Display configurado para: $DISPLAY"
    
    print_status "Testando aplicação X11 simples..."
    if command -v xclock &> /dev/null; then
        timeout 5s xclock 2>/dev/null && print_success "GUI funcionando!" || print_warning "GUI pode não estar funcionando - verifique servidor X no Windows"
    else
        print_warning "xclock não disponível para teste"
    fi
}

# Cleanup temporary files
cleanup() {
    print_header "11. Limpeza final"
    
    print_status "Removendo arquivos temporários..."
    cd ~
    rm -rf /tmp/android-studio-linux.tar.gz
    rm -rf /tmp/commandlinetools-linux.zip
    rm -rf /tmp/cmdline-tools
    
    print_success "Limpeza concluída!"
}

# Main installation function
main() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🤖 ANDROID STUDIO WSL2 SETUP com Suporte GUI"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    check_wsl
    install_system_dependencies
    install_gui_dependencies
    install_java
    install_android_studio
    install_android_sdk
    create_avd
    configure_display
    create_launchers
    create_aliases
    test_gui
    cleanup
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎉 INSTALAÇÃO CONCLUÍDA COM SUCESSO!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    print_success "Android Studio instalado em: ~/android-studio/"
    print_success "Android SDK configurado em: ~/Android/Sdk"
    print_success "AVD criado: Pixel_7_API_34_WSL"
    echo ""
    print_header "📋 PRÓXIMOS PASSOS:"
    echo ""
    print_note "1. INSTALAR SERVIDOR X NO WINDOWS:"
    print_note "   • VcXsrv (gratuito): https://sourceforge.net/projects/vcxsrv/"
    print_note "   • X410 (Microsoft Store)"
    print_note "   • MobaXterm: https://mobaxterm.mobatek.net/"
    echo ""
    print_note "2. CONFIGURAR SERVIDOR X:"
    print_note "   • Habilite 'Disable access control'"
    print_note "   • Use display number :0"
    print_note "   • Marque 'Native opengl' se disponível"
    echo ""
    print_note "3. REINICIAR TERMINAL:"
    print_note "   • Execute: source ~/.bashrc"
    print_note "   • Ou reinicie o terminal WSL"
    echo ""
    print_note "4. TESTAR INSTALAÇÃO:"
    print_note "   • display-check  (testa conexão X11)"
    print_note "   • android-studio (abre Android Studio)"
    print_note "   • android-emulator (inicia emulador)"
    echo ""
    print_header "🛠️  COMANDOS ÚTEIS:"
    echo ""
    print_note "• as              - Abrir Android Studio"
    print_note "• emu             - Iniciar emulador padrão"
    print_note "• avd             - Gerenciar AVDs"
    print_note "• adb-devices     - Listar dispositivos conectados"
    print_note "• display-test    - Testar GUI (abre xeyes)"
    print_note "• gpu-info        - Informações da GPU"
    echo ""
    print_warning "⚠️  NOTAS IMPORTANTES:"
    print_warning "• Performance do emulador pode ser limitada no WSL2"
    print_warning "• Para melhor performance, considere usar emulador no Windows"
    print_warning "• Hardware acceleration limitado no WSL2"
    print_warning "• Certifique-se que Windows Defender não bloqueia o servidor X"
    echo ""
    print_success "🚀 Pronto para desenvolver Android no WSL2!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Execute main function
main "$@"