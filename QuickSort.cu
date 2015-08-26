#define N 5

using namespace std;

__global__ void quickSort(int *x, int *dfirst, int *dlast, int *list)
{
	int idx = threadIdx.x;
	int first = dfirst[idx];
	int last = dlast[idx];
	list[idx] = 0;

	if(first<last)
	{
		int pivot, j, temp, i;

		pivot = first;
		i = first;
		j = last;

		while(i<j)
		{
			while(x[i]<=x[pivot] && i<last)
				i++;
			while(x[j] > x[pivot])
				j--;
			if(i<j)
			{
				temp = x[i];
				x[i] = x[j];
				x[j] = temp;
			}
		}

		temp = x[pivot];
		x[pivot] = x[j];
		x[j] = temp;

		for(i=first; i<=last; i++)
			if(x[i] > x[i+1])
			{
				list[idx] = j+1;
				break;
			}
	}
}

int main()
{
	int a[N] = {1, 5, 9, 3, 6}, *da, i, size = N*sizeof(int), len = 0;
	int *list, *dlist, *dfirst, *dlast;

	cudaMalloc(&da, size);
	cudaMemcpy(da, a, size, cudaMemcpyHostToDevice);

	vector<int> v;

	while(true)
	{
		size = (++len)*sizeof(int);

		int *first = (int *)malloc(size);
		int *last = (int *)malloc(size);

		first[0] = 0;
		last[len-1] = N-1;

		for(i=0; i<v.size(); i++)
		{
			first[i+1] = v[i]+1;
			last[i] = v[i]-1;
		}

		cudaMalloc(&dfirst, size);
		cudaMemcpy(dfirst, first, size, cudaMemcpyHostToDevice);
		cudaMalloc(&dlast, size);
		cudaMemcpy(dlast, last, size, cudaMemcpyHostToDevice);

		cudaMalloc(&dlist, size);

		quickSort<<<1,len>>>(da, dfirst, dlast, dlist);

		list = (int *)malloc(size);
		cudaMemcpy(list, dlist, size, cudaMemcpyDeviceToHost);

		v.clear();
		for(i=0; i<len; i++)
			if(list[i] != 0)
				v.push_back(list[i]-1);
		len = v.size();

		if(len == 0)
			break;
	}

	cudaMemcpy(a, da, N*sizeof(int), cudaMemcpyDeviceToHost);
	for(i=0; i<N; i++)
		printf("%d\t", a[i]);
}
