%{
	
	#include<stdio.h>
	#include <stdlib.h>
	void yyerror(const char*);
	int yywrap(void)
	{return 1;}
%}
%token ID NUM CLASS PUBLIC STATIC VOID MAIN STRING EXTENDS BOOLEAN INT SYSTEM LENGTH TRUE1 FALSE1 THIS NEW PRINT RETURN FOR U_OP UNARY BREAK CONTINUE
%%

Goal : MainClass ClassDeclaration	{YYACCEPT;}
     ;
MainClass : CLASS ID "{" PUBLIC STATIC VOID MAIN "(" STRING "[" "]" ID ")"  COMPOUND_STMT  "}"
	  ;
ClassDeclaration : CLASS ID  EXT  "{"  DECL   MethodDeclaration  "}"
		 |
		 ;

MethodDeclaration : PUBLIC TYPE ID "(" TYPE ID ")"   COMPOUND_STMT   MethodDeclaration
		  |
	          ;
COMPOUND_STMT			:	'{' DECL STMT '}'
									| '{' STMT '}'
									;

STMT							: E ';' STMT
									| ASSIGNEXPR STMT
									| COMPOUND_STMT STMT
									| ITERATION_STMT STMT
									| JUMP_STMT STMT
									| PRINT '(' E ')'';' STMT 
									| ';'
									| 
									;



ITERATION_STMT			:  FOR '(' ASSIGNEXPR COND ';' E ')' COMPOUND_STMT
						;

JUMP_STMT							: CONTINUE ';'
									| BREAK ';'
									| RETURN E ';'
									;

COND								: EXPR
									| EXPR LOGOP EXPR
									;

EXPR								: RELEXP
									| LOGEXP
									;

RELEXP								: E RELOP E
									;

LOGEXP								: E LOGOP E
									;

LOGOP								: '|' '|'
									| '&' '&'
									;

RELOP								: '<'
									| '>'
									| '<' '='
									| '>' '='
									| '!' '='
									| '=' '='
									;
DECL								: TYPE VARLIST ';'
 									| TYPE ASSIGNEXPR
									;

TYPE								: INT
									| VOID
									;

VARLIST								: VARLIST ',' ID
									| ID
									;

ASSIGNEXPR							: ID '=' E ',' ASSIGNEXPR
									| ID '=' E ';'
									;

E									: E '+' T
									| E '-' T
									| T
									;

T									: T '*' F
									| T '/' F
									| F
									;

F									: ID
									| NUM
									| '(' E ')'
									| UNARYEXPR
									| UNARY_OPERATION
									;

UNARY_OPERATION						: ID U_OP ID
									| ID U_OP NUM
									| ID U_OP '(' E ')'
									;


UNARYEXPR							: UNARY ID
									| ID UNARY
									;
EXT 								: EXTENDS ID
									|
									;


      
%%
void yyerror(const char* s)
{
	printf("%s\n",s);
	exit(0);
}

