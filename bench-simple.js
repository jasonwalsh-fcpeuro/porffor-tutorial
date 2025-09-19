// Simplified benchmark for Porffor compatibility
console.log('Starting simple benchmarks...');

// Simple Fibonacci
function fib(n) {
  if (n <= 1) return n;
  return fib(n - 1) + fib(n - 2);
}

// Simple loop test
function loopTest(n) {
  let sum = 0;
  for (let i = 0; i < n; i++) {
    sum += i;
  }
  return sum;
}

// Simple array test
function arraySum(size) {
  let arr = [];
  for (let i = 0; i < size; i++) {
    arr[i] = i;
  }
  let sum = 0;
  for (let i = 0; i < size; i++) {
    sum += arr[i];
  }
  return sum;
}

// Run benchmarks
console.log('Fibonacci(20): ' + fib(20));
console.log('Loop sum(1000): ' + loopTest(1000));
console.log('Array sum(100): ' + arraySum(100));
console.log('Benchmarks complete!');