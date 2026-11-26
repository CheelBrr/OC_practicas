#include <stdio.h>

#define MAX 5

extern int maximo(int *arr, int len);
extern int minimo(int *arr, int len);
extern int sumatoria(int *arr, int len);

int main(void)
{
    int arr[MAX];
    int n = 0;
    int i;


    while (n < 1 || n > MAX) {
        printf("Cuantos numeros capturaras (1-%d)? ", MAX);
        if (scanf("%d", &n) != 1) {
            while (getchar() != '\n');  
            n = 0;
        }
    }

    for (i = 0; i < n; i++) {
        printf("Elemento [%d]: ", i);
        while (scanf("%d", &arr[i]) != 1) {
            while (getchar() != '\n');
            printf("Valor invalido, intenta de nuevo: ");
        }
    }


    printf("\nArreglo: ");
    for (i = 0; i < n; i++)
        printf("%d ", arr[i]);
    printf("\n");

    printf("Maximo:    %d\n", maximo(arr, n));
    printf("Minimo:    %d\n", minimo(arr, n));
    printf("Sumatoria: %d\n", sumatoria(arr, n));

    return 0;
}