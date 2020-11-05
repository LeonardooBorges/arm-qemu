#include "types.h"
#include "versatilepb_pl190_vic.h"
#include "uart.h"
#include "vid.h"

#define GETPID_SYSCALL_NB	1

extern UART uart[4];
extern void uart_handler(UART *up);

extern void uprints(UART *up, u8 *s);
extern void ugets(UART *up, char *s);

int system_call(int sc_n);
int SWI_Handler_C(int nb_syscall);
int get_pid();

void init_display()
{
    fbuf_init();
}

void process()
{
    while(1)
    {
        int x = system_call(GETPID_SYSCALL_NB);
        show_bmp((x / 3)*100, (x % 3)*100, x);
	    show_bmp((x / 3)*100, (x % 3)*100, 100);
    }
}


void copy_vectors()
{
    extern u32 vectors_start, vectors_end;
    u32 *vectors_src = &vectors_start;
    u32 *vectors_dst = (u32 *)0;
    while(vectors_src < &vectors_end)
    {
        *vectors_dst++ = *vectors_src++;
    }
}

void IRQ_handler()
{
    u32 vicstatus = VIC_STATUS;

    //UART 0
    if(vicstatus & UART0_IRQ_VIC_BIT)
    {
        uart_handler(&uart[0]);
    }

    //UART 1
    if(vicstatus & UART1_IRQ_VIC_BIT)
    {
        uart_handler(&uart[1]);
    }

}

int SWI_Handler_C(int nb_syscall)
{
    if (nb_syscall == GETPID_SYSCALL_NB){
        return get_pid();
    }
}
