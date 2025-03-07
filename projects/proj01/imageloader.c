/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

// Opens a .ppm P3 image file, and constructs an Image object.
// You may find the function fscanf useful.
// Make sure that you close the file with fclose before returning.

Image *readData(char *filename)
{
	FILE *fp = fopen(filename, "r");

	char buf[2];
	fscanf(fp, "%s", buf);

	uint32_t columns;
	fscanf(fp, "%d", &columns);

	uint32_t rows;
	fscanf(fp, "%d", &rows);

	uint8_t color_res;
	fscanf(fp, "%hhd", &color_res);

	if (strcmp(buf, "P3") != 0 || color_res != 255)
	{
		fprintf(stderr, "Invalid PPM P3 file format\n");
		fclose(fp);
		return NULL;
	};

	Image *image = malloc(sizeof(struct Image));
	image->cols = columns;
	image->rows = rows;
	image->image = malloc(rows * sizeof(Color *));


	for (int i = 0; i < rows; i++)
	{
		image->image[i] = malloc(columns * sizeof(Color));
		if (image->image[i] == NULL)
		{
			fclose(fp);
			freeImage(image);
			return NULL;
		}

		for (int j = 0; j < columns; j++)
		{
			Color *color = &image->image[i][j];
			fscanf(fp, "%hhu %hhu %hhu", &color->R, &color->G, &color->B);
		}
	}

	fclose(fp);
	return image;
}

// Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	// YOUR CODE HERE
	printf("P3\n");
	printf("%d %d\n", image->cols, image->rows);
	printf("255\n");
	Color **colors = image->image;
	for (int i = 0; i < image->rows; i++)
	{
		for (int j = 0; j < image->cols; j++)
		{
			Color color = colors[i][j];
			printf("%3hhu %3hhu %3hhu", color.R, color.G, color.B);
			if (j != image->cols - 1)
			{
				printf("   ");
			}
		}
		printf("\n");
	}
}

// Frees an image
void freeImage(Image *image)
{
	for (int i = 0; i < image->rows; i++)
	{
		free(image->image[i]);
	}
	free(image->image);
	free(image);
}
