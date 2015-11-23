/*
 * TimerCPU.h
 *
 *  Created on: 15 lis 2015
 *      Author: pSolT
 */

#ifndef TIMERCPU_H_
#define TIMERCPU_H_

class TimerCPU
{
   public:
		TimerCPU();
	   ~TimerCPU();
	   void StartCounter();
	   double GetCounter();
   private:
	   long _currentTime;
};

#endif /* TIMERCPU_H_ */
