#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <cstdio>
#include <iostream>

using namespace std;

__global__ void convolucion2D(int* d_matriz,int fil,int col) {
	for (int i = 0; i < fil; i++) {
		for (int j = 0; j < col; j++) {
			printf("%d", d_matriz[i * col + j]);
		}
		printf("\n");
	}
}

void crearMatriz(int* matriz, int fil, int col, int dif) {
	if (dif == 1) {
		for (int j = 0; j < fil; j++) {

			for (int i = 0; i < col; i++) {

				matriz[i * col + j] = rand() % 4 + 1;
			}
		}
	}
	else {
		for (int j = 0; j < fil; j++) {

			for (int i = 0; i < col; i++) {

				matriz[i * col + j] = rand() % 6 + 1;
			}
		}
	}
}

void eliminarPosicion(int X, int Y, int** matriz) {
	matriz[X][Y] = 0;
}



int main() {
	int dif;
	int fil;
	int col;
	cout << "Dificultad (1 Facil y 2 Dificil)" << endl;
	cin >> dif;
	cout << "Tamanio de la matriz" << endl;
	cout << "Numero de columnas" << endl;
	cin >> col;
	cout << "Numero de filas" << endl;
	cin >> fil;
	printf("\n");
	int* matriz = new int[fil * col];

	crearMatriz(matriz, fil, col, dif);

	int* d_matriz;
	cudaMalloc((void**)&d_matriz, fil * col * sizeof(int));



	dim3 numBloques(1);
	dim3 hilosEnBloque(1);

	cudaMemcpy(d_matriz, matriz, col * fil * sizeof(int), cudaMemcpyHostToDevice);
	
	convolucion2D << <numBloques, hilosEnBloque >> > (d_matriz, fil, col);
	
	cudaMemcpy(matriz, d_matriz, col * fil * sizeof(int), cudaMemcpyDeviceToHost);

	cudaFree(d_matriz);
}
	/*
	* 
	* ////////////Codigo de 2D por si acaso
	cudaMemcpy(d_matriz, matriz, col * sizeof(int), cudaMemcpyHostToDevice);
	dim3 numBloques(1);
	dim3 hilosEnBloque(1);
	convolucion2D << <numBloques, hilosEnBloque >> > (d_matriz, fil, col);

	for (int i = 0; i < fil; i++) {
		cudaMemcpy(matriz[i], d_matriz[i], col * sizeof(int), cudaMemcpyDeviceToHost);
	}
	for (int i = 0; i < fil; i++) {
		cudaFree(d_matriz[i]); // libera memoria para cada fila de la matriz
	}
	cudaFree(d_matriz);
		/*for (int i = 0; i < fil; i++) {
		cudaMalloc((void**)&d_matriz[i], col * sizeof(int));
	}*/

	/*for (int i = 0; i < fil; i++) {

		cudaMemcpy(d_matriz[i], matriz[i], col * sizeof(int), cudaMemcpyHostToDevice);
	}*/

		/*
		* 
		* 
		* 
		* /////Codigo lo de pillar las coordenadas
	int X_coord;
	int Y_coord;
	cout << "Fila en la que quieres borrar" << endl;
	cin >> X_coord;
	cout << "Columna en la que quieres borrar" << endl;
	cin >> Y_coord;
	eliminarPosicion(X_coord, Y_coord, matriz);
	for (int i = 0; i < fil; i++) {
		for (int j = 0; j < col; j++) {
			cout << matriz[i][j] << " ";
		}
		cout << endl;
	}
	*/

