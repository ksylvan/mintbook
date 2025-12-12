# Troubleshooting

Common issues and how to fix them.

---

## Installation Issues

### Can't see the EFI Boot option when holding Option key

**Symptoms:** Only see the Mac hard drive, no USB option

**Solutions:**
1. Make sure the USB drive is fully inserted
2. Try a different USB port
3. Recreate the bootable USB — it may not have been created correctly
4. Try holding Option key *before* pressing the power button

### Black screen after selecting "Start Linux Mint"

**Symptoms:** Screen goes black and nothing happens

**Solutions:**
1. Wait 2-3 minutes — sometimes it takes a while
2. Try selecting "Start Linux Mint (compatibility mode)" instead
3. If using a 15" MacBook with discrete GPU, you may need `nomodeset`:
   - At the boot menu, press `e` to edit
   - Find the line starting with `linux`
   - Add `nomodeset` before `quiet splash`
   - Press F10 to boot

### Installation hangs or freezes

**Solutions:**
1. Ensure your phone is connected for internet (some packages download during install)
2. Wait longer — some steps take 10+ minutes
3. If truly frozen, hold power button 10 seconds, restart, and try again

---

## WiFi Issues

### WiFi doesn't work after installation

This is expected! See [Part 5 of the Installation Guide](INSTALL.md#part-5-fix-wifi).

**Quick fix:**
1. Connect phone via USB tethering
2. Menu → Driver Manager
3. Select Broadcom driver → Apply
4. Restart

### WiFi stopped working after an update

**Solutions:**
1. Connect phone via USB tethering
2. Open Driver Manager (Menu → Driver Manager)
3. The Broadcom driver may need to be reapplied
4. Select it and click "Apply Changes"
5. Restart

### WiFi is slow or drops frequently

**Solutions:**
1. Check if you're on 2.4GHz or 5GHz — try switching
2. Move closer to the router
3. Check for interference from other devices
4. Try disabling power management:
   ```bash
   sudo sed -i 's/wifi.powersave = 3/wifi.powersave = 2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
   sudo systemctl restart NetworkManager
   ```

### "No WiFi Adapter Found"

**Solutions:**
1. Open Terminal (Ctrl + Alt + T) and run:
   ```bash
   lspci | grep -i broadcom
   ```
2. If you see the Broadcom chip listed, the driver isn't loaded:
   ```bash
   sudo modprobe wl
   ```
3. If that works, make it permanent:
   ```bash
   echo "wl" | sudo tee -a /etc/modules
   ```

---

## USB Tethering Issues

### iPhone not connecting

**Solutions:**
1. Make sure Personal Hotspot is ON
2. Unlock your iPhone and tap "Trust" when prompted
3. Try unplugging and replugging
4. Restart the iPhone
5. Try a different cable

### Android not connecting

**Solutions:**
1. Make sure "USB Tethering" is enabled (not WiFi Hotspot)
2. Try "File Transfer" or "MTP" mode first, then enable USB Tethering
3. Some phones need developer options enabled
4. Try a different cable

---

## Display Issues

### Screen resolution looks wrong

**Solutions:**
1. Menu → Preferences → Display
2. Choose your desired resolution
3. Click Apply

### HiDPI/Retina display too small

**Solutions:**
1. Menu → Preferences → General
2. Find "User interface scaling" and set to 2x (or 1.5x)
3. Log out and back in

### Screen brightness keys not working

The brightness keys usually work out of the box, but if not:
1. Use the brightness slider: Menu → Preferences → Brightness
2. Or install `pommed`:
   ```bash
   sudo apt install pommed
   ```

---

## Audio Issues

### No sound

**Solutions:**
1. Click the speaker icon in the system tray
2. Make sure volume isn't muted
3. Check output device: Menu → Sound → Output tab
4. Try selecting a different output device
5. Restart PulseAudio:
   ```bash
   pulseaudio -k && pulseaudio --start
   ```

### Headphones not detected

**Solutions:**
1. Unplug and replug headphones
2. Check Menu → Sound → Output for headphone option
3. Some MacBook audio quirks require:
   ```bash
   sudo apt install linux-firmware
   ```

---

## Keyboard Issues

### Function keys not working as expected

**Solutions:**
1. By default, F1-F12 act as media keys
2. To use as standard function keys, hold `Fn` while pressing
3. To swap this behavior:
   ```bash
   echo "options hid_apple fnmode=2" | sudo tee /etc/modprobe.d/hid_apple.conf
   sudo update-initramfs -u
   ```
   Then restart.

### @ and " keys swapped (UK layout issue)

**Solutions:**
1. Menu → Keyboard → Layouts tab
2. Make sure you have the correct layout (US vs UK)
3. Remove incorrect layout and add correct one

---

## Trackpad Issues

### Trackpad not responsive or jumpy

**Solutions:**
1. Menu → Preferences → Mouse and Touchpad
2. Adjust sensitivity and acceleration
3. Enable/disable "Tap to click" based on preference

### Two-finger scrolling not working

**Solutions:**
1. Menu → Preferences → Mouse and Touchpad
2. Check "Two-finger scrolling" is enabled
3. Adjust scrolling speed if needed

### Natural scrolling (like macOS)

**Solutions:**
1. Menu → Preferences → Mouse and Touchpad
2. Check "Reverse scrolling direction"

---

## Performance Issues

### System feels slow

**Solutions:**
1. Check what's using resources: Menu → System Monitor
2. Close unnecessary applications
3. Reduce visual effects:
   - Menu → Effects → Turn off effects
4. Check for stuck processes:
   ```bash
   top
   ```
   Press `q` to exit.

### High CPU usage

**Solutions:**
1. Open System Monitor and check which process is using CPU
2. If it's `tracker-miner-fs`, it's indexing files (will stop eventually)
3. If it's `apt` or `dpkg`, updates are being installed

### Fan running constantly

**Solutions:**
1. Install `mbpfan` for better fan control:
   ```bash
   sudo apt install mbpfan
   sudo systemctl enable mbpfan
   sudo systemctl start mbpfan
   ```
2. Check for runaway processes in System Monitor

---

## Boot Issues

### "Grub" menu appears instead of booting normally

This is normal! GRUB is the bootloader. Linux Mint should be auto-selected. Just wait 5 seconds or press Enter.

To hide GRUB:
1. Edit `/etc/default/grub`
2. Change `GRUB_TIMEOUT=10` to `GRUB_TIMEOUT=0`
3. Run `sudo update-grub`

### Boots to black screen

**Solutions:**
1. At GRUB menu, press `e` to edit
2. Add `nomodeset` to the linux line
3. Press F10 to boot
4. If that works, make it permanent:
   ```bash
   sudo nano /etc/default/grub
   # Add nomodeset to GRUB_CMDLINE_LINUX_DEFAULT
   sudo update-grub
   ```

---

## Recovery

### Forgot password

**Solutions:**
1. Boot from the USB drive again (live mode)
2. Open Terminal and mount your Linux partition:
   ```bash
   sudo mount /dev/sda2 /mnt  # May be different device
   sudo chroot /mnt
   passwd your_username
   exit
   sudo umount /mnt
   ```
3. Restart without USB

### System won't boot at all

**Solutions:**
1. Boot from USB drive in live mode
2. Your files should still be accessible on the hard drive
3. Back up important files to external drive
4. Reinstall Linux Mint if necessary

### Need to restore from Timeshift backup

1. Boot from USB drive
2. Install Timeshift in live session:
   ```bash
   sudo apt update && sudo apt install timeshift
   ```
3. Open Timeshift and select your backup
4. Click Restore

---

## Getting More Help

If your issue isn't listed here:

1. **Search the forums:** [forums.linuxmint.com](https://forums.linuxmint.com)
2. **Check Ask Ubuntu:** [askubuntu.com](https://askubuntu.com) (most solutions work for Mint)
3. **Search with your error message:** Google the exact error text
4. **Open an issue:** [github.com/YOUR_USERNAME/mintbook/issues](https://github.com/YOUR_USERNAME/mintbook/issues)

When asking for help, include:
- Your MacBook model (e.g., MacBookPro11,1)
- Linux Mint version (Menu → About This Computer)
- What you were doing when the problem occurred
- Any error messages (exact text or screenshots)
