#!/bin/bash

# Android Studio WSL2 Setup - Versão Enxuta
# Instala apenas o essencial: Android Studio + GUI + Emulador no WSL2

set -e

echo "🤖 Instalação enxuta do Android Studio WSL2..."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; }

# Verificar WSL
check_wsl() {
    info "Verificando WSL..."
    if [[ ! -f /proc/version ]] || ! grep -qi "microsoft\|wsl" /proc/version; then
        error "Execute no WSL2!"
        exit 1
    fi
    success "WSL detectado"
}

# Dependências básicas
install_basic_deps() {
    info "Instalando dependências básicas..."
    sudo apt update -q
    sudo apt install -y curl wget unzip zip
    success "Dependências básicas instaladas"
}

# GUI essencial para Android Studio + Emulador
install_gui_deps() {
    info "Instalando GUI essencial..."
    sudo apt install -y \
        x11-apps \
        mesa-utils \
        libgl1-mesa-dri \
        libqt5gui5 \
        libgtk-3-0 \
        libasound2-dev
    success "GUI essencial instalada"
}

# Instalar SDKMAN! e Java 21
install_java_sdkman() {
    info "Instalando SDKMAN!..."
    
    # Verificar se SDKMAN já está instalado
    if [ -d "$HOME/.sdkman" ]; then
        info "SDKMAN! já instalado, carregando..."
        source "$HOME/.sdkman/bin/sdkman-init.sh"
    else
        # Instalar SDKMAN!
        curl -s "https://get.sdkman.io" | bash
        source "$HOME/.sdkman/bin/sdkman-init.sh"
        
        # Adicionar SDKMAN ao bashrc
        echo '' >> ~/.bashrc
        echo '# SDKMAN!' >> ~/.bashrc
        echo 'export SDKMAN_DIR="$HOME/.sdkman"' >> ~/.bashrc
        echo '[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"' >> ~/.bashrc
    fi
    
    success "SDKMAN! configurado"
    
    info "Instalando Java 21 LTS via SDKMAN!..."
    # Instalar Java 21 LTS (Temurin)
    sdk install java 21.0.1-tem
    sdk default java 21.0.1-tem
    
    # Exportar JAVA_HOME para sessão atual
    export JAVA_HOME="$HOME/.sdkman/candidates/java/current"
    
    success "Java 21 LTS instalado e configurado como padrão"
}

# Instalar Android Studio
install_android_studio() {
    info "Baixando Android Studio..."
    mkdir -p ~/Android/Sdk
    cd /tmp
    
    STUDIO_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.1.1.28/android-studio-2023.1.1.28-linux.tar.gz"
    wget -q -O android-studio.tar.gz "$STUDIO_URL"
    
    info "Instalando Android Studio..."
    tar -xzf android-studio.tar.gz -C ~/
    chmod +x ~/android-studio/bin/studio.sh
    
    success "Android Studio instalado"
}

# Instalar SDK
install_sdk() {
    info "Instalando Android SDK..."
    export ANDROID_HOME=$HOME/Android/Sdk
    
    cd /tmp
    wget -q -O cmdtools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
    unzip -q cmdtools.zip
    mkdir -p $ANDROID_HOME/cmdline-tools/latest
    mv cmdline-tools/* $ANDROID_HOME/cmdline-tools/latest/
    
    # Configurar ambiente
    export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
    export PATH=$ANDROID_HOME/platform-tools:$PATH
    export PATH=$ANDROID_HOME/emulator:$PATH
    
    cat >> ~/.bashrc << 'EOF'

# Android + Display WSL2
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/emulator:$PATH
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
export LIBGL_ALWAYS_INDIRECT=1
EOF

    source ~/.bashrc
    
    # Instalar componentes essenciais
    yes | sdkmanager --licenses >/dev/null 2>&1
    sdkmanager --install \
        "platform-tools" \
        "platforms;android-34" \
        "build-tools;34.0.0" \
        "emulator" \
        "system-images;android-34;google_apis;x86_64"
    
    success "SDK instalado"
}

# Criar AVD
create_avd() {
    info "Criando emulador..."
    export ANDROID_HOME=$HOME/Android/Sdk
    export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
    
    AVD_NAME="Pixel_API34_WSL"
    
    echo no | avdmanager create avd \
        -n "$AVD_NAME" \
        -k "system-images;android-34;google_apis;x86_64" \
        -d "pixel_7" \
        --force
    
    # Otimizar para WSL2
    cat >> "$HOME/.android/avd/$AVD_NAME.avd/config.ini" << 'EOF'

hw.gpu.enabled=yes
hw.gpu.mode=swiftshader_indirect
hw.ramSize=2048
hw.keyboard=yes
EOF
    
    success "Emulador criado: $AVD_NAME"
}

# Criar launchers essenciais
create_launchers() {
    info "Criando launchers..."
    mkdir -p ~/.local/bin
    
    # Android Studio
    cat > ~/.local/bin/studio << 'EOF'
#!/bin/bash
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
export ANDROID_HOME=$HOME/Android/Sdk
echo "🚀 Abrindo Android Studio... (Servidor X deve estar rodando no Windows)"
$HOME/android-studio/bin/studio.sh &
EOF
    
    # Emulator  
    cat > ~/.local/bin/emulator-wsl << 'EOF'
#!/bin/bash
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0
export ANDROID_HOME=$HOME/Android/Sdk
AVD=${1:-"Pixel_API34_WSL"}
echo "📱 Iniciando emulador: $AVD"
$ANDROID_HOME/emulator/emulator -avd "$AVD" -gpu swiftshader_indirect &
EOF

    # Java Manager (SDKMAN helper)
    cat > ~/.local/bin/java-manager << 'EOF'
#!/bin/bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

if [ $# -eq 0 ]; then
    echo "🔧 Gerenciador Java (SDKMAN!)"
    echo ""
    echo "Versão atual: $(java --version | head -n1)"
    echo ""
    echo "Comandos disponíveis:"
    echo "  java-manager list      - Listar versões disponíveis"
    echo "  java-manager install X - Instalar versão X"
    echo "  java-manager use X     - Usar versão X (sessão atual)"
    echo "  java-manager default X - Definir X como padrão"
    echo "  java-manager current   - Ver versão atual"
    echo ""
    echo "Exemplo: java-manager install 17.0.9-tem"
    exit 0
fi

case $1 in
    list)     sdk list java ;;
    install)  sdk install java $2 ;;
    use)      sdk use java $2 ;;
    default)  sdk default java $2 ;;
    current)  sdk current java ;;
    *)        echo "Comando inválido. Use: java-manager (sem argumentos) para ajuda" ;;
esac
EOF
    
    chmod +x ~/.local/bin/studio ~/.local/bin/emulator-wsl ~/.local/bin/java-manager
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    
    success "Launchers criados: studio, emulator-wsl, java-manager"
}

# Limpeza
cleanup() {
    info "Limpando arquivos temporários..."
    rm -f /tmp/android-studio.tar.gz /tmp/cmdtools.zip
    rm -rf /tmp/cmdline-tools
    success "Limpeza concluída"
}

# Main
main() {
    echo "🤖 Android Studio WSL2 - Instalação Enxuta"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    check_wsl
    install_basic_deps
    install_gui_deps  
    install_java_sdkman
    install_android_studio
    install_sdk
    create_avd
    create_launchers
    cleanup
    
    echo ""
    success "✅ Instalação concluída!"
    echo ""
    warn "⚠️  PRÓXIMOS PASSOS:"
    echo "1. Instale VcXsrv no Windows: https://sourceforge.net/projects/vcxsrv/"
    echo "2. Configure: Display :0, Disable access control"
    echo "3. Reinicie terminal: source ~/.bashrc"
    echo "4. Teste: xclock"
    echo "5. Abra Android Studio: studio"
    echo "6. Inicie emulador: emulator-wsl"
    echo ""
    warn "📋 COMANDOS JAVA (SDKMAN!):"
    echo "• sdk list java          - Listar versões Java disponíveis"
    echo "• sdk install java X.Y.Z - Instalar versão específica"
    echo "• sdk use java X.Y.Z     - Usar versão temporariamente"
    echo "• sdk default java X.Y.Z - Definir versão padrão"
    echo "• java --version         - Ver versão atual"
    echo ""
    success "🚀 Pronto para usar!"
}

main "$@"