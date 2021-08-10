#include <stdio.h>
#include <stdlib.h>

int main()
{
    FILE *fp;
    int width, height, pixel, i;
    unsigned char *red, *green, *blue;

    printf("width? >>> ");
    scanf("%d", &width);
    printf("height? >>> ");
    scanf("%d", &height);

    pixel = width * height;

    red = (unsigned char *)malloc(pixel * sizeof(unsigned char));
    green = (unsigned char *)malloc(pixel * sizeof(unsigned char));
    blue = (unsigned char *)malloc(pixel * sizeof(unsigned char));

    if ( red == NULL || pixel > 100000000 )
    {
        printf("too many pixels...");
        return 0;
    }

    printf("width = %d\nheight = %d\npixel = %d", width, height, pixel);

    for ( i = 0; i < pixel; i++) red[i]   = rand() % 255;
    for ( i = 0; i < pixel; i++) green[i] = rand() % 255;
    for ( i = 0; i < pixel; i++) blue[i]  = rand() % 255;

    fp = fopen("image.txt", "w");

    fprintf(fp, "%d %d %d\n", width, height, pixel);

    for ( i = 0; i < pixel; i++)
    {
        fprintf(fp, "%d %d %d\n", red[i], green[i], blue[i]);
    }

    fclose(fp);

    free(red);
    free(green);
    free(blue);

    return 0;
}