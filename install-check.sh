#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo "   Runtime Installation Check & Setup"
echo "=========================================="
echo ""

# Track if all dependencies are met
ALL_DEPS_MET=true

# Function to check if a command exists
check_command() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 is installed ($(command -v $1))"
        return 0
    else
        echo -e "${RED}✗${NC} $1 is not installed"
        return 1
    fi
}

# Function to get version
get_version() {
    if command -v $1 &> /dev/null; then
        case $1 in
            node)
                echo "  Version: $(node --version)"
                ;;
            bun)
                echo "  Version: $(bun --version)"
                ;;
            deno)
                echo "  Version: $(deno --version | head -1)"
                ;;
        esac
    fi
}

echo "Checking Node.js..."
if check_command node; then
    get_version node
else
    ALL_DEPS_MET=false
    echo -e "${YELLOW}  To install Node.js:${NC}"
    echo "    macOS: brew install node"
    echo "    Linux: curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs"
    echo "    Or visit: https://nodejs.org/"
fi
echo ""

echo "Checking npm..."
if check_command npm; then
    echo "  Version: $(npm --version)"
else
    ALL_DEPS_MET=false
    echo -e "${YELLOW}  npm usually comes with Node.js${NC}"
fi
echo ""

echo "Checking Bun..."
if check_command bun; then
    get_version bun
else
    echo -e "${YELLOW}  To install Bun (optional):${NC}"
    echo "    curl -fsSL https://bun.sh/install | bash"
    echo "    Or visit: https://bun.sh/"
fi
echo ""

echo "Checking Deno..."
if check_command deno; then
    get_version deno
else
    echo -e "${YELLOW}  To install Deno (optional):${NC}"
    echo "    macOS: brew install deno"
    echo "    Linux/macOS: curl -fsSL https://deno.land/install.sh | sh"
    echo "    Or visit: https://deno.land/"
fi
echo ""

echo "Checking Porffor..."
if [ -f "porffor/runtime/index.js" ]; then
    echo -e "${GREEN}✓${NC} Porffor is available (local submodule)"
    # Check if node_modules exist in porffor
    if [ ! -d "porffor/node_modules" ]; then
        echo -e "${YELLOW}  Installing Porffor dependencies...${NC}"
        cd porffor && npm install && cd ..
    fi
else
    ALL_DEPS_MET=false
    echo -e "${RED}✗${NC} Porffor submodule not found"
    echo -e "${YELLOW}  To initialize Porffor:${NC}"
    echo "    git submodule update --init --recursive"
fi
echo ""

echo "Checking Git..."
if check_command git; then
    echo "  Version: $(git --version)"
else
    ALL_DEPS_MET=false
    echo -e "${YELLOW}  Git is required. Install from: https://git-scm.com/${NC}"
fi
echo ""

echo "Checking Make..."
if check_command make; then
    echo "  Version: $(make --version | head -1)"
else
    echo -e "${YELLOW}  To install Make (optional):${NC}"
    echo "    macOS: xcode-select --install"
    echo "    Linux: sudo apt-get install build-essential"
fi
echo ""

# Optional: Check for Guile and WASM tools
echo "Checking optional WASM tools..."
if check_command wasmtime; then
    echo "  wasmtime version: $(wasmtime --version)"
else
    echo -e "${YELLOW}  wasmtime is optional for running standalone WASM${NC}"
    echo "    Install from: https://wasmtime.dev/"
fi

if check_command guile; then
    echo -e "${GREEN}✓${NC} Guile is installed"
    echo "  Version: $(guile --version | head -1)"
else
    echo -e "${YELLOW}  Guile is optional for Scheme->WASM compilation${NC}"
    echo "    macOS: brew install guile"
    echo "    Linux: sudo apt-get install guile-3.0"
fi
echo ""

echo "=========================================="
if [ "$ALL_DEPS_MET" = true ]; then
    echo -e "${GREEN}All required dependencies are installed!${NC}"
    echo "You can now run: ./run-benchmarks.sh"
else
    echo -e "${YELLOW}Some dependencies are missing.${NC}"
    echo "Install the required dependencies above and run this script again."
fi
echo "=========================================="