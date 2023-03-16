
%x CHAR
%x CMT
%x COMMENT

%x STRING
%{

#include<iostream>
#include<stdlib.h>
#include<string.h>
using namespace std;

#include "SymbolTable.h"
//#include "1705055_SymbolInfo.h"
#define YYSTYPE SymbolInfo*

#include "y.tab.h"

#include<bits/stdc++.h>


	
SymbolTable smtable(7,1);

FILE* logFile;
FILE* output;		 

std::string tmp = "";
std::string origin = "";
std::string pp="";
int lineCount = 1,errorCount = 0;
int counter = 0;


string to_upper(string in)
{
	string t = in;
    for (int i = 0; i < in.length(); i++)
          if ('a' <= in[i] <= 'z')
              t[i] = in[i] - 'a' + 'A';
    return t;
}

void PrintLog(int count, std::string Token, std::string Lexeme){
	fprintf(logFile, "\nLine no %d: Token %s Lexeme %s found\n",count,Token.c_str(),Lexeme.c_str());
}

void PrintLog2(int count, std::string Token){
	fprintf(logFile, "\nLine no %d: Token %s Lexeme %s found\n",count,Token.c_str(),tmp.c_str());
}
void PrintOutPutFile_TV(std::string Token, std::string value){
	fprintf(output,"<%s, %s> ",Token.c_str(),value.c_str());
}

void PrintOutPutFile_T(std::string Token){
	fprintf(output,"<%s> ",Token.c_str());
}

void PrintLogSpec(int count, std::string Token, std::string Lexeme,std::string t,std::string n){
	fprintf(logFile, "\nLine no %d: Token %s Lexeme %s found --> <%s, %s>\n",count,Token.c_str(),Lexeme.c_str(),t.c_str(),n.c_str());
} 

void PrintOutPutFile_Str(std::string Token, std::string value){
	std::string::size_type i =0;
	pp="";
	for (i = 0; i < value.size()-1; i++) {
    		 //   std::cout << n[i] << ' ';
    		    if(value[i] =='\\' && value[i+1] == 't') {
    		    pp+='\t';
    		    i++;
    		    }
    		    else if(value[i] =='\\' && value[i+1] == '\"') {
    		    pp+='\"';
    		    i++;
    		    }
    		    
    		    else if(value[i] =='\\' && value[i+1] == '\n') {

    		    i++;
    		    }
    		    else
    		    pp+=value[i];
    		}	
    		pp+=value[i];

	fprintf(output,"<%s, %s> ",Token.c_str(),pp.c_str());
	pp="";
}

void PrintLogSpecStr(int count, std::string Token, std::string Lexeme,std::string t,std::string n){
	std::string::size_type i =0;
	pp="";
	for (i = 0; i < n.size()-1; i++) {
    		 //   std::cout << n[i] << ' ';
    		    if(n[i] =='\\' && n[i+1] == 't') {
    		    pp+='\t';
    		    i++;
    		    }
    		     else if(n[i] =='\\' && n[i+1] == '\"') {
    		    pp+='\"';
    		    i++;
    		    }
    		     else if(n[i] =='\\' && n[i+1] == '\n') {

    		    i++;
    		    }
    		    else
    		    pp+=n[i];
    		}	
    		pp+=n[i];
	
	fprintf(logFile, "\nLine no %d: Token %s Lexeme %s found --> <%s, %s>\n",count,Token.c_str(),n.c_str(),t.c_str(),pp.c_str());
	pp="";
} 





extern YYSTYPE yylval;
extern SymbolTable *table;
extern FILE *fp1;
void yyerror(char *);


SymbolTable* st;


%}


WS [ \t\v\f\r]+
pl \\\n
nl \n
special [ntafrbv0]
digit [0-9]
letter [a-zA-Z_] 
wletter [a-zA-Z ] 
identifier ({letter}|_)({letter}|{digit})*
AlphaNumeric [a-zA-Z0-9]

%%
{nl} {lineCount++;}

{WS} {}

"if" {
	printf("%s matched in if rule\n",yytext);
	//PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	//PrintOutPutFile_T(to_upper(yytext));	
	SymbolInfo *s= new SymbolInfo(yytext, "IF");

	yylval = (YYSTYPE)s;
		
	return IF;
	
	}
	
"else" {
	//printf("%s matched in else rule\n",yytext);
	//PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	//PrintOutPutFile_T(to_upper(yytext));	
	SymbolInfo *s= new SymbolInfo(yytext, "ELSE");

	yylval = (YYSTYPE)s;
		
	return ELSE;
	
	}
"then" {
	//printf("%s matched in then rule\n",yytext);
	//PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	//PrintOutPutFile_T(to_upper(yytext));	
	SymbolInfo *s= new SymbolInfo(yytext, "THEN");

	yylval = (YYSTYPE)s;
		
	return THEN;
	
	}
"for" {
	printf("%s matched in for rule\n",yytext);
	//PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	//PrintOutPutFile_T(to_upper(yytext));	
	SymbolInfo *s= new SymbolInfo(yytext, "FOR");

	yylval = (YYSTYPE)s;
		
	return FOR;
	
	}
"do" {
	//printf("%s matched in do rule\n",yytext);
	//PrintLog(lineCount,"<%s>",to_upper(yytext));
	//PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	SymbolInfo *s= new SymbolInfo(yytext, "DO");

	yylval = (YYSTYPE)s;
		
	return DO;
	
	}
"while" {
	//printf("%s matched in while rule\n",yytext);
	//PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	//PrintOutPutFile_T(to_upper(yytext));	
	SymbolInfo *s= new SymbolInfo(yytext, "WHILE");

	yylval = (YYSTYPE)s;
		
	return WHILE;
	
	}
"char" {
	//printf("%s matched in char rule\n",yytext);
	//PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	//PrintOutPutFile_T(to_upper(yytext));	
	SymbolInfo *s= new SymbolInfo(yytext, "CHAR");

	yylval = (YYSTYPE)s;
		
	return CHAR;
	
	}
"break" {
	//printf("%s matched in break rule\n",yytext);
	//PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	//PrintOutPutFile_T(to_upper(yytext));	
	SymbolInfo *s= new SymbolInfo(yytext, "BREAK");

	yylval = (YYSTYPE)s;
		
	return BREAK;
	
	}
"int" 	{ 
	printf("%s matched in int rule\n",to_upper(yytext).c_str());
	
	//PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	//PrintOutPutFile_T(to_upper(yytext));	
	
	SymbolInfo *s= new SymbolInfo(yytext, "INT");

	yylval = (YYSTYPE)s;
		
	return INT;
	
	}
"float" {
	//printf("%s matched in float rule\n",yytext);
	//PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	//PrintOutPutFile_T(to_upper(yytext));	
	SymbolInfo *s= new SymbolInfo(yytext, "FLOAT");

	yylval = (YYSTYPE)s;
		
	return FLOAT;
	
	}
"double" {
	//printf("%s matched in double rule\n",yytext);
	//PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	//PrintOutPutFile_T(to_upper(yytext));	
	SymbolInfo *s= new SymbolInfo(yytext, "DOUBLE");

	yylval = (YYSTYPE)s;
		
	return DOUBLE;
	
	}
"continue" {
	//printf("%s matched in continue rule\n",yytext);
	//PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	//PrintOutPutFile_T(to_upper(yytext));	
	SymbolInfo *s= new SymbolInfo(yytext, "CONTINUE");

	yylval = (YYSTYPE)s;
		
	return CONTINUE;
	
	}
	/*
"case" {printf("%s matched in case rule\n",yytext);
	PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	PrintOutPutFile_T(to_upper(yytext));	
	}
"default" {printf("%s matched in default rule\n",yytext);
	PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	PrintOutPutFile_T(to_upper(yytext));	
	}
	*/
"void" {printf("%s matched in void rule %d\n",yytext,lineCount);
	//PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	//PrintOutPutFile_T(to_upper(yytext));	
	SymbolInfo *s= new SymbolInfo(yytext, "VOID");

	yylval = (YYSTYPE)s;
		
	return VOID;
	
	}
"return" {//printf("%s matched in return rule\n",yytext);
	//PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	//PrintOutPutFile_T(to_upper(yytext));	
	SymbolInfo *s= new SymbolInfo(yytext, "RETURN");

	yylval = (YYSTYPE)s;
		
	return RETURN;
	
	}
	/*
"switch" {printf("%s matched in switch rule\n",yytext);
	PrintLog(lineCount,"<"+to_upper(yytext)+">",yytext);
	PrintOutPutFile_T(to_upper(yytext));	
	}
	*/
	
		

{digit}+ {
		/*
		printf("%s const_int matched\n",yytext);
		PrintOutPutFile_TV("CONST_INT", yytext);
		PrintLog(lineCount,"<CONST_INT>",yytext);
		if(smtable.Insert(logFile,yytext,"CONST_INT"))
		smtable.Print_All_Scope(logFile);
		*/
		SymbolInfo *s= new SymbolInfo(yytext, "CONST_INT");

		yylval = (YYSTYPE)s;
		
		return CONST_INT;
	}
{digit}+(\.{digit}+)?(E[+-]?{digit}+)? {/*
		printf("%s const_float matched\n",yytext);
		PrintOutPutFile_TV("CONST_FLOAT", yytext);
		PrintLog(lineCount,"<CONST_FLOAT>",yytext);
		if(smtable.Insert(logFile,yytext,"CONST_FLOAT"))
		smtable.Print_All_Scope(logFile);
		*/
		SymbolInfo *s= new SymbolInfo(yytext,"CONST_FLOAT");

		yylval = (YYSTYPE)s;
		

		return CONST_FLOAT;
			}
	/*

"main" {
		
		printf("%s main matched\n",yytext);
		
		PrintOutPutFile_TV("ID", yytext);
		PrintLog(lineCount,"<ID>",yytext);
		
		if(smtable.Insert(logFile,yytext,"ID"))
		smtable.Print_All_Scope(logFile);
	
		return MAIN;
	}
	*/
	
"println" {
		
		
		
		
		
		SymbolInfo *s= new SymbolInfo(yytext,"PRINTLN");

		yylval = (YYSTYPE)s;

		return PRINTLN;
	}
	
	
	
{identifier} {
		printf("%s id matched\n",yytext);
		/*return ID;
		//PrintOutPutFile_TV("ID", yytext);
		//PrintLog(lineCount,"<ID>",yytext);
		//if(smtable.Insert(logFile,yytext,"ID"))
		//	smtable.Print_All_Scope(logFile);
		*/
		
		SymbolInfo *s= new SymbolInfo(yytext,"ID");

		yylval = (YYSTYPE)s;

		return ID;
	}
	
\'[^((\\)|(\n))]\'	{
		//PrintLog(lineCount,"<CONST_CHAR>",yytext);
		
		std::string st = yytext;
		char *p = yytext;
		p++;
		p[strlen(p)-1] = 0;
		/*
		//fprintf(logFile," --> <CHAR_CONST, %s>",p);
		PrintOutPutFile_TV("CHAR_CONST", p);
		PrintLogSpec(lineCount,"<CONST_CHAR>",st,"CHAR_CONST",p);
		if(smtable.Insert(logFile,st,"CONST_CHAR"))
		smtable.Print_All_Scope(logFile);
		*/
		SymbolInfo *s= new SymbolInfo(p,"CHAR_CONST");

		yylval = (YYSTYPE)s;
		
		return CONST_CHAR;
		
}
'\\t'	{
		
		char *p = "\t";
		/*
		
		PrintOutPutFile_TV("CHAR_CONST", p);
		PrintLogSpec(lineCount,"<CONST_CHAR>",yytext,"CHAR_CONST",p);
		if(smtable.Insert(logFile,yytext,"CONST_CHAR"))
		smtable.Print_All_Scope(logFile);
		*/
		SymbolInfo *s= new SymbolInfo(p, "CHAR_CONST");

		yylval = (YYSTYPE)s;
		
		return CONST_CHAR;
}
'\\r'	{
		
		char *p = "\r";
		/*
		PrintOutPutFile_TV("CHAR_CONST", p);
		PrintLogSpec(lineCount,"<CONST_CHAR>",yytext,"CHAR_CONST",p);
		if(smtable.Insert(logFile,yytext,"CONST_CHAR"))
		smtable.Print_All_Scope(logFile);
		*/
		SymbolInfo *s= new SymbolInfo(p, "CHAR_CONST");

		yylval = (YYSTYPE)s;
		
		return CONST_CHAR;
}
'\\n'	{
		
		char *p = "\n";
		/*
		PrintOutPutFile_TV("CHAR_CONST", p);
		PrintLogSpec(lineCount,"<CONST_CHAR>",yytext,"CHAR_CONST",p);
		if(smtable.Insert(logFile,yytext,"CONST_CHAR"))
		smtable.Print_All_Scope(logFile);*/
		SymbolInfo *s= new SymbolInfo(p, "CHAR_CONST");

		yylval = (YYSTYPE)s;
		
		return CONST_CHAR;
}
'\\v'	{
		
		char *p = "\v";
		/*
		PrintOutPutFile_TV("CHAR_CONST", p);
		PrintLogSpec(lineCount,"<CONST_CHAR>",yytext,"CHAR_CONST",p);
		
		if(smtable.Insert(logFile,yytext,"CONST_CHAR"))
		smtable.Print_All_Scope(logFile);*/
		SymbolInfo *s= new SymbolInfo(p, "CHAR_CONST");

		yylval = (YYSTYPE)s;
		
		return CONST_CHAR;
}
'\\f'	{
		
		char *p = "\f";
		/*
		PrintOutPutFile_TV("CHAR_CONST", p);
		PrintLogSpec(lineCount,"<CONST_CHAR>",yytext,"CHAR_CONST",p);
		if(smtable.Insert(logFile,yytext,"CONST_CHAR"))
		smtable.Print_All_Scope(logFile);
		*/
		SymbolInfo *s= new SymbolInfo(p, "CHAR_CONST");

		yylval = (YYSTYPE)s;
		
		return CONST_CHAR;
}

[\/][\/] { 
		tmp ="\/\/";
		counter=0;
		BEGIN CMT; }
<CMT>[\\][\n] {
		counter++;
		tmp+=yytext;
		//printf("%s is sudo single comment-----",str );
}	
<CMT>[\n] {
		//tmp+=yytext;
		counter++;
		printf("%s is sudo single comment----- \n",tmp.c_str() );

		//PrintLog2(lineCount,"<COMMENT>");
		tmp ="";
		lineCount+=counter;
		BEGIN INITIAL;
}	
<CMT>. {
		tmp+=yytext;
		//printf("%s is sudo single comment-----",str );
}		
	/*
[\/][\/][^\n]* {
		int count = 0;
		for(int i=1;i<strlen(yytext);i++)
		{
			if(yytext[i] == '\n') count++;
		}
		printf("%s matched in Single comment line rule\n",yytext);
		PrintLog(lineCount,"<COMMENT>",yytext);
		lineCount+=count;
}

	
[\/][\/].*([^\n]*{pl})* {
		int count = 0;
		for(int i=1;i<strlen(yytext);i++)
		{
			if(yytext[i] == '\n') count++;
		}
		printf("%s matched in Single comment (sudo multi) rule\n",yytext);
		PrintLog(lineCount,"<COMMENT>",yytext);
		lineCount+=count;
}


	

	*/

(\/)(\*) {
	
	BEGIN COMMENT;
	tmp=yytext;
	counter = 0;
	}
<COMMENT>(\*)(\/)  {
	tmp +=yytext;		
	//PrintLog2(lineCount,"<COMMENT>");
	lineCount+=counter;
	tmp ="";
	counter = 0;
	BEGIN INITIAL;}
<COMMENT>([^*]|\n)+|. {

		for(int i=1;i<strlen(yytext);i++)
		{
			if(yytext[i] == '\n') counter++;
		}
		
		tmp+=yytext;	
		
	}
<COMMENT><<EOF>> {
		for(int i=1;i<strlen(yytext);i++)
		{
			if(yytext[i] == '\n') counter++;
		}
		lineCount+=counter;
		 errorCount++;		
		printf("Unfinished comment %s\n",tmp.c_str());
		//fprintf(logFile,"Error at line no %d: Unterminated Comment %s\n",lineCount,tmp.c_str());
		BEGIN INITIAL;	 }	


(\") {		
	counter =0;
	tmp="\"";	
	origin="\"";			
	BEGIN STRING;
	}

<STRING>(\\)(\n) {
		counter++;
		
		//origin+="";
		//tmp+=yytext;
		//origin+="\\\n";
		//origin+='\\';
		//origin+='\n';
		
		
}
<STRING>.?[\n]	{
		tmp+=yytext;
		origin+=yytext;
		counter++;
		errorCount++;		
		//fprintf(logFile,"Error at line no %d: Unterminated String %s",lineCount,tmp.c_str());
		printf("%s matched in Unfinished string  error  rule\n",tmp.c_str());
		
		lineCount+=counter;
		counter = 0;
		tmp ="";
		origin  = "";
		BEGIN INITIAL;
	}
<STRING>[\\][\"] {
		//tmp+='\"';
		tmp+=yytext;
		origin+=yytext;
		//printf("%s is sudo single comment-----",str );
}
<STRING>[\\][\t] {
		//tmp+='\t';
		tmp+=yytext;
		origin+=yytext;
		printf("%s is sudo single comment--tttt---",tmp );
}

<STRING>[\"] {
		tmp+=yytext;
		origin+=yytext;
		//printf("%s is STRING **** \n",tmp.c_str() );
		//PrintLogSpecStr(lineCount,"<STRING>",tmp.c_str(),"STRING",tmp.c_str());
		//PrintOutPutFile_Str("STRING",tmp.c_str());
		
		SymbolInfo *s= new SymbolInfo("STRING",tmp.c_str());

		yylval = (YYSTYPE)s;
		

		
		
		lineCount+=counter;
		counter = 0;
		tmp ="";
		origin = "";
		//return STRING;
		BEGIN INITIAL;
}	
<STRING>. {
		tmp+=yytext;

		origin+=yytext;
}		
	/*
\"(.*(\\\n)*)*\" {
	
	tmp = ""; 
	
	int count=0;
	
	for(int i=1;i<strlen(yytext)-1;i++)
	{
		if(yytext[i] == '\\' && yytext[i+1] == 'n')
		{
			tmp+="\n";
			i++;
	
		}
		else if(yytext[i] == '\\' && yytext[i+1] == 't')
		{
	
			tmp+="\t";
			i++;
	
		}
		
		else if(yytext[i]=='\\' && yytext[i+1]=='\n')
		{
			count++;
			i++;
			
		}
		else 
		{
	
			tmp+=yytext[i];
			
		}
		
	}
	
	//str[c] = '\0';
	PrintLogSpecStr(lineCount,"<STRING>",yytext,"STRING",tmp.c_str());
	//fprintf(logFile," --> <STRING, \"%s\">",str);
	printf("%s matched in string rule\n",tmp.c_str());
		PrintOutPutFile_TV("STRING", tmp.c_str());
		//PrintLog(lineCount,"<STRING>",str);
		//smtable.Insert(logFile,str,"STRING");
		//smtable.Print_All_Scope(logFile);
	lineCount+=count;
	tmp = "";
}	
	
	*/	
	





"\*" { 
	/*
	PrintOutPutFile_TV("MULOP", yytext);
	PrintLog(lineCount,"<MULOP>",yytext);
	*/
	SymbolInfo *s= new SymbolInfo(yytext, "MULOP");

	yylval = (YYSTYPE)s;
		
	return MULOP;
	
     }
"\/" { 
	/*
	PrintOutPutFile_TV("MULOP", yytext);
	PrintLog(lineCount,"<MULOP>",yytext);
	*/
	SymbolInfo *s= new SymbolInfo(yytext, "MULOP");

	yylval = (YYSTYPE)s;
		
	return MULOP;	
     }
"%" { 
	/*
	PrintOutPutFile_TV("MULOP", yytext);
	PrintLog(lineCount,"<MULOP>",yytext);
	*/
	SymbolInfo *s= new SymbolInfo(yytext, "MULOP");

	yylval = (YYSTYPE)s;
		
	return MULOP;
     }

"&&" { 
	/*
	PrintOutPutFile_TV("LOGICOP", yytext);
	PrintLog(lineCount,"<LOGICOP>",yytext);
	*/
	SymbolInfo *s= new SymbolInfo(yytext, "LOGICOP");

	yylval = (YYSTYPE)s;
		
	return LOGICOP;
     }
"||" { 
	/*
	PrintOutPutFile_TV("LOGICOP", yytext);
	PrintLog(lineCount,"<LOGICOP>",yytext);
	*/
	SymbolInfo *s= new SymbolInfo(yytext, "LOGICOP");

	yylval = (YYSTYPE)s;
		
	return LOGICOP;
     }
"<" { 	/*
	PrintOutPutFile_TV("RELOP", yytext);
	PrintLog(lineCount,"<RELOP>",yytext);
	*/
	SymbolInfo *s= new SymbolInfo(yytext, "RELOP");

	yylval = (YYSTYPE)s;
		
	return RELOP;
     }
     
"<=" { 
	/*
	PrintOutPutFile_TV("RELOP", yytext);
	PrintLog(lineCount,"<RELOP>",yytext);
	*/
	SymbolInfo *s= new SymbolInfo(yytext, "RELOP");

	yylval = (YYSTYPE)s;
		
	return RELOP;
     }
"==" { 
	/*
	PrintOutPutFile_TV("RELOP", yytext);
	PrintLog(lineCount,"<RELOP>",yytext);
	*/
	SymbolInfo *s= new SymbolInfo(yytext, "RELOP");

	yylval = (YYSTYPE)s;
		
	return RELOP;
     }

"=" { 
	/*
	PrintOutPutFile_TV("ASSIGNOP", yytext);
	PrintLog(lineCount,"<ASSIGNOP>",yytext);
	*/
	SymbolInfo *s= new SymbolInfo(yytext, "ASSIGNOP");

	yylval = (YYSTYPE)s;
		
	return ASSIGNOP;
     }

">" { 
	/*
	PrintOutPutFile_TV("RELOP", yytext);
	PrintLog(lineCount,"<RELOP>",yytext);
	*/
	SymbolInfo *s= new SymbolInfo(yytext, "RELOP");

	yylval = (YYSTYPE)s;
		
	return RELOP;
     }
">=" { 
	/*
	PrintOutPutFile_TV("RELOP", yytext);
	PrintLog(lineCount,"<RELOP>",yytext);
	*/
	SymbolInfo *s= new SymbolInfo(yytext, "RELOP");

	yylval = (YYSTYPE)s;
		
	return RELOP;
     }
"!"  { 
	/*
	PrintOutPutFile_TV("NOT", yytext);
	PrintLog(lineCount,"<NOT>",yytext);
	
	*/
	SymbolInfo *s= new SymbolInfo(yytext, "NOT");

	yylval = (YYSTYPE)s;
		
	return NOT;
     }
"!=" { 
	/*
	PrintOutPutFile_TV("RELOP", yytext);
	PrintLog(lineCount,"<RELOP>",yytext);
	*/
	SymbolInfo *s= new SymbolInfo(yytext, "RELOP");

	yylval = (YYSTYPE)s;
		
	return RELOP;
     }
"++" { 
	/*
	PrintOutPutFile_TV("INCOP", yytext);
	PrintLog(lineCount,"<INCOP>",yytext);
	*/
	SymbolInfo *s= new SymbolInfo(yytext, "INCOP");

	yylval = (YYSTYPE)s;
		
	return INCOP;
     }
"+" { 
	//PrintOutPutFile_TV("ADDOP", yytext);
	//PrintLog(lineCount,"<ADDOP>",yytext);
	
	SymbolInfo *s= new SymbolInfo(yytext, "ADDOP");

	yylval = (YYSTYPE)s;
		
	return ADDOP;
	
     }
"--" { 
	//PrintOutPutFile_TV("DECOP", yytext);
	//PrintLog(lineCount,"<DECOP>",yytext);
	
	SymbolInfo *s= new SymbolInfo(yytext, "DECOP");

	yylval = (YYSTYPE)s;
		
	return DECOP;
	
     }
"-" { 
	//PrintOutPutFile_TV("ADDOP", yytext);
	//PrintLog(lineCount,"<ADDOP>",yytext);
	
	SymbolInfo *s= new SymbolInfo(yytext, "ADDOP");

	yylval = (YYSTYPE)s;
		
	return ADDOP;
     }
"(" { 
	//PrintOutPutFile_TV("LPAREN", yytext);
	//PrintLog(lineCount,"<LPAREN>",yytext);
	
	
	SymbolInfo *s= new SymbolInfo(yytext, "LPAREN");

	yylval = (YYSTYPE)s;
		
	return LPAREN;
     }
")" { 
	//PrintOutPutFile_TV("RPAREN", yytext);
	//PrintLog(lineCount,"<RPAREN>",yytext);
	
	SymbolInfo *s= new SymbolInfo(yytext, "RPAREN");

	yylval = (YYSTYPE)s;
		
	return RPAREN;
     }
"{"  { 
	//PrintOutPutFile_TV("LCURL", yytext);
	//PrintLog(lineCount,"<LCURL>",yytext);
	//st->Enter_Scope();
	
	SymbolInfo *s= new SymbolInfo(yytext, "LCURL");

	yylval = (YYSTYPE)s;

	return LCURL;
     }
"}"  { 
	//PrintOutPutFile_TV("RCURL", yytext);
	//PrintLog(lineCount,"<RCURL>",yytext);
	//st->Print_All_Scope(fp1);
	//st->Exit_scope();
	
	SymbolInfo *s= new SymbolInfo(yytext, "RCURL");

	yylval = (YYSTYPE)s;
	
		
	return RCURL;
     }
"["  { 
	//PrintOutPutFile_TV("LTHIRD", yytext);
	//PrintLog(lineCount,"<LTHIRD>",yytext);
	SymbolInfo *s= new SymbolInfo(yytext, "LTHIRD");

	yylval = (YYSTYPE)s;
		
	return LTHIRD;
     }
"]"  { 
	//PrintOutPutFile_TV("RTHIRD", yytext);
	//PrintLog(lineCount,"<RTHIRD>",yytext);
	SymbolInfo *s= new SymbolInfo(yytext, "RTHIRD");

	yylval = (YYSTYPE)s;
		
	return RTHIRD;
     }
","  { 
	//PrintOutPutFile_TV("COMMA", yytext);
	//PrintLog(lineCount,"<COMMA>",yytext);
	SymbolInfo *s= new SymbolInfo(yytext, "COMMA");

	yylval = (YYSTYPE)s;
		
	return COMMA;
     }
";"  { 
	//PrintOutPutFile_TV("SEMICOLON", yytext);
	//PrintLog(lineCount,"<SEMICOLON>",yytext);
	SymbolInfo *s= new SymbolInfo(yytext, "RCURL");

	yylval = (YYSTYPE)s;
		
	
	return SEMICOLON;
     }




	/*
{AlphaNumeric}+ 	{printf("%s matched in Alphanumeric rule\n",yytext);}

	*/





(\.|{digit})* {	
		errorCount++;		
		printf("Too many decimal point error \n");
		//fprintf(logFile,"Error at line no %d: Too many decimal points %s\n",lineCount,yytext);
}
{digit}+(\.{digit}+)?(E[+-]?{digit}+(\.{digit}+)?)?	{	
		errorCount++;		
		printf("Ill formed number \n");
		//fprintf(logFile,"Error at line no %d: Ill formed number %s\n",lineCount,yytext);
}

({digit}+({digit}|{letter})*|{letter}+({digit}|{letter})*)	{	
		errorCount++;		
		//fprintf(logFile,"Error at line no %d: Invalid prefix on ID or invalid suffix on Number %s\n",lineCount,yytext);
		printf("%s matched in dSuffix  error  rule\n",yytext);
}
\'{wletter}{wletter}+\' {	
		errorCount++;		
		//fprintf(logFile,"Error at line no %d: Multi character constant error %s\n",lineCount,yytext);
		printf("%s matched inmulti const error  rule\n",yytext);
}


\'\'.* {
		errorCount++;		
		//printf("Empty const character error %s\n",yytext);
	fprintf(logFile,"Error at line no %d: Empty character constant error %s\n",lineCount,yytext);
}
(\'([a-zA-Z0-9;=\\\+\? ]{-}[\'])*)|([\'][\\][\'])	 {
		errorCount++;		
		//printf("%s matched in Unterminated character error\n",yytext);
		fprintf(logFile,"Error at line no %d: Unterminated character %s\n",lineCount,yytext);

}
	/*
\"[a-zA-Z0-9;=\? |(\\\n)]* {
		int c = 0; 
		for(int i=0;i<strlen(yytext);i++) {
		if(yytext[i] == '\n') c++; 
		}
		errorCount++;		
		fprintf(logFile,"Error at line no %d: Unterminated String %s",lineCount,yytext);
		printf("%s matched in Unfinished string  error  rule\n",yytext);
		lineCount+=c;
}
	*/

. {
		errorCount++;		
		//fprintf(logFile,"Error at line no %d: Unrecognized character %s\n",lineCount,yytext);
		printf("%s matched in Unrecognized error  rule\n",yytext);
	}
	

%%

int yywrap(void)
{
	
	return 1;
}






