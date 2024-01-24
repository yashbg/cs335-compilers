%{
/* need this for the call to atof() below */
// #include <math.h>
// #include <vector>
%}

KEYWORD         (?i:ARRAY)|(?i:BEGIN)|(?i:BOOLEAN)|(?i:COMMENT)|(?i:CONTINUE)|(?i:DO)|(?i:DOUBLE)|(?i:ELSE)|(?i:END)|(?i:FALSE)|(?i:FOR)|(?i:IF)|(?i:INTEGER)|(?i:LABEL)|(?i:LIST)|(?i:LONG)|(?i:OWN)|(?i:PROCEDURE)|(?i:STEP)|(?i:SWITCH)|(?i:THEN)|(?i:TRUE)|(?i:UNTIL)|(?i:VALUE)|(?i:WHILE)
OPERATOR        (?i:AND)|(?i:OR)|(?i:LEQ)|(?i:LT)|(?i:GEQ)|(?i:GT)|(?i:NOT)|(?i:EQL)|(?i:NEQ)|[+\-*/%^|&]|(:=)|(«)|(»)|(<=)|(>=)
IDENTIFIER      [a-zA-Z][a-zA-Z0-9]*
STRING          \"(.|\n)*\"
DELIMITER       [;:,'"[\]{}()]
INTEGER         0|[1-9][0-9]*
FLOATING_POINT  {INTEGER}\.[0-9]{1,6}
HEXADECIMAL     0[xX](0|[1-9a-fA-F][0-9a-fA-F]*)
COMMENT         \{(.|\n)*\}
WHITESPACE      [ \t\f\n]+

%%

{KEYWORD}           printf("KEYWORD: %s\n", yytext);

{OPERATOR}          printf("OPERATOR: %s\n", yytext);

{IDENTIFIER}        printf("IDENTIFIER: %s\n", yytext);

{STRING}            printf("STRING: %s\n", yytext);

{DELIMITER}         printf("DELIMITER: %s\n", yytext);

{INTEGER}           printf("INTEGER: %s\n", yytext);

{FLOATING_POINT}    printf("FLOATING_POINT: %s\n", yytext);

{HEXADECIMAL}       printf("HEXADECIMAL: %s\n", yytext);

{COMMENT}           printf("COMMENT: %s\n", yytext);

{WHITESPACE}        /* ignore whitespace */

.                   printf("Unrecognized character: %s\n", yytext);

%%
