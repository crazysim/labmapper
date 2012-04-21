#include <stdio.h>
#include <utmpx.h>

struct utmpx *utmpp;
struct utmpx *getutent();

int main(){
    utmpp = getutxent();
    while ((utmpp = getutxent())!= (struct utmp *) NULL) {
        printf("%s\n", utmpp->ut_user);
    }
    return 0;
}
