%{
	#include "y.tab.h"
	void yyerror(const char*);
%}


%%
continue							return CONTINUE;
break								return BREAK;
class								return CLASS;
public								return PUBLIC;
static								return STATIC;
String								return STRING;
extends								return EXTENDS;
boolean								return BOOLEAN;
System.out.println						return PRINT;
length								return LENGTH;
true								return TRUE1;
false								return FALSE1;
this								return THIS;
new								return NEW;
for								return FOR;								
int		   						return INT;
main 								return MAIN;
void								return VOID;						
return								return RETURN;
[a-zA-Z][a-zA-Z0-9_]*						return ID;
[0-9]+								return NUM;
"+="|"-="|"*="|"/="						return U_OP;
"++"|"--"							return UNARY;
"("|")"|"{"|"}"|";"|","|"&"|"\|"|"<"|">"|"="|"!"|"+"|"-"|"*"|"/"|"["|"]"|"." return *yytext;
" "|"\n"|"\t"							;
.								{yyerror("Invalid Character");}
																	
%%

int main()
{
	//printf("Enter Input: ");
	yyin = fopen("code.java","r");
	if(!yyparse())
		printf("Valid Identifier\n");
	else
		printf("Invalid Identifier\n");
	return 0;
}

