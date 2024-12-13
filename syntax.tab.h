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
     DEBUT = 258,
     FIN = 259,
     EXECUTION = 260,
     FIXE = 261,
     SI = 262,
     ALORS = 263,
     SINON = 264,
     TANTQUE = 265,
     FAIRE = 266,
     AFFICHE = 267,
     LIRE = 268,
     ASSIGN = 269,
     EQ = 270,
     NEQ = 271,
     LE = 272,
     GE = 273,
     ET = 274,
     OU = 275,
     NON = 276,
     cstflt = 277,
     cstint = 278,
     idf = 279,
     TEXTV = 280,
     COMMENT = 281,
     COMMENTM = 282,
     NUM = 283,
     REAL = 284,
     TEXT = 285
   };
#endif
/* Tokens.  */
#define DEBUT 258
#define FIN 259
#define EXECUTION 260
#define FIXE 261
#define SI 262
#define ALORS 263
#define SINON 264
#define TANTQUE 265
#define FAIRE 266
#define AFFICHE 267
#define LIRE 268
#define ASSIGN 269
#define EQ 270
#define NEQ 271
#define LE 272
#define GE 273
#define ET 274
#define OU 275
#define NON 276
#define cstflt 277
#define cstint 278
#define idf 279
#define TEXTV 280
#define COMMENT 281
#define COMMENTM 282
#define NUM 283
#define REAL 284
#define TEXT 285




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 17 "syntax.y"
{
    int entier; 
    float reel; 
    char *str; 
    char *strv;
    struct listeD *symbole;
    struct listeT *symbol;
    struct constant *con;
}
/* Line 1529 of yacc.c.  */
#line 119 "syntax.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

