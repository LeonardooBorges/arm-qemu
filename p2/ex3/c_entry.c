volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;

void print_uart0(const char *s) {
    while(*s != '\0') { /* Loop until end of string */
    *UART0DR = (unsigned int)(*s); /* Transmit char */
    s++; /* Next char */
    }
}

void print_uart0_char(char c) {
    *UART0DR = (unsigned int)(c); /* Transmit char */
}

void undefined() {
    print_uart0("instrucao invalida!\n");
}

void print_hashtag() {
    print_uart0("#");
}

void processA() {
    while(1){
        print_uart0("1");
    }
}

void processB() {
    while(1){
        print_uart0("2");
    }
}

void processC() {
    while(1){
        print_uart0("3");
    }
}
