#!/usr/bin/env bash
set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

LOCAL_BIN_DIR="$HOME/.local/bin"
FAKETERM_DIR="$LOCAL_BIN_DIR/faketerm"

echo "========================================"
echo "     Faketerm Uninstallation Tool      "
echo "========================================"
echo ""

# Phase 1: Check if faketerm is installed
echo "Phase 1: Checking installation..."
if [ ! -d "$FAKETERM_DIR" ]; then
    echo -e "${YELLOW}Warning: faketerm directory not found at $FAKETERM_DIR${NC}"
    echo "faketerm may not be installed or already uninstalled."
else
    echo -e "${GREEN}Found faketerm installation at $FAKETERM_DIR${NC}"
fi
echo ""

# Phase 2: Remove faketerm directory
echo "Phase 2: Removing faketerm files..."
if [ -d "$FAKETERM_DIR" ]; then
    echo "Removing directory: $FAKETERM_DIR"
    rm -rf "$FAKETERM_DIR"
    echo -e "${GREEN}faketerm directory removed successfully.${NC}"
else
    echo "Nothing to remove."
fi
echo ""

# Phase 3: Clean up .bashrc
echo "Phase 3: Cleaning up ~/.bashrc..."
if [ -f "$HOME/.bashrc" ]; then
    # Create a backup
    cp "$HOME/.bashrc" "$HOME/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"
    echo "Backup created: ~/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Remove faketerm entries from .bashrc
    # This removes the comment, PATH exports, and any empty lines that were part of faketerm installation
    sed -i '/# faketerm path/d' "$HOME/.bashrc"
    sed -i '/export PATH="\$HOME\/.local\/bin\/faketerm\/lib:\$PATH"/d' "$HOME/.bashrc"
    sed -i '/export PATH="\$HOME\/.local\/bin\/faketerm\/bin:\$PATH"/d' "$HOME/.bashrc"
    
    echo -e "${GREEN}Removed faketerm entries from ~/.bashrc${NC}"
    echo "Changes removed:"
    echo "  - # faketerm path"
    echo "  - export PATH=\"\$HOME/.local/bin/faketerm/lib:\$PATH\""
    echo "  - export PATH=\"\$HOME/.local/bin/faketerm/bin:\$PATH\""
else
    echo -e "${YELLOW}Warning: ~/.bashrc not found${NC}"
fi
echo ""

# Phase 4: Verify cleanup
echo "Phase 4: Verifying uninstallation..."
CLEANUP_SUCCESS=true

if [ -d "$FAKETERM_DIR" ]; then
    echo -e "${RED}✗ faketerm directory still exists${NC}"
    CLEANUP_SUCCESS=false
else
    echo -e "${GREEN}✓ faketerm directory removed${NC}"
fi

if grep -q "faketerm" "$HOME/.bashrc" 2>/dev/null; then
    echo -e "${YELLOW}➮ Some faketerm references may still exist in ~/.bashrc${NC}"
    CLEANUP_SUCCESS=false
else
    echo -e "${GREEN}✓ ~/.bashrc cleaned${NC}"
fi
echo ""

# Final message
echo "========================================"
if [ "$CLEANUP_SUCCESS" = true ]; then
    echo -e "${GREEN}Uninstallation completed successfully!${NC}"
else
    echo -e "${YELLOW}Uninstallation completed with warnings.${NC}"
fi
echo "========================================"
echo ""
echo "NOTE: Please run 'source ~/.bashrc' or restart your terminal"
echo "      to apply the changes to your current session."
echo ""
echo "If you want to restore your .bashrc, backup files are saved as:"
echo "~/.bashrc.backup.YYYYMMDD_HHMMSS"
