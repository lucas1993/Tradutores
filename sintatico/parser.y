%{
#include <stdio.h>

void yyerror(const char *str)
{    fprintf(stderr,"error: %s\n",str);}
%}

%token ID
%token WILDSCORE
%token FLOAT
%token BOOLVAL
%token BOOL
%token NUMBER
%token FLOATNUM
%token INTEGER
%token IF
%token ELSE
%token THEN
%token WHILE
%token WHERE
%token YIELD
%token DO
%token PRINT
%token READBOOL
%token READFLOAT
%token READINT
%token RARROW
%token LARROW
%token DIFF
%token EQUALS
%token DOUBLECOLON
%token APPEND
%token AND
%token OR
%token LEQ
%token GEQ


%start program

%%
program:  
    line_elems
	;

line_elems: 
    line_elem line_elems
    | line_elem
	;

line_elem:
    fundecl
    | procdecl
    | funtype_decl
	;

fundecl: 
    ID args '=' expr ';'
    | ID args '=' expr where_exp 
    | ID '=' expr ';'
    | ID '=' expr where_exp
	;

args:
    arg_value args 
    | arg_value
    | WILDSCORE
	;

arg_value:
    list_value
    | basic_value
    | '(' arg_value ')'
	;

basic_value: 
    NUMBER 
    | FLOATNUM
    | BOOLVAL
    | ID
    | '(' ')'
	;

list_value:
    basic_value ':' list_value
    '[' list_args ']' ':' list_value
    | WILDSCORE ':' list_value
    | built_list_value
	;

list_args:
         arg_value
         | arg_value ',' list_args
         ;

built_list_value:
    '[' ']'
    | '[' list_args ']'
	;

funtype_decl:
    ID DOUBLECOLON funtype ';'
	;

funtype:
    basic_type
    | '(' funtype ')'
    | basic_type RARROW funtype
	;

basic_type:
    INTEGER
    | FLOAT
    | BOOL
    | '[' basic_type ']' 
    | ID
    | '(' ')'
	;

appexpr:
       appexpr nonapp
       | nonapp nonapp
	;

nonapp:
      basic_value
      | '(' expr ')'
      ;

expr:
    op_prec1
    | appexpr
    | ifexpr
    | yieldexpr
	;

ifexpr:
    IF expr THEN '{' expr '}' ELSE '{' expr '}'
	;

yieldexpr:
    YIELD ifexpr
    | YIELD appexpr
    | YIELD op_prec1
	;

op_prec1:
     op_prec2 OR op_prec1
     | op_prec2
	;

op_prec2:
     op_prec3 AND op_prec2
     | op_prec3
	;

op_prec3:
     op_prec4 EQUALS op_prec3
     | op_prec4 DIFF op_prec3
     | op_prec4 '<' op_prec3
     | op_prec4 LEQ op_prec3
     | op_prec4 '>' op_prec3
     | op_prec4 GEQ op_prec3
     | op_prec4
	;

op_prec4:
     op_prec5 ':' op_prec4
     | op_prec5 APPEND op_prec4
     | op_prec5
	;

op_prec5:
    op_prec5 '+' op_prec6
    | op_prec5 '-' op_prec6
    | op_prec6
	;

op_prec6:
     op_prec6 '%' op_prec7
     | op_prec7
	;

op_prec7:
    op_prec7 '*' op_prec8
    | op_prec7 '/' op_prec8
    | op_prec8
	;

op_prec8:
    basic_value
    | list_expr
    | '(' expr ')'
    | '-' op_prec8
	;

exprs:
    expr
    | expr ',' exprs
	;

list_expr:
     '[' exprs ']'
    | '[' ']'
	;


where_exp:
    WHERE '{' line_elems '}' 
	;

procdecl:
    ID args '=' DO '{' stmts '}'
    | ID args '=' DO '{' stmts '}' where_exp
    | ID '=' DO '{' stmts '}'
    | ID '=' DO '{' stmts '}' where_exp
	;

stmts:
    stmt
    | stmt stmts
	;

stmt:
    ID LARROW expr ';'
    | ID LARROW while_expr ';'
    | ID LARROW io_stmt ';'
    | expr ';'
    | while_expr ';'
    | io_stmt ';'
	;

io_stmt:
    READINT
    | READFLOAT
    | READBOOL
    | PRINT expr
	;

while_expr:
    WHILE '(' expr ')' '{' stmts '}' 
	;
%%

int main(int argc, char** argv) {

    /*if(argc > 1) {*/
        /*yyin = fopen(argv[1], "r");*/
    /*}*/

    yyparse();

    return 0;
}
