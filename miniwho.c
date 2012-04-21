#include <stdio.h>
#include <utmpx.h>

struct utmpx *utmpp;
struct utmpx *getutent();

int main(){
    printf("sanity check\n");
    return 0;
}
