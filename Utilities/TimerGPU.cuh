/*
 * TimerGPU.cuh
 *
 *  Created on: 15 lis 2015
 *      Author: pSolT
 */

#ifndef TIMERGPU_CUH_
#define TIMERGPU_CUH_

struct CUDAEventTimer;

class TimerGPU
{
    public:
        TimerGPU();
        ~TimerGPU();
        void StartCounter();
        void StartCounterFlags();
        float GetCounter();

    private:
		CUDAEventTimer * _timer;

}; // TimerGPU class




#endif /* TIMERGPU_CUH_ */
