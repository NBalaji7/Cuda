#include<stdio.h>
#include<stdlib.h>
#include<cuda.h>
#define N 3
#define BLOCK_DIM 3

__global__ void matrixAdd(int *a,int *b,int *c)
{
	int col=blockIdx.x*blockDim.x+threadIdx.x;
	int row=blockIdx.y*blockDim.y+threadIdx.y;
	int index=col+row*N;
	printf("\n%d\t%d",threadIdx.x,threadIdx.y);
	printf("\nIndex val:%d\n",index);
	if(col<N && row<N)
	{
		c[index]=a[index]+b[index];
	}
}

int main()
{
	int x[3][3]={1,2,3,4,5,6,7,8,9};
	int y[3][3]={0,1,2,3,4,5,6,7,8};
	int z[3][3];
	int i=0,j=0;
	int *dev_a,*dev_b,*dev_c;
	cudaMalloc((void**)&dev_a,sizeof(x));
	cudaMalloc((void**)&dev_b,sizeof(y));
	cudaMalloc((void**)&dev_c,sizeof(z));
	cudaMemcpy(dev_a,x,sizeof(x),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b,y,sizeof(y),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_c,z,sizeof(z),cudaMemcpyHostToDevice);

	dim3 dimBlock(BLOCK_DIM,BLOCK_DIM	);
	dim3 dimGrid((int)ceil(N/dimBlock.x),(int)ceil(N/dimBlock.y));
	matrixAdd<<<dimGrid,dimBlock>>>(dev_a,dev_b,dev_c);
	cudaMemcpy(z,dev_c,sizeof(z),cudaMemcpyDeviceToHost);
	printf("\noutput\n");
	for(i=0;i<3;i++)
	{
		for(j=0;j<3;j++)
		{
			printf("\n%d",z[i][j]);	
		}
	}
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);
	return 0;
}
