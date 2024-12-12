# SipHash Assembly Implementation

This repository contains an implementation of the **SipHash** algorithm in both **NASM** and **MASM** (x86-64). It includes two versions of the algorithm:

- **SipHash-2-4**: The original variant, optimized for speed.
- **SipHash-4-8**: A more secure variant with additional rounds.

The code includes a simple **C test file** to check the correctness.

## Files

- `siphash_nasm.asm`: Contains the NASM implementation of the SipHash algorithm.
- `siphash_masm.asm`: Contains the MASM implementation of the SipHash algorithm.
- `siphash.h`: Header file for integrating the assembly functions into C programs.
- `test.c`: A C file to test the SipHash functions.
- 
## Example Usage (C)

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

## References
- https://www.aumasson.jp/siphash/siphash_slides.pdf
- Test from https://github.com/veorq/SipHash/blob/master/vectors.h
