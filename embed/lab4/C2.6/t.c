#include "types.h"
#include "versatilepb_pl190_vic.h"
#include "uart.h"
#include "vid.h"

void init_display()
{
    fbuf_init();
}

void process(int x)
{
    while(1)
    {
        show_bmp(0, 0, x);// show the image at the screen location (0,0)
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
