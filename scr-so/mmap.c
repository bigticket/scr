#include<stdlib.h>
#include<stdio.h>
#include<unistd.h>
#include<fcntl.h>
#include<sys/stat.h>
#include<sys/mman.h>


char* getinput(char line[], size_t len){
  return fgets(line, len, stdin);
}

int file_exist (char *filename)
{
  struct stat buffer;
  return (stat (filename, &buffer) == 0);
}

int empty_file_checker(char *filename)
{
  struct stat buffer;
  stat(filename, &buffer);
  return buffer.st_size;
}

int file_length(int fd)
{
  struct stat buffer;
  fstat(fd, &buffer);
  return buffer.st_size;
}

int main () {
    
  int filedesc, memdesc, filesize, chars_read;
  char buffer[BUFSIZ], filename[BUFSIZ];
  char* mapped_memory;

  if (file_exist ("memory.jpg")){
    printf("Memory file already exists! Preparing workspace...\n");
    system("rm -f memory.jpg");
    system("touch memory.jpg");
  }
  else{
    printf("Memory file is being created...\n");
    system("touch memory.jpg");
  }

  if(fork() == 0){
    while(!empty_file_checker("memory.jpg")){
      sleep(1);
    }
    execlp("display", "display", "-update", "1", "memory.jpg", NULL);
    exit(0);
    }
  
  do{
    int j=0;
    printf("Enter path of the file you want to display(q - exit): \n");
    scanf("%s", filename);
    if ( filename[0] == 'q' )
      exit(0);
    else{ 
      filedesc = open(filename, O_RDONLY);
      if (filedesc < 0){
        printf("File does not exist!\n");
        exit(-1);
      }
      memdesc = open("memory.jpg", O_RDWR);
      if (memdesc < 0){
        printf("Memory file does not exist!");
	exit(-1);      
      }
      
      filesize = file_length(filedesc);
      printf("Parsed file is %d long \n", filesize);
      ftruncate(memdesc, filesize);
      mapped_memory = mmap(0, filesize, PROT_READ | PROT_WRITE, MAP_SHARED, memdesc, 0);
      
      while ((chars_read=read(filedesc, buffer, BUFSIZ))>0){
        for(int i = 0; i < chars_read; i++){
 	  mapped_memory[j] = buffer[i];
	  j++;
        }
      }
      
      msync(mapped_memory, filesize, MS_SYNC);
      close(filedesc);
      close(memdesc);
      munmap(mapped_memory, filesize);
    }
  } while ( getinput(filename, sizeof(filename)) );

  return 0;

}