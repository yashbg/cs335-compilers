%{
  #include <stdio.h>
  #include "prob3.tab.h"
%}

%option noyywrap yylineno nodefault

ws    [ \t\f\n]

%%

(?i:quiz)           return QUIZ;
(?i:singleselect)   return SINGLESELECT;
(?i:multiselect)    return MULTISELECT;
(?i:marks)          return MARKS;
(?i:choice)         return CHOICE;
(?i:correct)        return CORRECT;
[1-2]               return SINGLESELECT_MARKS_NUM;
[2-8]               return MULTISELECT_MARKS_NUM;
\<{ws}*\/           return CLOSE_TAG_OPEN;
[<>/="]             return yytext[0];
.|\n                /* ignore question text and stray characters */

%%