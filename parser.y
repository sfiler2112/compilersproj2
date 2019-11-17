/* Compiler Theory and Design
   Dr. Duane J. Jarc */

%{

#include <string>

using namespace std;

#include "listing.h"
#include "tokens.h"

int yylex();
void yyerror(const char* message);

%}

%error-verbose

%token IDENTIFIER
%token INT_LITERAL REAL_LITERAL BOOL_LITERAL

%token ADDOP MULOP RELOP ANDOP REMOP EXPOP OROP NOTOP ARROW

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE 
%token CASE ELSE ENDCASE ENDIF IF OTHERS REAL THEN WHEN RETURNS

%%

function:	
	function_header optional_variable body ;
	
function_header:	
	FUNCTION IDENTIFIER optional_parameters RETURNS type ';' |
	error ';' ;

optional_variable:
	variable_ |
	;

variable_:
	variable |
	variable_ variable;

variable:
	IDENTIFIER ':' type IS statement_ ;

optional_parameters:
	parameter_ |
	;

parameter_:
	parameter |
	parameter_ ',' parameter ;

parameter:
	IDENTIFIER ':' type ;

type:
	INTEGER |
	REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' |
	error ';' ;
    
statement_:
	statement ';' |
	error ';' ;
	
statement:
	expression |
	REDUCE operator reductions ENDREDUCE ;

operator:
	ADDOP |
	MULOP ;

reductions:
	reductions statement_ |
	;
		    
expression:
	expression ANDOP relation |
	relation ;

relation:
	relation RELOP term |
	term;

term:
	term ADDOP factor |
	factor ;
      
factor:
	factor MULOP primary |
	primary ;

primary:
	'(' expression ')' |
	INT_LITERAL | 
	IDENTIFIER ;
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
