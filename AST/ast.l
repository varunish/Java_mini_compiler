%{
	#include <stdlib.h>
	#include "header.h"
	#include "y.tab.h"
	void yyerror(char *);
%}
%%
[a-z] 					{
							yylval.sIndex = *yytext - 'a';
							return VARIABLE;
						}
0 						{
						yylval.iValue = atoi(yytext);
						return INTEGER;
						}
[1-9][0-9]* 						{
						yylval.iValue = atoi(yytext);
						return INTEGER;
						}



[-()<>=+*/;{}.] 				return *yytext;
"["|"]"						return yytext[0];
						
"++"						return INC;
"--"						return DEC;
">=" 						return GE;
"<=" 						return LE;
"==" 						return EQ;
"!=" 						return NE;
"while" 					return WHILE;
"for"						return FOR;
"if" 						return IF;
"else" 						return ELSE;
"print" 					return PRINT;
[ \t\n]+					; /* ignore whitespace */
"static"					return STATIC;
"public"|"private"				return access_specifier;
"class"						return CLASS;
"main"						return MAIN;
"void"|"char"|"int"|"long"|"float"|"double"|"signed"|"unsigned"|"String"	return type_const;
							
										    			
[a-zA-Z_][a-zA-Z_0-9]*				return ID;
. 						yyerror("Unknown character");
%%
int yywrap(void) {
return 1;
}
