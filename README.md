# scr
programs and scripts written in C and shell during academic classes
## description (written in Polish language):

## check_day.sh

polecenie 
```
export LC_ALL=C 
```
ustawia wartość zmiennej na C, co powoduje wymuszenie lokalizacji kanonicznej. Pozwala to uniezależnić działanie skryptu od lokalizacji. Następnie do zmiennej var przypisujemy wynik polecenia date. Polecenie generuje informację w poniższym formacie:

Mon Oct 15 21:32:10 CEST 2018

Aby stwierdzić, czy obecny dzień jest dniem pracującym, wykorzystuję metaznak ^ do zakotwiczenia wzorca na początku. Jeśli na początku wyniku polecenia date występuje jeden z pracujących dni tygodnia, skrypt wysyła stosowną informację. Podobnie w przypadku weekendu - przyrównujemy początek wyniku polecenia date do wyrażeń reprezentujących sobotę i niedzielę. W razie dopasowania zostanie wystosowany komunikat. 

Aby uruchamiać skrypt wraz ze startem powłoki, należy wykonać poniższe kroki:

utworzyć(lub otworzyć, jeśli istnieje) plik ~/.bashrc

dodać w nim ścieżkę do naszego skryptu, przykładowo: /home/user/SCR/skrypt.sh

aby sprawdzić działanie, wystarczy otworzyć poleceniem bash nową powłokę.

## mail_sender.sh

- zmienna dest przechowuje ścieżkę do katalogu z załącznikami, jakie będziemy chcieli wysłać

- zmienna subject przechowuje tytuł maila

- zmienna attachment będzie miała za zadanie przechowywać łańcuch, który będzie odpowiadał za dołączanie załączników

Pierwszym etapem jest przygotowanie stringa, którego wywołanie zadba o załączenie pożądanych plików do maila. Przeszukujemy ścieżkę, w której umieściliśmy załączniki. Jeśli takowe istnieją(za to jest odpowiedzialny operator -f, który daje prawdę gdy plik istnieje), zostają dołączone do zmiennej attachment poprzedzone parametrem -a, który pozwala programowi mailx uznać plik jako załącznik.

Przykład: w ścieżce przypisanej do zmiennej dest znajdują się dwa pliki. Po wykonaniu tej części zmienna attachment będzie reprezentowała łańcuch:

-a plik1 -a plik2

Główną częścią skryptu jest wysyłanie maili do każdego z adresów wskazanych w pliku adresses.txt. Poprzez iterację po kolejnych wierszach tego pliku, tworzymy polecenia pozwalające na wysłanie wiadomości e-mail do każdego z adresatów.

W pliku body.txt jest zawarta uniwersalna treść maila.

Do obsługi maili został wykorzystany dostępny na serwerach diablo i panamint klient mailx.

Parametr -s pozwala na zadanie tematu wiadomości. Do wysłania załączników wykorzystujemy uprzednio przygotowaną zmienną attachment. Na końcu podajemy adres e-mail, na który chcemy wysłać ofertę.

## find_and_tar.sh

Skrypt wyszukuje docelowo w katalogu bieżącym pliki o zadanej masce, modyfikowane w ciągu N ostatnich dni i tworzy z nich skompresowane archiwum.

Do zmiennej MASK przypisujemy pierwszy argument wywołania, do zmiennej DAYS drugi, a zmienna ARCHIVE_NAME przechowuje trzeci.

Przykład wywołania:

./find.sh '*.txt' 10 archiwum

Zbierze pliki z rozszerzeniem 'txt' modyfikowane w ciągu ostatnich 10 dni oraz stworzy skompresowane archiwum o nazwie archiwum.

## getopts.sh

Skrypt nr 2 rozbudowuje pierwszy program dając wygodny interfejs. Argumenty pozycyjne zastąpione opcjonalnymi jednoliterowymi słowami kluczowymi poprzedzonymi znakiem minus. Parsowanie argumentów opcjonalnych wspiera program getopt. Skrypt wie, że parametry:

- -m (maska) 
- -n (n ostatnich dni w ciągu których plik modyfikowano)
- -a (nazwa archiwum)
będą przyjmować argumenty. Mogą zostać podane w dowolnej kolejności, mogą zostać pominięty.

Wtedy skrypt sprawdza, czy istnieją zmienne środowiskowe przechowujące argumenty dla tych parametrów. Są to:

- SCR_MASK
- SCR_DAYS
- SCR_ARCHIVE_NAME
Aby ustawić zmienną środowiskową należy zadać polecenie:
```
export SCR_MASK="*.txt"
```
natomiast aby sprawdzić, czy takowa istnieje, można wykorzystać polecenie:
```
env (opcjonalnie dla nas env | grep SCR)
```
oraz żeby ją usunąć:
```
unset SCR_MASK 
```
W razie braku podania parametrów opcjonalnych z argumentami oraz braku zmiennych środowiskowych, skrypt poprosi o podanie maski, ilości dni oraz nazwy dla archiwum.

W przypadku podania argumentu -h program zakończy działanie i wyświetli manuala dla getopt. - dodatkowe polecenie od prowadzącego

W przypadku podania złego parametru wywołania, skrypt powiadomi o właściwej składni.

Przykład wywołania:
```
./getopt.sh -n 10 -m '*.txt' -a archiwum
```

## trap.sh

Skrypt co trzy sekundy wypisuje bieżącą datę. Została zaimplementowana obsługa przechwytywania sygnałów - za pomocą programu trap. Po załączeniu skryptu możemy testować przechwytywanie sygnałów w taki sposób:
```
kill -<nr_sygnalu> PID
```
Zaimplementowana funkcjonalność pozwala na przechwytywanie 14 z 15 podstawowych sygnałów, za wyjątkiem sygnału SIGKILL (9). Wysłanie tego sygnału kończy działanie programu.

## pipe.c

Na początku deklarujemy potrzebne zmienne. Pobieramy nazwę pliku, który będziemy chcieli wyświetlić, sprawdzamy czy ten plik istnieje. Polecenie pipe(potok) tworzy potok.

Operacje dla procesu potomnego realizujemy w środku instrukcji warunkowej sprawdzającej, czy proces potomny został utworzony właściwie(fork()==0). Kolejnymi poleceniami zamykamy stdin i przekierowujemy go do potoku(funkcje close i dup). Dalsze polecenia close pozwalają zabezpieczyć przed innymi sposobami interakcji z procesem. Funkcja execlp wywołana z odpowiednimi argumentami pozwala na wyświetlenie programem display wczytanego na stdin obrazu.

Dla procesu nadrzędnego należy zamknąć koniec czytający potoku. Kolejno, za pomocą funkcji fread odczytujemy dane zawarte w pliku, a funkcją write dane są przesyłane w potoku. Korzystając z funkcji close zamykamy koniec piszący potoku.

## fifo.c

Przerobiono program z poprzednich zajęć w taki sposób, aby wykorzystywał potok nazwany i wysyłał do niego zawartości kolejno podanych plików. Dodano dwie funkcje: pierwsza z nich czyta kolejne znaki ze strumienia i zwraca je w postaci tablicy znakowej. Wykorzystujemy ją w pętli - wczytujemy nazwy plików przekazywanych do potoku, a w razie podania klawisza 'q' kończymy działanie programu. Druga funkcja pozwala sprawdzić, czy plik istnieje - wykorzystujemy ją na starcie podczas sprawdzenia, czy potok, z którym chcemy pracować już istnieje. W pętli kolejno sprawdzamy, czy plik tekstowy zlecony do wczytania istnieje, otwieramy go, otwieramy potok, przekazujemy dane i zamykamy plik oraz potok. Do wyświetlania wykorzystujemy polecenie "tail +1cf potok" otwarte w drugim terminalu.

Przykład działania:

1) kompilacja (gcc -Wall -pedantic fifo.c)

2) ./a.out

3) otwieramy drugi terminal, wchodzimy do katalogu ze stworzonym potokiem, wpisujemy polecenie "tail +1cf potok"

4) w programie głównym podajemy kolejne pliki, których zawartość chcemy wysłać do potoku; klawisz 'q' kończy program

## signals.c

Na samym początku napisano program, który w funkcji main wyłącznie inkrementował zmienną i. Program top uwzględniał uruchomiony program w czołówce programów wykorzystujących cykle obliczeniowe komputera. Po dodaniu opóźnienia za pomocą funkcji nanosleep(potrzebna biblioteka time.h) zauważono, że programu już nie widzimy w czołówce wyników polecenia top. 

Następnie dodane zostały mechanizmy przechwytywania oraz reagowania na wysyłane do programu sygnały. Potrzebna była biblioteka signal.h zapewniająca obsługę sygnałów. Ważną na sam początek rzeczą jest stworzenie funkcji przechwytującej sygnał, w moim przypadku sig_catchera. Przydaje się on w funkcji main, gdy za pomocą polecenia signal, która jako argumenty przyjmuje dany sygnał oraz właśnie sig_catchera. W zależności od przechwyconego sygnału, należało zaimplementować jego obsługę. W przypadku sygnału SIGALRM należało wyświetlić komunikat oraz wyjść z programu. Do wywołania polecenia exit(0) potrzebna była biblioteka stdlib.h. Dla sygnału SIGUSR1 wyłącznie wyświetlono komunikat oraz kontynuowano pracę programu. Za pomocą polecenia signal(SIGUSR2, SIG_INT);
sygnał SIGUSR2 został całkowicie ignorowany w trakcie pracy programu.

## mmap.c

Do kodu z poprzednich zajęć dodano dwie funkcje: empty_file_checker, która się przydaje w momencie, gdy sprawdzamy, czy obszar pamięci został zmapowany do pliku oraz file_length, którą używamy do zwrócenia długości pliku podczas jego przetwarzania.

1) sprawdzamy, czy plik, do którego mapujemy pamięć istnieje - jeśli tak, to czyścimy środowisko pracy

2) czynność procesu potomnego - czeka na zmapowanie pamięci do pliku, później uruchamia displaya z aktualizacją

3) proces nadrzędny:

- odpytuje w pętli o kolejne pliki

- sprawdza, czy pliki istnieją(obrazek oraz plik do zapisu zmapowanej pamięci)

- oblicza długość pliku, ustala rozmiar pamięci (ftruncate) oraz mapuje tę pamięć

- wczytuje obrazek do obszaru pamięci

- wymusza aktualizację wyświetlenia obrazka

- zamyka wykorzystywane pliki i kasuje odwzorowanie pamięci
```
jmacek@panamint:~/scr18-19/lab10$ gcc -Wall -pedantic memory.c
jmacek@panamint:~/scr18-19/lab10$ ./a.out 
Memory file already exists! Preparing workspace...
Enter path of the file you want to display(q - exit): 
Lena2.jpg
Parsed file is 138851 long 
Enter path of the file you want to display(q - exit): 
q
```
^ przykład wywołania
