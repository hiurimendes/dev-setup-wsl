# Configuração do Servidor X11 para Android Studio WSL2

Este guia explica como configurar um servidor X11 no Windows para usar o Android Studio no WSL2 com interface gráfica completa.

## 📋 Pré-requisitos

- Windows 10/11 com WSL2 instalado
- Ubuntu ou distribuição similar no WSL2
- Conexão de internet ativa

## 🖥️ Opções de Servidor X11

### 1. VcXsrv (Recomendado - Gratuito)

**Download:** https://sourceforge.net/projects/vcxsrv/

#### Instalação do VcXsrv:
1. Baixe e instale o VcXsrv do link acima
2. Execute o XLaunch após a instalação
3. Configure as seguintes opções:

**Tela 1 - Display settings:**
- Selecione: "Multiple windows"
- Display number: `0`
- Clique "Next"

**Tela 2 - Client startup:**
- Selecione: "Start no client"
- Clique "Next"

**Tela 3 - Extra settings:**
- ✅ Marque: "Clipboard"
- ✅ Marque: "Primary Selection"  
- ✅ Marque: "Native opengl"
- ✅ **IMPORTANTE:** Marque "Disable access control"
- Clique "Next"

**Tela 4 - Configuration complete:**
- Opcionalmente salve a configuração para reuso
- Clique "Finish"

#### Criar atalho com configuração automática:
```batch
# Crie um arquivo .bat com o conteúdo:
"C:\Program Files\VcXsrv\vcxsrv.exe" :0 -multiwindow -clipboard -wgl -ac
```

### 2. X410 (Microsoft Store - Pago)

**Download:** Microsoft Store - busque por "X410"

#### Configuração do X410:
1. Instale via Microsoft Store
2. Inicie o X410
3. Clique no ícone na bandeja do sistema
4. Vá para Settings → General
5. Configure:
   - Enable Public Access: ✅
   - DPI Scaling: Native ou Custom (teste ambos)
   - Hardware Acceleration: ✅

### 3. MobaXterm (Versão gratuita limitada)

**Download:** https://mobaxterm.mobatek.net/

#### Configuração do MobaXterm:
1. Baixe e instale o MobaXterm
2. Inicie o programa
3. O servidor X é iniciado automaticamente
4. Verifique na aba "X server" se está rodando na porta :0

## 🔧 Configuração do Windows Firewall

### Permitir conexões X11:

1. Abra o Windows Defender Firewall
2. Clique em "Allow an app or feature through Windows Defender Firewall"
3. Clique "Change Settings" → "Allow another app"
4. Adicione o executável do seu servidor X11:
   - VcXsrv: `C:\Program Files\VcXsrv\vcxsrv.exe`
   - X410: Já configurado automaticamente
   - MobaXterm: `C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe`

5. Marque tanto "Private" quanto "Public" networks

## 🧪 Teste da Configuração

### No WSL2:

```bash
# 1. Instale aplicações de teste
sudo apt install x11-apps

# 2. Configure a variável DISPLAY
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0

# 3. Teste aplicações simples
xclock    # Deve abrir um relógio
xeyes     # Deve abrir olhos que seguem o cursor
glxgears  # Teste de OpenGL (se disponível)

# 4. Se funcionou, instale o Android Studio
./setup-android-studio-wsl.sh
```

## 🚨 Solução de Problemas Comuns

### Problema: "Can't open display"

**Solução:**
```bash
# Verifique a variável DISPLAY
echo $DISPLAY

# Reconfigure se necessário  
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0

# Teste novamente
xclock
```

### Problema: Aplicação não abre/tela preta

**Possíveis causas:**
1. **Firewall do Windows bloqueando** - Siga as instruções de firewall acima
2. **Antivirus interferindo** - Adicione exceção para o servidor X11
3. **Porta ocupada** - Reinicie o servidor X11
4. **WSL2 IP mudou** - Reinicie WSL2: `wsl --shutdown` no cmd, depois reabra

### Problema: Performance gráfica lenta

**Melhorias:**
```bash
# Desabilite compositing se disponível
export LIBGL_ALWAYS_INDIRECT=1

# Ajuste DPI scaling
export GDK_SCALE=1
export QT_SCALE_FACTOR=1

# Para VcXsrv, use native opengl
# Para X410, teste hardware acceleration on/off
```

### Problema: Emulador Android não funciona

**Alternativas:**
```bash
# 1. Use software rendering
android-emulator -gpu swiftshader_indirect

# 2. Ou use emulador do Windows + ADB do WSL2
# No Windows: Start Android Studio emulator
# No WSL2: adb devices (deve detectar)
```

## 📱 Fluxo de Trabalho Recomendado

### Para Desenvolvimento:
1. **Use Android Studio no WSL2** para:
   - Edição de código
   - Build e compilação
   - Debug via ADB
   - Controle de versão (Git)

### Para Testing:
2. **Use emulador no Windows** para:
   - Testes de performance intensivos
   - Testes de hardware (câmera, GPS, etc.)
   - Validação final do app

### Comandos Úteis:
```bash
# Iniciar servidor X (se não auto-iniciou)
# No Windows: execute o servidor X11 manualmente

# No WSL2: 
display-check          # Testa conexão X11
android-studio         # Abre Android Studio
adb devices           # Lista dispositivos (funciona com emulador Windows)
gradle-build          # Build do projeto
```

## 💡 Dicas de Performance

1. **Use SSD** - WSL2 se beneficia muito de armazenamento rápido
2. **RAM suficiente** - Mínimo 8GB, recomendado 16GB+
3. **Configure swap** se necessário:
   ```bash
   # No WSL2
   sudo fallocate -l 4G /swapfile
   sudo chmod 600 /swapfile
   sudo mkswap /swapfile
   sudo swapon /swapfile
   ```

4. **Limite uso de recursos** - Crie `.wslconfig` no `C:\Users\SEU_USUARIO\`:
   ```ini
   [wsl2]
   memory=8GB
   processors=4
   swap=4GB
   ```

## 🔄 Inicialização Automática

### Script para iniciar X11 automaticamente:

**Arquivo: `start-x11.bat`**
```batch
@echo off
echo Starting X11 Server for WSL2...
start "" "C:\Program Files\VcXsrv\vcxsrv.exe" :0 -multiwindow -clipboard -wgl -ac
echo X11 Server started!
pause
```

**Adicionar ao startup do Windows:**
1. Win+R → digite `shell:startup`
2. Copie o arquivo .bat para a pasta que abrir
3. X11 iniciará automaticamente com o Windows

## ✅ Verificação Final

Após configurar tudo:

```bash
# No WSL2:
source ~/.bashrc
display-check     # Deve mostrar o DISPLAY e abrir xclock
as               # Deve abrir Android Studio
emu              # Deve mostrar opções do emulador
adb devices      # Deve listar dispositivos/emuladores
```

Se todos os comandos funcionarem, sua configuração está perfeita! 🎉

---

**Criado por:** Setup Android Studio WSL2  
**Versão:** 1.0  
**Data:** 2025  