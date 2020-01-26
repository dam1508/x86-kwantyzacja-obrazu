#include "bmp.h"
#include "uquantize.h"

int main(int argc, char *argv[])
{
    if(argc < 3)
    {
        printf("Blad przy wpisywaniu argumentow.");
        return -1;
    }

    char *image = get_image(argv[1]);
    display(image);

    int levels = atoi(argv[3]);

    uquantize(image, levels);

    save_image(image, argv[2]);

    return 0;
}
