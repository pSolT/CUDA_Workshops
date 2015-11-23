/*
 * TimerCPU.cpp
 *
 *  Created on: 15 lis 2015
 *      Author: pSolT
 */

#include "TimerCPU.h"
#include <sys/time.h>
#include <stdio.h>

TimerCPU::TimerCPU(): _currentTime(0) { StartCounter(); }
TimerCPU::~TimerCPU() { }

void TimerCPU::StartCounter()
{
	struct timeval time;
	if(gettimeofday( &time, 0 ))
	{
		return;
	}
	_currentTime = 1000000 * time.tv_sec + time.tv_usec;
}

double TimerCPU::GetCounter()
{
	struct timeval time;
	if(gettimeofday( &time, 0 ))
	{
		return -1;
	}
	long currentTime = 1000000 * time.tv_sec + time.tv_usec;
	double seconds = (currentTime - _currentTime) / 1000000.0;
	if(seconds < 0)
	{
		seconds += 86400;
	}
	_currentTime = currentTime;

	return 1000.0*seconds;
}
