#include "types.h"
#include "versatilepb_pl190_vic.h"
#include "uart.h"
#include "vid.h"

extern UART uart[4];
extern void uart_handler(UART *up);

extern void uprints(UART *up, u8 *s);
extern void ugets(UART *up, char *s);

#define SIZE 10
char* le_linha(int nproc);
void escreve_linha(int nproc, char* linha);
char* trata_linha(int nproc, char* linha);

UART *up;
void init_display()
{
	
	VIC_INTENABLE |= UART0_IRQ_VIC_BIT;
	VIC_INTENABLE |= UART1_IRQ_VIC_BIT;

	uart_init();
	up= &uart[0];
}
	
void process(int x)
{
	while(1) {
        	char* s = le_linha(x);
		char* t = trata_linha(x,s);
        	escreve_linha(x, t);
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

int tabela[SIZE];

int fila_leitura[SIZE];
int can_read = 1;
int read_line[] = {1,0};
char* le_linha(int nproc)
{
    /*char* linha;
    ugets(up, linha);
    return linha;*/
	if(can_read == 0) {
		read_line[nproc] = 0;
	}
	while(read_line[nproc] == 0) {}
	can_read = 0;
	char* linha;
    	ugets(up, linha);
	can_read = 1;
	if(nproc == 0) {
		read_line[0] = 0;
		read_line[1] = 1;
	} else {
		read_line[0] = 1;
		read_line[1] = 0;
	}	
	return linha;
}

int can_write = 1;
int fila_escrita[SIZE];
void escreve_linha(int nproc, char* linha)
{
    uprints(up, linha);
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
