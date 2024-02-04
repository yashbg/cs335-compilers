%{
// int yylex();
%}

%token QUIZ
%token SINGLESELECT
%token MULTISELECT
%token MARKS
%token SINGLESELECT_MARKS_NUM
%token MULTISELECT_MARKS_NUM
%token STRING
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
  STRING choice choice choice correct
| STRING choice choice choice choice correct

choice:
  '<' CHOICE '>' STRING '<' '/' CHOICE '>'

correct:
  %empty
| correct '<' CORRECT '>' STRING '<' '/' CORRECT '>'

%%

int main() {
  return yyparse();
}
