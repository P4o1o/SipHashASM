#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <windows.h>
#include "siphash.h"

#define vectoqword(vec) (((uint64_t)vec[7] << 56) | ((uint64_t)vec[6] << 48) | ((uint64_t)vec[5] << 40) | ((uint64_t)vec[4] << 32) | ((uint64_t)vec[3] << 24) | ((uint64_t)vec[2] << 16) | ((uint64_t)vec[1] << 8) | (uint64_t)vec[0])

#define REPEATS 1
// from https://github.com/veorq/SipHash/blob/master/vectors.h
const uint8_t vectors_sip64[64][8] = {
    {
        0x31,
        0x0e,
        0x0e,
        0xdd,
        0x47,
        0xdb,
        0x6f,
        0x72,
    },
    {
        0xfd,
        0x67,
        0xdc,
        0x93,
        0xc5,
        0x39,
        0xf8,
        0x74,
    },
    {
        0x5a,
        0x4f,
        0xa9,
        0xd9,
        0x09,
        0x80,
        0x6c,
        0x0d,
    },
    {
        0x2d,
        0x7e,
        0xfb,
        0xd7,
        0x96,
        0x66,
        0x67,
        0x85,
    },
    {
        0xb7,
        0x87,
        0x71,
        0x27,
        0xe0,
        0x94,
        0x27,
        0xcf,
    },
    {
        0x8d,
        0xa6,
        0x99,
        0xcd,
        0x64,
        0x55,
        0x76,
        0x18,
    },
    {
        0xce,
        0xe3,
        0xfe,
        0x58,
        0x6e,
        0x46,
        0xc9,
        0xcb,
    },
    {
        0x37,
        0xd1,
        0x01,
        0x8b,
        0xf5,
        0x00,
        0x02,
        0xab,
    },
    {
        0x62,
        0x24,
        0x93,
        0x9a,
        0x79,
        0xf5,
        0xf5,
        0x93,
    },
    {
        0xb0,
        0xe4,
        0xa9,
        0x0b,
        0xdf,
        0x82,
        0x00,
        0x9e,
    },
    {
        0xf3,
        0xb9,
        0xdd,
        0x94,
        0xc5,
        0xbb,
        0x5d,
        0x7a,
    },
    {
        0xa7,
        0xad,
        0x6b,
        0x22,
        0x46,
        0x2f,
        0xb3,
        0xf4,
    },
    {
        0xfb,
        0xe5,
        0x0e,
        0x86,
        0xbc,
        0x8f,
        0x1e,
        0x75,
    },
    {
        0x90,
        0x3d,
        0x84,
        0xc0,
        0x27,
        0x56,
        0xea,
        0x14,
    },
    {
        0xee,
        0xf2,
        0x7a,
        0x8e,
        0x90,
        0xca,
        0x23,
        0xf7,
    },
    {
        0xe5,
        0x45,
        0xbe,
        0x49,
        0x61,
        0xca,
        0x29,
        0xa1,
    },
    {
        0xdb,
        0x9b,
        0xc2,
        0x57,
        0x7f,
        0xcc,
        0x2a,
        0x3f,
    },
    {
        0x94,
        0x47,
        0xbe,
        0x2c,
        0xf5,
        0xe9,
        0x9a,
        0x69,
    },
    {
        0x9c,
        0xd3,
        0x8d,
        0x96,
        0xf0,
        0xb3,
        0xc1,
        0x4b,
    },
    {
        0xbd,
        0x61,
        0x79,
        0xa7,
        0x1d,
        0xc9,
        0x6d,
        0xbb,
    },
    {
        0x98,
        0xee,
        0xa2,
        0x1a,
        0xf2,
        0x5c,
        0xd6,
        0xbe,
    },
    {
        0xc7,
        0x67,
        0x3b,
        0x2e,
        0xb0,
        0xcb,
        0xf2,
        0xd0,
    },
    {
        0x88,
        0x3e,
        0xa3,
        0xe3,
        0x95,
        0x67,
        0x53,
        0x93,
    },
    {
        0xc8,
        0xce,
        0x5c,
        0xcd,
        0x8c,
        0x03,
        0x0c,
        0xa8,
    },
    {
        0x94,
        0xaf,
        0x49,
        0xf6,
        0xc6,
        0x50,
        0xad,
        0xb8,
    },
    {
        0xea,
        0xb8,
        0x85,
        0x8a,
        0xde,
        0x92,
        0xe1,
        0xbc,
    },
    {
        0xf3,
        0x15,
        0xbb,
        0x5b,
        0xb8,
        0x35,
        0xd8,
        0x17,
    },
    {
        0xad,
        0xcf,
        0x6b,
        0x07,
        0x63,
        0x61,
        0x2e,
        0x2f,
    },
    {
        0xa5,
        0xc9,
        0x1d,
        0xa7,
        0xac,
        0xaa,
        0x4d,
        0xde,
    },
    {
        0x71,
        0x65,
        0x95,
        0x87,
        0x66,
        0x50,
        0xa2,
        0xa6,
    },
    {
        0x28,
        0xef,
        0x49,
        0x5c,
        0x53,
        0xa3,
        0x87,
        0xad,
    },
    {
        0x42,
        0xc3,
        0x41,
        0xd8,
        0xfa,
        0x92,
        0xd8,
        0x32,
    },
    {
        0xce,
        0x7c,
        0xf2,
        0x72,
        0x2f,
        0x51,
        0x27,
        0x71,
    },
    {
        0xe3,
        0x78,
        0x59,
        0xf9,
        0x46,
        0x23,
        0xf3,
        0xa7,
    },
    {
        0x38,
        0x12,
        0x05,
        0xbb,
        0x1a,
        0xb0,
        0xe0,
        0x12,
    },
    {
        0xae,
        0x97,
        0xa1,
        0x0f,
        0xd4,
        0x34,
        0xe0,
        0x15,
    },
    {
        0xb4,
        0xa3,
        0x15,
        0x08,
        0xbe,
        0xff,
        0x4d,
        0x31,
    },
    {
        0x81,
        0x39,
        0x62,
        0x29,
        0xf0,
        0x90,
        0x79,
        0x02,
    },
    {
        0x4d,
        0x0c,
        0xf4,
        0x9e,
        0xe5,
        0xd4,
        0xdc,
        0xca,
    },
    {
        0x5c,
        0x73,
        0x33,
        0x6a,
        0x76,
        0xd8,
        0xbf,
        0x9a,
    },
    {
        0xd0,
        0xa7,
        0x04,
        0x53,
        0x6b,
        0xa9,
        0x3e,
        0x0e,
    },
    {
        0x92,
        0x59,
        0x58,
        0xfc,
        0xd6,
        0x42,
        0x0c,
        0xad,
    },
    {
        0xa9,
        0x15,
        0xc2,
        0x9b,
        0xc8,
        0x06,
        0x73,
        0x18,
    },
    {
        0x95,
        0x2b,
        0x79,
        0xf3,
        0xbc,
        0x0a,
        0xa6,
        0xd4,
    },
    {
        0xf2,
        0x1d,
        0xf2,
        0xe4,
        0x1d,
        0x45,
        0x35,
        0xf9,
    },
    {
        0x87,
        0x57,
        0x75,
        0x19,
        0x04,
        0x8f,
        0x53,
        0xa9,
    },
    {
        0x10,
        0xa5,
        0x6c,
        0xf5,
        0xdf,
        0xcd,
        0x9a,
        0xdb,
    },
    {
        0xeb,
        0x75,
        0x09,
        0x5c,
        0xcd,
        0x98,
        0x6c,
        0xd0,
    },
    {
        0x51,
        0xa9,
        0xcb,
        0x9e,
        0xcb,
        0xa3,
        0x12,
        0xe6,
    },
    {
        0x96,
        0xaf,
        0xad,
        0xfc,
        0x2c,
        0xe6,
        0x66,
        0xc7,
    },
    {
        0x72,
        0xfe,
        0x52,
        0x97,
        0x5a,
        0x43,
        0x64,
        0xee,
    },
    {
        0x5a,
        0x16,
        0x45,
        0xb2,
        0x76,
        0xd5,
        0x92,
        0xa1,
    },
    {
        0xb2,
        0x74,
        0xcb,
        0x8e,
        0xbf,
        0x87,
        0x87,
        0x0a,
    },
    {
        0x6f,
        0x9b,
        0xb4,
        0x20,
        0x3d,
        0xe7,
        0xb3,
        0x81,
    },
    {
        0xea,
        0xec,
        0xb2,
        0xa3,
        0x0b,
        0x22,
        0xa8,
        0x7f,
    },
    {
        0x99,
        0x24,
        0xa4,
        0x3c,
        0xc1,
        0x31,
        0x57,
        0x24,
    },
    {
        0xbd,
        0x83,
        0x8d,
        0x3a,
        0xaf,
        0xbf,
        0x8d,
        0xb7,
    },
    {
        0x0b,
        0x1a,
        0x2a,
        0x32,
        0x65,
        0xd5,
        0x1a,
        0xea,
    },
    {
        0x13,
        0x50,
        0x79,
        0xa3,
        0x23,
        0x1c,
        0xe6,
        0x60,
    },
    {
        0x93,
        0x2b,
        0x28,
        0x46,
        0xe4,
        0xd7,
        0x06,
        0x66,
    },
    {
        0xe1,
        0x91,
        0x5f,
        0x5c,
        0xb1,
        0xec,
        0xa4,
        0x6c,
    },
    {
        0xf3,
        0x25,
        0x96,
        0x5c,
        0xa1,
        0x6d,
        0x62,
        0x9f,
    },
    {
        0x57,
        0x5f,
        0xf2,
        0x8e,
        0x60,
        0x38,
        0x1b,
        0xe5,
    },
    {
        0x72,
        0x45,
        0x06,
        0xeb,
        0x4c,
        0x32,
        0x8a,
        0x95,
    },
};
// those vector must be read from 7 to 1

uint64_t test_vectors[64];

uint8_t in1[] = { 0 };
uint8_t in2[] = {0x01, 0};
uint8_t in3[] = {0x02, 0x01, 0 };
uint8_t in4[] = {0x03, 0x02, 0x01, 0 };
uint8_t in5[] = {0x04, 0x03, 0x02, 0x01, 0 };
uint8_t in6[] = {0x05, 0x04, 0x03, 0x02, 0x01, 0 };
uint8_t in7[] = {0x06, 0x05, 0x04, 0x03, 0x02, 0x01, 0 };
uint8_t in8[] = {0, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07 };
uint8_t in9[] = { 0, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08};
uint8_t in10[] = { 0, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x09, 0x08 };

int main() {
    uint8_t in[64];
    bool any_failed = false;
    uint64_t fails = 0;
    uint64_t res;
    res = siphash_2_4(NULL, 0, 0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL);
    if (res != vectoqword(vectors_sip64[0])) {
        printf("fail for 0 bytes, get %llx, right one %llx\n", res, vectoqword(vectors_sip64[0]));
        fails++;
        any_failed = true;
    }
    res = siphash_2_4(in1, 1, 0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL);
    if (res != vectoqword(vectors_sip64[1])) {
        printf("fail for 1 bytes, get %llx, right one %llx\n", res, vectoqword(vectors_sip64[1]));
        fails++;
        any_failed = true;
    }
    res = siphash_2_4(in2, 2, 0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL);
    if (res != vectoqword(vectors_sip64[2])) {
        printf("fail for 2 bytes, get %llx, right one %llx\n", res, vectoqword(vectors_sip64[2]));
        fails++;
        any_failed = true;
    }
    res = siphash_2_4(in3, 3, 0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL);
    if (res != vectoqword(vectors_sip64[3])) {
        printf("fail for 3 bytes, get %llx, right one %llx\n", res, vectoqword(vectors_sip64[3]));
        fails++;
        any_failed = true;
    }
    res = siphash_2_4(in4, 4, 0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL);
    if (res != vectoqword(vectors_sip64[4])) {
        printf("fail for 4 bytes, get %llx, right one %llx\n", res, vectoqword(vectors_sip64[4]));
        fails++;
        any_failed = true;
    }
    res = siphash_2_4(in5, 5, 0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL);
    if (res != vectoqword(vectors_sip64[5])) {
        printf("fail for 5 bytes, get %llx, right one %llx\n", res, vectoqword(vectors_sip64[5]));
        fails++;
        any_failed = true;
    }
    res = siphash_2_4(in6, 6, 0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL);
    if (res != vectoqword(vectors_sip64[6])) {
        printf("fail for 6 bytes, get %llx, right one %llx\n", res, vectoqword(vectors_sip64[6]));
        fails++;
        any_failed = true;
    }
    res = siphash_2_4(in7, 7, 0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL);
    if (res != vectoqword(vectors_sip64[7])) {
        printf("fail for 7 bytes, get %llx, right one %llx\n", res, vectoqword(vectors_sip64[7]));
        fails++;
        any_failed = true;
    }
    res = siphash_2_4(in8, 8, 0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL);
    if (res != vectoqword(vectors_sip64[8])) {
        printf("fail for 8 bytes, get %llx, right one %llx\n", res, vectoqword(vectors_sip64[8]));
        fails++;
        any_failed = true;
    }
    res = siphash_2_4(in9, 9, 0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL);
    if (res != vectoqword(vectors_sip64[9])) {
        printf("fail for 9 bytes, get %llx, right one %llx\n", res, vectoqword(vectors_sip64[9]));
        fails++;
        any_failed = true;
    }
    res = siphash_2_4(in10, 10, 0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL);
    if (res != vectoqword(vectors_sip64[10])) {
        printf("fail for 10 bytes, get %llx, right one %llx\n", res, vectoqword(vectors_sip64[10]));
        fails++;
        any_failed = true;
    }
    if (!fails)
        printf("OK\n");
	return 0;
}