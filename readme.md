# SipHash Assembly Implementation

This repository contains an implementation of the **SipHash** algorithm for both **NASM** and **MASM** (x86-64). It includes two versions of the algorithm:

- **SipHash-2-4**: The original variant, optimized for speed.
- **SipHash-4-8**: A more secure variant with additional rounds.

The code includes a simple **C test file** to check the correctness.

## Files

- `siphash_nasm.asm`: Contains the implementation of the SipHash algorithm for the NASM assembler.
- `siphash_masm.asm`: Contains the implementation of the SipHash algorithm for the MASM assembler.
- `siphash.h`: Header file for integrating the assembly functions into C programs.
- `test.c`: A C file to test the SipHash functions.
- 
## Example Usage (from C)

```c
#include "siphash.h"

int main() {
    const char *message = "Test message";
    uint64_t key0 = 0x0706050403020100;
    uint64_t key1 = 0x1F1E1D1C1B1A1918;

    uint64_t hash = siphash_2_4((uint8_t *)message, strlen(message), key0, key1);
    printf("Hash: %llx\n", hash);
    
    return 0;
}
```

## About This Implementation

This project includes an independent implementation of the SipHash algorithm, originally designed by Jean-Philippe Aumasson and Daniel J. Bernstein. SipHash is a cryptographic pseudorandom function optimized for speed on short messages and is free from patent claims, as explicitly stated by its authors.

## Disclaimer

This implementation is not affiliated with or endorsed by the original authors of SipHash. It is provided under MIT license.

## Attribution

This project uses test vectors derived from [SipHash](https://github.com/veorq/SipHash), which is released under the CC0-1.0, MIT, and Apache 2.0 with LLVM exceptions licenses.  
The test vector values were used solely for verifying the correctness of this implementation.


## References
- https://www.aumasson.jp/siphash/siphash_slides.pdf
- Test from https://github.com/veorq/SipHash/blob/master/vectors.h
