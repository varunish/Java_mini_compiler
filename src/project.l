%option yylineno

%{
	#include<stdio.h>
	#include<string.h>
	#include"y.tab.h"
	#include<math.h>
	#include"symtab.h" 
	extern int tcnt;
	extern int bal_brack;
	//extern int open_brack;
	extern int temp;
	char prev[2]={'{','\0'};
	int ifPresent(char* sym){
  		int i;
		//printf("sym = %s\n",sym);
  		for(i = 1; i < tcnt ; i ++)
   		{
			if(!strcmp(symtab[i].type,"Identifier"))
      				{
					if(!strcmp(sym,symtab[i].symbol) && symtab[i].scope_num == bal_brack)
        				return 1;
				}
			else{
				      				
					if(!strcmp(sym,symtab[i].symbol))
        				return 1;
				}
				
    		}
		return 0;
	}
	
	void initEntry(char* sym)
	{

		if(!ifPresent(sym)){
			symtab[tcnt].tok_num = tcnt;
			symtab[tcnt].scope_num = bal_brack;
			strcpy(symtab[tcnt].symbol,sym);
			symtab[tcnt].lineno = yylineno;
			
			
		
		}
	}

%}

%%


"void"|"char"|"int"|"long"|"float"|"double"|"signed"|"unsigned"|"String"							   {initEntry(yytext);
														    strcpy(symtab[tcnt].type,"Keyword");	
														    tcnt++;
														    ECHO;
														    return type_const;
														}

"public"|"private"|"protected"							   {initEntry(yytext);
														    strcpy(symtab[tcnt].type,"Keyword");	
														    tcnt++;
														    ECHO;return access_specifier;}						

"class"														   {initEntry(yytext); 
														    strcpy(symtab[tcnt].type,"Keyword");
														    tcnt++;
														    ECHO;return CLASS;}

"System.out.println"														   {initEntry(yytext); 
														    strcpy(symtab[tcnt].type,"Keyword");
														    tcnt++;
														    ECHO;return PRINT;}														    

"extends"														   {initEntry(yytext); 
														    strcpy(symtab[tcnt].type,"Keyword");
														    tcnt++;
														    ECHO;return EXTENDS;}														    
"static"													   {initEntry(yytext);strcpy(symtab[tcnt].type,"Keyword");
														    tcnt++;
														    ECHO;return STATIC;}
"main"													    {initEntry(yytext);strcpy(symtab[tcnt].type,"Keyword");
														    tcnt++;
														    ECHO;return MAIN;}
"for"														  {initEntry(yytext);strcpy(symtab[tcnt].type,"Keyword");
														    
														    tcnt++;
														    ECHO;return FOR;}
"continue"													{initEntry(yytext);strcpy(symtab[tcnt].type,"Keyword");
														  
														    tcnt++;
														    ECHO;return CONTINUE;}
"break"														{initEntry(yytext);strcpy(symtab[tcnt].type,"Keyword");
														 
														    tcnt++;
														    ECHO;return BREAK;}
"return"													{initEntry(yytext);strcpy(symtab[tcnt].type,"Keyword");
														    
														    tcnt++;
														    ECHO;return RETURN;}
"||" 													      { initEntry(yytext);strcpy(symtab[tcnt].type,"LogicalOp");
														    
														    tcnt++;
														    ECHO;return or_const;}
"&&"														{initEntry(yytext); strcpy(symtab[tcnt].type,"LogicallOp");
														    
														    tcnt++;
														    ECHO;return and_const;}
"=="|"!="													 {initEntry(yytext); strcpy(symtab[tcnt].type,"RelationalOp");
														    
														    tcnt++;
														    ECHO;return eq_const;}
"<="|">="|"<"|">"													{initEntry(yytext);strcpy(symtab[tcnt].type,"RelationalOp");
														   
														    tcnt++;
														    ECHO;return rel_const;}
"++"|"--"													{initEntry(yytext);strcpy(symtab[tcnt].type,"IncrementalOp");
														   
														    tcnt++;
														    ECHO;return inc_const;}

";"|"="|","|"{"|"}"|"("|")"|"["|"]"|":"										{   initEntry(yytext); strcpy(symtab[tcnt].type,"Punctuation");
														    tcnt++;
														    /*printf("\nyytext = %s/-",yytext);*/
														    if(strcmp(yytext,"{")==0){
															//open_brack++;
															bal_brack++;
															if(strcmp(prev,"}")==0)
																bal_brack = temp;
															strcpy(prev,yytext);
														    }
														    else if(strcmp(yytext,"}")==0){
														        //close_brack++;	
															bal_brack--;
															if(strcmp(prev,"{")==0)
																temp = bal_brack+1;
																
															strcpy(prev,yytext);
														    }
														   		
														    ECHO;return yytext[0];}

"*"|"+"|"-"|"/"|"%"			   					   		   		  {initEntry(yytext); strcpy(symtab[tcnt].type,"Unary ");
														    
														    tcnt++;
														    ECHO;return U_OP;}
"*="|"+="|"-="|"/="			   					   		   		  {initEntry(yytext); strcpy(symtab[tcnt].type,"ArithmeticOp");
														    
														    tcnt++;
														    ECHO;return yytext[0];}														    
"&"|"|"|"!"												         {initEntry(yytext);strcpy(symtab[tcnt].type,"LogicalOp");
														    
														    tcnt++;
														    ECHO;return yytext[0];}

[0-9]+														{initEntry(yytext);strcpy(symtab[tcnt].type,"Integer");
														    
														    tcnt++;
														    ECHO;return NUM;}
[0-9]+"."[0-9]+													{initEntry(yytext);strcpy(symtab[tcnt].type,"Float");
														    
														    tcnt++;
														    ECHO;return float_const;}
"'"."'"														 {initEntry(yytext);strcpy(symtab[tcnt].type,"Character");
														    
														    tcnt++;
														    ECHO;return char_const;}
[a-zA-Z_][a-zA-Z_0-9]*			 									{initEntry(yytext);strcpy(symtab[tcnt].type,"Identifier");
														  /* printf("ID = %s\n",yytext);*/
														    tcnt++;
														    ECHO;return id;}
\"(\\.|[^\"])*\"												   {ECHO;return string;}
"//"(\\.|[^\n])*[\n]												   ;
[/][*]([^*]|[*]*[^*/])*[*]+[/]                                                                                     ;
[ \t\n]														   {ECHO;}
%%

int yywrap(void)
{
    return 1;
}



