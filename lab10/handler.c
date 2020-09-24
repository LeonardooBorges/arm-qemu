volatile unsigned int * const UART0DR2 = (unsigned int *)0x101f1000;
volatile unsigned int * const TIMER0X = (unsigned int *)0x101E200c;

void print_uart02(const char *s) {
    while(*s != '\0') { /* Loop until end of string */
    *UART0DR2 = (unsigned int)(*s); /* Transmit char */
    s++; /* Next char */
    }
}

void timer_handler(){
    print_uart02("#");
}
