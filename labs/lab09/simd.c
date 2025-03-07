#include <time.h>
#include <stdio.h>
#include <x86intrin.h>
#include "simd.h"

long long int sum(int vals[NUM_ELEMS]) {
	clock_t start = clock();

	long long int sum = 0;
	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		for(unsigned int i = 0; i < NUM_ELEMS; i++) {
			if(vals[i] >= 128) {
				sum += vals[i];
			}
		}
	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return sum;
}

long long int sum_unrolled(int vals[NUM_ELEMS]) {
	clock_t start = clock();
	long long int sum = 0;

	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		for(unsigned int i = 0; i < NUM_ELEMS / 4 * 4; i += 4) {
			if(vals[i] >= 128) sum += vals[i];
			if(vals[i + 1] >= 128) sum += vals[i + 1];
			if(vals[i + 2] >= 128) sum += vals[i + 2];
			if(vals[i + 3] >= 128) sum += vals[i + 3];
		}

		//This is what we call the TAIL CASE
		//For when NUM_ELEMS isn't a multiple of 4
		//NONTRIVIAL FACT: NUM_ELEMS / 4 * 4 is the largest multiple of 4 less than NUM_ELEMS
		for(unsigned int i = NUM_ELEMS / 4 * 4; i < NUM_ELEMS; i++) {
			if (vals[i] >= 128) {
				sum += vals[i];
			}
		}
	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return sum;
}

long long int sum_simd(int vals[NUM_ELEMS]) {
	clock_t start = clock();
	__m128i _127 = _mm_set1_epi32(127);		// This is a vector with 127s in it... Why might you need this?
	long long int result = 0;				   // This is where you should put your final result!
	/* DO NOT DO NOT DO NOT DO NOT WRITE ANYTHING ABOVE THIS LINE. */

	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		__m128i tmp_sum = _mm_setzero_si128();  // Zero vector for sum
        int i;

        // Main Cycle
        for (i = 0; i + 4 <= NUM_ELEMS; i += 4) {
            __m128i tmp = _mm_loadu_si128((__m128i*)(vals + i));  	// load 4 elements
            __m128i mask = _mm_cmpgt_epi32(tmp, _127);           	// Comapiring with 127
            tmp = _mm_and_si128(tmp, mask);                      	// Set elements less than 127 to zero
            tmp_sum = _mm_add_epi32(tmp, tmp_sum);                	// Summarizing
        }

        // Tail if elements in (vals % 4 != 0)
		for (; i < NUM_ELEMS; i++) {
			if (vals[i] >= 128) {
				result += vals[i];
			}
		}

        tmp_sum = _mm_add_epi32(tmp_sum, _mm_srli_si128(tmp_sum, 8));
		tmp_sum = _mm_add_epi32(tmp_sum, _mm_srli_si128(tmp_sum, 4));
		result += _mm_cvtsi128_si32(tmp_sum);
	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return result;
}

long long int sum_simd_unrolled(int vals[NUM_ELEMS]) {
	clock_t start = clock();
	__m128i _127 = _mm_set1_epi32(127);
	long long int result = 0;

	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
        __m128i tmp_sum1 = _mm_setzero_si128();  // Zero vector for sum
        __m128i tmp_sum2 = _mm_setzero_si128();  // Zero vector for sum2
        __m128i tmp_sum3 = _mm_setzero_si128();  // Zero vector for sum3
        __m128i tmp_sum4 = _mm_setzero_si128();  // Zero vector for sum4
        int i;

        // Main Cycle
        for (i = 0; i + 16 <= NUM_ELEMS; i += 16) {
            // load 4 by 4 elements
            __m128i tmp1 = _mm_loadu_si128((__m128i*)(vals + i));
            __m128i tmp2 = _mm_loadu_si128((__m128i*)(vals + i + 4));
            __m128i tmp3 = _mm_loadu_si128((__m128i*)(vals + i + 8));
            __m128i tmp4 = _mm_loadu_si128((__m128i*)(vals + i + 12));

            // Comapiring with 127 and set elements less than 127 to zero
            tmp1 = _mm_and_si128(tmp1, _mm_cmpgt_epi32(tmp1, _127));
            tmp2 = _mm_and_si128(tmp2, _mm_cmpgt_epi32(tmp2, _127));
            tmp3 = _mm_and_si128(tmp3, _mm_cmpgt_epi32(tmp3, _127));
            tmp4 = _mm_and_si128(tmp4, _mm_cmpgt_epi32(tmp4, _127));

            // Summarizing
            tmp_sum1 = _mm_add_epi32(tmp_sum1, tmp1);
            tmp_sum2 = _mm_add_epi32(tmp_sum2, tmp2);
            tmp_sum3 = _mm_add_epi32(tmp_sum3, tmp3);
            tmp_sum4 = _mm_add_epi32(tmp_sum4, tmp4);
        }

        // Summarizing
        tmp_sum1 = _mm_add_epi32(tmp_sum1, tmp_sum2);
        tmp_sum3 = _mm_add_epi32(tmp_sum3, tmp_sum4);
        tmp_sum1 = _mm_add_epi32(tmp_sum1, tmp_sum3);

        // Tail if elements in (vals % 4 != 0)
        for (; i < NUM_ELEMS; i++) {
            if (vals[i] >= 128) {
                result += vals[i];
            }
        }

		tmp_sum1 = _mm_add_epi32(tmp_sum1, _mm_srli_si128(tmp_sum1, 8));
		tmp_sum1 = _mm_add_epi32(tmp_sum1, _mm_srli_si128(tmp_sum1, 4));
		result += _mm_cvtsi128_si32(tmp_sum1);
	}

	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return result;
}
