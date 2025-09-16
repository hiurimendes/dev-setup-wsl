# WSL Ubuntu Web Development Setup 🚀

<div align="center">

![WSL](https://img.shields.io/badge/WSL-Ubuntu-orange?style=for-the-badge&logo=ubuntu)
![Node.js](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![Git](https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white)

*Complete automated setup for WSL Ubuntu development environment with Android SDK integration*

</div>

---

## 🎯 Overview

This script transforms your WSL Ubuntu into a powerful development environment with all essential tools pre-configured. Perfect for web development, mobile app development (Android), and full-stack projects.

## 📋 What's Included

### Core Development Tools
- 🐚 **Oh My Zsh** - Enhanced terminal with powerful plugins
- 📦 **Node.js + NVM** - Node Version Manager with latest LTS
- 🐍 **Python + pyenv** - Python version manager with latest stable version
- 📝 **Git** - Pre-configured version control
- 🐙 **GitHub CLI** - Official GitHub command-line tool

### Containerization & Build Tools
- 🐳 **Docker + Docker Compose** - Complete containerization stack
- ☕ **SDKMAN! + Java 21 LTS** - Java version manager with latest LTS
- 🏗️ **Gradle** - Modern build automation tool (managed by SDKMAN!)

### Mobile Development (Multiple Approaches)
- 🤖 **Android SDK Integration** - Seamless Windows Android Studio integration
- 📱 **ADB Tools** - Cross-platform Android debugging  
- 🔄 **Intelligent Detection** - Auto-configures based on Windows installation
- 🛠️ **Command Wrappers** - WSL-compatible Android tool wrappers
- 🎨 **WSL2 GUI Support** - Full Android Studio with emulator in WSL2
- 🖥️ **X11 Integration** - Complete graphical interface support

### Developer Experience
- ⚡ **100+ Aliases** - Time-saving shortcuts for all tools
- 🎨 **Syntax Highlighting** - Enhanced terminal experience  
- 💡 **Auto-suggestions** - Intelligent command completion

---

## 🚀 Quick Installation

### Complete Development Environment
```bash
curl -fsSL https://raw.githubusercontent.com/hiurimendes/dev-setup-wsl/main/setup-wsl-dev.sh | bash
```

### Android Studio with GUI Support (WSL2)
```bash
curl -fsSL https://raw.githubusercontent.com/hiurimendes/dev-setup-wsl/main/setup-android-studio-wsl.sh | bash
```

### Manual Installation
```bash
# Clone the repository
git clone https://github.com/hiurimendes/dev-setup-wsl.git
cd dev-setup-wsl

# Complete environment setup
chmod +x setup-wsl-dev.sh
./setup-wsl-dev.sh

# Android Studio with GUI (requires X11 server on Windows)
chmod +x setup-android-studio-wsl.sh  
./setup-android-studio-wsl.sh
```

---

## 📋 Prerequisites

- Windows 10/11 with **WSL2** enabled
- **Ubuntu** distribution installed in WSL
- Basic terminal knowledge

---

## 🤖 Android Studio WSL2 Setup

### Full GUI Android Studio in WSL2

For developers who want to run Android Studio completely within WSL2 with full GUI support:

```bash
# Run the Android Studio WSL2 installer
curl -fsSL https://raw.githubusercontent.com/hiurimendes/dev-setup-wsl/main/setup-android-studio-wsl.sh | bash
```

### What's Included in Android Studio WSL2 Setup

- 🎨 **Complete GUI Support** - Full Android Studio interface in WSL2
- 🖥️ **X11 Integration** - Seamless Windows-WSL2 display forwarding
- 📱 **Android Emulator** - Built-in emulator with hardware acceleration
- 🛠️ **Latest Android SDK** - Complete SDK with build tools and platform tools
- ⚡ **Optimized Performance** - WSL2-specific optimizations for graphics
- 🎯 **Ready-to-Use AVD** - Pre-configured Android Virtual Device
- 🔧 **Development Tools** - ADB, SDK Manager, AVD Manager

### Prerequisites for Android Studio WSL2

1. **WSL2** (not WSL1) with Ubuntu
2. **X11 Server on Windows** - Choose one:
   - [VcXsrv](https://sourceforge.net/projects/vcxsrv/) (Free - Recommended)
   - [X410](https://www.microsoft.com/store/apps/9nlp712zmn9q) (Paid - Microsoft Store)
   - [MobaXterm](https://mobaxterm.mobatek.net/) (Free/Paid)

📖 **Detailed X11 Setup Guide:** [SETUP-X11-GUIDE.md](SETUP-X11-GUIDE.md)

### Quick Start with Android Studio WSL2

```bash
# 1. Install X11 server on Windows (VcXsrv recommended)
# 2. Run the installer
./setup-android-studio-wsl.sh

# 3. Configure X11 server with these settings:
#    - Display number: 0
#    - Enable "Disable access control"
#    - Enable "Native opengl" (if available)

# 4. Test the installation
source ~/.bashrc
display-check        # Test X11 connection
android-studio       # Launch Android Studio
```

### Android Studio WSL2 Commands

```bash
# Launch applications
as                   # Open Android Studio
emu                  # Start default emulator
avd                  # Manage Android Virtual Devices

# Development tools
adb-devices          # List connected devices
adb-logs            # View device logs
gradle-clean        # Clean project
gradle-build        # Build project
gradle-install      # Install debug APK

# Display testing
display-test        # Test GUI (opens xeyes)
gpu-info           # Check OpenGL information
```

### Performance Notes for WSL2 Android Studio

**✅ Advantages:**
- Complete Linux development environment
- Better file system performance for large projects
- Native Linux tools and terminal
- Integrated development workflow

**⚠️ Considerations:**
- Emulator performance may be slower than native Windows
- Graphics acceleration is software-based
- X11 forwarding adds slight latency
- RAM usage is higher due to GUI components

**💡 Recommended Workflow:**
- Use WSL2 Android Studio for development and coding
- Use Windows emulator for intensive testing (better performance)
- Use WSL2 for CLI tools (ADB, Gradle, Git)

---

## 🔧 Post-Installation Setup

### 1. Apply Changes
```bash
# Restart terminal or reload shell
exec zsh
```

### 2. Restart WSL (if needed for Docker)
```powershell
# In Windows PowerShell/CMD
wsl --shutdown
wsl
```

### 3. Authenticate Services
```bash
# GitHub authentication
gh auth login

# Verify installations
node --version
python --version
docker --version
java --version
adb --version
```

---

## 🛠️ Tool Usage Guide

### Node.js Development
```bash
# Install and use Node versions
nvm install 18.17.0
nvm use 18.17.0
nvm alias default 18.17.0

# Package management
npm install
npm run dev
yarn install
yarn dev
```

### Python Development
```bash
# Install and manage Python versions
pyenv install 3.11.5
pyenv global 3.11.5
pyenv local 3.9.0

# Virtual environments
python -m venv myproject
source myproject/bin/activate
```

### Docker Operations
```bash
# Basic operations
docker run hello-world
docker ps
docker images

# Docker Compose
docker-compose up -d
docker-compose down
docker-compose logs -f
```

### Java Development with SDKMAN!
```bash
# List available Java versions
sdk list java

# Install specific Java version
sdk install java 17.0.9-tem
sdk install java 21.0.1-tem

# Switch Java version for current session
sdk use java 17.0.9-tem

# Set default Java version
sdk default java 21.0.1-tem

# Check current Java version
sdk current java
java --version
```

### Android Development
```bash
# Device management
adb devices
adb logcat
adb install app.apk

# Emulator operations
emulator -list-avds
emulator -avd Pixel_4_API_34

# Build operations
./gradlew assembleDebug
./gradlew installDebug

# Framework-specific
npx react-native run-android
flutter devices && flutter run
```

---

## 🔄 Android SDK Synchronization

### Automatic Windows Integration
The script intelligently detects and synchronizes with Windows Android Studio:

**✅ If Windows Android Studio is detected:**
- Creates symbolic link to Windows SDK
- Shares AVDs, system images, and tools
- Maintains single source of truth
- No duplicate downloads

**✅ If Windows Android Studio not found:**
- Installs standalone Android SDK in WSL
- Downloads essential components
- Sets up independent environment

### Manual Sync Management
```bash
# Check current setup
ls -la ~/Android/Sdk

# Revert to WSL-only SDK
rm ~/Android/Sdk
mv ~/Android/Sdk.backup ~/Android/Sdk

# Re-run synchronization
./setup-wsl-dev.sh
```

---

## ⚡ Complete Alias Reference

### System Navigation
```bash
ll          # ls -alF (detailed list)
la          # ls -A (show hidden files)
l           # ls -CF (compact list)
..          # cd .. (go up one directory)
...         # cd ../.. (go up two directories)
....        # cd ../../.. (go up three directories)
back        # cd $OLDPWD (previous directory)
home        # cd ~ (home directory)
root        # cd / (root directory)
```

### File Management
```bash
# Directory operations
md          # mkdir -p (create directories)
rd          # rmdir (remove empty directory)
rf          # rm -rf (remove recursively)
mkcd        # create directory and cd into it

# File operations
cp          # cp -i (copy with confirmation)
mv          # mv -i (move with confirmation)  
rm          # rm -i (remove with confirmation)
find        # find . -name (search files)
size        # du -sh (show size)
count       # count files in directory

# Permissions
+x          # chmod +x (make executable)
755         # chmod 755 (executable permissions)
644         # chmod 644 (file permissions)
```

### Content Viewing
```bash
cat         # cat -n (with line numbers)
less        # less -R (with colors)
head        # head -n 20 (first 20 lines)
tail        # tail -n 20 (last 20 lines)
tf          # tail -f (follow file changes)
grep        # grep --color=auto (colored search)
tree        # tree -C (colored directory tree)
```

### Archive Management
```bash
tarzip      # tar -czf (create tar.gz)
untar       # tar -xzf (extract tar.gz)
zip         # zip -r (create zip archive)
unzip       # unzip (extract zip)
```

### Git Operations
```bash
gs          # git status
ga          # git add
gc          # git commit
gp          # git push
gl          # git pull
gd          # git diff
gb          # git branch
gco         # git checkout
```

### Docker Management
```bash
dps         # docker ps
dpa         # docker ps -a
di          # docker images
dsp         # docker system prune
dc          # docker-compose
dcu         # docker-compose up
dcd         # docker-compose down
dcb         # docker-compose build
```

### Node.js Development
```bash
nrs         # npm run start
nrd         # npm run dev
nrb         # npm run build
nrt         # npm run test
ni          # npm install
nid         # npm install --save-dev
nig         # npm install -g
```

### Java Development & Management
```bash
# Java version management (SDKMAN!)
java-list       # sdk list java
java-install    # sdk install java [version]
java-use        # sdk use java [version] (current session)
java-default    # sdk default java [version] (permanent)
java-current    # sdk current java
gradle-list     # sdk list gradle
gradle-install  # sdk install gradle [version] 
gradle-use      # sdk use gradle [version]
```

### Android Development
```bash
# ADB Operations (Windows-integrated)
adb-devices     # adb devices
adb-logcat      # adb logcat
adb-install     # adb install
adb-uninstall   # adb uninstall
adb-shell       # adb shell
adb-push        # adb push
adb-pull        # adb pull
adb-restart     # restart ADB server

# Build & Deployment
gradle-clean    # ./gradlew clean
gradle-build    # ./gradlew build
gradle-debug    # ./gradlew assembleDebug
gradle-release  # ./gradlew assembleRelease
gradle-install  # ./gradlew installDebug

# Framework Integration
react-android   # npx react-native run-android
flutter-devices # flutter devices
flutter-run     # flutter run
flutter-build   # flutter build apk
flutter-clean   # flutter clean

# SDK Management (Windows-integrated)
sdk-update      # sdkmanager --update
sdk-list        # sdkmanager --list

# Emulator (Windows Android Studio required)
emulator-list   # List available AVDs
emulator-start  # Reminder to use Windows Android Studio
```

---

## 🔧 Troubleshooting

### Common Issues

#### Oh My Zsh Not Loading
```bash
# Check default shell
echo $SHELL

# Change to zsh if needed
chsh -s $(which zsh)
# Restart terminal
```

#### Docker Permission Denied
```bash
# Verify docker group membership
groups $USER

# Restart WSL completely
wsl --shutdown && wsl
```

#### NVM Command Not Found
```bash
# Reload shell configuration
source ~/.zshrc
# Or restart terminal
exec zsh
```

#### Python Build Issues
```bash
# Install build dependencies (usually already handled)
sudo apt update
sudo apt install -y build-essential libssl-dev zlib1g-dev
```

#### Android SDK Issues
```bash
# Check environment variables
echo $ANDROID_HOME
echo $ANDROID_SDK_ROOT
echo $JAVA_HOME

# Restart ADB if needed
adb kill-server && adb start-server

# Revert to WSL-only SDK
rm ~/Android/Sdk && mv ~/Android/Sdk.backup ~/Android/Sdk
```

#### Gradle Build Failures
```bash
# Clean and rebuild
./gradlew clean
./gradlew build --refresh-dependencies

# Check Java version (should be 17+)
java --version
```

#### Android Studio WSL2 GUI Issues
```bash
# Check X11 connection
echo $DISPLAY
display-check

# Reset display configuration
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0

# Test basic GUI
xeyes  # Should open a GUI application

# Restart X11 server on Windows if GUI not working
# Make sure Windows Defender/Firewall isn't blocking X11 server
```

#### Android Emulator Issues in WSL2
```bash
# Check emulator configuration
emulator -list-avds

# Start emulator with software rendering
android-emulator Pixel_7_API_34_WSL

# If emulator fails to start, check hardware acceleration
cat ~/.android/avd/*/config.ini | grep hw.gpu

# Alternative: Use Windows emulator with WSL2 ADB
# 1. Start emulator in Windows Android Studio
# 2. Connect from WSL2: adb connect localhost:5555
```

#### Display Resolution Issues
```bash
# Adjust display scaling
export GDK_SCALE=1.5
export QT_SCALE_FACTOR=1.5

# Or disable scaling
export GDK_SCALE=1
export QT_SCALE_FACTOR=1

# Restart Android Studio
android-studio
```

### Performance & Best Practices
- Use `docker system prune` regularly to clean up Docker resources
- Run `sdk-update` periodically for Android SDK updates  
- Use `nvm use` to switch Node versions per project
- Use `sdk use java` to switch Java versions per project
- **For Android emulators**: Always use Windows Android Studio for best performance
- **ADB tip**: Start Windows emulator first, then WSL development commands
- Enable WSL2 for optimal performance and Docker support

---

## 🎨 Customization

### Adding Java/Gradle Project Support
```bash
# Set Java version for specific project
echo "21.0.1-tem" > .sdkmanrc  # SDKMAN! will auto-switch
gradle init --type java-application

# Or for Android project
echo "21.0.1-tem" > .sdkmanrc
npx react-native init MyApp
# or
flutter create myapp
```

### Configuring Android Development
```bash
# Set up Android project for WSL development
# In your Android project root:
echo "sdk.dir=/mnt/c/Users/$USER/AppData/Local/Android/Sdk" >> local.properties

# For React Native projects:
echo 'export ANDROID_HOME="/mnt/c/Users/$USER/AppData/Local/Android/Sdk"' >> ~/.zshrc

# For Flutter projects:
flutter config --android-sdk "/mnt/c/Users/$USER/AppData/Local/Android/Sdk"
```

### Installing Additional Oh My Zsh Plugins
```bash
# Example: Install additional plugins (some already included)
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

# Update .zshrc plugins line
plugins=(git node npm docker python pyenv zsh-autosuggestions zsh-syntax-highlighting zsh-completions)
```

### Adding Custom Aliases
```bash
# Edit your .zshrc file  
echo 'alias myproject="cd ~/projects/my-app"' >> ~/.zshrc
echo 'alias serve="python -m http.server 8000"' >> ~/.zshrc
source ~/.zshrc
```

### Configuring Git Further
```bash
# Set up signing (optional)
git config --global user.signingkey YOUR_GPG_KEY
git config --global commit.gpgsign true

# Set default branch
git config --global init.defaultBranch main
```

---

## 📚 Additional Resources

### Official Documentation
- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Oh My Zsh Documentation](https://ohmyz.sh/)
- [NVM Documentation](https://github.com/nvm-sh/nvm)
- [Docker Documentation](https://docs.docker.com/)
- [pyenv Documentation](https://github.com/pyenv/pyenv)
- [GitHub CLI Documentation](https://cli.github.com/)
- [SDKMAN! Documentation](https://sdkman.io/)
- [Android Developer Documentation](https://developer.android.com/)
- [Gradle Documentation](https://gradle.org/guides/)
- [React Native Environment Setup](https://reactnative.dev/docs/environment-setup)
- [Flutter Development Setup](https://flutter.dev/docs/get-started)

### Community & Learning
- [React Native Getting Started](https://reactnative.dev/docs/environment-setup)
- [Flutter Development Setup](https://flutter.dev/docs/get-started)
- [Docker Best Practices](https://docs.docker.com/develop/best-practices/)

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### Ways to Contribute
- 🐛 **Bug Reports** - Found an issue? Let us know!
- 💡 **Feature Requests** - Have ideas for improvements?
- 📖 **Documentation** - Help improve our guides
- 🧪 **Testing** - Test on different systems and configurations
- 💻 **Code** - Submit pull requests with improvements

### Development Process
1. **Fork** the repository
2. **Create** feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** changes (`git commit -m 'Add amazing feature'`)
4. **Push** to branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Guidelines
- Test your changes thoroughly
- Update documentation as needed
- Follow existing code style
- Add comments for complex logic

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🚨 Important Notes & Limitations

### Android Development Considerations
- **Emulator GUI Limitation**: WSL doesn't support Android emulator GUI due to graphics restrictions
- **Recommended Workflow**: Use Windows Android Studio for emulators + WSL for development
- **ADB Integration**: Seamless connection between Windows emulators and WSL ADB commands
- **Hardware Acceleration**: Only available through Windows Android Studio emulators

### System Requirements
- Windows 10/11 with WSL2 (WSL1 not supported for optimal experience)
- At least 8GB RAM recommended (4GB minimum)
- SSD storage recommended for better performance
- Windows Android Studio installation recommended for full Android development

### Script Safety
- This script modifies system configuration files
- Always review scripts before running them  
- Backup important data before installation
- Some changes require terminal restart to take effect
- Docker may need WSL restart to function properly

---

## ⭐ Support the Project

If this setup helped you become more productive, consider:
- ⭐ **Starring** the repository
- 🍴 **Forking** for your own modifications  
- 📢 **Sharing** with other developers
- 🐛 **Reporting** issues you encounter
- 💡 **Suggesting** new features

---

<div align="center">

**Made with ❤️ for the developer community**

[Report Bug](https://github.com/hiurimendes/dev-setup-wsl/issues) · [Request Feature](https://github.com/hiurimendes/dev-setup-wsl/issues) · [Contribute](https://github.com/hiurimendes/dev-setup-wsl/pulls)

---

*Transform your WSL into a powerhouse development environment in minutes!*

</div>
