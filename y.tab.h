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
    ID = 258,
    NUM = 259,
    WHILE = 260,
    TYPE = 261,
    CHARCONST = 262,
    COMPARE = 263,
    PREPRO = 264,
    INT = 265,
    RETURN = 266,
    IF = 267,
    ELSE = 268,
    STRUCT = 269,
    UNARYOP = 270,
    STATEKW = 271,
    STRING = 272,
    CC = 273,
    CO = 274,
    FLOAT = 275,
    VOID = 276,
    CHAR = 277,
    STATIC = 278,
    AND = 279,
    OR = 280,
    BREAK = 281,
    NEG = 282
  };
#endif
/* Tokens.  */
#define ID 258
#define NUM 259
#define WHILE 260
#define TYPE 261
#define CHARCONST 262
#define COMPARE 263
#define PREPRO 264
#define INT 265
#define RETURN 266
#define IF 267
#define ELSE 268
#define STRUCT 269
#define UNARYOP 270
#define STATEKW 271
#define STRING 272
#define CC 273
#define CO 274
#define FLOAT 275
#define VOID 276
#define CHAR 277
#define STATIC 278
#define AND 279
#define OR 280
#define BREAK 281
#define NEG 282

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
