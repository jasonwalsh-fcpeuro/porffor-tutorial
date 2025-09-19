# Porffor Tutorial - Multi-Runtime JavaScript Benchmarking

A comprehensive tutorial and benchmarking suite for JavaScript runtimes including Porffor, Deno, Bun, and Node.js, with WebAssembly support through Guile Scheme integration.

## Features

- **Multi-Runtime Support**: Run JavaScript code across Porffor, Deno, Bun, and Node.js
- **WebAssembly Integration**: Compile Guile Scheme to WASM for cross-platform execution
- **Performance Benchmarking**: Compare runtime performance with Fibonacci, string, and array operations
- **Universal JavaScript**: Single codebase that adapts to different runtime environments
- **Porffor Integration**: Includes Porffor as a git submodule for AOT JavaScript compilation to WebAssembly

## Project Structure

```
.
├── hello.js              # Universal JavaScript with runtime detection
├── hello.scm             # Guile Scheme source for WASM compilation
├── bench.js              # Performance benchmark suite
├── run-benchmarks.sh     # Automated benchmark runner
├── compile-guile.sh      # Guile to WASM compilation script
├── package.json          # NPM configuration with scripts
└── porffor/              # Porffor compiler submodule
```

## Installation

1. Clone the repository with submodules:
```bash
git clone --recursive https://github.com/jasonwalsh-fcpeuro/porffor-tutorial
cd porffor-tutorial
```

2. Install Porffor dependencies:
```bash
cd porffor && npm install && cd ..
```

3. Install optional runtimes:
```bash
# Install Bun
curl -fsSL https://bun.sh/install | bash

# Install Deno
curl -fsSL https://deno.land/install.sh | sh

# Install Guile Hoot for WASM compilation (optional)
# See: https://gitlab.com/spritely/guile-hoot
```

## Usage

### Run Hello World

```bash
# With Node.js
node hello.js

# With Deno
deno run --allow-read hello.js

# With Bun
bun run hello.js

# With Porffor
node porffor/runtime/index.js hello.js
```

### Run Benchmarks

```bash
./run-benchmarks.sh
```

This will automatically detect available runtimes and run performance benchmarks on each.

### Compile Guile to WASM

```bash
./compile-guile.sh
```

## Benchmark Results

The benchmark suite tests three key areas:
- **Fibonacci(35)**: Recursive computation performance
- **String Operations(10000)**: String manipulation and memory handling
- **Array Operations(100000)**: Array filtering, mapping, and reduction

Example results on Apple Silicon:
```
Node.js (baseline):
- Fibonacci(35): ~60ms
- String ops(10000): ~15ms
- Array ops(100000): ~2ms
```

## About Porffor

[Porffor](https://github.com/CanadaHonk/porffor) is an experimental Ahead-of-Time (AOT) JavaScript engine that compiles JavaScript to WebAssembly. It aims to provide faster startup times and smaller binary sizes compared to traditional JIT engines.

## Technologies Used

- **Porffor**: AOT JavaScript to WebAssembly compiler
- **WebAssembly**: Portable compilation target for web and native
- **Guile Scheme**: Functional programming language with WASM support
- **Multiple JS Runtimes**: Deno, Bun, Node.js compatibility
- **Performance Benchmarking**: Comparative runtime analysis

## Contributing

Contributions are welcome! Feel free to:
- Add new benchmarks
- Improve runtime detection
- Add support for more JavaScript engines
- Enhance WASM integration

## License

MIT

## Resources

- [Porffor GitHub](https://github.com/CanadaHonk/porffor)
- [WebAssembly MDN](https://developer.mozilla.org/en-US/docs/WebAssembly)
- [Guile Hoot](https://gitlab.com/spritely/guile-hoot)
- [Deno](https://deno.land/)
- [Bun](https://bun.sh/)