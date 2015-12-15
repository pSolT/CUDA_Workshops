/*
 * Filter.h
 *
 *  Created on: 6 gru 2015
 *      Author: pSolT
 */

#ifndef FILTER_H_
#define FILTER_H_

template<typename PixelValueType>
class Filter
{
public:
	Filter(dim3 gridSize, dim3 blockSize, int tileWidth, int tileHeight, int radius)
		: _gridSize(gridSize), _blockSize(blockSize), _tileWidth(tileWidth), _tileHeight(tileHeight), _radius(radius)

	{
		_diameter = _radius * 2 +1;
		_size = _diameter * _diameter;
		_blockWidth = _tileWidth + (2*_radius);
		_blockHeight = _tileHeight + (2*_radius);
	}

	virtual void Apply( PixelValueType* inputImage, PixelValueType* outputImage, int numRows, int numCols) = 0;
	virtual ~Filter() {}
protected:

	int _tileWidth;
	int _tileHeight;
	int _radius;
	int _diameter;
	int _size;
	int _blockWidth;
	int _blockHeight;
	dim3 _gridSize;
	dim3 _blockSize;
private:
	Filter(){}



};

typedef Filter<uchar4> RGBAFilter;
typedef Filter<unsigned char> GreyscaleFilter;

#endif /* FILTER_H_ */
