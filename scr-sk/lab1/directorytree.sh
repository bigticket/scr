#!/usr/bin/env bash

# this script makes a directory tree and fill the .txt files with given data

mkdir KatalogA
cd KatalogA
mkdir KatalogB0
cd KatalogB0
echo -e "\tPodobnie jak i wiele innych postaci z książek Milne'a, Kubuś Puchatek został nazwany imieniem jednej z zabawek Christophera Robina Milne'a (1920-1996), syna pisarza.\n\tZ kolei pluszowa zabawka Christophera zosała nazwana tak od imienia niedźwiedzicy Winnipeg będącej żywą maskotką kanadyjskiego wojska z Korpusu Weterynaryjnego Kanady." >> puchatek.txt
echo -e "\t260\t15.568 -13.65842.587 109.169\n\t259\t-81.395-50.075-12.86632.528\n\t258\t10.522 37.701 -4.843 44.894\n\t257\t-64.84911.416 2.066  36.619\n\t256\t86.834 93.307 57.582 27.923\n\t255\t-32.839-21.847-25.36249.023\n\t254\t-108.083     -28.919-36.20339.898\n\t253\t35.565 2.269 -19.075 -19.474\n\t252\t11.601 66.078 -15.93634.376\n\t251\t6.701  -11.251-25.9486.086\n\t250\t-5.692 3.201  -36.721-44.202" >> samle.txt
cd ..
mkdir KatalogB1
cd KatalogB1
mkdir KatalogC
cd KatalogC
mkdir KatalogD
cd KatalogD
echo "fikcyjne istoty o antropomorficznej budowie ciała(nieco podobne do hipopotamów, ale dwunożne), zamieszkujące pewną dolinę gdzieś w Finlandii, bohaterowie cyklu dziewięciu książek i dwudziestu dwóch komiksów fińskiej(piszącej po szwedzku) autorki Tove Jansson, oraz pięćdziesięciu dwóch komiksów brata Tove Larsa Janssona. Są one odmianą trolli" >> muminki.txt

