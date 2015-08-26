#include<stdio.h>
#include<cuda.h>
#include<string.h>

#define N 100
__global__ void comp(int *a,int *b,int *dot)
{
        int id=threadIdx.x;
        
        atomicAdd(out,(a[id]*b[id]));
}

int main()
{
        int a[N],b[N];
        int n,out;
        int *dev_a,*dev_b,*dev_c;

        cudaMalloc((void **) &dev_a,N*sizeof(int));
        cudaMalloc((void **) &dev_b,N*sizeof(int));
        cudaMalloc((void **) &dev_c,sizeof(int));

        printf("\nEnter the number of elements:");
        scanf("%d",&n);
       printf("\nEnter array a\n")
       for(int i=0;i<n;i++)
       	scanf("%d",&a[i]);
      printf("\nEnter array b\n");
       for(int i=0;i<n;i++)
       	scanf("%d",&b[i]);
   

        cudaMemcpy(dev_a,a,N*sizeof(int),cudaMemcpyHostToDevice);
        cudaMemcpy(dev_b,b,N*sizeof(int),cudaMemcpyHostToDevice);

        comp<<<1,n>>>(dev_a,dev_b,dev_c);

        cudaMemcpy(&out,dev_c,sizeof(int),cudaMemcpyDeviceToHost);

        printf("\n%d",out);
}
