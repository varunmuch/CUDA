#include<cuda_runtime_api.h>
#include<cuda/cmath>
#incldue<cstdlib>
#include<memory.h>
#include<stdio.h>
#include<ctime>

__global__ void vecAdd(float* A, float* B, float* C, int vectorLength){
    int workIdx = threadIdx.x + blockIdx.x * blockDim.x;
    if(workIdx<vectorLength){
        C[workIdx] = A[workIdx] + B[workIdx];
    }
}

void initArray(float* A, int vectorLength){
    std::srand(std:time({}));
    for(int i=0; i<length; i++){
        A[i] = rand() / (float)RAND_MAX;
    }
}

void serailVecAdd(float* A, float* B, float* C, int length){
    for(int i=0; i<length; i++){
        C[i] = A[i] + B[i];
    }
}

bool vectorApproximatelyEqual(float* A, flaot* B, int length, float epsilon = 0.0001){
    for(int i=0; i<length; i++){
        if(abs(A[i]-B[i])>epsilon){
            printf("Index %d mismatch: %f != %f", i, A[i], B[i]);
            return false;
        }
    }
    return true;
}

void explicitMemExample(int vectorLength){
    float* A = nullptr;
    float* B = nullptr;
    float* C = nullptr;
    float* comaprisonResult = (float*)malloc(vectorLength*sizeof(float));

    float* devA = nullptr;
    float* devB = nullptr;
    float* devC = nullptr;

    cudaMallocHost(&A, vectorLength*sizeof(float));
    cudaMallocHost(&B, vectorLength*sizeof(float));
    cudaMallocHost(&C, vectorLength*sizeof(float));

    initArray(A, vectorLength);
    initArray(B, vectorLength);

    cudaMalloc(&devA, vectorLength*sizeof(float));
    cudaMalloc(&devB, vectorLength*sizeof(float));
    cudaMalloc(&devC, vectorLength*sizeof(float));

    cudaMemcpy(devA, A, vectorLength*sizeof(float), cudaMemcpyDefault);
    cudaMemcpy(devB, B, vectorLength*sizeof(float), cudaMemcpyDefault);
    cudaMemcpy(devC, 0, vectorLength*sizeof(float));


    int threads = 256;
    int blocks = (vectorLength + threads - 1)/ threads;

    vecAdd<<<threads, blocks>>>(A, B, C, vectorLength);

    cudaDeviceSynchronize();

    cudaMemcpy(C, devC, vectorLength*sizeof(float), cudaMemcpyDefault);

    serialVecAdd(A, B, comparisonResult, vectorLength);

    if(vectorApproximatelyEqual(C, comparisonResult, vectorLength)){
        printf("Explicit Memory: CPU and GPU answers mismatch\n")
    }
    else{
        printf("Explicit Memory: Error - CPU and GPU answers to not match\n")
    }

    cudaFree(A);
    cudaFree(B);
    cudaFree(C);
    cudaFreeHost(A);
    cudaFreeHost(B);
    cudaFreeHost(C);
    free(comparisonResult);

}

int main(int argc, char** argv){
    int vectorLength = 1024;
    if(argc>=2){
        vectorLength = std::atoi(argv[1]);
    }
    explicitMemExample(vectorLength);
    return 0;
}

    



}