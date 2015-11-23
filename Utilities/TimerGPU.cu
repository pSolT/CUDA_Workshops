
#include "TimerGPU.cuh"

#include <cuda.h>
#include <cuda_runtime.h>

struct CUDAEventTimer
{
    cudaEvent_t     start;
    cudaEvent_t     stop;
};

TimerGPU::TimerGPU()
{
	_timer = new CUDAEventTimer();
}


TimerGPU::~TimerGPU() { }

void TimerGPU::StartCounter()
{
    cudaEventCreate(&((*_timer).start));
    cudaEventCreate(&((*_timer).stop));
    cudaEventRecord((*_timer).start,0);
}


float TimerGPU::GetCounter()
{
    float time;
    cudaEventRecord((*_timer).stop, 0);
    cudaEventSynchronize((*_timer).stop);
    cudaEventElapsedTime(&time,(*_timer).start,(*_timer).stop);
    return time;
}
