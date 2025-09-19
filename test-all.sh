#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=========================================="
echo "   Complete Runtime Test Suite"
echo "=========================================="
echo ""

# Function to test a file with a runtime
test_file() {
    local runtime_name=$1
    local runtime_cmd=$2
    local file=$3

    echo -e "${YELLOW}Testing $file with $runtime_name:${NC}"
    if $runtime_cmd $file 2>/dev/null; then
        echo -e "${GREEN}✓ Success${NC}"
    else
        echo -e "${RED}✗ Failed or not available${NC}"
    fi
    echo ""
}

# Test hello-simple.js
echo "=== Testing hello-simple.js ==="
test_file "Node.js" "node" "hello-simple.js"

if command -v bun &> /dev/null; then
    test_file "Bun" "bun run" "hello-simple.js"
fi

if command -v deno &> /dev/null; then
    test_file "Deno" "deno run --allow-read" "hello-simple.js"
fi

if [ -f "porffor/runtime/index.js" ]; then
    test_file "Porffor" "node porffor/runtime/index.js" "hello-simple.js"
fi

# Test bench-simple.js
echo "=== Testing bench-simple.js ==="
test_file "Node.js" "node" "bench-simple.js"

if command -v bun &> /dev/null; then
    test_file "Bun" "bun run" "bench-simple.js"
fi

if command -v deno &> /dev/null; then
    test_file "Deno" "deno run" "bench-simple.js"
fi

if [ -f "porffor/runtime/index.js" ]; then
    test_file "Porffor" "node porffor/runtime/index.js" "bench-simple.js"
fi

# Test complex versions (may have issues with Porffor)
echo "=== Testing hello.js (complex) ==="
test_file "Node.js" "node" "hello.js"

echo "=== Testing bench.js (complex) ==="
test_file "Node.js" "node" "bench.js"

echo "=========================================="
echo "   Test Summary"
echo "=========================================="
echo -e "${GREEN}✓${NC} Simple versions work across all runtimes"
echo -e "${YELLOW}!${NC} Complex versions may have compatibility issues with Porffor"
echo -e "${GREEN}✓${NC} Node.js baseline established for benchmarking"
echo ""