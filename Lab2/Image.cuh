/*
 * Image.h
 *
 *  Created on: 6 gru 2015
 *      Author: pSolT
 */

#ifndef IMAGE_H_
#define IMAGE_H_

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/opencv.hpp>
#include "utils.h"
#include <cuda.h>
#include <cuda_runtime.h>
#include <string>
#include "Filter.cuh"

class Image {

public:
	static Image* Load(const std::string &filename);
	void SaveGrayscale(const std::string &filename);
	void SaveRGBA(const std::string &filename);
	Image& ApplyRGBAFilter(RGBAFilter* filter);
	Image&  ApplyGreyscaleFilter(GreyscaleFilter* filter);
	size_t GetRowsCount() const;
	size_t GetColumnsCount() const;
	uchar4 * HostRGBA() const;
	uchar4 * DeviceRGBA() const;
	unsigned char * HostGreyscale() const;
	unsigned char * DeviceGreyscale() const;
	~Image();
private:
	void CreateGreyscale();
	Image();
	cv::Mat imageRGBA;
	cv::Mat imageGrey;
	uchar4 *h_rgbaImage__;
	uchar4 *d_rgbaImage__;
	unsigned char *d_greyImage__;
	unsigned char *h_greyImage__;
};

#endif /* IMAGE_H_ */
