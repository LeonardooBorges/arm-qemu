#include "types.h"
#include "versatilepb_pl190_vic.h"
#include "uart.h"
#include "vid.h"

extern UART uart[4];
extern void uart_handler(UART *up);

extern void uprints(UART *up, u8 *s);
extern void ugets(UART *up, char *s);

#define SIZE 10
void enQueue(int items[], int value);
int deQueue(int items[]);
extern void syscall_le_linha(UART *up, char *s);
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
		char *s, *t;
		syscall_le_linha(&uart[0],s);
		t = trata_linha(x, s);
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

int tabela[SIZE];

int fila_leitura[SIZE];
int can_read = 1;
char* le_linha(int nproc)
{
    char* linha;
    if(can_read == 0) 
    {
        enQueue(fila_leitura, nproc);
        tabela[nproc] = 1;
    }
    while(tabela[nproc] == 1) { }
    can_read = 0;
    ugets(up, linha);
    can_read = 1;
    int p = deQueue(fila_leitura);
    tabela[p] = 0;
    return linha;
}

int can_write = 1;
int fila_escrita[SIZE];
void escreve_linha(int nproc, char* linha)
{
    if(can_write == 0)
    {
        enQueue(fila_escrita, nproc);
        tabela[nproc] = 1;
    }
    while(tabela[nproc] == 1) { }
    can_write = 0;
    uprints(up, linha);
    can_write = 1;
    int p = deQueue(fila_escrita);
    tabela[p] = 0;
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

int front = -1, rear = -1;

void enQueue(int items[], int value) 
{
    if (front == -1)
        front = 0;
    rear++;
    items[rear] = value;
}

int deQueue(int items[]) 
{
    int item = items[front];
    front++;
    if (front > rear)
        front = rear = -1;
    return item;
}
