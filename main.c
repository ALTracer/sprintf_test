/* ============================================================================
 * Name : main.c
 * Author : @ALTracer
 * Copyright : (c) 2022 All rights reserved.
 * Description : Prints integers formatted in hexadecimal.
 * ============================================================================
 */

#include <stdio.h>
#include <stdint.h>

#define LEN 32
static uint64_t arr[LEN] = {0};
static char str_loc[24]; //sprintf buffer

static void proc1(void)
{
	arr[0] = 0;
	arr[1] = 1;
	for (short i=2; i<LEN; i++) { arr[i] = arr[i-1]*4 + 1; }

	for (short i=0; i<LEN; i++)
	{
		sprintf(str_loc, "0x%.16lX\t", arr[i]);
//		sprintf(str_loc, "%ld\t", arr[i]);
		fputs(str_loc, stdout);

		if (i%4 == 4-1)	{ fputc('\n', stdout); }
	}

	if (LEN % 4 > 0) { fputc('\n', stdout); }
}

int main(int argc, char * argv[])
{
	if (argc < 2) {	printf("I am %s with %d argc\n", argv[0], argc); }

	proc1();

	return 0;
}
