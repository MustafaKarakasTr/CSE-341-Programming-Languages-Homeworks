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
    exit_command = 258,
    number = 259,
    identifier = 260,
    KW_AND = 261,
    KW_OR = 262,
    KW_NOT = 263,
    KW_EQUAL = 264,
    KW_LESS = 265,
    KW_IF = 266,
    OP_PLUS = 267,
    OP_MINUS = 268,
    OP_DIV = 269,
    OP_MULT = 270,
    OP_DBLMULT = 271,
    OP_OP = 272,
    OP_CP = 273,
    KW_SET = 274,
    KW_DISP = 275,
    KW_TRUE = 276,
    KW_FALSE = 277,
    KW_LIST = 278,
    KW_CONCAT = 279,
    KW_APPEND = 280
  };
#endif
/* Tokens.  */
#define exit_command 258
#define number 259
#define identifier 260
#define KW_AND 261
#define KW_OR 262
#define KW_NOT 263
#define KW_EQUAL 264
#define KW_LESS 265
#define KW_IF 266
#define OP_PLUS 267
#define OP_MINUS 268
#define OP_DIV 269
#define OP_MULT 270
#define OP_DBLMULT 271
#define OP_OP 272
#define OP_CP 273
#define KW_SET 274
#define KW_DISP 275
#define KW_TRUE 276
#define KW_FALSE 277
#define KW_LIST 278
#define KW_CONCAT 279
#define KW_APPEND 280

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 73 "calc.y" /* yacc.c:1909  */
int num; char* id;int* listPointer;

#line 107 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
