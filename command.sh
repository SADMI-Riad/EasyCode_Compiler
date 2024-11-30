flex Lexical.l
bison -d syntax.y
gcc lex.yy.c syntax.tab.c -o compilateur -lfl -ly
