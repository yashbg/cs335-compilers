%{
  #include <stdio.h>
  #include "prob3.tab.h"
%}

%option noyywrap yylineno nodefault

num           [0-9]+
ws            [ \t\f\n]
marks_attr    (?i:marks){ws}*={ws}*\"{ws}*{num}{ws}*\"

%%

\<{ws}*(?i:quiz){ws}*\>                             return QUIZ_OPEN;
\<{ws}*\/{ws}*(?i:quiz){ws}*\>                      return QUIZ_CLOSE;
\<{ws}*(?i:singleselect){ws}*{marks_attr}{ws}*\>    return SINGLESELECT_OPEN;
\<{ws}*\/{ws}*(?i:singleselect){ws}*\>              return SINGLESELECT_CLOSE;
\<{ws}*(?i:multiselect){ws}*{marks_attr}{ws}*\>     return MULTISELECT_OPEN;
\<{ws}*\/{ws}*(?i:multiselect){ws}*\>               return MULTISELECT_CLOSE;
\<{ws}*(?i:choice){ws}*\>                           return CHOICE_OPEN;
\<{ws}*\/{ws}*(?i:choice){ws}*\>                    return CHOICE_CLOSE;
\<{ws}*(?i:correct){ws}*\>                          return CORRECT_OPEN;
\<{ws}*\/{ws}*(?i:correct){ws}*\>                   return CORRECT_CLOSE;
\<[^/>]*\>                                          /* ignore misspelt open tag */
\<{ws}*\/[^>]*\>                                    /* ignore misspelt close tag */
.|\n                                                /* ignore question text and stray characters */

%%
