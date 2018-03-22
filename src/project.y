%{
	#include<stdio.h>
	#include "symtab.h"
	int yylex(void);
	int yyerror(const char *s);
	int success = 1;
	int tcnt = 1;
	int bal_brack = 0;
	int temp = 0;
	int close_brack = 0;
%}

%token int_const char_const float_const id string type_const access_specifier
%token FOR BREAK CLASS CONTINUE RETURN STATIC MAIN PRINT EXTENDS NUM U_OP or_const and_const eq_const rel_const inc_const
%token point_const param_const ELSE HEADER
%left '+' '-'
%left '*' '/'
%define parse.error verbose
%start program_unit
%%
program_unit				: CLASS id '{' BODY '}'
							{YYACCEPT;};

BODY						: access_specifier STATIC type_const MAIN '(' type_const '[' ']' id ')'  COMPOUND_STMT 
							;

COMPOUND_STMT						: '{' DECL STMT '}'
							| '{' STMT '}'
							;

STMT						: E ';' STMT
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

TYPE								: type_const
									
									;

VARLIST								: VARLIST ',' id
									| id
									;

ASSIGNEXPR							: id '=' E ',' ASSIGNEXPR
									| id '=' E ';'
									;

E									: E '+' T
									| E '-' T
									| T
									;

T									: T '*' F
									| T '/' F
									| F
									;

F									: id
									| NUM
									| '(' E ')'
									| UNARYEXPR
									| UNARY_OPERATION
									;

UNARY_OPERATION						: id U_OP id
									| id U_OP NUM
									| id U_OP '(' E ')'
									;


UNARYEXPR							: inc_const id
									| id inc_const
									;
EXT 								: EXTENDS id
									|
									;

%%

int main()
{

    printf("\nCode After Stripping off Comments:");
    printf("\n-------------------------------------------------------------------------------------------------\n");
    yyparse();
    printf("\n-------------------------------------------------------------------------------------------------\n");
    if(success)
    	printf("\n\t\t\t\t\tParsing Successful!\n\n");
			int i = 0;
		printf("\n\t\t\t\t\tSYMBOL TABLE\n\n");
		printf("Scope_Num\tTok_Num\t\t Symbol\t\t\tTypeOfToken\t\tLine Number\n");
		printf("----------------------------------------------------------------------------------------------\n");
		for(i = 0; i < tcnt; i ++)
		{
			if(symtab[i].tok_num != 0)
				printf("%5d\t\t%5d\t\t%8s\t\t%8s\t\t%5d\n",symtab[i].scope_num,symtab[i].tok_num,symtab[i].symbol,symtab[i].type,symtab[i].lineno);
		}
		printf("Total number of tokens : %d\n",tcnt);
    return 0;
}

int yyerror(const char *msg)
{
	extern int yylineno;
	printf("Parsing Failed\nLine Number: %d %s\n",yylineno,msg);
	success = 0;
	return 0;
}
