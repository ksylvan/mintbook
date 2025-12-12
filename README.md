# 🍃 mintbook

> Give your old MacBook Pro a second life with Linux Mint.

**mintbook** is an automated setup guide and installer script for running Linux Mint on 2013-2015 MacBook Pros. Perfect for turning that dusty old Mac into a fast, modern, daily-driver laptop.

![License](https://img.shields.io/badge/license-MIT-green)
![macOS](https://img.shields.io/badge/prep-macOS-blue)
![Linux Mint](https://img.shields.io/badge/install-Linux%20Mint%2022.2-87CF3E)

---

## ✨ What You Get

- **Automated USB creation** — Downloads Linux Mint, verifies integrity, and creates a bootable USB
- **Step-by-step guidance** — Interactive prompts walk you through everything
- **WiFi fix included** — Handles the notorious Broadcom BCM4360 driver setup
- **Phone tethering guide** — Use your phone for internet anywhere
- **Non-technical friendly** — Written for smart people who don't want to mess with terminals

## 🎯 Supported Hardware

| Model | Identifier | Status |
|-------|------------|--------|
| MacBook Pro 13" (Late 2013) | MacBookPro11,1 | ✅ Tested |
| MacBook Pro 13" (Mid 2014) | MacBookPro11,1 | ✅ Should work |
| MacBook Pro 15" (Late 2013) | MacBookPro11,2/11,3 | ⚠️ Untested |
| MacBook Pro 13" (Early 2015) | MacBookPro12,1 | ⚠️ Untested |
| MacBook Air (2013-2015) | Various | ⚠️ Untested |

> **Note:** Models with Intel Iris graphics (no discrete GPU) have the smoothest experience.

## 🚀 Quick Start

### On your Mac (to create the bootable USB)

```bash
# Download the script
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/mintbook/main/scripts/setup.sh -o setup.sh

# Make it executable
chmod +x setup.sh

# Run it
./setup.sh
```

The script will:

1. Install required tools via Homebrew
2. Download Linux Mint 22.2 "Zara" (~3GB)
3. Verify the download checksum
4. Guide you through creating the bootable USB

### On the MacBook Pro (to install Linux)

1. Shut down completely
2. Insert the USB drive
3. Power on while holding **Option (⌥)**
4. Select **EFI Boot**
5. Follow the on-screen installer

📖 **[Full Installation Guide →](docs/INSTALL.md)**

## 📁 What's Inside

```text
mintbook/
├── README.md              # You are here
├── scripts/
│   └── setup.sh           # Automated setup script
└── docs/
    ├── INSTALL.md         # Detailed installation guide
    ├── QUICK-REFERENCE.md # Printable cheat sheet
    └── TROUBLESHOOTING.md # Common issues & fixes
```

## 🛠 Requirements

**To create the USB (on any Mac):**

- macOS 10.15+
- 8GB+ USB flash drive
- ~4GB free disk space
- Internet connection

**Target MacBook Pro:**

- 2013-2015 MacBook Pro (Intel)
- 8GB RAM recommended (4GB minimum)
- iPhone or Android phone (for initial internet)

## 💡 Why Linux Mint?

We chose Linux Mint Cinnamon because:

- **Familiar interface** — Taskbar, start menu, system tray (no learning curve)
- **Everything included** — Browser, office suite, media player out of the box
- **Rock solid** — Based on Ubuntu LTS, supported until 2029
- **Hardware friendly** — Best driver support for older Macs
- **Non-technical friendly** — GUI tools for everything, terminal optional

## 📊 Performance Comparison

| Metric | macOS (OCLP) | Linux Mint |
|--------|--------------|------------|
| Boot time | ~45 sec | ~12 sec |
| Idle RAM | ~3.5 GB | ~800 MB |
| Battery life | Good | Good (with TLP) |
| Responsiveness | Sluggish | Snappy |

(Results from MacBook Pro 11,1 with 8GB RAM)

> **Note:** OCLP (OpenCore Legacy Patcher) allows running newer macOS versions on unsupported Macs.

## 🤝 Contributing

Found a bug? Have a suggestion? PRs welcome!

- 🐛 [Report an issue](https://github.com/YOUR_USERNAME/mintbook/issues)
- 💡 [Request a feature](https://github.com/YOUR_USERNAME/mintbook/issues)
- 🔧 [Submit a PR](https://github.com/YOUR_USERNAME/mintbook/pulls)

### Tested on different hardware?

Please open an issue or PR to update the compatibility table!

## 📜 License

MIT License — do whatever you want with it.

## 🙏 Acknowledgments

- [Linux Mint](https://linuxmint.com/) team for an amazing distro
- The countless forum posts about Broadcom WiFi drivers
- Everyone keeping old hardware alive

---

<p align="center">
  <i>Made with 🐧 for old Macs everywhere</i>
</p>
