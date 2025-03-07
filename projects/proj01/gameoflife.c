/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

// Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
// Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
// and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	Color *newGeneration = malloc(sizeof(struct Color));
	Color *oldGeneration = &image->image[row][col];

	uint32_t liveNeighbors = 0b1;

	uint64_t r, g, b;
	int i, j;
	for (i = -1; i <= 1; i++)
	{
		for (j = -1; j <= 1; j++)
		{
			if (i == 0 && j == 0)
				continue;
			int x = row + i;
			int y = col + j;
			if (x < 0 || y < 0)
			{
				continue;
			}
			if (x >= image->rows || y >= image->cols)
			{
				continue;
			}

			if (image->image[x][y].R != 0 || image->image[x][y].G != 0 || image->image[x][y].B != 0)
			{
				r = image->image[x][y].R;
				g = image->image[x][y].G;
				b = image->image[x][y].B;
				liveNeighbors <<= 1;
			}
		}
	}

	if (oldGeneration->B != 0 || oldGeneration->G != 0 || oldGeneration->R != 0)
	{
		liveNeighbors <<= 9;
	}

	if ((rule & liveNeighbors) != 0)
	{
		newGeneration->R = r;
		newGeneration->G = g;
		newGeneration->B = b;
	}
	else
	{
		newGeneration->R = 0;
		newGeneration->G = 0;
		newGeneration->B = 0;
	}

	return newGeneration;
}

// The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
// You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
{
	Image *newImage = malloc(sizeof(Image));
	newImage->cols = image->cols;
	newImage->rows = image->rows;
	newImage->image = malloc(newImage->rows * sizeof(Color *));

	for (int i = 0; i < newImage->rows; i++)
	{
		newImage->image[i] = malloc(newImage->cols * sizeof(Color *));
		for (int j = 0; j < newImage->cols; j++)
		{
			Color *c = evaluateOneCell(image, i, j, rule);
			newImage->image[i][j] = *c;
			free(c);
		}
	}
	return newImage;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	// YOUR CODE HERE
	Image *image;
	Image *oldImage;
	char *filename;
	if (argc < 3)
	{
		printf("usage: %s filename rule\n", argv[0]);
		printf("filename is an ASCII PPM file (type P3) with maximum value 255.\n");
		printf("rule is a hexadecimal number (such as 0x1808).\n");
		exit(-1);
	}
	uint32_t rule = strtol(argv[2], NULL, 16);
	filename = argv[1];
	oldImage = readData(filename);
	image = life(oldImage, rule);
	writeData(image);
	freeImage(image);
	freeImage(oldImage);
}
