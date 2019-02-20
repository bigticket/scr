#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <time.h>
#include <stdlib.h>
#include <setjmp.h>

/*
SIGALRM - komunikat + exit
SIGTERM - komunikat + powrót
SIGUSR1 - wstrzymanie odbierania na 100 iteracji + wznowienie
SIGUSR2 - całkowite ignorowanie sygnałów
*/

jmp_buf buf;
struct timespec ts = {0, 100000000L};

void sig_catcher(int sig_number)
{
  if (sig_number == SIGALRM)
      {
          printf("SIGALRM has been caught!\n");
          printf("Terminating...\n");
          exit(0);
      }
  else if (sig_number == SIGTERM)
      {
          printf("SIGTERM has been caught!\n");
          longjmp(buf, 1);
      }
  else if (sig_number == SIGUSR1)
      printf("SIGUSR1 has been caught!\n");
}

int i=0;

int main(void){
    signal(SIGALRM, sig_catcher);
    signal(SIGTERM, sig_catcher);
    signal(SIGUSR1, sig_catcher);
    signal(SIGUSR2, SIG_IGN);

    while(1){
        if(setjmp(buf))
        {
            for(int i = 0; i < 100; i++)
                nanosleep(&ts, NULL);
        }
        else
        {
            i++;
            printf("My PID is: %d\n", getpid());
            nanosleep(&ts, NULL);
        }
    }
}