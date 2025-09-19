// Hello World with Deno/Bun support and WASM from Guile
const isDeno = typeof Deno !== 'undefined';
const isBun = typeof Bun !== 'undefined';
const isNode = !isDeno && !isBun && typeof process !== 'undefined';

console.log('Hello World!');
console.log(`Running on: ${isDeno ? 'Deno' : isBun ? 'Bun' : isNode ? 'Node.js' : 'Unknown'}`);

// Load and execute WASM module
async function loadWasm() {
  try {
    let wasmBytes;

    if (isDeno) {
      wasmBytes = await Deno.readFile('./hello.wasm');
    } else if (isBun) {
      const fs = await import('fs');
      wasmBytes = fs.readFileSync('./hello.wasm');
    } else {
      const fs = await import('fs');
      wasmBytes = fs.readFileSync('./hello.wasm');
    }

    const wasmModule = await WebAssembly.compile(wasmBytes);
    const instance = await WebAssembly.instantiate(wasmModule, {
      env: {
        print_string: (ptr, len) => {
          const memory = instance.exports.memory;
          const bytes = new Uint8Array(memory.buffer, ptr, len);
          const str = new TextDecoder().decode(bytes);
          console.log(`From WASM (Guile): ${str}`);
        }
      }
    });

    if (instance.exports.hello) {
      instance.exports.hello();
    }
  } catch (error) {
    console.log('WASM module not found or failed to load:', error.message);
    console.log('Run compile-guile.sh to generate hello.wasm');
  }
}

loadWasm();