%{
  #include <stdlib.h>
  #include <ctype.h>
  #include "prob3.tab.h"

  void yyerror(char const *s);
  void store_marks();
%}

%option noyywrap yylineno nodefault

num           [0-9]+
ws            [ \t\f\n]
marks_attr    (?i:marks){ws}*={ws}*\"{ws}*{num}{ws}*\"

%%

\<{ws}*(?i:quiz){ws}*\>                             return QUIZ_OPEN;
\<{ws}*\/{ws}*(?i:quiz){ws}*\>                      return QUIZ_CLOSE;
\<{ws}*(?i:singleselect){ws}*{marks_attr}{ws}*\>    store_marks(); return SINGLESELECT_OPEN;
\<{ws}*\/{ws}*(?i:singleselect){ws}*\>              return SINGLESELECT_CLOSE;
\<{ws}*(?i:multiselect){ws}*{marks_attr}{ws}*\>     store_marks(); return MULTISELECT_OPEN;
\<{ws}*\/{ws}*(?i:multiselect){ws}*\>               return MULTISELECT_CLOSE;
\<{ws}*(?i:choice){ws}*\>                           return CHOICE_OPEN;
\<{ws}*\/{ws}*(?i:choice){ws}*\>                    return CHOICE_CLOSE;
\<{ws}*(?i:correct){ws}*\>                          return CORRECT_OPEN;
\<{ws}*\/{ws}*(?i:correct){ws}*\>                   return CORRECT_CLOSE;
\<{ws}*(?i:singleselect)[^/>]*\>                    yyerror("marks attribute is erroneous in singleselect tag");
\<{ws}*(?i:multiselect)[^/>]*\>                     yyerror("marks attribute is erroneous in multiselect tag");
\<[^/>]*\>                                          /* ignore misspelt open tag */
\<{ws}*\/[^>]*\>                                    /* ignore misspelt close tag */
.|\n                                                /* ignore question text and stray characters */

%%

void store_marks() {
  char *str = yytext;
  while (*str && !isdigit(*str)) {
    str++;
  }
  yylval = atoi(str);
}

void yyerror(char const *s) {
  fprintf(stderr, "Error on line %d: %s: %s\n", yylineno, s, yytext);
}
