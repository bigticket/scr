#include<stdlib.h>
#include<stdio.h>
#include<unistd.h>
#include<fcntl.h>
#include<sys/stat.h>

char* getinput(char line[], size_t len){
  return fgets(line, len, stdin);
}

int file_exist (char *filename)
{
  struct stat buffer;
  return (stat (filename, &buffer) == 0);
}

int main () {
    
  int pipe, chars_read, fd;
  char buffer[BUFSIZ], filename[BUFSIZ];
  
  if (file_exist ("potok")){
    printf("Pipe already exists!\n");
  }
  else{
    printf("Pipe is being created...\n");
    system("mknod potok p");
  }

  do{
    printf("Enter path of the file you want to display(q - exit): \n");
    scanf("%s", filename);
    if ( filename[0] == 'q' )
      break;
    else{ 
      fd = open(filename, O_RDONLY);
      if (fd < 0){
        printf("File does not exist!\n");
        exit(-1);
      }
      pipe = open("potok", O_WRONLY);

      while ((chars_read=read(fd, buffer, BUFSIZ))>0)
        write(pipe,buffer,chars_read);
      close(fd);
      close(pipe);
    }
  } while ( getinput(filename, sizeof(filename)) );

  return 0;
}