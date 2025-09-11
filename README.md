# WSL Ubuntu Web Development Setup 🚀

<div align="center">

![WSL](https://img.shields.io/badge/WSL-Ubuntu-orange?style=for-the-badge&logo=ubuntu)
![Node.js](https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![Git](https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white)

*One-command setup for the perfect WSL Ubuntu web development environment*

</div>

## 📋 What's Included

This automated setup script configures a complete web development environment on WSL Ubuntu with:

- 🐚 **Oh My Zsh** - Enhanced terminal with useful plugins
- 📦 **NVM** - Node Version Manager with latest LTS Node.js
- 🐳 **Docker** - Containerization platform with Docker Compose
- 🐍 **pyenv** - Python version manager with latest stable Python
- 📝 **Git** - Version control with sensible configurations
- 🐙 **GitHub CLI** - Command-line interface for GitHub
- ⚡ **Useful aliases** - Time-saving shortcuts for common tasks

## 🚀 Quick Start

### Prerequisites

- Windows 10/11 with WSL2 enabled
- Ubuntu distribution installed in WSL

### One-Command Installation

```bash
curl -fsSL https://raw.githubusercontent.com/your-username/wsl-ubuntu-setup/main/setup-wsl-dev.sh | bash
```

### Manual Installation

1. **Clone this repository:**
   ```bash
   git clone https://github.com/your-username/wsl-ubuntu-setup.git
   cd wsl-ubuntu-setup
   ```

2. **Make the script executable:**
   ```bash
   chmod +x setup-wsl-dev.sh
   ```

3. **Run the setup script:**
   ```bash
   ./setup-wsl-dev.sh
   ```

## 🔧 Post-Installation Steps

After the script completes:

1. **Restart your terminal** or run:
   ```bash
   exec zsh
   ```

2. **Restart WSL** (if needed for Docker):
   ```bash
   # In Windows PowerShell/CMD
   wsl --shutdown
   wsl
   ```

3. **Authenticate with GitHub:**
   ```bash
   gh auth login
   ```

4. **Verify installations:**
   ```bash
   node --version
   python --version
   docker --version
   docker-compose --version
   ```

## 📚 Installed Tools Overview

### Oh My Zsh Configuration

The script sets up Oh My Zsh with these plugins:
- `git` - Git aliases and branch info
- `node` - Node.js completion
- `npm` - NPM completion
- `docker` - Docker completion
- `docker-compose` - Docker Compose completion
- `python` - Python completion
- `pyenv` - pyenv integration
- `zsh-autosuggestions` - Command suggestions
- `zsh-syntax-highlighting` - Syntax highlighting

### Node.js with NVM

```bash
# Install latest LTS Node.js
nvm install --lts
nvm use --lts

# Install specific Node.js version
nvm install 18.17.0
nvm use 18.17.0

# List installed versions
nvm list
```

### Python with pyenv

```bash
# List available Python versions
pyenv install --list

# Install specific Python version
pyenv install 3.11.5

# Set global Python version
pyenv global 3.11.5

# Set local Python version for project
pyenv local 3.9.0
```

### Docker Usage

```bash
# Basic Docker commands
docker run hello-world
docker ps
docker images

# Docker Compose
docker-compose up -d
docker-compose down
docker-compose logs
```

## ⚡ Included Aliases

### Git Aliases
```bash
gs     # git status
ga     # git add
gc     # git commit
gp     # git push
gl     # git pull
gd     # git diff
gb     # git branch
gco    # git checkout
```

### Docker Aliases
```bash
dps    # docker ps
dpa    # docker ps -a
di     # docker images
dsp    # docker system prune
dc     # docker-compose
dcu    # docker-compose up
dcd    # docker-compose down
dcb    # docker-compose build
```

### Node/NPM Aliases
```bash
nrs    # npm run start
nrd    # npm run dev
nrb    # npm run build
nrt    # npm run test
ni     # npm install
nid    # npm install --save-dev
nig    # npm install -g
```

### System & Navigation Aliases
```bash
ll     # ls -alF
la     # ls -A
l      # ls -CF
..     # cd ..
...    # cd ../..
....   # cd ../../..
back   # cd $OLDPWD (go back to previous directory)
home   # cd ~ (go to home directory)
root   # cd / (go to root directory)
```

### File & Directory Management Aliases
```bash
# Directory operations
md     # mkdir -p (create directories with parent directories)
rd     # rmdir (remove empty directory)
rf     # rm -rf (remove directory and contents recursively)
mkcd   # create directory and cd into it

# File operations
cp     # cp -i (copy with confirmation)
mv     # mv -i (move with confirmation)
rm     # rm -i (remove with confirmation)
touch  # create empty file
find   # find . -name (search for files by name)
size   # du -sh (show directory/file size)
count  # count files in current directory

# File permissions
+x     # chmod +x (make executable)
755    # chmod 755 (executable permissions)
644    # chmod 644 (regular file permissions)
```

### File Viewing & Content Aliases
```bash
cat    # cat -n (with line numbers)
less   # less -R (with colors)
head   # head -n 20 (first 20 lines)
tail   # tail -n 20 (last 20 lines)
tf     # tail -f (follow file changes)
grep   # grep --color=auto (with colors)
tree   # tree -C (colorized directory tree)
du     # du -h (human readable disk usage)
df     # df -h (human readable filesystem usage)
```

### Archive Management Aliases
```bash
tarzip # tar -czf (create tar.gz archive)
untar  # tar -xzf (extract tar.gz archive)
zip    # zip -r (create zip archive recursively)
unzip  # unzip (extract zip archive)
```

## 🛠️ Customization

### Adding More Oh My Zsh Plugins

Edit your `~/.zshrc` file:
```bash
plugins=(git node npm docker docker-compose python pyenv zsh-autosuggestions zsh-syntax-highlighting your-new-plugin)
```

### Configuring Git

The script will prompt for your Git credentials, but you can also configure manually:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Adding Custom Aliases

Add to your `~/.zshrc` file:
```bash
# Custom aliases
alias myproject='cd ~/projects/my-awesome-project'
alias serve='python -m http.server 8000'
```

## 🔍 Troubleshooting

### Docker Permission Issues
```bash
# Add your user to the docker group (already done by script)
sudo usermod -aG docker $USER

# Restart WSL
wsl --shutdown
wsl
```

### NVM Not Found After Installation
```bash
# Reload your shell configuration
source ~/.zshrc
# or restart your terminal
```

### Python/pyenv Issues
```bash
# Install Python build dependencies (already done by script)
sudo apt update
sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev
```

### Oh My Zsh Not Loading
```bash
# Check if zsh is your default shell
echo $SHELL

# If not, change it
chsh -s $(which zsh)
```

## 📖 Additional Resources

- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Oh My Zsh Documentation](https://ohmyz.sh/)
- [NVM Documentation](https://github.com/nvm-sh/nvm)
- [Docker Documentation](https://docs.docker.com/)
- [pyenv Documentation](https://github.com/pyenv/pyenv)
- [GitHub CLI Documentation](https://cli.github.com/)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⭐ Star History

If this project helped you, please consider giving it a star! ⭐

## 🚨 Disclaimer

This script modifies your system configuration. While it's designed to be safe, please review the code before running it on your system. Always backup important data before running system modification scripts.

---

<div align="center">

**Made with ❤️ for the developer community**

[Report Bug](https://github.com/hiurimendes/dev-setup-wsl/issues) · [Request Feature](https://github.com/hiurimendes/dev-setup-wsl/issues) · [Contribute](https://github.com/hiurimendes/dev-setup-wsl/pulls)

</div>
