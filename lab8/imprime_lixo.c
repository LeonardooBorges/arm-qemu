void imprime(int N, int i) {
    if (i>=N) {
        return;
    }
    printf("numero = %d\n", ++i);
    imprime(N, i);
}


int main() {
    imprime(7, 0);
    return (0);
}
