__global__ void enumsort(int *deva, int *devn)
{
	int tid = threadIdx.x;
	int i, count=0;

	for(i=0;i<N;i++)
		if((deva[i]<=deva[tid])&&(i!=tid))
			count++;

	devn[count]=deva[tid];
}

int main(void)
{
	int a[] = {1, 5, 9, 3, 6};
	int *deva, *n, *devn;
	int i, k = 3;

	n = (int*)malloc(N*sizeof(int));

	cudaMalloc((void**)&deva, N*sizeof(int));
	cudaMalloc((void**)&devn, N*sizeof(int));
	cudaMemcpy(deva, a, N*sizeof(int), cudaMemcpyHostToDevice);

	enumsort<<<1,N>>>(deva,devn);

	cudaMemcpy(n, devn, N*sizeof(int), cudaMemcpyDeviceToHost);

	printf("\nSorted Array: \n");
	for(i=0;i<N;i++)
		printf("%d\t",n[i]);

	printf("\nThe kth largest element is : %d\n",n[N-k]);

	return 0;
}
