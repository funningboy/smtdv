/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     RETURN = 258,
     BEGIN_CYCLE = 259,
     END_CYCLE = 260,
     BEGIN_TIME = 261,
     END_TIME = 262,
     ID = 263,
     BST_TYPE = 264,
     TRX_SIZE = 265,
     TRX_PRT = 266,
     LOCK = 267,
     RESP = 268,
     RW = 269,
     ADDR = 270,
     DATA = 271,
     BYTEN = 272,
     TLPAREN = 273,
     TRPAREN = 274,
     TCOMMA = 275,
     COMMENT = 276,
     TIDENTIFIER = 277,
     SIDENTIFIER = 278
   };
#endif
/* Tokens.  */
#define RETURN 258
#define BEGIN_CYCLE 259
#define END_CYCLE 260
#define BEGIN_TIME 261
#define END_TIME 262
#define ID 263
#define BST_TYPE 264
#define TRX_SIZE 265
#define TRX_PRT 266
#define LOCK 267
#define RESP 268
#define RW 269
#define ADDR 270
#define DATA 271
#define BYTEN 272
#define TLPAREN 273
#define TRPAREN 274
#define TCOMMA 275
#define COMMENT 276
#define TIDENTIFIER 277
#define SIDENTIFIER 278




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 32 "dpi_smtdv_parser.y"
{
std::string *smtdv_string;
   unsigned long smtdv_long;
int token;
}
/* Line 1529 of yacc.c.  */
#line 101 "dpi_smtdv_parser.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

