// Benchmark script for performance comparison
const isDeno = typeof Deno !== 'undefined';
const isBun = typeof Bun !== 'undefined';
const runtime = isDeno ? 'Deno' : isBun ? 'Bun' : 'Node.js';

// Simple computation benchmark
function fibonacci(n) {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

// String manipulation benchmark
function stringOperations(iterations) {
  let result = '';
  for (let i = 0; i < iterations; i++) {
    result += 'Hello';
    result = result.slice(0, -2);
    result += 'World';
  }
  return result;
}

// Array operations benchmark
function arrayOperations(size) {
  const arr = Array(size).fill(0).map((_, i) => i);
  return arr
    .filter(x => x % 2 === 0)
    .map(x => x * 2)
    .reduce((a, b) => a + b, 0);
}

// Benchmark runner
async function runBenchmark(name, fn, ...args) {
  const start = performance.now();
  const result = await fn(...args);
  const end = performance.now();
  return { name, time: end - start, result };
}

// Main benchmark suite
async function main() {
  console.log(`🏃 Running benchmarks on ${runtime}\n`);

  const benchmarks = [
    { name: 'Fibonacci(35)', fn: () => fibonacci(35) },
    { name: 'String Operations(10000)', fn: () => stringOperations(10000) },
    { name: 'Array Operations(100000)', fn: () => arrayOperations(100000) },
  ];

  const results = [];

  for (const bench of benchmarks) {
    const result = await runBenchmark(bench.name, bench.fn);
    results.push(result);
    console.log(`${bench.name}: ${result.time.toFixed(3)}ms`);
  }

  const totalTime = results.reduce((sum, r) => sum + r.time, 0);
  console.log(`\n📊 Total time: ${totalTime.toFixed(3)}ms`);
  console.log(`Runtime: ${runtime}`);
}

// Execute main function
main().catch(console.error);