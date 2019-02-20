#include<stdlib.h>
#include<stdio.h>
#include<unistd.h>

int main () {
  
  int potok[2], chars_read;
  char buffer[BUFSIZ], filename[20]; 
 
  printf("Enter path of the file you want to display: \n");
  scanf("%s", filename);
  
  FILE *pic = fopen(filename, "r");
  if (pic == NULL){
    printf("File does not exist!\n");
    exit(-1);
  }

  pipe(potok);

  if (fork() == 0){
    close(0);
    dup(potok[0]);
    close(potok[0]);
    close(potok[1]);
    close(1);
    execlp("display","display", NULL);
    exit(1);
  }

  close(potok[0]);
  while ((chars_read=fread(buffer, sizeof(char), BUFSIZ, pic))>0)
    write(potok[1],buffer,chars_read);
  close(potok[1]);

}