flex Lexical.l
bison -d syntax.y
gcc lex.yy.c syntax.tab.c -o compilateur -lfl -ly
echo "test 1 : "
./compilateur < test1.txt
echo "\n\n\n\n\n\n\n test 2 : "
./compilateur < test2.txt