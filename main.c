#include "bmp.h"
#include "uquantize.h"

int main(int argc, char *argv[])
{
    if(argc < 3)
    {
        printf("Blad przy wpisywaniu argumentow.");
        return 2;
    }

    char *image = get_image(argv[1]);
    display(image);

    int levels = atoi(argv[3]);

    if(levels > 255)
    {
        printf("Za duza wartosc levels.");
        return 3;
    }

    uquantize(image, levels);
    save_image(image, argv[2]);

    return 0;
}
