#include <stdio.h>
					
int mostra;

int main()
{
    mostra = 0;
    __asm__(
        "LDR    r2, =mostra\n\t"
        "LDR    r3, =1\n\t"
        "STR    r3, [r2, #0]\n\t"
    );
    return (0);
}
