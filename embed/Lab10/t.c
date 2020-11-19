#include "types.h"
#include "versatilepb_pl190_vic.h"
#include "uart.h"
#include "vid.h"

#define GETPID_SYSCALL_NB	1
#define GETLINHA_SYSCALL_NB	2
#define SLEEP_SYSCALL_NB	3
#define WAKEUP_SYSCALL_NB	4

extern UART uart[4];
extern void uart_handler(UART *up);

extern void uprints(UART *up, u8 *s);
extern void ugets(UART *up, char *s);

int system_call(int sc_n, int pid);
int SWI_Handler_C(int nb_syscall, int pid);
char* trata_linha(int nproc, char* linha);

extern void syscall_le_linha(UART *up, char *s);

int get_pid();
extern char* get_linha(UART *up);
void sleep();
void wakeup(int pid);

UART *up;
void init_uart()
{
	
	VIC_INTENABLE |= UART0_IRQ_VIC_BIT;
	VIC_INTENABLE |= UART1_IRQ_VIC_BIT;

	uart_init();
	up= &uart[0];
}
	
void process()
{
	int pid = system_call(GETPID_SYSCALL_NB, 0);
	/*int proc_1_count = 0;
	int proc_2_count = 0;
	while(1){
		int j = 0;	
       		for(j=0;j<10000000;j++);
		proc_1_count++;
		proc_2_count++;
		if (pid == 1 && proc_1_count >= 5) {
			proc_1_count = 0;
			system_call(SLEEP_SYSCALL_NB, 0);
		}

		if (pid == 0 && proc_2_count >= 20) 
		{
		    proc_2_count = 0;
		    system_call(WAKEUP_SYSCALL_NB, 1);
		}

		if(pid == 0) {
			uprints(&uart[0],"0");
		} else {
			uprints(&uart[0],"1");
		}
		
	    }*/

	
	while(1) {
		char *s, *t;
		int a = system_call(GETLINHA_SYSCALL_NB,0);
		s = (char *) a;
		t = trata_linha(pid,s);
		uprints(&uart[0],t);
    	}
}

char* trata_linha(int nproc, char* linha)
{
	char *linha_copy = linha;
	if(nproc == 0) {
		const char OFFSET = 'a' - 'A';
		while (*linha)
		{
			*linha = (*linha >= 'a' && *linha <= 'z') ? *linha -= OFFSET : *linha;
			linha++;
		}
		return linha_copy;
	}
	return linha;
}


int SWI_Handler_C(int nb_syscall, int pid)
{
    if (nb_syscall == GETPID_SYSCALL_NB){
        return get_pid();
    }
    else if (nb_syscall == GETLINHA_SYSCALL_NB){
        char* s;
        syscall_le_linha(&uart[0], s);
        return (int) s;
    } 
    else if (nb_syscall == SLEEP_SYSCALL_NB){
        sleep();
        return 1;
    }
    else if (nb_syscall == WAKEUP_SYSCALL_NB){
        wakeup(pid);
        return 1;
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


void VIC_Init()
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

