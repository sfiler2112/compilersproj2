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
	function_header optional_variable body;
	
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
	IDENTIFIER ':' type IS statement_ |
	error ';' ;

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
	BEGIN_ statement_ END ';'|
	BEGIN_ error END ';';
    
statement_:
	statement ';' |
	error ';';
	
statement:
	expression |
	reduce_statement |
	if_statement |
	case_statement ;

case_statement:
	CASE expression IS optional_case OTHERS ARROW statement_ ENDCASE |
	CASE error ENDCASE ; 

if_statement:
	IF expression THEN statement_ ELSE statement_ ENDIF |
	IF error ENDIF ;

reduce_statement:
	REDUCE operator optional_reductions ENDREDUCE |
	REDUCE error ENDREDUCE ;


optional_case:
	case_ |
	;

case_: 
	case |
	case_ case ;
case:
	WHEN INT_LITERAL ARROW statement_ ; 

operator:
	ADDOP |
	MULOP ;


optional_reductions:
	reductions |
	;

reductions:
	statement_ |
	reductions statement_ ;

expression: 
	expression OROP and_expression |
	and_expression ;
		    
and_expression:
	and_expression ANDOP relation |
	relation ;

relation:
	relation RELOP term |
	term;

term:
	term ADDOP factor |
	factor ;
      
factor:
	factor MULOP exponent | 
	factor REMOP exponent |
	exponent ;

exponent:
	primary EXPOP exponent |
	primary ;

primary:
	'(' expression ')' |
	NOTOP primary |
	INT_LITERAL |
	REAL_LITERAL |
	BOOL_LITERAL | 
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
