%{
  #include <stdio.h>

  int num_ques = 0, num_ss = 0, num_ms = 0, num_choice = 0, num_correct = 0, total_marks = 0;
  int num_marks[9] = {0};

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
| question SINGLESELECT_OPEN ss_question_body SINGLESELECT_CLOSE    { singleselect_action($SINGLESELECT_OPEN); }
| question MULTISELECT_OPEN ms_question_body MULTISELECT_CLOSE      { multiselect_action($MULTISELECT_OPEN); }

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
  CHOICE_OPEN CHOICE_CLOSE      { num_choice++; }

correct_multi:
  %empty
| correct_multi correct

correct:
  CORRECT_OPEN CORRECT_CLOSE    { num_correct++; }

%%

int main() {
  yyparse();
  
  printf("Number of questions: %d\n", num_ques);
  printf("Number of singleselect questions: %d\n", num_ss);
  printf("Number of multiselect questions: %d\n", num_ms);
  printf("Number of answer choices: %d\n", num_choice);
  printf("Number of correct answers: %d\n", num_correct);
  printf("Total marks: %d\n", total_marks);
  printf("Number of 1 mark questions: %d\n", num_marks[1]);
  printf("Number of 2 marks questions: %d\n", num_marks[2]);
  printf("Number of 3 marks questions: %d\n", num_marks[3]);
  printf("Number of 4 mark questions: %d\n", num_marks[4]);
  printf("Number of 5 mark questions: %d\n", num_marks[5]);
  printf("Number of 6 mark questions: %d\n", num_marks[6]);
  printf("Number of 7 mark questions: %d\n", num_marks[7]);
  printf("Number of 8 mark questions: %d\n", num_marks[8]);
}

void yyerror(char const *s) {
  fprintf(stderr, "%s\n", s);
}

void singleselect_action(int marks) {
  if (marks != 1 && marks != 2) {
    yyerror("marks is out of range in singleselect tag");
  }
  num_ques++;
  num_ss++;
  total_marks += marks;
  num_marks[marks]++;
}

void multiselect_action(int marks) {
  if (marks < 2 || marks > 8) {
    yyerror("marks is out of range in multiselect tag");
  }
  num_ques++;
  num_ms++;
  total_marks += marks;
  num_marks[marks]++;
}
