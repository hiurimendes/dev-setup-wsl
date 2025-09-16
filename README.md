# WSL Ubuntu Development Setup 🚀

<div align="center">

![WSL](https://img.shields.io/badge/WSL-Ubuntu-orange?style=for-the-badge&logo=ubuntu)
![Node.js](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![Git](https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white)

*Complete automated setup for WSL Ubuntu development environment*

</div>

---

## 🎯 Overview

This script transforms your WSL Ubuntu into a powerful development environment with all essential tools pre-configured. Perfect for web development, backend services, and full-stack projects.

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

### Developer Experience
- ⚡ **Useful Aliases** - Time-saving shortcuts for all tools
- 🎨 **Syntax Highlighting** - Enhanced terminal experience  
- 💡 **Auto-suggestions** - Intelligent command completion

---

## 🚀 Quick Installation

```bash
curl -fsSL https://raw.githubusercontent.com/hiurimendes/dev-setup-wsl/main/setup.sh | bash
```

### Manual Installation
```bash
# Clone the repository
git clone https://github.com/hiurimendes/dev-setup-wsl.git
cd dev-setup-wsl

# Make executable and run
chmod +x setup.sh
./setup.sh
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

# Switch Java version
sdk use java 17.0.9-tem
sdk default java 21.0.1-tem

# Check current version
sdk current java
java --version
```



---

## ⚡ Key Aliases Reference

### System Navigation
```bash
ll          # ls -alF (detailed list)
..          # cd .. (go up directory)
...         # cd ../.. (go up two directories)
mkcd        # create directory and cd into it
```

### File Management
```bash
rf          # rm -rf (remove recursively)
+x          # chmod +x (make executable)
find        # find . -name (search files)
```

### Git Operations
```bash
gs          # git status
ga          # git add
gc          # git commit
gp          # git push
gl          # git pull
```

### Docker Management
```bash
dps         # docker ps
di          # docker images
dc          # docker-compose
dcu         # docker-compose up
```

### Node.js Development
```bash
nrs         # npm run start
nrd         # npm run dev
ni          # npm install
```

### Java Management
```bash
java-list       # sdk list java
java-use        # sdk use java [version]
java-current    # sdk current java
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



---

## 🎨 Customization

### Adding Custom Aliases
```bash
# Edit your .zshrc file  
echo 'alias myproject="cd ~/projects/my-app"' >> ~/.zshrc
source ~/.zshrc
```

### Installing Additional Oh My Zsh Plugins
```bash
# Example: Install additional plugins
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

# Update .zshrc plugins line
plugins=(git node npm docker python pyenv zsh-autosuggestions zsh-syntax-highlighting zsh-completions)
```

---

## 📚 Additional Resources

- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Oh My Zsh Documentation](https://ohmyz.sh/)
- [NVM Documentation](https://github.com/nvm-sh/nvm)
- [Docker Documentation](https://docs.docker.com/)
- [pyenv Documentation](https://github.com/pyenv/pyenv)
- [GitHub CLI Documentation](https://cli.github.com/)
- [SDKMAN! Documentation](https://sdkman.io/)

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

### System Requirements
- Windows 10/11 with WSL2 (WSL1 not supported)
- At least 4GB RAM recommended
- SSD storage recommended for better performance

### Script Safety
- This script modifies system configuration files
- Always review scripts before running them  
- Backup important data before installation
- Some changes require terminal restart to take effect

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

*Transform your WSL into a clean, efficient development environment!*

</div>
