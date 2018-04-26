/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INTEGER = 258,
    STATIC = 259,
    MAIN = 260,
    CLASS = 261,
    access_specifier = 262,
    ID = 263,
    type_const = 264,
    VARIABLE = 265,
    WHILE = 266,
    IF = 267,
    PRINT = 268,
    FOR = 269,
    INT = 270,
    FLOAT = 271,
    CHAR = 272,
    IFX = 273,
    ELSE = 274,
    GE = 275,
    LE = 276,
    EQ = 277,
    NE = 278,
    UMINUS = 279,
    INC = 280,
    DEC = 281
  };
#endif
/* Tokens.  */
#define INTEGER 258
#define STATIC 259
#define MAIN 260
#define CLASS 261
#define access_specifier 262
#define ID 263
#define type_const 264
#define VARIABLE 265
#define WHILE 266
#define IF 267
#define PRINT 268
#define FOR 269
#define INT 270
#define FLOAT 271
#define CHAR 272
#define IFX 273
#define ELSE 274
#define GE 275
#define LE 276
#define EQ 277
#define NE 278
#define UMINUS 279
#define INC 280
#define DEC 281

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 16 "ast.y" /* yacc.c:1909  */

	int iValue; /* integer value */
	char sIndex; /* symbol table index */
	nodeType *nPtr; /* node pointer */

#line 112 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
