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

# Verificar WSL e WSLg
check_wsl() {
    info "Verificando WSL2 e suporte GUI nativo..."
    
    # Verificar se está no WSL
    if [[ ! -f /proc/version ]] || ! grep -qi "microsoft\|wsl" /proc/version; then
        error "Execute no WSL2!"
        exit 1
    fi
    
    # Verificar se é WSL2 (necessário para WSLg)
    if ! grep -qi "wsl2" /proc/version && [ -z "$WSL_DISTRO_NAME" ]; then
        error "WSL2 é necessário para GUI nativo. Atualize para WSL2."
        exit 1
    fi
    
    # Verificar se WSLg está disponível (Windows 11)
    if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
        warn "WSLg pode não estar habilitado. Certifique-se de estar no Windows 11."
        warn "Execute 'wsl --update' no Windows para habilitar GUI nativo."
    else
        success "WSLg (GUI nativo) detectado!"
    fi
    
    success "WSL2 verificado"
}

# Verificar GPU e drivers
check_gpu_support() {
    info "Verificando suporte GPU para WSLg..."
    
    # Verificar se glxinfo está disponível para testar
    if command -v glxinfo &> /dev/null; then
        GPU_INFO=$(glxinfo | grep -i "opengl renderer" || echo "N/A")
        info "GPU detectada: $GPU_INFO"
        
        if echo "$GPU_INFO" | grep -qi "llvmpipe\|software"; then
            warn "⚠️  GPU usando software rendering"
            warn "💡 Instale drivers GPU no Windows para melhor performance:"
            warn "   • NVIDIA: https://www.nvidia.com/drivers"
            warn "   • AMD: https://www.amd.com/support/download/drivers.html" 
            warn "   • Intel: https://downloadcenter.intel.com/"
        else
            success "✅ Hardware acceleration disponível"
        fi
    else
        info "glxinfo será instalado para testar GPU..."
    fi
}

# Dependências básicas
install_basic_deps() {
    info "Instalando dependências básicas..."
    sudo apt update -q
    sudo apt install -y curl wget unzip zip
    success "Dependências básicas instaladas"
}

# GUI nativo WSLg para Android Studio + Emulador
install_gui_deps() {
    info "Instalando dependências GUI para WSLg (nativo)..."
    
    # Dependências mínimas para WSLg - hardware acceleration nativo
    sudo apt install -y \
        mesa-utils \
        mesa-vulkan-drivers \
        libgl1-mesa-dri \
        libqt5gui5 \
        libgtk-3-0 \
        libasound2-plugins \
        pulseaudio
    
    # Configurar PulseAudio para WSLg
    if [ ! -f ~/.config/pulse/client.conf ]; then
        mkdir -p ~/.config/pulse
        echo "default-server = unix:/mnt/wslg/PulseServer" > ~/.config/pulse/client.conf
    fi
    
        success "GUI nativo WSLg configurado"
}

# Configurar permissões KVM para emulador
setup_kvm_permissions() {
    info "Configurando permissões KVM para aceleração de hardware..."
    
    # Verificar se /dev/kvm existe (WSL2 com nested virtualization)
    if [ -e /dev/kvm ]; then
        # Verificar se usuário já tem acesso
        if [ -r /dev/kvm ] && [ -w /dev/kvm ]; then
            success "Acesso ao /dev/kvm já configurado"
            return
        fi
        
        # Adicionar usuário ao grupo kvm
        if getent group kvm >/dev/null 2>&1; then
            sudo usermod -aG kvm $USER
            success "Usuário adicionado ao grupo kvm"
        else
            # Criar grupo kvm se não existir
            sudo groupadd kvm
            sudo usermod -aG kvm $USER
            success "Grupo kvm criado e usuário adicionado"
        fi
        
        # Configurar permissões do dispositivo
        sudo chmod 666 /dev/kvm
        
        warn "⚠️  Para aplicar permissões KVM, reinicie o terminal WSL ou faça logout/login"
        warn "💡 Teste com: ls -la /dev/kvm"
        
    else
        warn "⚠️  /dev/kvm não encontrado"
        warn "💡 Para habilitar KVM no WSL2:"
        warn "   1. Habilite 'Virtual Machine Platform' no Windows"
        warn "   2. Use WSL2 com kernel atualizado"
        warn "   3. Configure nested virtualization se necessário"
        info "Emulador funcionará com software rendering (mais lento)"
    fi
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
    info "Baixando Android Studio (versão mais recente)..."
    mkdir -p ~/Android/Sdk
    cd /tmp
    
    # URL oficial da versão mais recente (2025.1.3.7)
    STUDIO_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2025.1.3.7/android-studio-2025.1.3.7-linux.tar.gz"
    
    info "Download iniciando... (pode levar alguns minutos - ~1.5GB)"
    
    # Download com progress bar e retry
    if ! wget --progress=bar:force:noscroll -O android-studio.tar.gz "$STUDIO_URL" 2>&1; then
        error "Falha no download. Tentando URL alternativa..."
        
        # Fallback para URL direta do Google
        ALT_URL="https://dl.google.com/dl/android/studio/ide-zips/2025.1.3.7/android-studio-2025.1.3.7-linux.tar.gz"
        
        if ! wget --progress=bar:force:noscroll -O android-studio.tar.gz "$ALT_URL" 2>&1; then
            error "Download falhou. Verifique sua conexão de internet."
            error "Tente baixar manualmente de: https://developer.android.com/studio"
            exit 1
        fi
    fi
    
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
    
    # URL atualizada do Command Line Tools (versão mais recente)
    CMDTOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip"
    
    info "Baixando Android Command Line Tools..."
    if ! wget --progress=bar:force:noscroll -O cmdtools.zip "$CMDTOOLS_URL" 2>&1; then
        error "Falha no download do Command Line Tools"
        exit 1
    fi
    
    unzip -q cmdtools.zip
    mkdir -p $ANDROID_HOME/cmdline-tools/latest
    mv cmdline-tools/* $ANDROID_HOME/cmdline-tools/latest/
    
    # Configurar ambiente
    export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
    export PATH=$ANDROID_HOME/platform-tools:$PATH
    export PATH=$ANDROID_HOME/emulator:$PATH
    
    cat >> ~/.bashrc << 'EOF'

# Android SDK + WSLg Native Graphics
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
export PATH=$ANDROID_HOME/emulator:$PATH

# WSLg Native Display (Windows 11)
# Display é automaticamente configurado pelo WSLg
if [ -n "$WSL_DISTRO_NAME" ]; then
    # Habilitar hardware acceleration nativo
    export LIBGL_ALWAYS_SOFTWARE=0
    export __GLX_VENDOR_LIBRARY_NAME=mesa
    # Audio nativo WSLg
    export PULSE_SERVER="unix:/mnt/wslg/PulseServer"
fi
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
    
    # Otimizar para WSL2 com KVM
    cat >> "$HOME/.android/avd/$AVD_NAME.avd/config.ini" << 'EOF'

# WSLg Native + KVM Hardware Acceleration
hw.gpu.enabled=yes
hw.gpu.mode=host
hw.ramSize=2048
hw.keyboard=yes
hw.mainKeys=yes
hw.trackBall=no
hw.audioInput=yes
hw.audioOutput=yes
# KVM acceleration (se disponível)
hw.cpu.ncore=2
vm.heapSize=512
disk.dataPartition.size=2048MB
EOF
    
    success "Emulador criado: $AVD_NAME"
}

# Criar launchers essenciais
create_launchers() {
    info "Criando launchers..."
    mkdir -p ~/.local/bin
    
    # Android Studio com WSLg nativo
    cat > ~/.local/bin/studio << 'EOF'
#!/bin/bash
# WSLg Native Graphics (Windows 11)
export ANDROID_HOME=$HOME/Android/Sdk

# Verificar se WSLg está disponível
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
    echo "⚠️  WSLg não detectado. Certifique-se de estar no Windows 11 com WSL atualizado."
    echo "💡 Execute no Windows: wsl --update && wsl --shutdown"
    exit 1
fi

echo "🚀 Abrindo Android Studio com GPU nativa do Windows..."
$HOME/android-studio/bin/studio.sh &
EOF
    
    # Emulator com WSLg nativo
    cat > ~/.local/bin/emulator-wsl << 'EOF'
#!/bin/bash
export ANDROID_HOME=$HOME/Android/Sdk
AVD=${1:-"Pixel_API34_WSL"}

# Verificar WSLg
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
    echo "⚠️  WSLg não disponível. Use Windows 11 com WSL atualizado."
    exit 1
fi

echo "📱 Iniciando emulador com GPU nativa: $AVD"
echo "🚀 Usando hardware acceleration do Windows!"

# Verificar se KVM está disponível para máxima aceleração
if [ -r /dev/kvm ] && [ -w /dev/kvm ]; then
    echo "⚡ KVM detectado - máxima aceleração habilitada!"
    $ANDROID_HOME/emulator/emulator -avd "$AVD" -gpu host -accel on -feature HVF &
else
    echo "⚠️  KVM não disponível - usando aceleração básica"
    $ANDROID_HOME/emulator/emulator -avd "$AVD" -gpu host -feature HVF &
fi
EOF

    # KVM Diagnostic Tool
    cat > ~/.local/bin/kvm-check << 'EOF'
#!/bin/bash
echo "🔍 Diagnóstico KVM para Android Emulator"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Verificar se /dev/kvm existe
if [ -e /dev/kvm ]; then
    echo "✅ /dev/kvm encontrado"
    
    # Verificar permissões
    KVM_PERMS=$(ls -la /dev/kvm)
    echo "📋 Permissões: $KVM_PERMS"
    
    if [ -r /dev/kvm ] && [ -w /dev/kvm ]; then
        echo "✅ Acesso de leitura/escrita OK"
    else
        echo "❌ Sem acesso adequado ao /dev/kvm"
        echo "🔧 Solução: sudo chmod 666 /dev/kvm"
        echo "🔧 Ou adicionar ao grupo: sudo usermod -aG kvm $USER"
    fi
    
    # Verificar grupos do usuário
    if groups | grep -q kvm; then
        echo "✅ Usuário no grupo kvm"
    else
        echo "⚠️  Usuário não está no grupo kvm"
        echo "🔧 Solução: sudo usermod -aG kvm $USER && newgrp kvm"
    fi
    
else
    echo "❌ /dev/kvm não encontrado"
    echo "💡 KVM não está disponível no WSL2"
    echo "💡 Emulador usará software acceleration (mais lento)"
fi

echo ""
echo "🧪 Para testar emulador:"
echo "emulator-wsl"
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
    
    chmod +x ~/.local/bin/studio ~/.local/bin/emulator-wsl ~/.local/bin/java-manager ~/.local/bin/kvm-check
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    
    success "Launchers criados: studio, emulator-wsl, java-manager, kvm-check"
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
    check_gpu_support
    setup_kvm_permissions
    install_java_sdkman
    install_android_studio
    install_sdk
    create_avd
    create_launchers
    cleanup
    
    echo ""
    success "✅ Instalação concluída!"
    echo ""
    warn "⚠️  PRÓXIMOS PASSOS (WSLg Nativo):"
    echo "1. ✅ Certifique-se que está no Windows 11"
    echo "2. ✅ Execute no Windows: wsl --update"  
    echo "3. ✅ Reinicie WSL: wsl --shutdown (depois reabra)"
    echo "4. 🔄 Reinicie terminal WSL: source ~/.bashrc"
    echo "5. 🧪 Teste GUI nativo: glxgears (deve usar GPU do Windows)"
    echo "6. 🚀 Abra Android Studio: studio"
    echo "7. 📱 Inicie emulador: emulator-wsl"
    echo ""
    warn "📋 COMANDOS JAVA (SDKMAN!):"
    echo "• sdk list java          - Listar versões Java disponíveis"
    echo "• sdk install java X.Y.Z - Instalar versão específica"
    echo "• sdk use java X.Y.Z     - Usar versão temporariamente"  
    echo "• sdk default java X.Y.Z - Definir versão padrão"
    echo "• java --version         - Ver versão atual"
    echo ""
    warn "🎮 VANTAGENS WSLg NATIVO + KVM:"
    echo "✅ Hardware acceleration da GPU do Windows"
    echo "✅ KVM para máxima aceleração do emulador"
    echo "✅ Sem necessidade de servidor X11 externo"
    echo "✅ Apps aparecem no menu Iniciar do Windows"
    echo "✅ Alt+Tab entre apps Windows e Linux"
    echo "✅ Copy/paste nativo entre Windows e Linux"
    echo "✅ Performance superior ao X11 forwarding"
    echo ""
    warn "🔧 VERIFICAR PERMISSÕES KVM:"
    echo "• ls -la /dev/kvm (deve mostrar rw-rw---- ou similar)"
    echo "• Se necessário: sudo chmod 666 /dev/kvm"
    echo "• Reinicie terminal se adicionado ao grupo kvm"
    echo ""
    success "🚀 Pronto para desenvolver com GPU nativa!"
}

main "$@"