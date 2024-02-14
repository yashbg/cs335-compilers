%{
  #include <stdio.h>

  int num_ques = 0, num_ss = 0, num_ms = 0, num_choice = 0, num_correct = 0, total_marks = 0;
  int num_marks[9] = {0};
  int cur_num_choice = 0;

  int yylex();
  void yyerror(char const *s);
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
| question SINGLESELECT_OPEN question_body SINGLESELECT_CLOSE    { singleselect_action($SINGLESELECT_OPEN); }
| question MULTISELECT_OPEN question_body MULTISELECT_CLOSE      { multiselect_action($MULTISELECT_OPEN); }

question_body:
  %empty
| question_body choice
| question_body correct

choice:
  CHOICE_OPEN CHOICE_CLOSE      { num_choice++; cur_num_choice++; }

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

  for (int i = 1; i <= 8; i++) {
    printf("Number of %d mark questions: %d\n", i, num_marks[i]);
  }
}

void singleselect_action(int marks) {
  if (marks != 1 && marks != 2) {
    yyerror("marks is out of range in singleselect tag");
  }
  num_ques++;
  num_ss++;
  total_marks += marks;
  num_marks[marks]++;

  if (cur_num_choice != 3 && cur_num_choice != 4) {
    cur_num_choice = 0;
    yyerror("number of choices is out of range in singleselect tag");
  }

  cur_num_choice = 0;
}

void multiselect_action(int marks) {
  if (marks < 2 || marks > 8) {
    yyerror("marks is out of range in multiselect tag");
  }
  num_ques++;
  num_ms++;
  total_marks += marks;
  num_marks[marks]++;

  if (cur_num_choice != 3 && cur_num_choice != 4) {
    cur_num_choice = 0;
    yyerror("number of choices is out of range in multiselect tag");
  }

  cur_num_choice = 0;
}
