# Installation Guide

Complete step-by-step instructions for installing Linux Mint on your MacBook Pro.

---

## Prerequisites

Before you begin, make sure you have:

- [ ] A 2013-2015 MacBook Pro (Intel-based)
- [ ] A USB flash drive (8GB or larger)
- [ ] Another Mac or PC to create the bootable USB
- [ ] Your iPhone or Android phone (for initial internet)
- [ ] USB cable for your phone
- [ ] About 45-60 minutes

## Part 1: Create Bootable USB

### Option A: Use the Automated Script (Recommended)

On your Mac (not the target MacBook):

```bash
# Download and run the setup script
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/mintbook/main/scripts/setup.sh -o setup.sh
chmod +x setup.sh
./setup.sh
```

The script handles everything automatically. Skip to [Part 2](#part-2-boot-from-usb).

### Option B: Manual Setup

If you prefer to do it manually:

#### 1. Download Linux Mint

Go to [linuxmint.com/download.php](https://linuxmint.com/download.php) and download:

- **Edition:** Cinnamon
- **Architecture:** 64-bit

Or use this direct link:

```bash
curl -L -o ~/Downloads/linuxmint-22.2-cinnamon-64bit.iso \
  "https://mirrors.kernel.org/linuxmint/stable/22.2/linuxmint-22.2-cinnamon-64bit.iso"
```

#### 2. Verify the Download

```bash
# Calculate checksum
shasum -a 256 ~/Downloads/linuxmint-22.2-cinnamon-64bit.iso

# Should output:
# 759c9b5a2ad26eb9844b24f7da1696c705ff5fe07924a749f385f435176c2306
```

#### 3. Create Bootable USB

Install and open balenaEtcher:

```bash
brew install --cask balenaetcher
open -a balenaEtcher
```

In balenaEtcher:

1. Click **Flash from file** → Select the downloaded ISO
2. Click **Select target** → Choose your USB drive
3. Click **Flash!**
4. Wait for completion

---

## Part 2: Boot from USB

1. **Shut down** the MacBook Pro completely

2. **Insert** the bootable USB drive

3. **Power on** and immediately press and **hold the Option (⌥) key**

4. **Keep holding** until you see a screen with drive icons (may take 20-30 seconds)

5. **Select** the orange/yellow drive labeled **"EFI Boot"**

6. **Press Enter** or click the arrow

7. From the boot menu, select **"Start Linux Mint"**

8. **Wait** 1-2 minutes for the desktop to load

You're now running Linux Mint from the USB drive! Nothing has been installed yet.

---

## Part 3: Connect to Internet

The MacBook's WiFi won't work until we install drivers. We'll use your phone for internet.

### iPhone USB Tethering

1. On your iPhone: **Settings → Personal Hotspot**

2. Turn on **"Allow Others to Join"**

3. Connect iPhone to MacBook with your **Lightning/USB cable**

4. On iPhone, tap **"Trust"** when asked "Trust This Computer?"

5. On the MacBook, click the **network icon** in the bottom-right corner

6. You should see a wired connection appear — click to connect

7. Verify by opening Firefox and visiting google.com

### Android USB Tethering

1. Connect your Android phone to MacBook with **USB cable**

2. On phone: **Settings → Network & Internet → Hotspot & Tethering**
   (Location varies by phone — search for "tethering" if needed)

3. Turn on **"USB tethering"**

4. On the MacBook, the connection should appear automatically

5. Verify by opening Firefox and visiting google.com

### Troubleshooting

- **No connection?** Try unplugging and re-plugging the phone
- **Still nothing?** Toggle USB tethering off and on
- **iPhone not showing "Trust"?** Unlock your phone first

---

## Part 4: Install Linux Mint

⚠️ **This will erase everything on the MacBook.** Back up any important data first.

1. **Double-click** the **"Install Linux Mint"** icon on the desktop

2. **Select your language** → Click Continue

3. **Select keyboard layout** (usually "English (US)") → Click Continue

4. **Check the box** for "Install multimedia codecs" → Click Continue

5. **Select "Erase disk and install Linux Mint"** → Click Install Now

6. **Confirm** by clicking Continue when asked about disk changes

7. **Click your timezone** on the map → Click Continue

8. **Create your user account:**
   - Your name: (e.g., "Sarah")
   - Computer name: (e.g., "macbook" or "laptop")
   - Username: lowercase, no spaces (e.g., "sarah")
   - Password: choose something memorable
   - Check "Require my password to log in"

9. **Click Continue** and wait 10-15 minutes

10. When complete, click **"Restart Now"**

11. **Remove the USB drive** when prompted, then press Enter

---

## Part 5: Fix WiFi

After restarting, you'll need to install the WiFi driver. This is a one-time setup.

1. **Log in** with the password you created

2. **Reconnect your phone** via USB tethering (same as Part 3)

3. Click the **Menu button** (bottom-left corner)

4. Type **"Driver Manager"** and open it

5. **Enter your password** when prompted

6. Wait for Driver Manager to scan your system

7. You should see an entry for **Broadcom wireless** (likely `bcmwl-kernel-source`)

8. **Check/select** the Broadcom driver

9. Click **"Apply Changes"**

10. Wait 2-5 minutes for download and installation

11. **Restart** the computer

12. After restart, click the **network icon** — you should now see WiFi networks!

13. **Connect to your WiFi** network

🎉 **Done!** You can now unplug your phone. WiFi works independently.

---

## Part 6: Post-Installation (Optional)

### Recommended Apps

Open **Menu → Software Manager** and search for:

| App | Purpose |
|-----|---------|
| VLC | Play any video/audio format |
| Timeshift | System backup/restore |
| Flameshot | Better screenshots |
| Visual Studio Code | Code editor |

### Enable Automatic Backups

1. Menu → Search "Timeshift" → Open
2. Select "RSYNC" as snapshot type
3. Choose your schedule (Weekly recommended)
4. Click Create to make your first snapshot

### Improve Battery Life

Battery life should be good out of the box, but you can install TLP for optimization:

```bash
sudo apt install tlp tlp-rdw
sudo tlp start
```

### Improve Fan Control (keep it quieter and cooler)

You can also install the fan control daemon for MacBooks (keeps it cooler/quieter)

```bash
sudo apt install mbpfan
sudo systemctl enable mbpfan
```

---

## What's Next?

- **[Quick Reference](QUICK-REFERENCE.md)** — Printable cheat sheet
- **[Troubleshooting](TROUBLESHOOTING.md)** — Common issues and fixes
- **[Linux Mint User Guide](https://linuxmint-user-guide.readthedocs.io/)** — Official docs

---

## Need Help?

- [Linux Mint Forums](https://forums.linuxmint.com/) — Friendly community
- [Ask Ubuntu](https://askubuntu.com/) — Most solutions apply to Mint too
- [Open an issue](https://github.com/YOUR_USERNAME/mintbook/issues) — We'll try to help!
