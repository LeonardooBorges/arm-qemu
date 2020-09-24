#include <stdio.h>
					
extern int int2str(int n, const char *p);
					
int main()
{
    const char *p;
    int2str(9345213, p);
    puts(p);
    return (0);
}
