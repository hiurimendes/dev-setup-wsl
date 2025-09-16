# 🤖 Android Studio WSL2 - Instalação Enxuta

<div align="center">

![Android Studio](https://img.shields.io/badge/Android_Studio-3DDC84?style=for-the-badge&logo=android-studio&logoColor=white)
![WSL2](https://img.shields.io/badge/WSL2-0078D4?style=for-the-badge&logo=windows&logoColor=white)
![Java](https://img.shields.io/badge/Java_21_LTS-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![SDKMAN](https://img.shields.io/badge/SDKMAN!-326CE5?style=for-the-badge&logo=java&logoColor=white)

*Script otimizado para instalar Android Studio com GUI completo no WSL2*

</div>

---

## 🎯 Objetivo

Este script instala **apenas o essencial** para rodar Android Studio com emulador GUI no WSL2:
- ✅ Android Studio completo
- ✅ Android SDK otimizado  
- ✅ Emulador funcional com GUI
- ✅ Java 21 LTS via SDKMAN!
- ✅ Dependências mínimas para X11

## 🚀 Instalação Rápida

```bash
# Executar no WSL2 Ubuntu
curl -fsSL https://raw.githubusercontent.com/hiurimendes/dev-setup-wsl/main/android-studio/setup-android-studio-wsl.sh | bash
```

### Ou instalação manual:
```bash
git clone https://github.com/hiurimendes/dev-setup-wsl.git
cd dev-setup-wsl/android-studio
chmod +x setup-android-studio-wsl.sh
./setup-android-studio-wsl.sh
```

---

## 📋 Pré-requisitos

### Sistema
- **Windows 11** com WSL2 habilitado
- **Ubuntu 20.04+** no WSL2
- Mínimo **8GB RAM** (recomendado 16GB)
- **10GB** espaço livre em disco

### Servidor X11 no Windows
Escolha **uma** das opções:

| Servidor | Tipo | Recomendação |
|----------|------|--------------|
| **VcXsrv** | Gratuito | ⭐ **Recomendado** |
| **X410** | Pago (Microsoft Store) | 💰 Premium |
| **MobaXterm** | Freemium | 🆓 Alternativa |

#### Configuração VcXsrv (Recomendado):
1. Baixe: https://sourceforge.net/projects/vcxsrv/
2. Configure:
   - Display: `:0`
   - ✅ **Disable access control**
   - ✅ **Native OpenGL** (se disponível)
   - ✅ **Clipboard**

---

## 🛠️ O Que é Instalado

### Core System
```
• Java 21 LTS (via SDKMAN!)
• Android Studio (última versão)
• Android SDK 34
• Build Tools 34.0.0
• Platform Tools (ADB)
• Emulator + System Image
```

### GUI Dependencies
```
• X11 essentials
• Mesa OpenGL drivers  
• Qt5/GTK libraries
• Audio support (emulator)
```

### Gerenciamento
```
• SDKMAN! (Java version manager)
• Launchers otimizados
• Configuração automática de ambiente
```

---

## 🎮 Comandos Após Instalação

### Principais
```bash
# Abrir Android Studio
studio

# Iniciar emulador  
emulator-wsl

# Gerenciar versões Java
java-manager
```

### Testes
```bash
# Testar conexão X11
xclock

# Ver versão Java atual
java --version

# Listar dispositivos Android
adb devices
```

---

## 🔧 Gerenciamento Java (SDKMAN!)

### Comandos Básicos
```bash
# Ver ajuda completa
java-manager

# Listar versões disponíveis
java-manager list

# Instalar versão específica
java-manager install 17.0.9-tem
java-manager install 11.0.21-tem

# Alternar versões
java-manager use 17.0.9-tem     # Temporário (sessão atual)
java-manager default 21.0.1-tem # Permanente (padrão)

# Ver versão atual
java-manager current
```

### Cenários de Uso
```bash
# Projeto legado (Java 11)
java-manager install 11.0.21-tem
java-manager use 11.0.21-tem
studio  # Abre com Java 11

# Projeto moderno (Java 21) - já é padrão
studio  # Abre com Java 21

# Teste de compatibilidade  
java-manager install 22-tem
java-manager use 22-tem
```

---

## 🎯 Workflow Recomendado

### 1. Desenvolvimento
```bash
# WSL2: Coding + Build + Debug
studio                    # Desenvolvimento
adb devices              # Verificar dispositivos
./gradlew assembleDebug  # Build
adb install app-debug.apk # Deploy
```

### 2. Testing Intensivo
```bash
# Windows: Emulador para performance
# 1. Abra Android Studio no Windows
# 2. Inicie emulador no Windows  
# 3. Use ADB do WSL2: adb devices
```

### 3. Híbrido (Melhor dos dois mundos)
```bash
# WSL2: Desenvolvimento
studio                   # Codificação

# Windows: Emulador  
# Emulador Windows + ADB WSL2 = ❤️
```

---

## 🚨 Solução de Problemas

### GUI não funciona
```bash
# Verificar display
echo $DISPLAY

# Reconfigurar display
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0.0

# Testar X11
xclock
```

### Emulador não inicia
```bash
# Verificar AVD
ls ~/.android/avd/

# Recriar AVD se necessário
avdmanager delete avd -n Pixel_API34_WSL
avdmanager create avd -n Pixel_API34_WSL -k "system-images;android-34;google_apis;x86_64"
```

### Android Studio não abre
```bash
# Verificar Java
java --version

# Recarregar ambiente
source ~/.bashrc

# Verificar instalação
ls ~/android-studio/bin/studio.sh
```

### Problemas de Performance
```bash
# Verificar recursos WSL2
# Criar ~/.wslconfig no Windows:
[wsl2]
memory=8GB
processors=4
swap=2GB

# Reiniciar WSL2
wsl --shutdown  # No Windows CMD
```

---

## 📊 Comparação com Outras Abordagens

### Script Enxuto vs Instalação Completa

| Aspecto | Script Enxuto | Instalação Tradicional |
|---------|---------------|------------------------|
| **Tempo** | ~10 minutos | ~30+ minutos |
| **Espaço** | ~3GB | ~8+ GB |
| **Dependências** | Mínimas | Completas |
| **Funcionalidade** | Android Studio + Emulador | Tudo + extras |
| **Manutenção** | Simples | Complexa |
| **Performance** | Otimizada | Variável |

### WSL2 vs Windows Nativo vs Dual Boot

| Característica | WSL2 | Windows | Linux Nativo |
|----------------|------|---------|---------------|
| **Setup** | ⭐⭐⭐ Fácil | ⭐⭐⭐⭐ Muito Fácil | ⭐⭐ Médio |
| **Performance** | ⭐⭐⭐ Boa | ⭐⭐⭐⭐ Excelente | ⭐⭐⭐⭐ Excelente |
| **Integração** | ⭐⭐⭐⭐ Híbrida | ⭐⭐ Windows | ⭐⭐⭐ Linux |
| **Emulador** | ⭐⭐ Funcional | ⭐⭐⭐⭐ Nativo | ⭐⭐⭐ KVM |
| **Flexibilidade** | ⭐⭐⭐⭐ Total | ⭐⭐ Windows | ⭐⭐⭐⭐ Total |

---

## 📈 Otimizações Incluídas

### Performance
- ✅ Software rendering otimizado
- ✅ RAM configurada (2GB emulador)
- ✅ GPU mode: `swiftshader_indirect`
- ✅ Apenas componentes essenciais

### Usabilidade  
- ✅ Launchers simplificados
- ✅ Auto-configuração de ambiente
- ✅ Gerenciador Java integrado
- ✅ Display automático WSL2

### Manutenção
- ✅ SDKMAN! para Java
- ✅ Scripts modulares
- ✅ Limpeza automática
- ✅ Configuração persistente

---

## 🔄 Atualizações e Manutenção

### Atualizar Android Studio
```bash
# Manual: Baixar nova versão e substituir
cd /tmp
wget -O android-studio-new.tar.gz [NOVA_URL]
tar -xzf android-studio-new.tar.gz
mv ~/android-studio ~/android-studio-backup
mv android-studio ~/
```

### Atualizar SDK
```bash
# Via GUI Android Studio ou CLI
sdkmanager --update
```

### Atualizar Java
```bash
# Listar novas versões
java-manager list

# Instalar versão mais recente
java-manager install 21.0.2-tem
java-manager default 21.0.2-tem
```

---

## 🤝 Contribuindo

### Reportar Issues
- 🐛 [Bug Reports](https://github.com/hiurimendes/dev-setup-wsl/issues)
- 💡 [Feature Requests](https://github.com/hiurimendes/dev-setup-wsl/issues)

### Melhorias Sugeridas
- [ ] Auto-update do Android Studio
- [ ] Suporte a múltiplos AVDs
- [ ] Integração com Flutter
- [ ] Profiles de desenvolvimento

---

## 📝 Changelog

### v2.0.0 (Atual)
- ✅ SDKMAN! + Java 21 LTS
- ✅ Script enxuto otimizado
- ✅ Launcher `java-manager`
- ✅ Melhor integração WSL2

### v1.0.0 (Legacy)
- ✅ Instalação completa
- ✅ Java 17 via apt
- ✅ Múltiplas dependências

---

## 📄 Licença

MIT License - Veja [LICENSE](../LICENSE) para detalhes.

---

<div align="center">

**🚀 Desenvolvido para a comunidade Android + WSL2**

[⭐ Star no GitHub](https://github.com/hiurimendes/dev-setup-wsl) · [🐛 Reportar Bug](https://github.com/hiurimendes/dev-setup-wsl/issues) · [💡 Sugerir Feature](https://github.com/hiurimendes/dev-setup-wsl/issues)

---

*Transforme seu WSL2 em um ambiente Android profissional em minutos!*

</div>