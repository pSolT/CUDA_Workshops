/*
 * Image.cpp
 *
 *  Created on: 6 gru 2015
 *      Author: pSolT
 */

#include "Image.cuh"

Image::Image()
{

}

Image::~Image()
{
	free(h_greyImage__);
	free(h_rgbaImage__);
	cudaFree(d_rgbaImage__);
	cudaFree(d_greyImage__);
}

Image& Image::ApplyRGBAFilter(RGBAFilter * filter)
{
	int numPixels = GetColumnsCount() * GetRowsCount();
	uchar4 * result;
	cudaMalloc(&result, sizeof(uchar4) * numPixels);
	cudaMemcpy(d_rgbaImage__, h_rgbaImage__, sizeof(uchar4)*numPixels, cudaMemcpyHostToDevice);
	filter->Apply(d_rgbaImage__, result, GetRowsCount(), GetColumnsCount());
	cudaMemcpy(h_rgbaImage__, result, sizeof(uchar4)*numPixels, cudaMemcpyDeviceToHost);
	return *this;
}

Image& Image::ApplyGreyscaleFilter(GreyscaleFilter * filter)
{
	int numPixels = GetColumnsCount() * GetRowsCount();
	unsigned char * result;
	cudaMalloc(&result, sizeof(unsigned char) * numPixels);
	cudaMemcpy(d_greyImage__, h_greyImage__, sizeof(unsigned char)*numPixels, cudaMemcpyHostToDevice);
	filter->Apply(d_greyImage__, result, GetRowsCount(), GetColumnsCount());
	cudaMemcpy(h_greyImage__, result, sizeof(unsigned char)*numPixels, cudaMemcpyDeviceToHost);
	return *this;
}

Image* Image::Load(const std::string &filename)
{
	Image * result = new Image();
	cv::Mat image;
	image = cv::imread(filename.c_str(), CV_LOAD_IMAGE_COLOR);
	if (image.empty()) {
		std::cerr << "Couldn't open file: " << filename << std::endl;
		exit(1);
	}

	// Convert image from default OpenCV color space  to RGBA
	cv::cvtColor(image, result->imageRGBA, CV_BGR2RGBA);

	//allocate memory for the output
	result->imageGrey.create(image.rows, image.cols, CV_8UC1);

	//This shouldn't ever happen given the way the images are created
	//at least based upon my limited understanding of OpenCV, but better to check
	if (!result->imageRGBA.isContinuous() || !result->imageGrey.isContinuous()) {
		std::cerr << "Images aren't continuous!! Exiting." << std::endl;
		exit(1);
	}


	result->h_rgbaImage__ = (uchar4 *) result->imageRGBA.ptr<unsigned char>(0);
	result->h_greyImage__ = result->imageGrey.ptr<unsigned char>(0);

	const size_t numPixels = result->GetRowsCount() * result->GetColumnsCount();
	//allocate memory on the device for both input and output
	checkCudaErrors(cudaMalloc(&result->d_rgbaImage__, sizeof(uchar4) * numPixels));
	checkCudaErrors(cudaMalloc(&result->d_greyImage__, sizeof(unsigned char) * numPixels));

	//copy input array to the GPU
	checkCudaErrors(
			cudaMemcpy(result->d_rgbaImage__, result->h_rgbaImage__, sizeof(uchar4) * numPixels,
					cudaMemcpyHostToDevice));
	checkCudaErrors(
			cudaMemcpy(result->d_greyImage__, result->h_greyImage__,
					sizeof(unsigned char) * numPixels, cudaMemcpyHostToDevice));
	result->CreateGreyscale();
	return result;
}

__global__
void rgba_to_greyscale(const uchar4* const rgbaImage,
                       unsigned char* const greyImage,
                       int numRows, int numCols)
{
	  int blockId = gridDim.x * blockIdx.y + blockIdx.x;
	  int i = blockId * blockDim.x * blockDim.y + blockDim.x * threadIdx.y + threadIdx.x;

	  if(i < numRows * numCols)
	  {
	      greyImage[i] = .299f * rgbaImage[i].x + .587f * rgbaImage[i].y + .114f * rgbaImage[i].z;
	  }
}


void Image::CreateGreyscale()
{

	  const dim3 blockSize(32, 32, 1);  //TODO
	  const dim3 gridSize( 32, 32, 1);  //TODO
	  rgba_to_greyscale<<<gridSize, blockSize>>>(this->d_rgbaImage__, this->d_greyImage__, this->GetRowsCount(), this->GetColumnsCount());

	  cudaDeviceSynchronize(); checkCudaErrors(cudaGetLastError());
	  checkCudaErrors(
				cudaMemcpy(this->h_greyImage__, this->d_greyImage__,
						sizeof(unsigned char) * this->GetRowsCount() * this->GetColumnsCount(), cudaMemcpyDeviceToHost));
}



void Image::SaveGrayscale(const std::string &filename)
{
	cv::Mat output(GetRowsCount(), GetColumnsCount(), CV_8UC1, (void*) h_greyImage__);

	//output the image
	cv::imwrite(filename.c_str(), output);
}

void Image::SaveRGBA(const std::string &filename)
{
	cv::Mat output(GetRowsCount(), GetColumnsCount(), CV_8UC4, (void*) h_rgbaImage__);
	bool cont = output.isContinuous();
	bool empt = output.empty();
	int channels = output.channels();
	cv::Mat bgr;
	cv::cvtColor(output, output, CV_RGB2BGR);
	//output the image
	cv::imwrite(filename.c_str(), output);
}




size_t Image::GetRowsCount() const
{
	return imageRGBA.rows;
}

size_t Image::GetColumnsCount() const
{
	return imageRGBA.cols;
}

uchar4 * Image::HostRGBA() const
{
	return h_rgbaImage__;
}
uchar4 * Image::DeviceRGBA() const
{
	return d_rgbaImage__;
}

unsigned char * Image::HostGreyscale() const
{
	return h_greyImage__;
}
unsigned char * Image::DeviceGreyscale() const
{
	return d_greyImage__;
}
