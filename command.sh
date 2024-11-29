flex Lexical.l
bison -d syntax.y
gcc lex.yy.c syn.tab.c -o compiler -lfl -ly
./compiler<test.txt