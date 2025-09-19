.PHONY: all install check deps clean run-hello run-bench test help

# Default target
all: check deps

# Help target
help:
	@echo "Available targets:"
	@echo "  make install    - Install all dependencies"
	@echo "  make check      - Check installed runtimes"
	@echo "  make deps       - Install project dependencies"
	@echo "  make run-hello  - Run hello world on all runtimes"
	@echo "  make run-bench  - Run benchmarks on all runtimes"
	@echo "  make test       - Run all tests 5 times"
	@echo "  make clean      - Clean generated files"
	@echo "  make help       - Show this help message"

# Check installed runtimes
check:
	@echo "Checking runtime installations..."
	@./install-check.sh

# Install dependencies
install: install-node install-optional deps

# Install Node.js (required)
install-node:
	@if ! command -v node &> /dev/null; then \
		echo "Installing Node.js..."; \
		if [ "$$(uname)" = "Darwin" ]; then \
			brew install node; \
		else \
			curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs; \
		fi; \
	else \
		echo "Node.js already installed"; \
	fi

# Install optional runtimes
install-optional: install-bun install-deno

# Install Bun
install-bun:
	@if ! command -v bun &> /dev/null; then \
		echo "Installing Bun (optional)..."; \
		curl -fsSL https://bun.sh/install | bash; \
		echo "Please restart your terminal or run: source ~/.bashrc"; \
	else \
		echo "Bun already installed"; \
	fi

# Install Deno
install-deno:
	@if ! command -v deno &> /dev/null; then \
		echo "Installing Deno (optional)..."; \
		if [ "$$(uname)" = "Darwin" ]; then \
			brew install deno; \
		else \
			curl -fsSL https://deno.land/install.sh | sh; \
			echo "Please add $$HOME/.deno/bin to your PATH"; \
		fi; \
	else \
		echo "Deno already installed"; \
	fi

# Install project dependencies
deps:
	@echo "Installing project dependencies..."
	@if [ ! -d "porffor" ]; then \
		echo "Initializing Porffor submodule..."; \
		git submodule update --init --recursive; \
	fi
	@if [ ! -d "porffor/node_modules" ]; then \
		echo "Installing Porffor dependencies..."; \
		cd porffor && npm install; \
	fi
	@if [ ! -d "node_modules" ] && [ -f "package.json" ]; then \
		echo "Installing main project dependencies..."; \
		npm install; \
	fi

# Run hello world example (simple version for compatibility)
run-hello:
	@echo "=== Running Hello World (Simple) ==="
	@echo ""
	@echo "--- Node.js ---"
	@node hello-simple.js 2>/dev/null || echo "Node.js not available"
	@echo ""
	@if command -v deno &> /dev/null; then \
		echo "--- Deno ---"; \
		deno run hello-simple.js 2>/dev/null || echo "Deno execution failed"; \
		echo ""; \
	fi
	@if command -v bun &> /dev/null; then \
		echo "--- Bun ---"; \
		bun run hello-simple.js 2>/dev/null || echo "Bun execution failed"; \
		echo ""; \
	fi
	@if [ -f "porffor/runtime/index.js" ]; then \
		echo "--- Porffor ---"; \
		node porffor/runtime/index.js hello-simple.js 2>/dev/null || echo "Porffor execution failed"; \
		echo ""; \
	fi

# Run simple benchmarks (Porffor compatible)
run-bench-simple:
	@echo "=== Running Simple Benchmarks ==="
	@echo ""
	@echo "--- Node.js ---"
	@node bench-simple.js
	@echo ""
	@if [ -f "porffor/runtime/index.js" ]; then \
		echo "--- Porffor ---"; \
		node porffor/runtime/index.js bench-simple.js; \
		echo ""; \
	fi

# Run benchmarks
run-bench:
	@./run-benchmarks.sh

# Test everything 5 times
test: deps
	@echo "Running complete test suite 5 times..."
	@for i in 1 2 3 4 5; do \
		echo ""; \
		echo "========== Test Run $$i/5 =========="; \
		echo ""; \
		$(MAKE) run-hello; \
		echo ""; \
		echo "--- Benchmarks ---"; \
		$(MAKE) run-bench; \
		echo ""; \
		sleep 1; \
	done
	@echo "========== All 5 test runs completed =========="

# Run a single test iteration
test-once: deps run-hello run-bench

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	@rm -f *.wasm
	@rm -f bench.wasm
	@rm -f hello.wasm
	@echo "Clean complete"

# Git operations
commit:
	@git add -A
	@git status
	@git commit -m "feat: add Makefile and installation checks for multi-runtime support"

push:
	@git push origin main