volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;

void print_uart0(const char *s) {
    while(*s != '\0') { /* Loop until end of string */
    *UART0DR = (unsigned int)(*s); /* Transmit char */
    s++; /* Next char */
    }
}

void undefined(char c) {
    print_uart0(&c);
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
