#include <stdio.h>
#include <utmpx.h>

struct utmpx *utmpp;
struct utmpx *getutent();

int main(){
    utmpp = getutxent();
    while ((utmpp = getutxent())!= (struct utmpx *) NULL) {
        if (utmpp->ut_type == USER_PROCESS){
            printf("%s %s\n", utmpp->ut_user, utmpp->ut_host);
        }
    }
    return 0;
}
