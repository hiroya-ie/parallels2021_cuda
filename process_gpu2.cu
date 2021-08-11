#include <stdio.h>
#include <stdlib.h>
#include <time.h>

__global__ void convertToGray(int pixel, int cycle, unsigned char *red, unsigned char *green, unsigned char *blue, unsigned char *out)
{
    for (int j = blockIdx.x; j < cycle; j+=gridDim.x)
    {
        for (int i = threadIdx.x; i < pixel; i+=blockDim.x)
        {
        out[i] = (red[i] + green[i] + blue[i]) / 3;
        /*printf("%d,", out[i]);*/
        }
    }
}

int main()
{
    int width, height, pixel, cycle, i;
    unsigned char *red,   *green,   *blue,   *out;
    unsigned char *d_red, *d_green, *d_blue, *d_out;

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

    /* Allocate device memory */
    cudaMalloc((void**)&d_red,   pixel * sizeof(unsigned char));
    cudaMalloc((void**)&d_green, pixel * sizeof(unsigned char));
    cudaMalloc((void**)&d_blue,  pixel * sizeof(unsigned char));
    cudaMalloc((void**)&d_out,   pixel * sizeof(unsigned char));

    /* Transfer data from host to device memory */
    cudaMemcpy(d_red,   red,   pixel * sizeof(unsigned char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_green, green, pixel * sizeof(unsigned char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_blue,  blue,  pixel * sizeof(unsigned char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_out,   out,   pixel * sizeof(unsigned char), cudaMemcpyHostToDevice);

    /* Main function */
    convertToGray<<< 512,1024>>>(pixel, cycle, d_red, d_green, d_blue, d_out);

    /* Transfer data from device to host memory */
    cudaMemcpy(out, d_out, pixel * sizeof(unsigned char), cudaMemcpyDeviceToHost);

    /* Stop timer */
    clock_t end = clock();

    /* Show result */
    printf("\n(width, height, pixel, cycle) = (%d, %d, %d, %d)\n", width, height, pixel, cycle);
    printf( "clock:%f\n", (double)(end - start) / CLOCKS_PER_SEC);

    /* Deallocate device memory */
    cudaFree(d_red);
    cudaFree(d_green);
    cudaFree(d_blue);
    cudaFree(d_out);

    /* Deallocate host memory */
    free(red);
    free(green);
    free(blue);
    free(out);

    return 0;
}