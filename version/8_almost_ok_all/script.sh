#!/bin/bash

yacc -d -y 1705055.y
echo 'Generated the parser C file as well the header file'
g++ -w -c -o y.o y.tab.c
echo 'Generated the parser object file'
flex 1705055.l
echo 'Generated the scanner C file'
g++ -w -c -o l.o lex.yy.c
# if the above command doesn't work try g++ -fpermissive -w -c -o l.o lex.yy.c
echo 'Generated the scanner object file'
g++ y.o l.o -lfl
echo 'All ready, running'

#g++ SymbolInfo.cpp ScopeTable.cpp SymbolTable.cpp -c

#g++ SymbolTable.h -c
#echo 'making obj file, running'
#g++ SymbolInfo.o ScopeTable.o SymbolTable.o y.o l.o -lfl

#g++ SymbolTable.o y.o l.o -lfl
#echo 'Linking..., running'
./a.out input.c 1705055_log.txt 1705055_error.txt code.asm
echo 'ending...console'
