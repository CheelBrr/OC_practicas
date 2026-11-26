
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

extern void          set_bit(unsigned char *value, unsigned char bit);
extern unsigned char get_bit(unsigned char value, unsigned char bit);

#define BIT_N 0   
#define BIT_O 1   
#define BIT_T 2   
#define BIT_G 3   
#define BIT_D 4  
#define BIT_U 5  

#define SENSORES 2


void update_temp(int *temps)
{
    for (int i = 0; i < SENSORES; i++)
        temps[i] += (rand() % 11) - 5;
}

void update_flags(int *temps, int *last_temps, unsigned char *flags)
{
    for (int i = 0; i < SENSORES; i++) {
        int dif  = temps[i] - last_temps[i];
        int dabs = dif < 0 ? -dif : dif;

        flags[i] = 0;                              
        if (dif == 0) {
            set_bit(&flags[i], BIT_N);
        } else {
            set_bit(&flags[i], dif > 0 ? BIT_U : BIT_D);
            if (dabs == 1)      set_bit(&flags[i], BIT_O);
            else if (dabs == 2) set_bit(&flags[i], BIT_T);
            else                set_bit(&flags[i], BIT_G);
        }
        last_temps[i] = temps[i];
    }
}

void imprime_estado(unsigned char flags)
{
    if (get_bit(flags, BIT_N)) {
        printf("-");
        return;
    }
    char simbolo = get_bit(flags, BIT_U) ? '>' : '<';
    int  cuantos = get_bit(flags, BIT_O) ? 1 : (get_bit(flags, BIT_T) ? 2 : 3);
    for (int k = 0; k < cuantos; k++)
        printf("%c", simbolo);
}

void muestra_menu(int *temps, unsigned char *flags)
{
    printf("\n");
    for (int i = 0; i < SENSORES; i++) {
        printf("SENSOR %d: ~ %d °C ", i + 1, temps[i]);
        imprime_estado(flags[i]);
        printf("\n");
    }
    printf("\n1 Actualizar\n2.Salir\n\nSeleccionar opción: ");
}

int main(void)
{2
    
    unsigned char banderas[SENSORES]       = {0, 0};
    int           ultima_lectura[SENSORES] = {25, 25};
    int           tem_sensores[SENSORES]   = {25, 25};
    int           opcion = 0;

    srand((unsigned) time(NULL));
    for (int i = 0; i < SENSORES; i++)
        set_bit(&banderas[i], BIT_N);               

    do {
        muestra_menu(tem_sensores, banderas);
        if (scanf("%d", &opcion) != 1) {            
            if (feof(stdin)) break;
            scanf("%*s");
            opcion = 0;
        }
        if (opcion == 1) {
            update_temp(tem_sensores);
            update_flags(tem_sensores, ultima_lectura, banderas);
        }
    } while (opcion != 2);

    printf("\n");
    return 0;
}