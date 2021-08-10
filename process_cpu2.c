#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void convertToGray(int pixel, int cycle, unsigned char *red, unsigned char *green, unsigned char *blue, unsigned char *out)
{
    for (int j = 0; j < cycle; j++)
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
    int width, height, pixel, cycle, i;
    unsigned char *red, *green, *blue, *out;

    /* input */
    printf("width?  >>> ");
    scanf("%d", &width);
    printf("height? >>> ");
    scanf("%d", &height);
    printf("cycle?  >>> ");
    scanf("%d", &cycle);

    pixel = width * height;

    /* Allocate host memory */
    red   = (unsigned char *)malloc(pixel * sizeof(unsigned char));
    green = (unsigned char *)malloc(pixel * sizeof(unsigned char));
    blue  = (unsigned char *)malloc(pixel * sizeof(unsigned char));
    out   = (unsigned char *)malloc(pixel * sizeof(unsigned char));

    /* Fail to assgin */
    if ( red == NULL || pixel > 100000000 || cycle > 1000000 )
    {
        printf("too many pixels or cycles...");
        return 0;
    }

    /* Make value of RGB */
    for ( i = 0; i < pixel; i++) red[i]   = rand() % 255;
    for ( i = 0; i < pixel; i++) green[i] = rand() % 255;
    for ( i = 0; i < pixel; i++) blue[i]  = rand() % 255;

    /* Start timer */
    clock_t start = clock();

    /* Main function */
    convertToGray(pixel, cycle, red, green, blue, out);

    /* Stop timer */
    clock_t end = clock();

    /* Show result */
    printf("\n(width, height, pixel, cycle) = (%d, %d, %d, %d)\n", width, height, pixel, cycle);
    printf( "clock:%f\n", (double)(end - start) / CLOCKS_PER_SEC);

    /* Deallocate host memory */
    free(red);
    free(green);
    free(blue);
    free(out);

    return 0;
}