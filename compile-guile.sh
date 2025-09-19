#!/bin/bash

# Script to compile Guile Scheme to WebAssembly
# Note: This requires Guile-Wasm or Hoot compiler to be installed

echo "Compiling Guile Scheme to WebAssembly..."

# Using Hoot (Guile to WASM compiler) if available
if command -v guild &> /dev/null && guild help compile-wasm &> /dev/null 2>&1; then
    guild compile-wasm hello.scm -o hello.wasm
elif command -v hoot &> /dev/null; then
    hoot compile hello.scm -o hello.wasm
else
    echo "Error: Guile-WASM compiler not found."
    echo "Please install Hoot or Guile-Wasm:"
    echo "  https://gitlab.com/spritely/guile-hoot"
    exit 1
fi

if [ -f hello.wasm ]; then
    echo "Successfully compiled hello.wasm"
else
    echo "Failed to compile WASM module"
    exit 1
fi