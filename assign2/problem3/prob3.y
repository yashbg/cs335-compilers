%{
  #include <stdio.h>

  int yylex();
  void yyerror(char const *);
  void singleselect_action(int marks);
  void multiselect_action(int marks);
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
| question SINGLESELECT_OPEN ss_question_body SINGLESELECT_CLOSE { singleselect_action($SINGLESELECT_OPEN); }
| question MULTISELECT_OPEN ms_question_body MULTISELECT_CLOSE { multiselect_action($MULTISELECT_OPEN); }

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

void singleselect_action(int marks) {
  if (marks != 1 && marks != 2) {
    yyerror("marks is out of range in singleselect tag");
  }
}

void multiselect_action(int marks) {
  if (marks < 2 || marks > 8) {
    yyerror("marks is out of range in multiselect tag");
  }
}
