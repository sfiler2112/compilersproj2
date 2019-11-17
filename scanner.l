/* Compiler Theory and Design
   Dr. Duane J. Jarc */

/* This file contains flex input file */

/* Edited by: Sean Filer 
   Date: 11/1/2019 */

%{
#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
dashcomment	\-\-.*\n
slashcomment	\/\/.*\n
comment		{dashcomment}|{slashcomment}
line		[\n]
id		[A-Za-z](_?[A-Za-z0-9]+)*
digit		[0-9]
int		{digit}+
real		{int}\.{int}?([eE]\-?{int})?
punc		[\(\),:;]
bool		true|false
relop		([/><]?=)|[><]
addop		[\+\-]
mulop		[\*\/]
remop		rem
expop		\*\*
arrow		=>
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
{arrow}		{ ECHO; return(ARROW); }
{relop}		{ ECHO; return(RELOP); }
{addop}		{ ECHO; return(ADDOP); }
{mulop}		{ ECHO; return(MULOP); }
{remop}		{ ECHO; return(REMOP); }
{expop}		{ ECHO; return(EXPOP); } 
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
case		{ ECHO; return(CASE); }
else		{ ECHO; return(ELSE); }
end		{ ECHO; return(END); }
endcase		{ ECHO; return(ENDCASE); }
endif		{ ECHO; return(ENDIF); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
if		{ ECHO; return(IF); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
not		{ ECHO; return(NOTOP); }
or		{ ECHO; return(OROP); }
others		{ ECHO; return(OTHERS); }
real		{ ECHO; return(REAL); }
reduce		{ ECHO; return (REDUCE); }
returns		{ ECHO; return(RETURNS); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }
and		{ ECHO; return(ANDOP); }
{bool}		{ ECHO; return(BOOL_LITERAL); }
{id}		{ ECHO; return(IDENTIFIER);}
{int}		{ ECHO; return(INT_LITERAL); }
{real}		{ ECHO; return(REAL_LITERAL); }
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }
%%


