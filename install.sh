
#!/usr/bin/env bash
set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Current path:
PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOCAL_BIN_DIR="$HOME/.local/bin"

echo "========================================"
echo "      Faketerm Installation Tool       "
echo "========================================"
echo ""
echo -e "${BLUE}Phase 1: Preparing installation...${NC}"
echo "Project root is at $PROJECT_ROOT"
echo "Local bin directory is at $LOCAL_BIN_DIR"
echo ""

# create folder ~/.local/bin/faketerm if not exists
echo -e "${BLUE}Phase 2: Setting up directories...${NC}"
echo "Creating 'faketerm' directory structure in $LOCAL_BIN_DIR if not exists..."
if [ ! -d "$LOCAL_BIN_DIR/faketerm" ]; then
    mkdir -p "$LOCAL_BIN_DIR/faketerm"
    echo -e "${GREEN}✓ 'faketerm' directory created.${NC}"
else
    echo -e "${YELLOW}➮ 'faketerm' directory already exists.${NC}"
fi

# check if any old files exists in $LOCAL_BIN_DIR/faketerm
echo ""
echo -e "${BLUE}Phase 3: Removing old faketerm resources...${NC}"
echo "Clearing old files if any..."
if [ -d "$LOCAL_BIN_DIR/faketerm/bin" ]; then
    rm -rf "$LOCAL_BIN_DIR/faketerm/bin"
    echo -e "${GREEN}✓ Old 'bin' directory removed.${NC}"
fi
if [ -d "$LOCAL_BIN_DIR/faketerm/lib" ]; then
    rm -rf "$LOCAL_BIN_DIR/faketerm/lib"
    echo -e "${GREEN}✓ Old 'lib' directory removed.${NC}"
fi

# copy folders (bin/lib) to faketerm dirs to ~/.local/bin/faketerm/bin/faketerm
echo ""
echo -e "${BLUE}Phase 4: Copying files...${NC}"
echo "Copying files to local bin directory..."
echo "Existing files to be copied:"
ls -l "$PROJECT_ROOT/bin"
ls -l "$PROJECT_ROOT/lib"
echo "Copying binaries and libraries..."
cp -r "$PROJECT_ROOT/bin" "$LOCAL_BIN_DIR/faketerm/bin"
cp -r "$PROJECT_ROOT/lib" "$LOCAL_BIN_DIR/faketerm/lib"
echo -e "${GREEN}✓ Files copied successfully.${NC}"

# check if comment '# faketerm path' exists in ~/.bashrc, if not add it
echo ""
echo -e "${BLUE}Phase 5: Configuring PATH...${NC}"
if ! grep -Fxq '# faketerm path' ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "" >> ~/.bashrc # Add an empty line for separation
    echo "# faketerm path" >> ~/.bashrc
    echo -e "${GREEN}✓ Added comment '# faketerm path' to ~/.bashrc${NC}"
else
    echo -e "${YELLOW}➮ Comment '# faketerm path' already exists in ~/.bashrc${NC}"
fi

# cp this one PATH="$HOME/.local/bin/faketerm/lib:$PATH" and PATH="$HOME/.local/bin/faketerm/bin:$PATH" to ~/.bashrc
if ! grep -Fxq 'export PATH="$HOME/.local/bin/faketerm/lib:$PATH"' ~/.bashrc; then
    echo 'export PATH="$HOME/.local/bin/faketerm/lib:$PATH"' >> ~/.bashrc
    echo -e "${GREEN}✓ Added faketerm lib to PATH in ~/.bashrc${NC}"
else
    echo -e "${YELLOW}➮ faketerm lib already in PATH in ~/.bashrc${NC}"
fi

if ! grep -Fxq 'export PATH="$HOME/.local/bin/faketerm/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="$HOME/.local/bin/faketerm/bin:$PATH"' >> ~/.bashrc
    echo -e "${GREEN}✓ Added faketerm bin to PATH in ~/.bashrc${NC}"
else
    echo -e "${YELLOW}➮ faketerm bin already in PATH in ~/.bashrc${NC}"
fi

# if current user do not have execute permission to faketerm binary, give it
echo ""
echo -e "${BLUE}Phase 6: Setting permissions...${NC}"
chmod u+x "$LOCAL_BIN_DIR/faketerm/bin/"*
chmod u+x "$LOCAL_BIN_DIR/faketerm/lib/"*
echo -e "${GREEN}✓ Execute permissions set for all binaries.${NC}"

echo ""
echo "========================================"
echo -e "${GREEN}✓ Installation completed successfully!${NC}"
echo "========================================"
echo ""
echo -e "${YELLOW}NOTE:${NC} Please run 'source ~/.bashrc' or restart your terminal to use faketerm."
echo "      Then you can run 'faketerm' from anywhere."

