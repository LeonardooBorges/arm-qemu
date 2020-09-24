void imprime(int N, int a, int b, int c, int d) {
    if (N<0) {
        return;
    }
    printf("numero = %d\n", N);
    imprime(N-1, --a, --b, --c, --d);
}


int main() {
    imprime(5, 7, 8, 9, 21);
    return (0);
}
