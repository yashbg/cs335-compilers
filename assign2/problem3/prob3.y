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
%token CLOSE_TAG_OPEN

%%

quiz:
  '<' QUIZ '>' question CLOSE_TAG_OPEN QUIZ '>'

question:
  %empty
| question '<' SINGLESELECT MARKS '=' '"' SINGLESELECT_MARKS_NUM '"' '>' ss_question_body CLOSE_TAG_OPEN SINGLESELECT '>'
| question '<' MULTISELECT MARKS '=' '"' MULTISELECT_MARKS_NUM '"' '>' ms_question_body CLOSE_TAG_OPEN MULTISELECT '>'

ss_question_body:
  ss_correct choice choice choice
| choice ss_correct choice choice
| choice choice ss_correct choice
| choice choice choice ss_correct
| ss_correct choice choice choice choice
| choice ss_correct choice choice choice
| choice choice ss_correct choice choice
| choice choice choice ss_correct choice
| choice choice choice choice ss_correct

ms_question_body:
  ms_correct choice ms_correct choice ms_correct choice ms_correct
| ms_correct choice ms_correct choice ms_correct choice ms_correct choice ms_correct

/* question_body:
  choice choice choice correct
| choice choice choice choice correct */

choice:
  '<' CHOICE '>' CLOSE_TAG_OPEN CHOICE '>'

ss_correct:
  '<' CORRECT '>' CLOSE_TAG_OPEN CORRECT '>'

ms_correct:
  %empty
| ms_correct '<' CORRECT '>' CLOSE_TAG_OPEN CORRECT '>'

%%

int main() {
  return yyparse();
}

void yyerror(char const *s) {
  fprintf(stderr, "%s\n", s);
}
