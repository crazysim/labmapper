#include <stdio.h>
#include <utmpx.h>
#include <time.h>

struct utmpx *utmpp;
struct utmpx *getutent();

int main(){
    utmpp = getutxent();
    while ((utmpp = getutxent())!= (struct utmpx *) NULL) {
        if (utmpp->ut_type == USER_PROCESS){
            printf("%s %s %li %s\n",
                    utmpp->ut_user,
                    utmpp->ut_line,
                    utmpp->ut_tv.tv_sec,
                    utmpp->ut_host);
        }
    }
    return 0;
}
