#!/bin/bash

echo "🚀 Running JavaScript Runtime Benchmarks"
echo "========================================"

# Check if runtimes are available
check_runtime() {
    if command -v $1 &> /dev/null; then
        echo "✓ $1 found"
        return 0
    else
        echo "✗ $1 not found"
        return 1
    fi
}

echo -e "\n📋 Checking runtimes:"
check_runtime "bun"
BUN_AVAILABLE=$?

check_runtime "deno"
DENO_AVAILABLE=$?

# Use local Porffor from submodule
PORFFOR_CLI="node porffor/runtime/index.js"
if [ -f "porffor/runtime/index.js" ]; then
    echo "✓ porffor (local) found"
    PORFFOR_AVAILABLE=0
else
    echo "✗ porffor not found"
    PORFFOR_AVAILABLE=1
fi

check_runtime "node"
NODE_AVAILABLE=$?

echo -e "\n🏁 Starting benchmarks...\n"

# Run Bun benchmark
if [ $BUN_AVAILABLE -eq 0 ]; then
    echo "=== Bun ==="
    bun run bench.js
    echo ""
fi

# Run Deno benchmark
if [ $DENO_AVAILABLE -eq 0 ]; then
    echo "=== Deno ==="
    deno run bench.js
    echo ""
fi

# Run Porffor benchmark
if [ $PORFFOR_AVAILABLE -eq 0 ]; then
    echo "=== Porffor ==="

    # Run with Porffor
    echo "Running with Porffor..."
    $PORFFOR_CLI bench.js
    echo ""
fi

# Run Node benchmark for comparison
if [ $NODE_AVAILABLE -eq 0 ]; then
    echo "=== Node.js (baseline) ==="
    node bench.js
    echo ""
fi

echo "✅ Benchmark complete!"