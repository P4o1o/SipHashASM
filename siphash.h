#pragma once
#include <stdint.h>

extern uint64_t siphash_2_4(char* message, uint64_t mess_len, uint64_t key0, uint64_t key1);

extern uint64_t siphash_4_8(char* message, uint64_t mess_len, uint64_t key0, uint64_t key1);