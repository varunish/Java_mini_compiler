/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

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
    int_const = 258,
    char_const = 259,
    float_const = 260,
    id = 261,
    string = 262,
    type_const = 263,
    access_specifier = 264,
    FOR = 265,
    BREAK = 266,
    CLASS = 267,
    CONTINUE = 268,
    RETURN = 269,
    STATIC = 270,
    MAIN = 271,
    PRINT = 272,
    EXTENDS = 273,
    NUM = 274,
    U_OP = 275,
    or_const = 276,
    and_const = 277,
    eq_const = 278,
    rel_const = 279,
    inc_const = 280,
    point_const = 281,
    param_const = 282,
    ELSE = 283,
    HEADER = 284
  };
#endif
/* Tokens.  */
#define int_const 258
#define char_const 259
#define float_const 260
#define id 261
#define string 262
#define type_const 263
#define access_specifier 264
#define FOR 265
#define BREAK 266
#define CLASS 267
#define CONTINUE 268
#define RETURN 269
#define STATIC 270
#define MAIN 271
#define PRINT 272
#define EXTENDS 273
#define NUM 274
#define U_OP 275
#define or_const 276
#define and_const 277
#define eq_const 278
#define rel_const 279
#define inc_const 280
#define point_const 281
#define param_const 282
#define ELSE 283
#define HEADER 284

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
