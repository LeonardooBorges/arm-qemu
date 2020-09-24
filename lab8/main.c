#include <stdio.h>
					
extern int myadd(int a, int b);
					
int main()
{
    int a = 4;
    int b = 5;
    printf("Adding %d and %d results in %d\n", a, b, myadd(a, b));
    return (0);
}
