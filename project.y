%{
	#include<stdio.h>
	#include "symtab.h"
	#include <string.h> 
	#include <stdlib.h>
	int yylex(void);
	int yyerror(const char *s);
	int success = 1;
	int tcnt = 1;
	extern int bal_brack;

	int close_brack = 0;
	extern int yylineno;
	void initEntry(char* sym);
	int ifPresent(char* sym);
	char st[1000][10];
	void insert(int type,char* text,char* toktype);
	char buf[100];
	int top=0;
	int flag = 0;
	int arr=1;
	int size(char* text);
	char tempo[2]="t";

	int label[200];
	int lnum=0;
	int ltop=0;
	int switch_stack[1000];
	int stop=0;
	char type[10];

	void push(char* text);
	void codegen_logical();
	void codegen_algebric();
	void intermediateCode();
	void codegen_assign();
	void end_loop();
	void for_inc();
	void for_start();
	void for_rep();
	void for_end();
	void for_end_iri();
	void codegen_unary();
	FILE* f1;
	int i =0;


%}

%union{
	char* txt;

}

%token<txt> char_const  id string type_const DEFINE int_const float_const
%token<txt> FOR BREAK SWITCH CONTINUE RETURN CASE DEFAULT or_const and_const eq_const rel_const inc_const CLASS access_specifier STATIC MAIN PRINT
%token<txt> point_const param_const ELSE HEADER 
%type<txt> consts primary_exp exp assignment_exp conditional_exp unary_exp  logical_and_exp 
%type<txt> logical_or_exp postfix_exp inclusive_or_exp exclusive_or_exp and_exp equality_exp relational_exp additive_exp  
%type<txt> type_spec decl_specs decl_list decl direct_declarator declarator init_declarator const_exp  init_declarator_list 
%type<txt> '>' '<' '|' '&' '^' '+' '-' '*' '/' '%' '=' mult_exp

%left '+' '-'
%left '*' '/'
%define parse.error verbose
%start program_unit
%%
program_unit				: CLASS id '{'BODY '}' {YYACCEPT;}
							| translation_unit
							;
BODY 						: access_specifier STATIC type_const MAIN '(' type_const '[' ']' id ')' stat
							|
						    ;

							;
translation_unit			: external_decl
							| translation_unit external_decl
							;
external_decl				: function_definition
							| decl
							;
function_definition			: decl_specs declarator decl_list compound_stat
							| declarator decl_list compound_stat
							| decl_specs declarator	compound_stat
							| declarator compound_stat
							;
decl						: decl_specs init_declarator_list ';'{insert(2,buf,$1);strcpy(buf,"");flag = 0;}
							| decl_specs ';'
							;
decl_list					: decl {$$ = $1;}
							| decl_list decl{$$ = $1;}
							;
decl_specs					: type_spec decl_specs{$$ = $1;}
							| type_spec{$$ = $1;}
							;

type_spec					: type_const{ insert(1,$1,"Keyword");
										  $$ = $1;}
							;

init_declarator_list		: init_declarator{$$ = $1;}
							| init_declarator_list ',' init_declarator{$$ = $1;}

							;
init_declarator				: declarator {$$ = $1;}
							| declarator '=' initializer {$$ = $1;}
							;



declarator					: direct_declarator{$$ = $1;}
							;
direct_declarator			: id {$$ = $1;strcat(buf,$1);strcat(buf,"~");}
							| '(' declarator ')' {$$ = $2;}
							| direct_declarator '[' const_exp ']'{flag = 2;arr = arr * atoi($3);}
							| direct_declarator '['	']'
							| direct_declarator '(' param_type_list ')'
							| direct_declarator '(' id_list ')'
							| direct_declarator '('	')'{flag = 1;}
							;

param_type_list				: param_list
							| param_list ',' param_const
							;
param_list					: param_decl
							| param_list ',' 
							;
param_decl					: decl_specs declarator
							| decl_specs abstract_declarator
							| decl_specs
							;
id_list						: id
							| id_list ',' id
							;
initializer					: assignment_exp
							| '{' initializer_list '}'
							| '{' initializer_list ',' '}'
							;
initializer_list			: initializer
							| initializer_list ',' initializer
							;

abstract_declarator			: direct_abstract_declarator
							;
direct_abstract_declarator	: '(' abstract_declarator ')'
							| direct_abstract_declarator '[' const_exp ']'
							| '[' const_exp ']'
							| direct_abstract_declarator '[' ']'
							| '[' ']'
							| direct_abstract_declarator '(' param_type_list ')'
							| '(' param_type_list ')'
							| direct_abstract_declarator '(' ')'
							| '(' ')'
							;

stat						: labeled_stat
							| exp_stat
							| compound_stat
							| iteration_stat
							| jump_stat
							;
labeled_stat				: id ':' stat
							| CASE const_exp ':' stat{insert(1,$1,"Keyword");}
							| DEFAULT ':' stat{insert(1,$1,"Keyword");}
							;

							
compound_stat				: '{' decl_list stat_list '}'
							| '{' stat_list '}'
							| '{' decl_list	'}'
							| '{' '}'
							;
stat_list					: stat
							| stat_list stat
							;

iteration_stat				: FOR '(' exp_stat{for_start();}  exp_stat{for_rep();}  exp {for_inc();}')' stat{insert(1,$1,"Keyword");for_end();}
							;



	
jump_stat					: CONTINUE ';'{insert(1,$1,"Keyword");}
							| BREAK ';'{insert(1,$1,"Keyword");}
							| RETURN exp ';'{insert(1,$1,"Keyword");}
							| RETURN ';'{insert(1,$1,"Keyword");}
							;

exp_stat					: exp ';'
							| ';'
							;

exp							: assignment_exp
							| exp ',' assignment_exp
							;
assignment_exp				: conditional_exp
							| unary_exp{push($1);} '='{push("=");} conditional_exp{codegen_assign();}
							;

conditional_exp				: logical_or_exp
							;
const_exp					: conditional_exp
							;
logical_or_exp				: logical_and_exp
							| logical_or_exp or_const{push($2);} logical_and_exp{codegen_logical();}
							;
logical_and_exp				: inclusive_or_exp
							| logical_and_exp and_const{push($2);} inclusive_or_exp{codegen_logical();}
							;
inclusive_or_exp			: exclusive_or_exp
							| inclusive_or_exp '|'{push($2);} exclusive_or_exp{codegen_logical();}
							;
exclusive_or_exp			: and_exp
							| exclusive_or_exp '^'{push($2);} and_exp{codegen_logical();}
							;
and_exp						: equality_exp
							| and_exp '&' {push($2);}equality_exp{codegen_logical();}
							;
equality_exp				: relational_exp
							| equality_exp eq_const{push($2);} relational_exp{codegen_logical();}
							;
relational_exp				: additive_exp
							| relational_exp '<'{push($2);} additive_exp{codegen_logical();}
							| relational_exp '>'{push($2);} additive_exp{codegen_logical();}
							| relational_exp rel_const{push($2);} additive_exp{codegen_logical();}
							;

additive_exp				: mult_exp
							| additive_exp '+'{push($2);}  mult_exp{codegen_algebric();}
							| additive_exp '-'{push($2);}  mult_exp{codegen_algebric();}
							;
mult_exp					: unary_exp
							| mult_exp '*'{push($2);}  unary_exp{codegen_algebric();}
							| mult_exp '/'{push($2);}  unary_exp{codegen_algebric();}
							| mult_exp '%' {push($2);} unary_exp{codegen_algebric();}
							;

unary_exp					: postfix_exp
							| inc_const unary_exp
							;

postfix_exp					: primary_exp
							| postfix_exp '[' exp ']'
							| postfix_exp '(' argument_exp_list ')'
							| postfix_exp '(' ')'
							| postfix_exp inc_const {push($2);codegen_unary();}
							;
primary_exp					: id {$$ = $1;insert(1,$1,"Id");push($1);}
							| consts {$$ = $1;push($1);}
							| string {$$ = $1;}
							| '(' exp ')'{$$ = $2;}
							;
argument_exp_list			: assignment_exp
							| argument_exp_list ',' assignment_exp
							;
consts						: int_const{$$ = $1;}
							| char_const{$$ = $1;}
							| float_const{$$ = $1;}
							;
%%


	int ifPresent(char* sym){
  		int i;
		//printf("sym = %s\n",sym);
  		for(i = 1; i < tcnt ; i ++)
   		{
			if(strcmp(symtab[i].type,"Keyword"))
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

	void insert(int type,char* text, char* toktype)
	{
		char var_name[10];
		char temp[10];
		int var_len = 0;
		switch(type){
			case 1:
					initEntry(text);
					strcpy(symtab[tcnt].type,toktype);

					tcnt++;
				    break;
			case 2:
				//printf("IN ACSE 2\n");
				//printf("text = %s\n",text);
				for(int i = 0; i < strlen(text);i++)
				{
					if(text[i] != '~'){
						var_name[var_len] = text[i];
						var_len++;
						//printf("NEw var_name = %s\n",var_name);
					}

					else if(text[i] == '~'){
						var_name[var_len]='\0';
						initEntry(var_name);
						if(strcmp(var_name,"main")==0)
						{
							//printf("RECOG MAIN\n");
							strcpy(temp,toktype);
							strcat(toktype,"-func");
							strcpy(symtab[tcnt].type,toktype);
							strcpy(toktype,temp);
							flag = 0;
						}
						else if(flag == 2)
						{
							//printf("Value of arr = %d\n",arr);
							strcpy(temp,toktype);
							strcat(toktype,"-arr");
							strcpy(symtab[tcnt].type,toktype);
							strcpy(toktype,temp);
							symtab[tcnt].size = size(toktype)*arr;
							arr = 1;
							flag = 0;

						}
						else 
							{strcpy(symtab[tcnt].type,toktype);
							symtab[tcnt].size = size(toktype);}
						tcnt++;
						strcpy(var_name,"");
						var_len = 0;
					}
					
				   

				}
				 break;

					



		}
										
	}
	int size(char* text)
	{
		if(!strcmp(text,"int"))
			return(sizeof(int));
	        if(!strcmp(text,"double"))
			return(sizeof(double));
		if(!strcmp(text,"float"))
			return(sizeof(float));
		if(!strcmp(text,"char"))
			return(sizeof(char));
		if(!strcmp(text,"long"))
			return(sizeof(long));
		else 
			return 0;

	}


	
void end_loop()
{
		fprintf(f1,"\tgoto $L%d\n",lnum-2);	
}
void for_inc()
{
	
		fprintf(f1,"\tgoto $L%d\n",lnum-3);
		fprintf(f1,"$L%d:\n",lnum-1);
}
	
void for_start()
	{
		lnum++;
		label[++ltop]=lnum;
		fprintf(f1,"$L%d:\n",lnum);

	}
void for_rep()
	{
	lnum++;
 	fprintf(f1,"if( not %s)",st[top]);
 	fprintf(f1,"\tgoto $L%d\n",lnum);
 	label[++ltop]=lnum;
 	lnum++;
 	fprintf(f1,"\tgoto $L%d\n",lnum);
 	label[++ltop]=lnum;
 	lnum++;
	label[++ltop]=lnum;
	fprintf(f1,"$L%d:\n",lnum);

	}
void for_end()
	{
	int x,y;
	y=label[ltop--];
	x=label[ltop-1];
	ltop = ltop - 2;
	fprintf(f1,"\t\tgoto $L%d\n",y);
	fprintf(f1,"$L%d: \n",x);
	ltop--;
	}

void for_end_iri()
	{
	int x,y;
	y=label[ltop--];
	//x=label[ltop--];
	fprintf(f1,"\t\tgoto $L%d\n",y);
	//fprintf(f1,"$L%d: \n",y);
	top--;
	}
void push(char* text)
{
	//printf(">PUSHING: %s<",text);
  	strcpy(st[++top],text);
}
void codegen_unary()
{
 	sprintf(tempo,"$t%d",i);
  	fprintf(f1,"%s\t=\t%s\t%c\t1\n",tempo,st[top-1],st[top][1]);
  	fprintf(f1,"%s\t=\t%s\n",st[top-1],tempo);
  	top-=2;
 	strcpy(st[top],tempo);
 	i++;
}
void codegen_logical()
{
 	sprintf(tempo,"$t%d",i);
  	fprintf(f1,"%s\t=\t%s\t%s\t%s\n",tempo,st[top-2],st[top-1],st[top]);
  	top-=2;
 	strcpy(st[top],tempo);
 	i++;
}
void codegen_algebric()
{
 	sprintf(tempo,"$t%d",i); // converts temp to reqd format
  	fprintf(f1,"%s\t=\t%s\t%s\t%s\n",tempo,st[top-2],st[top-1],st[top]);
  	top-=2;
 	strcpy(st[top],tempo);
 	i++;
}
void codegen_assign()
{
 	fprintf(f1,"%s\t=\t%s\n",st[top-2],st[top]);
 	top-=3;
}
void intermediateCode()
{
	int Labels[100000];
	char buf[100];
	f1=fopen("output","r");
	int flag=0,lineno=1;
	memset(Labels,0,sizeof(Labels));
	while(fgets(buf,sizeof(buf),f1)!=NULL)
	{
		//printf(" %s",buf);
		if(buf[0]=='$'&&buf[1]=='$'&&buf[2]=='L')
		{
			int k=atoi(&buf[3]);
			//printf("hi %d\n",k);
			Labels[k]=lineno;
		}
		else
		{
			lineno++;
		}
	}
	fclose(f1);
	f1=fopen("output","r");
	lineno=0;

	printf("\n\n\n*********************InterMediate Code***************************\n\n");
	while(fgets(buf,sizeof(buf),f1)!=NULL)
	{
		//printf("%s",buf);
		if(buf[0]=='$'&&buf[1]=='$'&&buf[2]=='L')
		{
			;
		}
		else
		{
			flag=0;
			lineno++;
			printf("%3d:\t",lineno);
			int len=strlen(buf),i,flag1=0;
			for(i=len-3;i>=0;i--)
			{
				if(buf[i]=='$'&&buf[i+1]=='$'&&buf[i+2]=='L')
				{
					flag1=1;
					break;
				}
			}
			if(flag1)
			{
				buf[i]=='\0';
				int k=atoi(&buf[i+3]),j;
				//printf("%s",buf);
				for(j=0;j<i;j++)
					printf("%c",buf[j]);
				printf(" %d\n",Labels[k]);
			}
			else printf("%s",buf);
		}
	}
	printf("%3d:\tend\n",++lineno);
	fclose(f1);
}

int main()
{
	f1=fopen("output","w");
    printf("\nCode After Stripping off Comments:");
    printf("\n-------------------------------------------------------------------------------------------------\n");
    yyparse();
    fclose(f1);
    printf("\n-------------------------------------------------------------------------------------------------\n");
    if(success)
    	printf("\n\t\t\t\t\tParsing Successful!\n\n");
			int i = 0;
		printf("\n\t\t\t\t\tSYMBOL TABLE\n\n");
		printf("Scope_Num\tTok_Num\t\t Symbol\t\t\tTypeOfToken\t\tLine Number\tSize\n");
		printf("----------------------------------------------------------------------------------------------\n");
		for(i = 0; i < tcnt; i ++)
		{
			if(symtab[i].tok_num != 0)
				printf("%5d\t\t%5d\t\t%8s\t\t%8s\t\t%5d\t\t%5d\n",symtab[i].scope_num,symtab[i].tok_num,symtab[i].symbol,symtab[i].type,symtab[i].lineno,symtab[i].size);
		}
		printf("Total number of tokens : %d\n",tcnt);
		int present_flag=0;
		int redeclare_flag=0;
		for(int i = 0; i < tcnt; i ++)
		{
			if(symtab[i].tok_num != 0)
			{
				if(!strcmp(symtab[i].type, "Id"))
				{
					if(!strcmp(symtab[i].symbol, "printf"))
					{
						printf("Undefined reference to function at %d\n", symtab[i].lineno);
					}
					else
					{
						for(int j=0;j<tcnt;j++)
						{
							if(!strcmp(symtab[j].symbol, symtab[i].symbol)&& strcmp(symtab[j].type, "Id"))
							{

								present_flag = 1;
								break;
								
							}

						}
						if(present_flag == 0)
							printf("Undefined variable at %d\n", symtab[i].lineno);
						present_flag=0;
					}
				}
			}
		}
		for(int i = 0; i < tcnt; i ++)
		{
			if(symtab[i].tok_num != 0)
			{
				if(strcmp(symtab[i].symbol, "printf") && strcmp(symtab[i].symbol, "main"))
				{
					for(int j=0;j<tcnt;j++)
					{
						if(!strcmp(symtab[j].symbol, symtab[i].symbol)&& strcmp(symtab[j].type, "Id"))
						{
							if(symtab[j].tok_num < symtab[i].tok_num && strcmp(symtab[i].type, "Id"))
							{
								redeclare_flag = 1;
								break;
							}
						}
					}
					if(redeclare_flag==1)
						printf("Redeclaration of variable at %d\n", symtab[i].lineno);
					redeclare_flag=0;
				}
			}			
		}

	intermediateCode();
    return 0;
}

int yyerror(const char *msg)
{
	extern int yylineno;
	printf("Parsing Failed\nLine Number: %d %s\n",yylineno,msg);
	success = 0;
	return 0;
}
