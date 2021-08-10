#include <stdio.h>
#include <stdlib.h>
#include <time.h>

__global__ void convertToGray(int pixel, unsigned char *red, unsigned char *green, unsigned char *blue, unsigned char *out)
{
    //int i = blockIdx.x*blockDim.x + threadIdx.x;
    for (int j = blockIdx.x; j < 100000; j+=gridDim.x)
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
    FILE *fp;
    int width, height, pixel, i;
    unsigned char *red, *green, *blue, *out;
    unsigned char *d_red, *d_green, *d_blue, *d_out;



    fp = fopen("image.txt", "r");

    fscanf(fp, "%d %d %d", &width, &height, &pixel);

    // Allocate host memory
    red   = (unsigned char *)malloc(pixel * sizeof(unsigned char));
    green = (unsigned char *)malloc(pixel * sizeof(unsigned char));
    blue  = (unsigned char *)malloc(pixel * sizeof(unsigned char));
    out   = (unsigned char *)malloc(pixel * sizeof(unsigned char));

    for ( i = 0; i < pixel; i++) fscanf(fp, "%hhu %hhu %hhu", &red[i], &green[i], &blue[i]);

    fclose(fp);


    clock_t start = clock();

    // Allocate device memory
    cudaMalloc((void**)&d_red,   pixel * sizeof(unsigned char));
    cudaMalloc((void**)&d_green, pixel * sizeof(unsigned char));
    cudaMalloc((void**)&d_blue,  pixel * sizeof(unsigned char));
    cudaMalloc((void**)&d_out,   pixel * sizeof(unsigned char));

    // Transfer data from host to device memory
    cudaMemcpy(d_red,   red,   pixel * sizeof(unsigned char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_green, green, pixel * sizeof(unsigned char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_blue,  blue,  pixel * sizeof(unsigned char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_out,   out,   pixel * sizeof(unsigned char), cudaMemcpyHostToDevice);

    // Main function
    convertToGray<<< 1024, 1024>>>(pixel, d_red, d_green, d_blue, d_out);

    // Transfer data from device to host memory
    cudaMemcpy(out, d_out, pixel * sizeof(unsigned char), cudaMemcpyDeviceToHost);

    clock_t end = clock();

    // printf("\nwidth = %d\nheight = %d\npixel = %d\n", width, height, pixel);

    printf( "clock:%f\n", (double)(end - start) / CLOCKS_PER_SEC);

    // Deallocate device memory
    cudaFree(d_red);
    cudaFree(d_green);
    cudaFree(d_blue);
    cudaFree(d_out);

    // Deallocate host memory
    free(red);
    free(green);
    free(blue);
    free(out);

    return 0;
}