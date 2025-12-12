#!/bin/bash

#===============================================================================
# Linux Mint MacBook Pro Setup Script
# For: 2013 MacBook Pro 11,1 (13" Retina)
#
# This script guides you through setting up Linux Mint on an old MacBook Pro.
# Run this on your Mac (the one you're using to CREATE the bootable USB).
#===============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Linux Mint 22.2 Zara details
MINT_VERSION="22.2"
MINT_CODENAME="Zara"
MINT_ISO="linuxmint-${MINT_VERSION}-cinnamon-64bit.iso"
MINT_SIZE="3.0 GB"
MINT_SHA256="759c9b5a2ad26eb9844b24f7da1696c705ff5fe07924a749f385f435176c2306"

# Mirror URLs (fast US mirrors)
MIRRORS=(
    "https://mirrors.kernel.org/linuxmint/stable/${MINT_VERSION}/${MINT_ISO}"
    "https://mirror.fcix.net/linuxmint-images/stable/${MINT_VERSION}/${MINT_ISO}"
    "https://mirrors.seas.harvard.edu/linuxmint/stable/${MINT_VERSION}/${MINT_ISO}"
    "https://mirrors.ocf.berkeley.edu/linux-mint/stable/${MINT_VERSION}/${MINT_ISO}"
)

# Download directory
DOWNLOAD_DIR="$HOME/Downloads"
ISO_PATH="${DOWNLOAD_DIR}/${MINT_ISO}"

#-------------------------------------------------------------------------------
# Helper Functions
#-------------------------------------------------------------------------------

print_header() {
    clear
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                           ║"
    echo "║           🐧 Linux Mint MacBook Pro Setup Assistant 🍎                    ║"
    echo "║                                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
}

print_step() {
    echo ""
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${BLUE}  STEP $1: $2${NC}"
    echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ $1${NC}"
}

wait_for_enter() {
    echo ""
    echo -e "${BOLD}Press ENTER to continue...${NC}"
    read -r
}

wait_for_confirmation() {
    echo ""
    echo -e "${BOLD}$1 (y/n):${NC} "
    read -r response
    case "$response" in
        [yY][eE][sS]|[yY]) return 0 ;;
        *) return 1 ;;
    esac
}

#-------------------------------------------------------------------------------
# Check Prerequisites
#-------------------------------------------------------------------------------

check_macos() {
    if [[ "$(uname)" != "Darwin" ]]; then
        print_error "This script must be run on macOS."
        print_info "You're currently on: $(uname)"
        exit 1
    fi
    print_success "Running on macOS"
}

check_homebrew() {
    if ! command -v brew &> /dev/null; then
        print_warning "Homebrew not found. Installing..."
        echo ""
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add brew to path for Apple Silicon Macs
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        print_success "Homebrew installed"
    else
        print_success "Homebrew is installed"
    fi
}

check_and_install_tool() {
    local tool=$1
    local cask=$2

    if [[ "$cask" == "cask" ]]; then
        if ! brew list --cask "$tool" &> /dev/null; then
            print_info "Installing $tool..."
            brew install --cask "$tool"
            print_success "$tool installed"
        else
            print_success "$tool is already installed"
        fi
    else
        if ! command -v "$tool" &> /dev/null; then
            print_info "Installing $tool..."
            brew install "$tool"
            print_success "$tool installed"
        else
            print_success "$tool is already installed"
        fi
    fi
}

#-------------------------------------------------------------------------------
# Main Script Sections
#-------------------------------------------------------------------------------

show_welcome() {
    print_header

    echo -e "Welcome! This script will help you create a bootable Linux Mint USB"
    echo -e "drive for installing on your 2013 MacBook Pro."
    echo ""
    echo -e "${BOLD}What we'll do:${NC}"
    echo "  1. Install required tools (via Homebrew)"
    echo "  2. Download Linux Mint ${MINT_VERSION} \"${MINT_CODENAME}\" (${MINT_SIZE})"
    echo "  3. Verify the download integrity"
    echo "  4. Create a bootable USB drive"
    echo "  5. Provide instructions for installation"
    echo ""
    echo -e "${BOLD}What you'll need:${NC}"
    echo "  • A USB flash drive (8GB or larger) - ${RED}ALL DATA WILL BE ERASED${NC}"
    echo "  • About 30-60 minutes"
    echo "  • Your iPhone or Android phone (for initial internet on the MacBook)"
    echo ""

    if ! wait_for_confirmation "Ready to begin?"; then
        echo "Okay, run this script again when you're ready!"
        exit 0
    fi
}

install_prerequisites() {
    print_step "1" "Installing Required Tools"

    check_macos
    check_homebrew

    echo ""
    print_info "Checking and installing required tools..."
    echo ""

    # Install balenaEtcher for USB creation
    check_and_install_tool "balenaetcher" "cask"

    # Install wget for downloading (curl is built-in but wget shows progress better)
    check_and_install_tool "wget"

    echo ""
    print_success "All required tools are installed!"
    wait_for_enter
}

download_linux_mint() {
    print_step "2" "Downloading Linux Mint ${MINT_VERSION} \"${MINT_CODENAME}\""

    # Check if already downloaded
    if [[ -f "$ISO_PATH" ]]; then
        print_info "Found existing ISO at: $ISO_PATH"

        if wait_for_confirmation "Use existing file? (Select 'n' to re-download)"; then
            print_success "Using existing ISO file"
            return 0
        fi
    fi

    echo ""
    echo "Linux Mint ${MINT_VERSION} \"${MINT_CODENAME}\" - Cinnamon Edition"
    echo "Size: ${MINT_SIZE}"
    echo ""
    echo "Download location: ${ISO_PATH}"
    echo ""

    # Try mirrors until one works
    local downloaded=false
    for mirror in "${MIRRORS[@]}"; do
        print_info "Downloading from: $(echo "$mirror" | cut -d'/' -f3)"
        echo ""

        if wget --progress=bar:force -O "$ISO_PATH" "$mirror" 2>&1; then
            downloaded=true
            break
        else
            print_warning "Mirror failed, trying next..."
            rm -f "$ISO_PATH"
        fi
    done

    if [[ "$downloaded" == false ]]; then
        print_error "All mirrors failed. Please try again later or download manually from:"
        echo "https://linuxmint.com/download.php"
        exit 1
    fi

    echo ""
    print_success "Download complete!"
    wait_for_enter
}

verify_download() {
    print_step "3" "Verifying Download Integrity"

    echo "This ensures the download wasn't corrupted or tampered with."
    echo ""

    print_info "Calculating SHA256 checksum (this may take a minute)..."
    echo ""

    local calculated_sum
    calculated_sum=$(shasum -a 256 "$ISO_PATH" | awk '{print $1}')

    echo "Expected:   ${MINT_SHA256}"
    echo "Calculated: ${calculated_sum}"
    echo ""

    if [[ "$calculated_sum" == "$MINT_SHA256" ]]; then
        print_success "Checksum verified! The download is authentic and complete."
    else
        print_error "Checksum mismatch! The file may be corrupted."
        print_info "Try deleting the file and running this script again."
        rm -f "$ISO_PATH"
        exit 1
    fi

    wait_for_enter
}

create_bootable_usb() {
    print_step "4" "Creating Bootable USB Drive"

    echo -e "${RED}${BOLD}⚠️  WARNING: This will ERASE ALL DATA on the USB drive! ⚠️${NC}"
    echo ""

    # List available disks
    echo "Currently connected drives:"
    echo ""
    diskutil list external
    echo ""

    print_info "Please insert your USB drive now (8GB or larger)."
    echo ""

    wait_for_enter

    echo "Updated drive list:"
    echo ""
    diskutil list external
    echo ""

    echo -e "${YELLOW}Identify your USB drive from the list above.${NC}"
    echo "It will be something like 'disk2' or 'disk3'."
    echo ""
    echo -e "${RED}DO NOT select your main hard drive!${NC}"
    echo ""

    read -p "Enter the disk identifier (e.g., disk2): " disk_id

    # Validate input
    if [[ ! "$disk_id" =~ ^disk[0-9]+$ ]]; then
        print_error "Invalid disk identifier. Please run this step again."
        exit 1
    fi

    # Extra confirmation
    echo ""
    echo -e "${RED}${BOLD}You selected: /dev/${disk_id}${NC}"
    echo ""
    diskutil info "/dev/${disk_id}" | grep -E "(Device Node|Media Name|Total Size)"
    echo ""

    if ! wait_for_confirmation "Are you ABSOLUTELY SURE this is your USB drive?"; then
        print_info "Cancelled. Please run this step again."
        exit 1
    fi

    echo ""
    print_info "Opening balenaEtcher..."
    echo ""
    echo "In balenaEtcher:"
    echo "  1. Click 'Flash from file' → Select: ${ISO_PATH}"
    echo "  2. Click 'Select target' → Choose your USB drive"
    echo "  3. Click 'Flash!'"
    echo "  4. Wait for completion (5-10 minutes)"
    echo "  5. Click 'Done' when finished"
    echo ""

    # Open balenaEtcher
    open -a "balenaEtcher"

    echo "balenaEtcher should now be open."
    echo ""

    wait_for_confirmation "Is the USB drive ready (balenaEtcher shows 'Flash Complete!')?"

    print_success "Bootable USB drive created!"

    # Eject the disk
    print_info "Ejecting USB drive..."
    diskutil eject "/dev/${disk_id}" 2>/dev/null || true
    print_success "USB drive ejected. You can safely remove it."

    wait_for_enter
}

show_installation_instructions() {
    print_step "5" "Installation Instructions"

    echo -e "${BOLD}Your bootable USB is ready! Here's how to install Linux Mint:${NC}"
    echo ""
    echo -e "${CYAN}━━━ ON THE 2013 MACBOOK PRO ━━━${NC}"
    echo ""
    echo "1. ${BOLD}Shut down${NC} the MacBook completely"
    echo ""
    echo "2. ${BOLD}Insert${NC} the USB drive you just created"
    echo ""
    echo "3. ${BOLD}Power on${NC} and IMMEDIATELY press and HOLD the ${BOLD}Option (⌥) key${NC}"
    echo ""
    echo "4. ${BOLD}Keep holding${NC} until you see disk icons appear (may take 20-30 seconds)"
    echo ""
    echo "5. ${BOLD}Select${NC} the orange/yellow 'EFI Boot' drive and press Enter"
    echo ""
    echo "6. ${BOLD}Select${NC} 'Start Linux Mint' from the menu"
    echo ""
    echo "7. ${BOLD}Wait${NC} for the desktop to load (1-2 minutes)"
    echo ""

    wait_for_enter

    echo -e "${CYAN}━━━ SETTING UP INTERNET (REQUIRED FOR WIFI DRIVERS) ━━━${NC}"
    echo ""
    echo "The WiFi won't work until we install drivers. Use your phone:"
    echo ""
    echo -e "${BOLD}For iPhone:${NC}"
    echo "  1. Settings → Personal Hotspot → Allow Others to Join: ON"
    echo "  2. Connect iPhone to MacBook with Lightning cable"
    echo "  3. Tap 'Trust' when prompted on iPhone"
    echo "  4. Internet should connect automatically"
    echo ""
    echo -e "${BOLD}For Android:${NC}"
    echo "  1. Connect phone to MacBook with USB cable"
    echo "  2. Settings → Network → Hotspot & Tethering → USB Tethering: ON"
    echo "  3. Internet should connect automatically"
    echo ""

    wait_for_enter

    echo -e "${CYAN}━━━ INSTALLING LINUX MINT ━━━${NC}"
    echo ""
    echo "1. Double-click 'Install Linux Mint' on the desktop"
    echo ""
    echo "2. Select language, keyboard, and check 'Install multimedia codecs'"
    echo ""
    echo "3. Select 'Erase disk and install Linux Mint'"
    echo ""
    echo "4. Set timezone, create user account with password"
    echo ""
    echo "5. Wait 10-15 minutes for installation"
    echo ""
    echo "6. Click 'Restart Now' when complete"
    echo ""
    echo "7. Remove USB drive when prompted, press Enter"
    echo ""

    wait_for_enter

    echo -e "${CYAN}━━━ FIXING WIFI (ONE-TIME SETUP) ━━━${NC}"
    echo ""
    echo "After restarting into your new Linux Mint installation:"
    echo ""
    echo "1. Log in with your password"
    echo ""
    echo "2. Reconnect your phone via USB tethering"
    echo ""
    echo "3. Click Menu (bottom-left) → Type 'Driver Manager' → Open it"
    echo ""
    echo "4. Enter your password"
    echo ""
    echo "5. Select the 'Broadcom' wireless driver"
    echo ""
    echo "6. Click 'Apply Changes' and wait"
    echo ""
    echo "7. Restart the computer"
    echo ""
    echo "8. WiFi should now work! Connect to your network."
    echo ""

    wait_for_enter
}

show_quick_reference() {
    print_step "6" "Quick Reference Card"

    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════════╗
║                    LINUX MINT QUICK REFERENCE                             ║
╠═══════════════════════════════════════════════════════════════════════════╣
║                                                                           ║
║  TO CONNECT INTERNET AWAY FROM HOME:                                      ║
║  1. Plug iPhone/Android into laptop with USB cable                        ║
║  2. On phone: Turn on USB Tethering                                       ║
║     • iPhone: Settings → Personal Hotspot                                 ║
║     • Android: Settings → Hotspot & Tethering                             ║
║  3. Internet should connect automatically                                 ║
║                                                                           ║
╠═══════════════════════════════════════════════════════════════════════════╣
║                                                                           ║
║  COMMON TASKS:                                                            ║
║  • Browse web: Click Firefox in taskbar                                   ║
║  • Open files: Click Files in taskbar                                     ║
║  • Install apps: Menu → Software Manager                                  ║
║  • Settings: Menu → System Settings                                       ║
║  • Shut down: Menu → Quit → Shut Down                                     ║
║                                                                           ║
╠═══════════════════════════════════════════════════════════════════════════╣
║                                                                           ║
║  IF WIFI STOPS WORKING:                                                   ║
║  1. Connect phone via USB + USB Tethering                                 ║
║  2. Menu → Driver Manager                                                 ║
║  3. Re-select Broadcom driver → Apply                                     ║
║  4. Restart computer                                                      ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
EOF

    echo ""
    print_info "TIP: Take a screenshot or photo of this for reference!"
    echo ""

    # Save to file
    local ref_file="${DOWNLOAD_DIR}/linux-mint-quick-reference.txt"
    cat << 'REFEOF' > "$ref_file"
LINUX MINT QUICK REFERENCE
===========================

TO CONNECT INTERNET AWAY FROM HOME:
1. Plug iPhone/Android into laptop with USB cable
2. On phone: Turn on USB Tethering
   • iPhone: Settings → Personal Hotspot
   • Android: Settings → Hotspot & Tethering
3. Internet should connect automatically

COMMON TASKS:
• Browse web: Click Firefox in taskbar
• Open files: Click Files in taskbar
• Install apps: Menu → Software Manager
• Settings: Menu → System Settings
• Shut down: Menu → Quit → Shut Down

IF WIFI STOPS WORKING:
1. Connect phone via USB + USB Tethering
2. Menu → Driver Manager
3. Re-select Broadcom driver → Apply
4. Restart computer

PASSWORD: _________________________
(write it somewhere safe)
REFEOF

    print_success "Quick reference saved to: ${ref_file}"
    echo ""
    wait_for_enter
}

show_completion() {
    print_header

    echo -e "${GREEN}${BOLD}"
    echo "  ✓ ✓ ✓   ALL DONE!   ✓ ✓ ✓"
    echo -e "${NC}"
    echo ""
    echo "Your bootable Linux Mint USB drive is ready!"
    echo ""
    echo -e "${BOLD}Files created:${NC}"
    echo "  • ISO: ${ISO_PATH}"
    echo "  • Quick Reference: ${DOWNLOAD_DIR}/linux-mint-quick-reference.txt"
    echo ""
    echo -e "${BOLD}Next steps:${NC}"
    echo "  1. Take the USB drive to the 2013 MacBook Pro"
    echo "  2. Follow the installation instructions above"
    echo "  3. Enjoy Linux Mint!"
    echo ""
    echo -e "${CYAN}Need help? Visit: https://forums.linuxmint.com${NC}"
    echo ""
    echo "Thanks for using this setup assistant!"
    echo ""
}

#-------------------------------------------------------------------------------
# Main Execution
#-------------------------------------------------------------------------------

main() {
    show_welcome
    install_prerequisites
    download_linux_mint
    verify_download
    create_bootable_usb
    show_installation_instructions
    show_quick_reference
    show_completion
}

# Run main function
main "$@"
