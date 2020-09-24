#include <stdio.h>
#include <string.h>

extern int int2str(int n, const char *p);

void imprime(int N) {
    if (N<0) {
        return;
    }
    const char *p;
    int2str(N, p);
    char str[20] = "numero = ";
    strcat(str, p);
    puts(str);
    imprime(N-1);
}

int main() {
    imprime(5);
    return (0);
}
