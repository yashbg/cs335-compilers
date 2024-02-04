%{
  #include <stdio.h>

  int yylex();
  void yyerror(char const *);
%}

%token QUIZ
%token SINGLESELECT
%token MULTISELECT
%token MARKS
%token SINGLESELECT_MARKS_NUM
%token MULTISELECT_MARKS_NUM
%token CHOICE
%token CORRECT

%%

quiz:
  '<' QUIZ '>' question '<' '/' QUIZ '>'

question:
  %empty
| question '<' SINGLESELECT MARKS '=' '"' SINGLESELECT_MARKS_NUM '"' '>' question_body '<' '/' SINGLESELECT '>'
| question '<' MULTISELECT MARKS '=' '"' MULTISELECT_MARKS_NUM '"' '>' question_body '<' '/' MULTISELECT '>'

question_body:
  choice choice choice correct
| choice choice choice choice correct

choice:
  '<' CHOICE '>' '<' '/' CHOICE '>'

correct:
  %empty
| correct '<' CORRECT '>' '<' '/' CORRECT '>'

%%

int main() {
  return yyparse();
}

void yyerror(char const *s) {
  fprintf(stderr, "%s\n", s);
}
