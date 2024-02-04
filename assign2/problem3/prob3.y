%{
  #include <stdio.h>

  int yylex();
  void yyerror(char const *);
%}

%token QUIZ_OPEN QUIZ_CLOSE
%token SINGLESELECT_OPEN SINGLESELECT_CLOSE
%token MULTISELECT_OPEN MULTISELECT_CLOSE
%token CHOICE_OPEN CHOICE_CLOSE
%token CORRECT_OPEN CORRECT_CLOSE

%%

quiz:
  QUIZ_OPEN question QUIZ_CLOSE

question:
  %empty
| question SINGLESELECT_OPEN ss_question_body SINGLESELECT_CLOSE
| question MULTISELECT_OPEN ms_question_body MULTISELECT_CLOSE

ss_question_body:
  correct choice choice choice
| choice correct choice choice
| choice choice correct choice
| choice choice choice correct
| correct choice choice choice choice
| choice correct choice choice choice
| choice choice correct choice choice
| choice choice choice correct choice
| choice choice choice choice correct

ms_question_body:
  correct_multi choice correct_multi choice correct_multi choice correct_multi
| correct_multi choice correct_multi choice correct_multi choice correct_multi choice correct_multi

choice:
  CHOICE_OPEN CHOICE_CLOSE

correct_multi:
  %empty
| correct_multi correct

correct:
  CORRECT_OPEN CORRECT_CLOSE

%%

int main() {
  return yyparse();
}

void yyerror(char const *s) {
  fprintf(stderr, "%s\n", s);
}
