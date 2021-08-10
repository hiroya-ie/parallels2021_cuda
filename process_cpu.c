#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void convertToGray(int pixel, unsigned char *red, unsigned char *green, unsigned char *blue, unsigned char *out)
{
    for (int j = 0; j < 100000; j++)
    {
        for (int i = 0; i < pixel; i++)
        {
        out[i] = (red[i] + green[i] + blue[i]) / 3;
        /*printf("%d,", out[i]);*/
        }
    }
}

int main()
{
    FILE *fp;
    int width, height, pixel, cycle, i;
    unsigned char *red, *green, *blue, *out;


    fp = fopen("image.txt", "r");

    fscanf(fp, "%d %d %d %d", &width, &height, &pixel ,&cycle);

    // Allocate host memory
    red   = (unsigned char *)malloc(pixel * sizeof(unsigned char));
    green = (unsigned char *)malloc(pixel * sizeof(unsigned char));
    blue  = (unsigned char *)malloc(pixel * sizeof(unsigned char));
    out   = (unsigned char *)malloc(pixel * sizeof(unsigned char));

    for ( i = 0; i < pixel; i++) fscanf(fp, "%d %d %d", &red[i], &green[i], &blue[i]);

    fclose(fp);

    clock_t start = clock();

    convertToGray(pixel, red, green, blue, out);    

    clock_t end = clock();

    printf("\n(width, height, pixel, cycle) = (%d, %d, %d, %d)", width, height, pixel, cycle);

    printf( "clock:%f\n", (double)(end - start) / CLOCKS_PER_SEC);

    // Deallocate host memory
    free(red);
    free(green);
    free(blue);
    free(out);

    return 0;
}