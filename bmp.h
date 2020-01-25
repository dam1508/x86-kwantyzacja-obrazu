#ifndef BMP_H
#define BMP_H
#include <stdio.h>
#include <stdlib.h>

char *get_image(char* fName)
{
    FILE *file = fopen(fName, "rb");

    fseek(file, 0, SEEK_END);
    unsigned int file_size = ftell(file);
    rewind(file);

    char *image = malloc(file_size);
    fread(image, 1, file_size, file);
    rewind(file);
    fclose(file);

    return image;
}

void display(char *bmpImage)
{

}

void save_image(char *bmpImage, char *fName)
{
    FILE *file = fopen(fName, "wb");
    unsigned int file_size = *(int*)&bmpImage[2];
    fwrite(bmpImage, 1, file_size, file);
    free(bmpImage);
    fclose(file);
}

#endif
