%{
#include<iostream>
#include<bits/stdc++.h>
#include<cstdlib>
#include<cstring>
#include<cmath>
#include<string.h>
using namespace std;


#include "SymbolTable.h"
//#include "1705055_SymbolInfo.h"
#define YYSTYPE SymbolInfo*

extern SymbolTable* st;
extern int lineCount;
extern int errorCount;
int yyparse(void);
int yylex(void);
extern FILE *yyin;

bool in_func = false;


vector<pair<string, string>> par_list;
vector<string> par_type_list;
vector <pair<string, pair<string, string>  >> var_list;

vector<pair<string,string>> arg_list;
vector<string> data_seg;
string func_type ="";
string func_name ="";

int labelCount=0;
int tempCount=0;



SymbolTable *table;
FILE *fp1;
FILE *er;
FILE *as;
void yyerror(char *s)
{
	//write your code
	  //fprintf (stderr, "%s\n", s);
}



char *newLabel()
{
	char *lb= new char[4];
	strcpy(lb,"L");
	char b[3];
	sprintf(b,"%d", labelCount);
	labelCount++;
	strcat(lb,b);
	return lb;
}

char *newTemp()
{
	char *t= new char[4];
	strcpy(t,"t");
	char b[3];
	sprintf(b,"%d", tempCount);
	tempCount++;
	strcat(t,b);
	return t;
}

%}
//%error-verbose
%token INT FOR ID SEMICOLON COMMA LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD CONST_FLOAT CONST_INT CONST_CHAR ADDOP MULOP RELOP ASSIGNOP DECOP INCOP NOT LOGICOP IF ELSE BREAK THEN DO WHILE CHAR FLOAT DOUBLE CONTINUE VOID RETURN PRINTF PRINTLN

//%left 
//%right

//%nonassoc 

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%%


start : program
	{
		fprintf(fp1,"\nLine %d: start : program\n",lineCount);
 		
 		
 		
 		//if(errorCount == 0) {
                /* assembly code generation */string init=".MODEL SMALL\n.STACK 100H\n";
		 		
		 		init+=".DATA\n";
		 		
		 		//variables
		 		
                for(int i=0; i<data_seg.size(); i++) {
                    init +="\t"+(string)data_seg[i]+"\n";
                }

                data_seg.clear();

		 		init+=".CODE\n";
				
		 		//function for PRINTLN
		 		init+="PRINT_ID PROC\n\n";
		 		init+="\t;SAVE IN STACK\n";
		 		init+="\tPUSH AX\n";
		 		init+="\tPUSH BX\n";
		 		init+="\tPUSH CX\n";
		 		init+="\tPUSH DX\n\n";

		 		init+="\t;CHECK IF NEGATIVE\n";
		 		init+="\tOR AX, AX\n";
		 		init+="\tJGE PRINT_NUMBER\n\n";
		 		init+="\t;PRINT MINUS SIGN\n";
		 		init+="\tPUSH AX\n";
		 		init+="\tMOV AH, 2\n";
		 		init+="\tMOV DL, '-'\n";
		 		init+="\tINT 21H\n";
		 		init+="\tPOP AX\n\n";
		 		init+="\tNEG AX\n\n";
		 		init+="\tPRINT_NUMBER:\n";
		 		init+="\tXOR CX, CX\n";
		 		init+="\tMOV BX, 10D\n\n";
		 		init+="\tREPEAT_CALC:\n\n";
		 		init+="\t\t;AX:DX- QUOTIENT:REMAINDER\n";
		 		init+="\t\tXOR DX, DX\n";
		 		init+="\t\tDIV BX  ;DIVIDE BY 10\n";
		 		init+="\t\tPUSH DX ;PUSH THE REMAINDER IN STACK\n\n";
		 		init+="\t\tINC CX\n\n";
		 		init+="\t\tOR AX, AX\n";
		 		init+="\t\tJNZ REPEAT_CALC\n\n";

		 		init+="\tMOV AH, 2\n\n";
		 		init+="\tPRINT_LOOP:\n";
		 		init+="\t\tPOP DX\n";
		 		init+="\t\tADD DL, 30H\n";
		 		init+="\t\tINT 21H\n";
		 		init+="\t\tLOOP PRINT_LOOP\n";

		 		init+="\n\t;NEWLINE\n";
		 		init+="\tMOV AH, 2\n";
		 		init+="\tMOV DL, 0AH\n";
		 		init+="\tINT 21H\n";
		 		init+="\tMOV DL, 0DH\n";
		 		init+="\tINT 21H\n\n";

		 		init+="\tPOP AX\n";
		 		init+="\tPOP BX\n";
		 		init+="\tPOP CX\n";
		 		init+="\tPOP DX\n\n";
		 		init+="\tRET\n";
		 		init+="PRINT_ID ENDP\n\n";
				
 				init+= $1->code;	
 		

                //init += (string)"end main";

                $$->code = init;
               
               	fprintf(as,"%s",init.c_str());
 		
 		
 		st->Print_All_Scope(fp1);
 		
		fprintf(fp1,"\nTotal lines: %d\n",lineCount);
		fprintf(fp1,"\nTotal errors: %d\n",errorCount);
		
		
		
		//write your code in this block in all the similar blocks below
	}
	;

program : program unit 
	{
	$$->Name = $1->Name+"\n"+$2->Name;
	$$->code = $1->code + $2->code;
	fprintf(fp1,"\nLine %d: program : program unit\n",lineCount);
 	fprintf(fp1,"\n%s\n",$$->Name.c_str());
 	
	//st->Print_All_Scope(fp1);
	}
	| unit
	{
	$$->Name = $1->Name;
	$$->code = $1->code;
	fprintf(fp1,"\nLine %d: program : unit\n",lineCount);
 	fprintf(fp1,"\n%s\n",$1->Name.c_str());
 	
	//st->Print_All_Scope(fp1);
	}
	;
	
unit : var_declaration
	{
	$$->Name = $1->Name;
	fprintf(fp1,"\nLine %d: unit : var_declaration\n",lineCount);
 	fprintf(fp1,"\n%s\n",$1->Name.c_str());
	}
     | func_declaration
     {
	$$->Name = $1->Name;
	fprintf(fp1,"\nLine %d: unit : func_declaration\n",lineCount);
 	fprintf(fp1,"\n%s\n",$1->Name.c_str());
	}
     | func_definition
     {
     	
     	$$->Name = $1->Name;
     	$$->code = $1->code;
	fprintf(fp1,"\nLine %d: unit : func_definition\n",lineCount);
 	fprintf(fp1,"\n%s\n",$$->Name.c_str());
     }
     ;
     
     /*
func_declaration : type_specifier ID LPAREN parameter_list RPAREN error     
     {
		fprintf(er,"\nError at line %d: var declaration must ends with semicolon\n",lineCount);
		fprintf(fp1,"\nError at line %d: var declaration must ends with semicolon\n",lineCount);
		yyerror("\nError !!\n");
	}
     ;
     */
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
		{
		
		
 		$2->par_type_list = par_type_list;
 		
 		
		if(!st->Insert($2->Name.c_str(),"ID",$1->Name, "func_declaration",par_type_list))
		{
 		  fprintf(er,"\nError at line %d: Multiple declaration of %s func_declaration \n",lineCount, $2->Name.c_str());
 		  fprintf(fp1,"\nError at line %d: Multiple declaration of %s func_declaration \n",lineCount, $2->Name.c_str());
 		  errorCount++;
 		  }
 		par_type_list.clear();
 		par_list.clear(); 
 		$$->Name = $1->Name+" "+$2->Name+$3->Name+$4->Name+$5->Name+";";
		fprintf(fp1,"\nLine %d: func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n",lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
 		  
 		  
		}
		| type_specifier ID LPAREN RPAREN SEMICOLON
		{
		
 		if(!st->Insert($2->Name.c_str(),"ID",$1->Name, "func_declaration"))
 		{
 		  fprintf(er,"\nError at line %d: Multiple declaration of %s func_declaration\n",lineCount, $2->Name.c_str());
 		  fprintf(fp1,"\nError at line %d: Multiple declaration of %s func_declaration\n",lineCount, $2->Name.c_str());
 		  errorCount++;
 		  }
 		  $$->Name = $1->Name+" "+$2->Name+$3->Name+$4->Name+";";
		fprintf(fp1,"\nLine %d: func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON\n",lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
 		
		}
		
		;
		 
func_definition : type_specifier ID LPAREN parameter_list  RPAREN  {
				bool arg_error =false;
		in_func = true;
		
		
		SymbolInfo *sii = st->cur->Look_up($2->Name.c_str());
		if(sii && (sii->id_type == "func_declaration"))
		{
		//printf("\n\ntype ----------> %s --%s -- %s\n\n", sii->var.c_str(),$1->Name.c_str(),$2->Name.c_str());
		
		if(sii->var != $1->Name )
		{
		fprintf(er,"\nError at line %d: Return type mismatch with function declaration in function %s\n",lineCount, $2->Name.c_str());
		fprintf(fp1,"\nError at line %d: Return type mismatch with function declaration in function %s\n",lineCount, $2->Name.c_str());
		errorCount++;
		}
		vector<string> temp_arg = sii->par_type_list;
		if(temp_arg.size() != par_list.size())
		{
		
		fprintf(er,"\nError at line %d: Total number of arguments mismatch with declaration in function %s\n",lineCount, $2->Name.c_str());
		fprintf(fp1,"\nError at line %d: Total number of arguments mismatch with declaration in function %s\n",lineCount, $2->Name.c_str());
		errorCount++;
		}
		
		int l = temp_arg.size();
		if(l< par_list.size()) l = par_list.size();
		
		for(int i=0;i<l;i++)
		{
			if(temp_arg[i] != par_list[i].second)
				{
				arg_error = true;
				fprintf(er,"\nError at line %d: %dth parameter type mismatch with declaration in function %s\n",lineCount,i+1, $2->Name.c_str());
				fprintf(fp1,"\nError at line %d: %dth parameter type mismatch with declaration in function %s\n",lineCount,i+1, $2->Name.c_str());
				errorCount++;	
				break;
				}
		}
		
		st->cur->Delete($2->Name.c_str());
		st->cur->Insert($2->Name.c_str(),"ID",$1->Name, "func_definition",par_type_list);
		

		
		cout<<"\n"<<$2->Name.c_str()<<"\n";
			
		}
		else{
			//$2->par_type_list = par_type_list;
			//par_type_list.clear();
		if(!st->cur->Insert($2->Name.c_str(),"ID",$1->Name, "func_definition",par_type_list))
		{
 		  fprintf(er,"\nError at line %d: Multiple declaration of %s func_definition\n",lineCount, $2->Name.c_str());
 		  fprintf(fp1,"\nError at line %d: Multiple declaration of %s func_definition\n",lineCount, $2->Name.c_str());
 		  errorCount++;
 		}
 		
 		}   
 		if(in_func) {
			st->Enter_Scope();
		}
		
 		
 		
		
} 		 compound_statement
		{
		bool er_ = true; 


		printf("\n---%s-----%s---\n",$1->Name.c_str(), $7->var.c_str());
		if(($1->Name =="void" && $7->var == "")||($1->Name ==$7->var))
		{

		er_ = false;
		}
			
		

		if(er_) cout<<"\n Function name :"<<$2->Name.c_str()<<" erorr"<<"\n";
		else cout<<"\n Function name :"<<$2->Name.c_str()<<" no erorr"<<"\n";
		
		if(er_)
		{
		
		fprintf(er,"\nError at line %d: Return type mismatch with function declaration in function %s\n",lineCount, $2->Name.c_str());
		fprintf(fp1,"\nError at line %d: Return type mismatch with function declaration in function %s\n",lineCount, $2->Name.c_str());
 		errorCount++;
 		cout<<"\n Function body :"<<$7->Name.c_str()<<"\n";
		cout<<"\n Function name :"<<$2->Name.c_str()<<"\n";
		}
		
		
 		//cout<<"\n Function name :"<<$2->Name.c_str()<<"\n";
 		//st->Print_All_Scope(fp1);
		//st->Exit_scope();
 		//id_list.push_back($2->Name.c_str());

						
		
		if($2->Name == "main")
		{
		$$->code+= "MAIN PROC\n\n";
		$$->code+="\t;INITIALIZE DATA SEGMENT\n";
		$$->code+="\tMOV AX, @DATA\n";
		$$->code+="\tMOV DS, AX\n\n";
		}
		else 
		{
		$$->code+= $2->Name+" PROC\n\n";
		
		for(int i = par_list.size() - 1; i>=0 ; i--)
		{
		
			SymbolInfo* sii = st->Look_up(par_list[i].first);

				if(sii != nullptr){
				
			data_seg.push_back(par_list[i].first + sii->symbol+ " dw ?")	;
			
			$$->code += "pop " + par_list[i].first + sii->symbol + "\n" ;
			}
		}
		
		}
					
 						
		$$->code += $7->code;
		if($2->Name == "main") {
			$$->code +="\tendp main\n";
			$$->code +="end main\n";
		}
		else {
			$$->code+=$2->Name+ " endp\n";
		}
		
		if(in_func)
		st->Exit_scope();
						
		par_list.clear();
 		par_type_list.clear();
 							
		
						
		$$->Name = $1->Name+" "+$2->Name+$3->Name+$4->Name+$5->Name+$7->Name;
		fprintf(fp1,"\nLine %d: func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n",lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
 		
 		
 		
		}
		| type_specifier ID  LPAREN  RPAREN  {
				bool arg_error =false;
		in_func = true;
		
		
		
		SymbolInfo *sii = st->cur->Look_up($2->Name.c_str());
		if(sii && (sii->id_type == "func_declaration"))
		{
		//printf("\n\ntype ----------> %s --%s -- %s\n\n", sii->var.c_str(),$1->Name.c_str(),$2->Name.c_str());
		
		if(sii->var != $1->Name )
		{
		fprintf(er,"\nError at line %d: Return type mismatch with function declaration in function %s\n",lineCount, $2->Name.c_str());
		fprintf(fp1,"\nError at line %d: Return type mismatch with function declaration in function %s\n",lineCount, $2->Name.c_str());
		errorCount++;
		}
		vector<string> temp_arg = sii->par_type_list;
		if(temp_arg.size() != par_list.size())
		{
		
		fprintf(er,"\nError at line %d: Total number of arguments mismatch with declaration in function %s\n",lineCount, $2->Name.c_str());
		fprintf(fp1,"\nError at line %d: Total number of arguments mismatch with declaration in function %s\n",lineCount, $2->Name.c_str());
		errorCount++;
		}
		
		int l = temp_arg.size();
		if(l< par_list.size()) l = par_list.size();
		
		for(int i=0;i<l;i++)
		{
			if(temp_arg[i] != par_list[i].second)
				{
				arg_error = true;
				fprintf(er,"\nError at line %d: %dth parameter type mismatch with declaration in function %s\n",lineCount,i+1, $2->Name.c_str());
				fprintf(fp1,"\nError at line %d: %dth parameter type mismatch with declaration in function %s\n",lineCount,i+1, $2->Name.c_str());
				errorCount++;
				break;
				}
		}
		
		st->cur->Delete($2->Name.c_str());
		st->cur->Insert($2->Name.c_str(),"ID",$1->Name, "func_definition",par_type_list);
		
		cout<<"\n"<<$2->Name.c_str()<<"\n";
			
		}
		else{
			//$2->par_type_list = par_type_list;
			//par_type_list.clear();
		if(!st->cur->Insert($2->Name.c_str(),"ID",$1->Name, "func_definition",par_type_list))
		{
 		  fprintf(er,"\nError at line %d: Multiple declaration of %s func_definition\n",lineCount, $2->Name.c_str());
 		  fprintf(fp1,"\nError at line %d: Multiple declaration of %s func_definition\n",lineCount, $2->Name.c_str());
 		  errorCount++;
 		}
 		
 		}   
 		
 		if(in_func) {
			st->Enter_Scope();
			in_func = false;
		}
		
} 		 compound_statement
		{

		
		
 		
		if($2->Name == "main")
		{
		$$->code+= "MAIN PROC\n\n";
		$$->code+="\t;INITIALIZE DATA SEGMENT\n";
		$$->code+="\tMOV AX, @DATA\n";
		$$->code+="\tMOV DS, AX\n\n";
		}
		else 
		{
		$$->code+= $2->Name+" PROC\n\n";
		
		for(int i = par_list.size() - 1; i>=0 ; i--)
		{
			SymbolInfo* sii = st->Look_up(par_list[i].first);
			

			if(sii != nullptr){
				
			data_seg.push_back(par_list[i].first + sii->symbol+ " dw ?")	;
			
			$$->code += "pop " + par_list[i].first + sii->symbol + "\n" ;
			}
			
		}
		
		}
					
 						
		$$->code += $6->code;
		if($2->Name == "main") {
			$$->code +="\tendp main\n";
			$$->code +="end main\n";
		}
		else {
			$$->code+=$2->Name+ " endp\n";
		}
		
		if(in_func)
		{
		st->Exit_scope();
		in_func = false;
		}
		
		par_list.clear();
 		par_type_list.clear();
 					
		$$->Name = $1->Name+" "+$2->Name+$3->Name+$4->Name+$6->Name;
		fprintf(fp1,"\nLine %d: func_definition : type_specifier ID LPAREN RPAREN compound_statement\n",lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());

 		
 		
		}
 		;				

parameter_list  : parameter_list COMMA type_specifier ID
		{
		par_type_list.push_back($3->Name.c_str());
		par_list.push_back(make_pair($4->Name.c_str(),$3->Name.c_str()));
		$$->Name = $1->Name+","+$3->Name+" "+$4->Name;
		fprintf(fp1,"\nLine %d: parameter_list : parameter_list COMMA type_specifier ID\n",lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
 		
		}
		| parameter_list COMMA type_specifier
		{
		par_type_list.push_back($3->Name.c_str());
		$$->Name = $1->Name+","+$3->Name;
		fprintf(fp1,"\nLine %d: parameter_list : parameter_list COMMA type_specifier\n",lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
		}
 		| type_specifier ID
 		{
 		par_type_list.push_back($1->Name.c_str());
 		par_list.push_back(make_pair($2->Name.c_str(),$1->Name.c_str()));
 		$$->Name = $1->Name+" "+$2->Name;
 		fprintf(fp1,"\nLine %d: parameter_list : type_specifier ID\n",lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
 		
 		}
		| type_specifier
		{

 		$$->Name = $1->Name;
 		par_type_list.push_back($$->Name.c_str());
 		fprintf(fp1,"\nLine %d: parameter_list  : type_specifier\n",lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
 		

		
 		}
 		;

 		
compound_statement : LCURL dummy_2 statements RCURL
		{

		
		
		$$->var = $3->var;
		$$->Name = "{\n"+$3->Name+"\n}";
		$$->code = $3->code;		
		fprintf(fp1,"\nLine %d: compound_statement : LCURL statements RCURL\n",lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
 		
 		
 		
 		st->Print_All_Scope(fp1);
 		if(!in_func)
		st->Exit_scope();
		
		}
		
 		| LCURL  dummy_2 RCURL
 		{
 		
		$$->Name = "{}";
		fprintf(fp1,"\nLine %d: compound_statement : LCURL RCURL\n",lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
 		st->Print_All_Scope(fp1);
 		
 		if(!in_func)
		st->Exit_scope();
		}
 		    ;
dummy_2:
		{
		printf("\n-> %d\n",lineCount);
		if(!in_func)
 		st->Enter_Scope();
 		
		//in_func = false;
		
 		int len = par_list.size();
 		if(len>0)
 		 		  printf("\n Parameter : ");
 		for(int i = 0;i<len;i++)
 		{
		// st->Insert(par_list[i],"ID",par_type_list[i]);
 		if(!st->Insert(par_list[i].first,"ID",par_list[i].second.c_str()))
		{
 		  fprintf(er,"\nError at line %d: Multiple declaration of %s in parameter \n",lineCount, par_list[i].first.c_str());
 		  fprintf(fp1,"\nError at line %d: Multiple declaration of %s in parameter \n",lineCount, par_list[i].first.c_str());
 		  errorCount++;
 		}
 		 printf("%s ",par_list[i].first.c_str());
 		/*if(!st->Insert(par_list[i],"ID"))
 		  {
 		  	
 		  fprintf(er,"\nError at line %d: Multiple declaration of %s declaration_list : declaration_list COMMA ID\n",lineCount, par_list[i].c_str());
 		  
 		  }*/
 		}
 		  printf("\n");
 		
 		
		}
	/*	
		
var_declaration : type_specifier declaration_list error
	{
		fprintf(er,"\nError at line %d: var declaration must ends with semicolon\n",lineCount);
		fprintf(fp1,"\nError at line %d: var declaration must ends with semicolon\n",lineCount);
		yyerror("\nError !!\n");
	}	;
	*/
var_declaration : type_specifier declaration_list  SEMICOLON
		{
		if($1->Name == "void")
		{
		fprintf(er,"\nError at line %d: Variable type cannot be void\n",lineCount);
		fprintf(fp1,"\nError at line %d: Variable type cannot be void\n",lineCount);
		errorCount++;
		}
		else{
		cout<<endl;
		for(int i=0;i<var_list.size();i++)
		{
			printf("{%s %s} ", var_list[i].first.c_str(),var_list[i].second.first.c_str());
		}
		cout<<endl;
		string type_name = "";
		for(int i=0;i<var_list.size();i++)
		{
		
			if(var_list[i].second.first == "array") type_name  = $1->Name+"_array";
			else type_name =  $1->Name.c_str();

			if(st->Insert(var_list[i].first,"ID", type_name))
			{
				SymbolInfo* sii = st->Look_up(var_list[i].first);

				if(sii != nullptr){
				
				if(var_list[i].second.second == "-1")
				{
					data_seg.push_back(var_list[i].first + sii->symbol+ " dw ?")	;
				}
				else
				{
					
					data_seg.push_back(var_list[i].first + sii->symbol+ " dw "+ var_list[i].second.second + " dup(?)")	;
				}
				}
			}
			else
 		  	{
 		  	
 		  	fprintf(er,"\nError at line %d: Multiple declaration of %s...in var declaration\n",lineCount, var_list[i].first.c_str());
 		  	fprintf(fp1,"\nError at line %d: Multiple declaration of %s...in var declaration\n",lineCount, var_list[i].first.c_str());
 		  	errorCount++;
 		  	}
 		  	
		}
		}
		var_list.clear();
		
		$$->Name = $1->Name+" "+$2->Name+";";
		fprintf(fp1,"\nLine %d: var_declaration : type_specifier declaration_list SEMICOLON\n",lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
 		/*
 		stringstream ss($2->Name.c_str());
 
	    	while (ss.good()) {
		string substr;
		getline(ss, substr, ',');
		id_list.push_back(substr);
    		}
 		*/
 		
		}
 		 ;
 		 
type_specifier	: INT
		{
		$$->Name = "int";
		 fprintf(fp1,"\nLine %d: type_specifier : INT\n",lineCount);
		 fprintf(fp1, "\n%s\n",$1->Name.c_str());
		}
 		| FLOAT
 		{
 		$$->Name = "float";
		 fprintf(fp1,"\nLine %d: type_specifier : FLOAT\n",lineCount);
		 fprintf(fp1, "\n%s\n",$1->Name.c_str());
		}
 		| VOID
 		{
 		$$->Name = "void";
		 fprintf(fp1,"\nLine %d: type_specifier : VOID\n",lineCount);
		 fprintf(fp1, "\n%s\n",$1->Name.c_str());
		}
 		;
 		
declaration_list : declaration_list COMMA ID
 		  {
 		  
 		  var_list.push_back(make_pair($3->Name.c_str(), make_pair("normal","-1")));
 		   		  
 		  $$->Name = $1->Name+","+$3->Name;	
 		  fprintf(fp1,"\nLine %d: declaration_list : declaration_list COMMA ID\n",lineCount);
 		  fprintf(fp1,"\n%s\n",$$->Name.c_str());
 		  
 		  
 		  
 		  
 		  }
 		  | declaration_list COMMA ID LTHIRD CONST_FLOAT RTHIRD
 		  {
 		  fprintf(er,"\nError at line %d: Expression inside third brackets not an integer\n",lineCount);
 		  fprintf(fp1,"\nError at line %d: Expression inside third brackets not an integer\n",lineCount);
 		  errorCount++;
 		  }
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
 		  {

 		  
 		  var_list.push_back(make_pair($3->Name.c_str(), make_pair("array",$5->Name.c_str())));
 		  	
 		  $$->Name = $1->Name+","+$3->Name+$4->Name+$5->Name+$6->Name;	
 		  fprintf(fp1,"\nLine %d: declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n",lineCount);
 		  fprintf(fp1,"\n%s\n",$$->Name.c_str());
 		  
 		  }
 		  
 		  | ID 
 		  {

 		  $$->Name = $1->Name;
 		  fprintf(fp1,"\nLine %d: declaration_list : ID\n",lineCount);
 		  fprintf(fp1,"\n%s\n",$1->Name.c_str());
 		  var_list.push_back(make_pair($1->Name.c_str(), make_pair("normal","-1")));
		  
 		  }
 		  | ID LTHIRD CONST_FLOAT RTHIRD
 		  {
 		  
 		  fprintf(er,"\nError at line 7: Expression inside third brackets not an integer\n",lineCount);
 		  fprintf(fp1,"\nError at line 7: Expression inside third brackets not an integer\n",lineCount);
 		  errorCount++;
 		  }
 		  | ID LTHIRD CONST_INT RTHIRD
 		  {
		  var_list.push_back(make_pair($1->Name.c_str(), make_pair("array",$3->Name.c_str())));
 		  
 		  $$->Name = $1->Name+$2->Name+$3->Name+$4->Name;
 		  fprintf(fp1,"\nLine %d: declaration_list : ID LTHIRD CONST_INT RTHIRD\n",lineCount);
 		  fprintf(fp1,"\n%s\n",$$->Name.c_str());
 		  
 		  }
 		  
 		  ;
 		  
statements : statement
		{

	   	$$->var = $1->var;
		$$->Name = $1->Name;	
		$$->code = $1->code;
 		fprintf(fp1,"\nLine %d: statements : statement\n", lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
		}
	   | statements statement
	   	{
	   	$$->var = $2->var;
		$$->Name = $1->Name+"\n"+$2->Name;	
		$$->code = $1->code + $2->code;
 		fprintf(fp1,"\nLine %d: statements : statements statement\n", lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
		}
	   ;
	   
statement : var_declaration
	  {
	  	$$->var ="";
	  
	  	$$->Name = $1->Name;	
 		fprintf(fp1,"\nLine %d: statement : var_declaration\n", lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
	  }
	  | expression_statement
	  {
	  	$$->var ="";
	  	$$->Name = $1->Name;
	  	$$->code = $1->code;	
 		fprintf(fp1,"\nLine %d: statement : expression_statement\n", lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
	  }
	  | compound_statement
	  {
	  	$$->var ="";	
	  	$$->Name = $1->Name;	
	  	$$->code = $1->code;
 		fprintf(fp1,"\nLine %d: statement : compound_statement\n", lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
	  }
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement
	  {
	  	$$->var ="";
	  	$$->Name = $1->Name+$2->Name+$3->Name+$4->Name+$5->Name+$6->Name+$7->Name;	
	  	
	  	
	  	
                char* label1 = newLabel();
                char* label2 = newLabel();
                
                $$->code= $3->code;
                
                $$->code += "\t"+ string(label1) + ":\n" ;
                $$->code += $4->code;
                $$->code += "\tmov ax, " + $4->symbol + "\n";
                $$->code += "\tcmp ax, 0\n";
                $$->code += "\tje " + string(label2) + "\n";
                
                
                
                $$->code += $7->code + $5->code;	
                $$->code += "\tjmp " + string(label1) + "\n";
                $$->code += "\t" + string(label2) + ":\n";
                
                
	  	
 		fprintf(fp1,"\nLine %d: statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n", lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
	  }
	  | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
	  {
	  	$$->var ="";
	  	$$->Name = $1->Name+" "+$2->Name+$3->Name+$4->Name+$5->Name;	
	  	

	  	
	  	char* label = newLabel();
	  	
	  	$$->code  = $3->code; 
	  	$$->code += "\tmov ax, " + $3->symbol + "\n" ;
	  	$$->code += "\tcmp ax, 0\n";
	  	$$->code += "\tje "+ string(label) + "\n";
	  	$$->code +=$5->code;
	  	$$->code += "\t" + string(label) + ":\n";
	  	
	  	
 		fprintf(fp1,"\nLine %d: statement : IF LPAREN expression RPAREN statement\n", lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
	  }
	  | IF LPAREN expression RPAREN statement ELSE statement
	  {
	  	$$->var ="";
	  	$$->Name = $1->Name+" "+$2->Name+$3->Name+$4->Name+$5->Name+$6->Name+" "+$7->Name;
	  	
	  	char* label1 = newLabel();
	  	char* label2 = newLabel();
	  	
	  	$$->code  = $3->code;
	  	$$->code += "\tmov ax, " + $3->symbol + "\n" ;
	  	$$->code += "\tcmp ax, 0\n";
	  	$$->code += "\tje "+ string(label1) + "\n";
	  	$$->code +=$5->code;
	  	$$->code += "\tjmp "+string(label2) + "\n";
	  	
	  	$$->code += "\t"+string(label1)+":\n";
	  	$$->code += $7->code;
	  	$$->code += "\t"+string(label2)+":\n";
	  	
	  	
	  	
 		fprintf(fp1,"\nLine %d: statement : IF LPAREN expression RPAREN statement ELSE statement\n", lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
	  }
	  | WHILE LPAREN expression RPAREN statement
	  {
	  	$$->var ="";
	  	$$->Name = $1->Name+" "+$2->Name+$3->Name+$4->Name+$5->Name;
	  	
	  	char* label1 = newLabel();
                char* label2 = newLabel();
                
                //$$->code= $3->code;
                
                $$->code += "\t"+ string(label1) + ":\n" ;
                $$->code += $3->code;
                $$->code += "\tmov ax, " + $3->symbol + "\n";
                $$->code += "\tcmp ax, 0\n";
                $$->code += "\tje " + string(label2) + "\n";
                
                
                
                $$->code += $5->code ;	
                $$->code += "\tjmp " + string(label1) + "\n";
                $$->code += "\t" + string(label2) + ":\n";
	  		
 		fprintf(fp1,"\nLine %d: statement : WHILE LPAREN expression RPAREN statement\n", lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
	  }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON
	  {
	  	SymbolInfo* sii = st->Look_up($3->Name.c_str());

		if(sii == nullptr)
		{
			fprintf(er,"\nError at line %d: Undeclared variable %s\n", lineCount, $3->Name.c_str());
			fprintf(fp1,"\nError at line %d: Undeclared variable %s\n", lineCount, $3->Name.c_str());
			errorCount++;
		} 
		else
		{
		$3->symbol = $3->Name + sii->symbol;
		}
	  	$$->var ="";
	  	
	  	$$->code="\n\tMOV AX, "+$3->symbol+"\n";
		$$->code += "\tCALL PRINT_ID\n";

	  	$$->Name = $1->Name+$2->Name+$3->Name+$4->Name+";";	
 		fprintf(fp1,"\nLine %d: statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n", lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
	  }
	  | RETURN expression SEMICOLON
	  {
	  	printf("-- %s....%s-++",$2->var.c_str(),$2->Name.c_str());
	  	$$->var =$2->var;
	  	$$->Name = $1->Name+" "+$2->Name+";";	
	  	
	  	
	  	$$->code = $2->code;
	  	$$->code += "\tpush " + $2->symbol + "\n" ;
	  	
 		fprintf(fp1,"\nLine %d: statement : RETURN expression SEMICOLON\n", lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());


	  }
	  ;
	  
expression_statement 	: SEMICOLON	
			{
			$$->var = "";
			$$->Name = ";";	
			
			$$->symbol = ";";
			
 			fprintf(fp1,"\nLine %d: expression_statement : SEMICOLON\n", lineCount);
 			fprintf(fp1,"\n%s\n",$$->Name.c_str());
			}
			| expression SEMICOLON 
			{
			$$->var = $1->var;
			$$->Name = $1->Name+";";	
			$$->symbol = $1->symbol;
			$$->code = $1->code;
 			fprintf(fp1,"\nLine %d: expression_statement : expression SEMICOLON\n", lineCount);
 			fprintf(fp1,"\n%s\n",$$->Name.c_str());
			}
			;
	  
variable : ID 	
	{
	SymbolInfo* sii = st->Look_up($1->Name.c_str());

	if(sii != nullptr){
		$$->var =   sii->var;		
		$$->symbol = $1->Name + sii->symbol;
		//fprintf(as,"**** %s ****\n",$$->symbol.c_str());
	}
	else
	{
		fprintf(er,"\nError at line %d: Undeclared variable %s\n", lineCount, $1->Name.c_str());
		fprintf(fp1,"\nError at line %d: Undeclared variable %s\n", lineCount, $1->Name.c_str());
		errorCount++;
	} 
	$$->Name = $1->Name;	
	
 	fprintf(fp1,"\nLine %d: variable : ID\n", lineCount);
 	fprintf(fp1,"\n%s\n",$1->Name.c_str());


	}
	 | ID LTHIRD expression RTHIRD 
	 {
	 if($3->var != "int")
	 {
 		  fprintf(er,"\nError at line %d: Expression inside third brackets not an integer\n",lineCount);
 		  fprintf(fp1,"\nError at line %d: Expression inside third brackets not an integer\n",lineCount);
 		  errorCount++;
	 }
	 SymbolInfo* sii = st->Look_up($1->Name.c_str());

	   	if(sii != nullptr){
			$$->var =   sii->var;
			$$->symbol = $1->Name + sii->symbol;		
	   	}
	
	
	if($$->var == "int_array") 
		$$->var = "int";
	else if($$->var == "float_array") 
		$$->var = "float";
	else if($$->var == "double_array") 
		$$->var = "double";
	else if($$->var == "bool_array") 
		$$->var = "bool";	
	else	
		{
 		  fprintf(er,"\nError at line %d: %s not an array\n",lineCount,$1->Name.c_str());
 		  fprintf(fp1,"\nError at line %d: %s not an array\n",lineCount,$1->Name.c_str());
 		  errorCount++;
	 	}	
	
	
	$$->code = $3->code;
	$$->code +="\tmov bx, "+ $3->symbol + "\n";
	$$->code +="\tadd bx, bx\n";
	
	
	$$->Name = $1->Name+$2->Name+$3->Name+$4->Name;	
 	fprintf(fp1,"\nLine %d: variable : ID LTHIRD expression RTHIRD\n", lineCount);
 	fprintf(fp1,"\n%s\n",$$->Name.c_str());
	}
	 ;
	 
 expression : logic_expression	
 	{
 	if($1->var == "void")
		{
 		  fprintf(er,"\nError at line %d: void in expression\n",lineCount);
 		  fprintf(fp1,"\nError at line %d: void in expression\n",lineCount);
 		  errorCount++;
					
		}

 	
 	$$->var = $1->var;

	$$->Name = $1->Name;	
	
	$$->code = $1->code;
	$$->symbol = $1->symbol;
	
	
 	fprintf(fp1,"\nLine %d: expression : logic expression\n", lineCount);
 	fprintf(fp1,"\n%s\n",$1->Name.c_str());
	
	}
	   | variable ASSIGNOP logic_expression 
	   {
	   	
	   	if($1->var =="" || $3->var =="" ){}
	   	else if($1->var != $3->var )
	   		{
	   		bool eer =true;
	   		if($1->var == "double_array" || $1->var == "int_array" || $1->var == "float_array"  ){
	   		fprintf(er,"\nError at line %d: Type Mismatch, %s is an array\n", lineCount,$1->Name.c_str());
	   		fprintf(fp1,"\nError at line %d: Type Mismatch, %s is an array\n", lineCount,$1->Name.c_str());
	   		errorCount++;
	   		}
	   		else if (($1->var == "float"||$1->var == "double"  )&&($3->var == "int" ))
	   		{
	   		eer = false;
	   		}
	   		else if (($1->var == "float"||$1->var == "double" ||$1->var == "int"  )&&($3->var == "bool" ))
	   		{
	   		eer = false;
	   		}
	   		else if ($3->var == "void" )
	   		{
	   		fprintf(er,"\nError at line %d: Void type assignment error\n", lineCount);
	   		fprintf(fp1,"\nError at line %d: Void type assignment error\n", lineCount);
	   		errorCount++;
	   		}
	   		else
	   		{
	   		fprintf(er,"\nError at line %d: Type Mismatch \n", lineCount);
	   		fprintf(fp1,"\nError at line %d: Type Mismatch \n", lineCount);
	   		errorCount++;
	   		}
	   		}
	   		
	   	// for now only
	   	if($1->var == "int_array" || $1->var == "bool_array" ||$1->var == "double_array" ||$1->var == "float_array" ) //for array
	   	{
	   		char *temp = newTemp();
	   		data_seg.push_back(string(temp)+" dw ?");
	   		
	   		$$->code = $3->code + $1->code;
	   		$$->code += "\tmov ax, " + $3->symbol + "\n";
	   		
	   		$$->code += "\tmov "+ $1->symbol + "[bx], ax\n";
	   		$$->code += "\tmov "+ string(temp) + ", ax\n"; 
	   		$$->symbol = string(temp);
	   	}
	   	else //for variable
	   	{
	   	$$->code = $1->code +$3->code ;
	   	$$->code+= "\tmov ax, "+$3->symbol + "\n\tmov "+ $1->symbol+ ", ax\n";  
	   	//$$->setCode($1->getCode()+$3->getCode()+(string)"\tmov ax, "+$3->getSymbol()+(string)"\n\tmov "+$1->getSymbol()+(string)", ax\n");
	   	
                $$->symbol = $1->symbol;
                }
	   	$$->var = $1->var;
	   	$$->Name = $1->Name+"="+$3->Name;	
 		fprintf(fp1,"\nLine %d: expression : variable ASSIGNOP logic_expression\n", lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
	   }	
	   ;
			
logic_expression : rel_expression 
		{
		$$->var = $1->var;
		$$->Name = $1->Name;	
		$$->code =$1->code;
		$$->symbol = $1->symbol;
	 	fprintf(fp1,"\nLine %d: logic_expression : rel_expression\n", lineCount);
	 	fprintf(fp1,"\n%s\n",$1->Name.c_str());
		
		}	
		 | rel_expression LOGICOP rel_expression 
		{
		printf("\n %s -- %s \n",$1->Name.c_str(),$3->Name.c_str() );
		$$->var = "bool";
		
		printf("\n(%s) (%s) --- (%s) (%s), \n",$1->Name.c_str(),$1->var.c_str(),$3->Name.c_str(),$3->var.c_str());
		
		
		
		char *label1=newLabel();
            	char *label2 = newLabel();
            	char *temp = newTemp();
            	data_seg.push_back(string(temp)+" dw ?");
            	$$->code = $1->code + $3->code;
            
            	if($2->Name == "&&")
            	{
            		$$->code += "\tmov ax, " + $1->symbol + "\n";
            		$$->code += "\tcmp ax, 0\n";
            		$$->code += "\tje " + string(label1) + "\n";
            		
            		
            		$$->code += "\tmov ax, " + $3->symbol + "\n";
            		$$->code += "\tcmp ax, 0\n";
            		$$->code += "\tje " + string(label1) + "\n";
            		
            		$$->code += "\tmov ax, 1\n";
            		$$->code += "\tmov "+ string(temp) + ", ax\n";
            		$$->code += "\tjmp " + string(label2) + "\n";
            		
            		$$->code += "\t" + string(label1) + ":\n";
            		$$->code += "\tmov ax, 0\n";
            		$$->code += "\tmov " + string (temp) + ", ax\n";
            		
            		$$->code += "\t" + string(label2)+":\n";
            		
            	}
            	else if($2->Name == "||")
            	{
            		$$->code += "\tmov ax, " + $1->symbol + "\n";
            		$$->code += "\tcmp ax, 0\n";
            		$$->code += "\tje " + string(label1) + "\n";
            		
            		
            		$$->code += "\tmov ax, " + $3->symbol + "\n";
            		$$->code += "\tcmp ax, 0\n";
            		$$->code += "\tje " + string(label1) + "\n";
            		
            		$$->code += "\tmov ax, 0\n";
            		$$->code += "\tmov "+ string(temp) + ", ax\n";
            		$$->code += "\tjmp " + string(label2) + "\n";
            		
            		$$->code += "\t" +string(label1) + ":\n";
            		$$->code += "\tmov ax, 1\n";
            		$$->code += "\tmov " + string (temp) + ", ax\n";
            		
            		$$->code += "\t" +string(label2)+":\n";
            		
            	}
            	$$->symbol = string(temp);
		$$->Name = $1->Name+$2->Name+$3->Name;	
	 	fprintf(fp1,"\nLine %d: logic_expression : rel_expression LOGICOP rel_expression\n", lineCount);
	 	fprintf(fp1,"\n%s\n",$$->Name.c_str());
		
		}	
		 ;
			
rel_expression	: simple_expression 
		{
		$$->var = $1->var;
		$$->Name = $1->Name;	
		$$->code = $1->code;
		$$->symbol = $1->symbol;
		
	 	fprintf(fp1,"\nLine %d: rel_expression : simple_expression\n", lineCount);
	 	fprintf(fp1,"\n%s\n",$1->Name.c_str());
		
		}
		| simple_expression RELOP simple_expression
		{
		
		
		
		$$->var = $1->var;
		
		
		
		char *label1=newLabel();
		char *label2=newLabel();
		char *temp=newTemp();
		data_seg.push_back(string(temp)+(string)" dw ?");
		
		$$->code = $1->code + $3->code;
		$$->code += "\t" +(string)" mov ax, "+$1->symbol+"\n";
		$$->code += "\tcmp ax, " + $3->symbol+ "\n";
			
			if($2->Name == "<"){
					
					$$->code += "\tjl "+ string(label1) + "\n";
					$$->code += "\tmov ax, 0 \n";
					$$->code += "\tmov " + string(temp) + ", ax\n";
					$$->code += "\tjmp " + string(label2) + "\n";
					
					$$->code += "\t" +string(label1) +":\n";
					$$->code += "\tmov ax, 1 \n";
					$$->code += "\tmov " + string(temp) + ", ax\n";
					$$->code += string(label2) + ":\n";
				}
				else if($2->Name == "<="){
					
					$$->code += "\tjle "+ string(label1) + "\n";
					$$->code += "\tmov ax, 0 \n";
					$$->code += "\tmov " + string(temp) + ", ax\n";
					$$->code += "\tjmp " + string(label2) + "\n";
					
					$$->code += "\t" +string(label1) +":\n";
					$$->code += "\tmov ax, 1 \n";
					$$->code += "\tmov " + string(temp) + ", ax\n";
					$$->code += "\t" +string(label2) + ":\n";
				}
				else if($2->Name == ">"){
					
					$$->code += "\tjg "+ string(label1) + "\n";
					$$->code += "\tmov ax, 0 \n";
					$$->code += "\tmov " + string(temp) + ", ax\n";
					$$->code += "\tjmp " + string(label2) + "\n";
					
					$$->code += "\t" +string(label1) +":\n";
					$$->code += "\tmov ax, 1 \n";
					$$->code += "\tmov " + string(temp) + ", ax\n";
					$$->code += "\t" +string(label2) + ":\n";
				}
				else if($2->Name == ">="){
				
					$$->code += "\tjge "+ string(label1) + "\n";
					$$->code += "\tmov ax, 0 \n";
					$$->code += "\tmov " + string(temp) + ", ax\n";
					$$->code += "\tjmp " + string(label2) + "\n";
					
					$$->code += "\t" +string(label1) +":\n";
					$$->code += "\tmov ax, 1 \n";
					$$->code += "\tmov " + string(temp) + ", ax\n";
					$$->code += "\t" +string(label2) + ":\n";
				}
				else if($2->Name == "=="){
				
					$$->code += "\tje "+ string(label1) + "\n";
					$$->code += "\tmov ax, 0 \n";
					$$->code += "\tmov " + string(temp) + ", ax\n";
					$$->code += "\tjmp " + string(label2) + "\n";
					
					$$->code += "\t" +string(label1) +":\n";
					$$->code += "\tmov ax, 1 \n";
					$$->code += "\tmov " + string(temp) + ", ax\n";
					$$->code += "\t" +string(label2) + ":\n";
				}
				else{
				
					$$->code += "\tjne "+ string(label1) + "\n";
					$$->code += "\tmov ax, 0 \n";
					$$->code += "\tmov " + string(temp) + ", ax\n";
					$$->code += "\tjmp " + string(label2) + "\n";
					
					$$->code += "\t" +string(label1) +":\n";
					$$->code += "\tmov ax, 1 \n";
					$$->code += "\tmov " + string(temp) + ", ax\n";
					$$->code += "\t" +string(label2) + ":\n";
				}
				
		$$->symbol = string(temp);
		
		$$->Name = $1->Name+$2->Name+$3->Name;	
		
		
		
		
		
	 	fprintf(fp1,"\nLine %d: rel_expression : simple_expression RELOP simple_expression\n", lineCount);
	 	fprintf(fp1,"\n%s\n",$$->Name.c_str());
		
		}	
		;
				
simple_expression : term 
	{

	$$->var = $1->var;
	$$->Name = $1->Name;
	$$->code = $1->code	;
	$$->symbol = $1->symbol;
 	fprintf(fp1,"\nLine %d: simple_expression : term\n", lineCount);
 	fprintf(fp1,"\n%s\n",$$->Name.c_str());
		
	}
	| simple_expression ADDOP term 
	{
	

	    char *temp=newTemp();
	    data_seg.push_back(string(temp)+(string)" dw ?");

	
	if($2->Name == "+")
	{
	

		//$$->code +=  "; Adding\n";
		$$->code +=$1->code+$3->code;
     		
     		$$->code += "\tmov ax, "+ $1->symbol + "\n";

     		$$->code+= "\tadd ax,  "+$3->symbol + "\n";
     		
		$$->code += "\tmov "+string(temp)+", ax\n";
		
		
                
	} 
	if($2->Name == "-")
	{
		$$->code +=  "; Subtracting\n";		
		$$->code +=$1->code+$3->code;
     		
     		$$->code += "\tmov ax, "+ $1->symbol + "\n";

     		$$->code+= "\tsub ax, "+$3->symbol + "\n";
     		
		$$->code += "\tmov "+string(temp)+", ax\n";
		
		
                
	} 

	$$->symbol = string(temp);
	// do other...
	$$->var = $3->var;
	$$->Name = $1->Name+$2->Name+$3->Name;	
	
 	fprintf(fp1,"\nLine %d: simple_expression : simple_expression ADDOP term\n", lineCount);
 	fprintf(fp1,"\n%s\n",$$->Name.c_str());
		
	}	  
		  ;
					
term :	unary_expression
	{
	$$->var = $1->var;
	$$->Name = $1->Name;	
	$$->code = $1->code;
	$$->symbol = $1->symbol;
 	fprintf(fp1,"\nLine %d: term : unary_expression\n", lineCount);
 	fprintf(fp1,"\n%s\n",$1->Name.c_str());
	}
     |  term MULOP unary_expression
     	{
     	$$->var = $1->var;
     	// need to write code;
     	
     	if(($2->Name == "%"))
     	{
     	if(($3->var !="int" )||(  $1->var != "int")){
     	fprintf(er,"\nError at line %d: Non-Integer operand on modulus operator\n", lineCount);
     	fprintf(fp1,"\nError at line %d: Non-Integer operand on modulus operator\n", lineCount);
     	$$->var == "";
     	errorCount++;
     	}
     	if(($3->Name == "0")){
     	fprintf(er,"\nError at line %d: Modulus by 0\n", lineCount);
     	fprintf(fp1,"\nError at line %d: Modulus by 0\n", lineCount);
     	errorCount++;
     	}
     	}
     	
     	// load 
     	//$$->code += $3->code;
     	// $$->code += "mov ax, "+ $1->symbol + "\n";
     	// $$->code += "mov bx, "+ $1->symbol + "\n";
     	
     	char *temp=newTemp();
     	data_seg.push_back(string(temp)+(string)" dw ?");
     	//multiplication
     	if($2->Name=="*"){
     		$$->code +=$1->code+$3->code;
     		
     		$$->code += "\tmov ax, "+ $1->symbol + "\n";
     		$$->code += "\tmov bx, "+ $3->symbol + "\n";
     		
		$$->code += "\tmul bx\n";
		$$->code += "\tmov "+ string(temp) + ", ax\n";
		$$->symbol = string(temp);
		
		 
	}
	//div
	else if($2->Name=="/"){
		
		$$->code +=$1->code+$3->code;
     		
     		$$->code += "\tmov ax, "+ $1->symbol + "\n";
     		$$->code += "\tcwd;\n";
     		$$->code += "\tmov bx, "+ $3->symbol + "\n";
     		
		$$->code += "\tidiv bx\n";
		
		$$->code += "\tmov "+ string(temp) + ", ax\n";
		$$->symbol = string(temp);
		
		
		
		
	}
	//mod
     	else if($2->Name=="%"){
		
		$$->code +=$1->code+$3->code;
     		
     		$$->code += "\tmov ax, "+ $1->symbol + "\n";
     		$$->code += "\tcwd;\n";
     		$$->code += "\tmov bx, "+ $3->symbol + "\n";
     		
		$$->code += "\tidiv bx\n";
		
		$$->code += "\tmov "+ string(temp) + ", dx\n";
		$$->symbol = string(temp);
		
		
		
		
	}
     	
     	
     	
     	
	$$->Name = $1->Name+$2->Name+$3->Name;	
 	fprintf(fp1,"\nLine %d: term : term MULOP unary_expression\n", lineCount);
 	fprintf(fp1,"\n%s\n",$$->Name.c_str());
	}
     ;

unary_expression : ADDOP unary_expression 
 		{
		$$->var = $2->var;
		$$->Name = $1->Name+ $2->Name;	
		
		if($1->Name == "-"){
			char *temp=newTemp();
			data_seg.push_back(string(temp)+(string)" dw ?");
			
			$$->code = $2->code + "\tmov ax, " + $2->symbol + "\n";
			$$->code+="\tmov "+string(temp)+", ax\n";
			
			$$->code+="\tneg" + string(temp) +" \n";

			$$->symbol = string(temp);
		}
		else
		{
			$$->code = $2->code;
			$$->symbol = $2->symbol;
		}
		fprintf(fp1,"\nLine %d: unary_expression : ADDOP unary_expression\n", lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
		}
		| NOT unary_expression 
		{
				
		//maybe boolean type
		$$->var ="bool";
		
		char *temp=newTemp();
		data_seg.push_back(string(temp)+(string)" dw ?");
		$$->code="\tmov ax, " + $2->symbol + "\n";
		$$->code+="\tnot ax\n";
		$$->code+="\tmov "+string(temp)+", ax";
		$$->symbol = string(temp);


		$$->Name = $1->Name+ $2->Name;	
		fprintf(fp1,"\nLine %d: unary_expression : NOT unary_expression\n", lineCount);
 		fprintf(fp1,"\n%s\n",$$->Name.c_str());
		}
		| factor 
		{
		
		$$->var = $1->var;
		
		

		$$->symbol = $1->symbol;
		$$->code = $1->code;
		
		$$->Name = $1->Name;	
		fprintf(fp1,"\nLine %d: unary_expression : factor\n", lineCount);
		fprintf(fp1,"\n%s\n",$$->Name.c_str());
		}
		;

factor	: variable 
	
	{
	$$->var = $1->var;
	printf("\n-**--%s-**-%d-\n",$1->var.c_str(),lineCount);
	$$->Name = $1->Name;	
 	fprintf(fp1,"\nLine %d: factor : variable\n", lineCount);
 	fprintf(fp1,"\n%s\n",$1->Name.c_str());
 	$$->symbol = $1->symbol;
 	$$->code = $1->code;
 	if($$->var == "int_array" || $$->var == "float_array" || $$->var == "double_array" || $$->var == "bool_array") 
			{
				char *temp= newTemp();
				data_seg.push_back(string(temp)+(string)" dw ?");
				$$->code+="\tmov ax, " + $1->symbol+ "[bx]\n";
				$$->code+= "\tmov " + string(temp) + ", ax\n";
				$$->symbol = temp;
			}
	
	}
	| ID LPAREN argument_list RPAREN
	{

	bool arg_zero = true;
	if(arg_list.size() == 0)
	{
		arg_zero = false;
	}
	SymbolInfo *sii = st->Look_up($1->Name.c_str());

	if(sii != nullptr){
		$$->var =   sii->var;		
	}	
	
	if(sii && (sii->id_type == "func_definition"))
		{
		//tt = sii->var.c_str();
		
		cout<<"\n"<<$1->Name.c_str()<<"  *2222222222**** "<<lineCount<<" "<<$1->id_type.c_str()<<"\n";
		vector<string> temp_arg = sii->par_type_list;
		cout<<temp_arg.size()<<endl;
		for(int i=0;i<temp_arg.size();i++)
		{
			printf("%s ",temp_arg[i].c_str());
		}
		cout<<endl;
		cout<<arg_list.size()<<endl;
		for(int i=0;i<arg_list.size();i++)
		{
			printf("%s ",arg_list[i].first.c_str());
		}
		cout<<endl;
		
		
		if(temp_arg.size() != arg_list.size())
		{
		
		
		fprintf(er,"\nError at line %d: Total number of arguments mismatch with declaration in function call %s\n",lineCount, $1->Name.c_str());
		fprintf(fp1,"\nError at line %d: Total number of arguments mismatch with declaration in function call %s\n",lineCount, $1->Name.c_str());
		errorCount++;
		}
		
		int l = temp_arg.size();
		if(l> arg_list.size()) l = arg_list.size();
		
		for(int i=0;i<l;i++)
		{
				if((temp_arg[i] != arg_list[i].first) && (temp_arg[i] !="") && (arg_list[i].first !=""))
				{
				
				
				

				fprintf(er,"\nError at line %d: %dth parameter type [should be %s , but found %s] mismatch with declaration in function call %s\n",lineCount,i+1,temp_arg[i].c_str(),arg_list[i].first.c_str(), $1->Name.c_str());
				fprintf(fp1,"\nError at line %d: %dth parameter type [should be %s , but found %s] mismatch with declaration in function call %s\n",lineCount,i+1,temp_arg[i].c_str(),arg_list[i].first.c_str(), $1->Name.c_str());
				errorCount++;
				break;
				}
		}
		
		
		}
		else
		{
			fprintf(er,"\nError at line %d: Undeclared function %s\n",lineCount,  $1->Name.c_str());
			fprintf(fp1,"\nError at line %d: Undeclared function %s\n",lineCount,  $1->Name.c_str());
			errorCount++;
		}
	
	
			
	//$$->var = tt;
				//printf("\n ->%s<-\n",$3->Name.c_str());
 			//printf("\n {{%s  %s}} \n",$1->Name.c_str(), $$->var.c_str() );
 	if(arg_zero)
	$$->Name = $1->Name+"("+$3->Name+")";	
	else
	$$->Name = $1->Name+"("+")";	
	
	
	char *temp= newTemp(); // for non void func ret type
	data_seg.push_back( string(temp)+(string)" dw ?");
	
	$$->code = $3->code;
	
	fprintf(as,"\n*******%s******\n",$$->Name.c_str());
	
	for(int i=0;i<arg_list.size();i++)
	{
		$$->code += "\tpush "+ arg_list[i].second + "\n";	
	}
	
	if(sii != nullptr)
	{
	$$->code += "\tcall "+ sii->Name + "\n";
	
	//if have return type
	
	if(sii->var != "void")
	{
		$$->code += "\tpop " + string(temp) + "\n";
	}
	}
	$$->symbol = string(temp);
	
 	fprintf(fp1,"\nLine %d: factor : ID LPAREN argument_list RPAREN\n", lineCount);
 	fprintf(fp1,"\n%s\n",$$->Name.c_str());
 	arg_list.clear();

	}
	| LPAREN expression RPAREN
	{
	$$->var = $2->var;
	$$->Name = $1->Name+$2->Name+$3->Name;
	$$->code = $2->code;	
	$$->symbol = $2->symbol;
 	fprintf(fp1,"\nLine %d: factor : LPAREN expression RPAREN\n", lineCount);
 	fprintf(fp1,"\n%s\n",$$->Name.c_str());
	
	}
	| CONST_INT 
	{
	$$->var = "int"; 
	$$->Name = $1->Name;  
	$$->symbol = $1->Name;
	fprintf(fp1,"\nLine %d: factor : CONST_INT\n", lineCount);
 	fprintf(fp1,"\n%s\n",$1->Name.c_str());
	}
	| CONST_FLOAT
	{
	$$->var = "float";
	$$->Name = $1->Name;
	$$->symbol = $1->Name;  
	fprintf(fp1,"\nLine %d: factor : CONST_FLOAT\n", lineCount);
 	fprintf(fp1,"\n%s\n",$1->Name.c_str());
	}
	| variable INCOP 
	{
	$$->var = $1->var;
	
	
	$$->symbol = $1->symbol;
		
		char* temp = newTemp();		
		
	 	if($1->var == "int_array" || $1->var == "float_array" || $$->var == "double_array" || $$->var == "bool_array") 
	 	{
	 	
                data_seg.push_back(string(temp)+(string)" dw ?");
                $$->code = $1->code+"\tmov ax, "+$1->symbol+"[bx]\n\tmov "+string(temp)+", ax\n";
                $$->code += "\tinc "+$1->symbol+"[bx]\n";

	 	}
	 	else{
	 	
	

		data_seg.push_back(string(temp) +  " dw ?");
		$$->code = $1->code + "\tmov ax, "+ $1->symbol +"\n\tmov "+string(temp)+", ax\n\tinc "+$1->symbol+"\n"; 


		}
		$$->symbol =string(temp);	
	$$->Name =  $1->Name + $2->Name ;
	fprintf(fp1,"\nLine %d: factor : variable INCOP\n", lineCount);
 	fprintf(fp1,"\n%s\n",$$->Name.c_str());
 	

	}
	| variable DECOP
	{
		$$->var = $1->var;
	
	
	$$->symbol = $1->symbol;
		
		char* temp = newTemp();		
		
	 	if($1->var == "int_array" || $1->var == "float_array" || $$->var == "double_array" || $$->var == "bool_array") 
	 	{
	 	
                data_seg.push_back(string(temp)+(string)" dw ?");
                $$->code = $1->code+"\tmov ax, "+$1->symbol+"[bx]\n\tmov "+string(temp)+", ax\n";
                $$->code += "\tinc "+$1->symbol+"[bx]\n";

	 	}
	 	else{
	 	
		

		data_seg.push_back(string(temp) +  " dw ?");
		$$->code = $1->code + "\tmov ax, "+ $1->symbol +"\n\tmov "+string(temp)+", ax\n\tdec "+$1->symbol+"\n"; 


		}
		$$->symbol =string(temp);
	$$->Name =  $1->Name + $2->Name ;
	fprintf(fp1,"\nLine %d: factor : variable DECOP\n", lineCount);
 	fprintf(fp1,"\n%s\n",$$->Name.c_str());
 	
 	
	
	
	}
	;
	
argument_list : arguments
	{
	$$->Name = $1->Name; 
	$$->code = $1->code; 
	fprintf(fp1,"\nLine %d: argument_list : arguments\n", lineCount);
 	fprintf(fp1,"\n%s\n",$$->Name.c_str());
	
	}
			  |
			  {
	 
	 
	fprintf(fp1,"\nLine %d: argument_list :\n", lineCount);
 	
	
	}
			  ;
	
arguments : arguments COMMA logic_expression
		{
		arg_list.push_back(make_pair($3->var,$3->symbol));
		fprintf(fp1,"\nLine %d: arguments : arguments COMMA logic_expression\n", lineCount);
 		
 		
		$$->Name = $1->Name+","+$3->Name;
		$$->code = $1->code+ $3->code;
		
		fprintf(fp1,"\n%s\n",$$->Name.c_str());
		
		
		}
	  	| logic_expression 
	      	{
	      	
	      	
	      	
	      	
	      	fprintf(fp1,"\nLine %d: arguments : logic_expression\n", lineCount);
 		fprintf(fp1,"\n%s\n",$1->Name.c_str());
	      	$$->code = $1->code;
	      	$$->symbol = $1->symbol;
	       	$$->Name = $1->Name;  
	       	arg_list.push_back(make_pair($1->var,$1->symbol));
	       	$$->code = $1->code;  
	      	}
	      	;
 		  
 

%%
int main(int argc,char *argv[])
{
	st = new SymbolTable(30,1);
	

	if(argc!=3)
	{
		printf("Provide File.\n");
		//return 0;
	}
	FILE *fin = fopen(argv[1], "r");
	
	if(fin == NULL)
	{
	printf("Can not open file\n");
	}
	

	
	fp1 = fopen(argv[2],"w");
	er = fopen(argv[3],"w");
	as = fopen(argv[4],"w");
	
	yyin=fin;
	yyparse();
	
	

	fclose(yyin);

	
	return 0;
}

