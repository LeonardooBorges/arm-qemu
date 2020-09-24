volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;

void print_uart0(const char *s) {
    while(*s != '\0') { /* Loop until end of string */
    *UART0DR = (unsigned int)(*s); /* Transmit char */
    s++; /* Next char */
    }
}

void undefined() {
    print_uart0("instrucao invalida!\n");
}

void print_hashtag() {
    print_uart0("#");
}

void imprec(const char *s){
    if(*s == '\0') return;
    *UART0DR = (unsigned int)(*s); /* Transmit char */
    s++;
    imprec(s);
}

void processA() {
    while(1){
        print_uart0("Leonardo-");
    }
}

void processB() {
    while(1){
        imprec("9345213-");
    }

}
