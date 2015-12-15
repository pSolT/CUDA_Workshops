#include <iostream>
#include "utils.h"
#include <string>
#include <stdio.h>
#include "Image.cuh"
#include "SimpleFilter.cuh"
#include "ThresholdFilter.cuh"
#include "SobelFilter.cuh"
int main()
{

	std::string input_file;
	std::string output_RGBA_file;
	std::string output_Greyscale_file;
	Image * inputImage = Image::Load(input_file);

	//Skonfiguruj parametry wywołania
	int tileWidth;
	int tileHeight;
	int radius;;
	int blockWidth;
	int blockHeight;

	//Skonfiguruj wywołanie
	dim3 blockSize;
	dim3 gridSize;


	//Zastosuj filtr(y) na obrazek

	cudaDeviceSynchronize();
	checkCudaErrors(cudaGetLastError());

	//Zapisz obrazek

	std::cout << "DONE!" << std::endl;

}
