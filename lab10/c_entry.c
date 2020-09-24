volatile unsigned int * const UART0DR = (unsigned int *)0x101f1000;
volatile unsigned int * const TIMER0X = (unsigned int *)0x101E200c;

void print_uart0(const char *s) {
    while(*s != '\0') { /* Loop until end of string */
    *UART0DR = (unsigned int)(*s); /* Transmit char */
    s++; /* Next char */
    }
}

void undefined() {
    print_uart0("instrucao invalida!\n");
}

void c_entry() {
    while(1){
        print_uart0(" ");
    }
}

void timer() {
    *TIMER0X = 0;
    print_uart0("#");
}
