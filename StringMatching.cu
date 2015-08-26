# Cuda
#include<stdio.h>
#include<cuda.h>
#include<string.h>

#define N 100
__global__ void comp(char *str1,char *str2,int len1,int len2,int *count)
{
        int id=threadIdx.x;
        int flag=0;
        for(int i=0;i<len2;i++,id++)
        {
                if(str1[id]!=str2[i])
                    flag=1;
        }
        if(flag==0)
               atomicAdd(count,1);

}

int main()
{
        char str1[N],str2[N];
        int len1,len2,count;
        char *dev_a,*dev_b;
        int *dev_c;

        cudaMalloc((void **) &dev_a,N*sizeof(char));
        cudaMalloc((void **) &dev_b,N*sizeof(char));
        cudaMalloc((void **) &dev_c,sizeof(int));

        printf("\nEnter first string:");
        scanf("%s",str1);
        printf("\nEnter the substring:");
        scanf("%s",str2);
        len1=strlen(str1);
        len2=strlen(str2);

        cudaMemcpy(dev_a,str1,N*sizeof(char),cudaMemcpyHostToDevice);
        cudaMemcpy(dev_b,str2,N*sizeof(char),cudaMemcpyHostToDevice);

        comp<<<1,len1>>>(dev_a,dev_b,len1,len2,dev_c);

        cudaMemcpy(&count,dev_c,sizeof(int),cudaMemcpyDeviceToHost);

        printf("\n%d",count);
}
