CC = gcc 
OUT = -o parser
LE = lex
parser: y.tab.c lex.yy.c y.tab.h 
	$(CC) -w y.tab.c lex.yy.c -ll -ly $(OUT)
lex.yy.c: ${fname}.l
	$(LE) ${fname}.l
y.tab.c: ${fname}.y
	yacc -v -d -t ${fname}.y 2> /dev/null 
clean: 
	rm -f *.c *.o *.out *.exe parser *.h *.gch *.output
