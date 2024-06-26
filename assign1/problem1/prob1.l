%{
#include <iostream>
#include <string>
#include <map>
#include <cctype>
#include <iomanip>

std::map<std::string, std::string> tokens; // lexeme -> token
std::map<std::string, int> counts; // lexeme -> count

void store(const std::string &lexeme, const std::string &token);
std::string tolower(const std::string &str);
%}

%option c++ noyywrap yylineno nodefault yylineno

KEYWORD         ?i:ARRAY|BEGIN|BOOLEAN|COMMENT|CONTINUE|DO|DOUBLE|ELSE|END|FALSE|FOR|IF|INTEGER|LABEL|LIST|LONG|OWN|PROCEDURE|STEP|SWITCH|THEN|TRUE|UNTIL|VALUE|WHILE
OPERATOR        (?i:AND|OR|LEQ|LT|GEQ|GT|NOT|EQL|NEQ)|[+\-*/%^|&]|:=|<<|>>|<=|>=
IDENTIFIER      [a-zA-Z][a-zA-Z0-9]*
STRING          (\"[^'"]*\")|(\'[^'"]*\')
DELIMITER       [;:,[\]{}()]
INTEGER         0|[1-9][0-9]*
FLOATING_POINT  {INTEGER}\.[0-9]{1,6}
HEXADECIMAL     0[xX](0|[1-9a-fA-F][0-9a-fA-F]*)
COMMENT         \{[^{}]*\}
WHITESPACE      [ \t\f\n]
err-string1     (\"[^"]*\")|(\'[^']*\')
err-string2     (\"[^"]*)|(\'[^']*)

%%

{KEYWORD}           store(yytext, "KEYWORD");

{OPERATOR}          store(yytext, "OPERATOR");

{IDENTIFIER}        store(yytext, "IDENTIFIER");

{STRING}            store(yytext, "STRING");

{DELIMITER}         store(yytext, "DELIMITER");

{INTEGER}           store(yytext, "INTEGER");

{FLOATING_POINT}    store(yytext, "FLOATING_POINT");

{HEXADECIMAL}       store(yytext, "HEXADECIMAL");

{COMMENT}           /* ignore comment */

{WHITESPACE}        /* ignore whitespace */

{err-string1}       std::cout << "Error on line " << yylineno << ": Ill-formed string: " << yytext << std::endl;

{err-string2}       std::cout << "Error on line " << yylineno << ": Ill-formed string: " << yytext << std::endl;

.                   std::cout << "Error on line " << yylineno << ": Illegal character: " << yytext << std::endl;

%%

void store(const std::string &lexeme, const std::string &token) {
    (token == "KEYWORD" || token == "OPERATOR") ? counts[tolower(lexeme)]++ : counts[lexeme]++;
    tokens[lexeme] = token;
}

std::string tolower(const std::string &str) {
    std::string str_lower = str;
    for (auto &c : str_lower) {
        c = std::tolower(c);
    }

    return str_lower;
}

int main(int /* argc */, char** /* argv */) {
    FlexLexer* lexer = new yyFlexLexer;
    while(lexer->yylex() != 0);

    std::cout << std::left << std::setw(20) << "TOKEN" << std::setw(10) << "COUNT" << "LEXEME" << std::endl;
    for (auto &token : tokens) {
        int count = (token.second == "KEYWORD" || token.second == "OPERATOR") ? counts[tolower(token.first)] : counts[token.first];
        std::cout << std::left << std::setw(20) << token.second << std::setw(10) << count << token.first << std::endl;
    }
    
    return 0;
}
