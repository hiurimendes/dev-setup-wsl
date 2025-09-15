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
- ☕ **SDKMAN! + Java 21** - Java version manager with latest LTS Java
- 🏗️ **Gradle** - Modern build automation tool

### Mobile Development
- 🤖 **Android SDK** - Complete Android development environment
- 📱 **ADB Tools** - Android Debug Bridge utilities
- 🔄 **Windows Sync** - Automatic synchronization with Windows Android Studio

### Developer Experience
- ⚡ **100+ Aliases** - Time-saving shortcuts for all tools
- 🎨 **Syntax Highlighting** - Enhanced terminal experience  
- 💡 **Auto-suggestions** - Intelligent command completion

---

## 🚀 Quick Installation

### One-Command Setup
```bash
curl -fsSL https://raw.githubusercontent.com/hiurimendes/dev-setup-wsl/main/setup-wsl-dev.sh | bash
```

### Manual Installation
```bash
# Clone the repository
git clone https://github.com/hiurimendes/dev-setup-wsl.git
cd dev-setup-wsl

# Make executable and run
chmod +x setup-wsl-dev.sh
./setup-wsl-dev.sh
```

---

## 📋 Prerequisites

- Windows 10/11 with **WSL2** enabled
- **Ubuntu** distribution installed in WSL
- Basic terminal knowledge

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

### Java Development
```bash
# List available Java versions
sdk list java

# Install specific Java version
sdk install java 21.0.1-tem
sdk install java 17.0.9-tem
sdk install java 11.0.21-tem

# Switch Java version for current session
sdk use java 21.0.1-tem

# Set default Java version
sdk default java 21.0.1-tem

# Check current Java version
sdk current java
java --version

# Update SDKMAN! itself
sdk update
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

## ☕ Java Version Management with SDKMAN!

SDKMAN! is a powerful tool for managing multiple Java versions. This setup installs Java 21 by default, which is required for modern Android development and applications.

### Common Java Version Commands
```bash
# List all available Java versions
java-list

# Install a specific Java version
java-install 21.0.1-tem
java-install 17.0.9-tem

# Switch Java version for current session
java-use 21.0.1-tem

# Set default Java version globally
java-default 21.0.1-tem

# Check current active Java version
java-current
java-version
```

### Why Java 21?
- **Latest LTS**: Long-term support with enhanced performance
- **Android Compatibility**: Required for latest Android SDK tools
- **Modern Features**: Improved garbage collection and language features
- **Security**: Latest security patches and improvements

### Managing Multiple Java Versions
```bash
# Install multiple versions for different projects
sdk install java 21.0.1-tem    # Latest LTS
sdk install java 17.0.9-tem    # Previous LTS
sdk install java 11.0.21-tem   # Legacy LTS

# Project-specific Java version (per terminal session)
cd my-java-17-project
sdk use java 17.0.9-tem

cd my-java-21-project  
sdk use java 21.0.1-tem

# Check which version is active
sdk current java
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

### Android Development
```bash
# ADB Operations
adb-devices     # adb devices
adb-logcat      # adb logcat
adb-install     # adb install
adb-uninstall   # adb uninstall
adb-shell       # adb shell
adb-push        # adb push
adb-pull        # adb pull
adb-restart     # restart ADB server

# Build & Emulator
emulator-list   # list available AVDs
emulator-start  # start emulator
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

# SDK Management
sdk-update      # sdkmanager --update
sdk-list        # sdkmanager --list

# Java Version Management (SDKMAN!)
java-list       # sdk list java
java-install    # sdk install java
java-use        # sdk use java
java-default    # sdk default java
java-current    # sdk current java
java-version    # java --version
sdkman-update   # sdk update
sdkman-version  # sdk version
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

# Check Java version (should be 21+)
java --version
sdk current java

# Switch to correct Java version if needed
sdk use java 21.0.1-tem
```

#### SDKMAN! Issues
```bash
# Reload SDKMAN! environment
source ~/.sdkman/bin/sdkman-init.sh

# Update SDKMAN! itself
sdk update

# Check SDKMAN! installation
sdk version

# List installed Java versions
sdk list java
```

### Performance Tips
- Use `docker system prune` regularly to clean up Docker
- Run `sdk-update` periodically for Android SDK updates
- Use `nvm use` to switch Node versions per project
- Enable WSL2 for better performance

---

## 🎨 Customization

### Adding Custom Aliases
```bash
# Edit your .zshrc file
echo 'alias myproject="cd ~/projects/my-app"' >> ~/.zshrc
echo 'alias serve="python -m http.server 8000"' >> ~/.zshrc
source ~/.zshrc
```

### Installing Additional Oh My Zsh Plugins
```bash
# Example: Install zsh-autosuggestions (already included)
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Update .zshrc plugins line
plugins=(git node npm docker python pyenv zsh-autosuggestions your-new-plugin)
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
- [Android Developer Documentation](https://developer.android.com/)
- [Gradle Documentation](https://gradle.org/guides/)

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

## 🚨 Important Notes

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
