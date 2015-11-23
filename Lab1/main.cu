#include "common/book.h"
#include "common/cpu_anim.h"

#define DIM 1024
#define PI 3.1415926535897932f

struct DataBlock{
	unsigned char *dev_bitmap;
	CPUAnimBitmap *bitmap;
};

// clean memory allocated on gpu
void cleanup(DataBlock *d){
	cudaFree(d->dev_bitmap);
}

__global__ void kernel(unsigned char *ptr, int ticks)
{
	// Zmapuj współrzędne wątku w siatce na położenie konkretnego piksela na obrazku
	// int x =
	// int y =
	// int offset = (położenie względem pozątku tablicy ptr)
	

	// oblicz odległość od środka
	// float fx =
	// float fy =
	// float d = (odległość od środka)

	// oblicz kolor
	unsigned char grey = (unsigned char) (128.0f + 127.0f * cos(d/10.0f - ticks / 7.0f) / (d / 10.0f + 1.0f));
	//przypisz kolor pikselowi - 4 kanały !
}

void generate_frame(DataBlock *d, int ticks){
	//określ odpowiednie wymiary bloku
	//dim3 gridDim(?)
	//dim3 blockDim(?)

	//wywołaj kernel

	//skopiuj bitmapę z device na host

}

int main(void){
	DataBlock data;
	CPUAnimBitmap bitmap(DIM, DIM, &data);
	data.bitmap = &bitmap;
	
	HANDLE_ERROR(cudaMalloc((void**)&data.dev_bitmap, bitmap.image_size()));
	
	bitmap.anim_and_exit((void (*)(void*,int))generate_frame, (void (*)(void*))cleanup);

}
