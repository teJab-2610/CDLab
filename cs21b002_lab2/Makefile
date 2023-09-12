CC=gcc


all:lexer

lexer: lex.yy.c 
	$(CC) lex.yy.c -o lexer

lex.yy.c: $(fname)
	lex $(fname)

clean: 
	rm -f *.o lex.yy.c
	rm -f lexer
	rm -f symbol_table.txt
