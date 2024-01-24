%{
#include <iostream>
#include <string>
#include <map>
#include <utility>
#include <cctype>

std::map<std::string, std::pair<int, std::string>> lexemes; // lexeme -> (count, token)
std::map<std::string, int> keywords; // keyword -> count

void store(std::string lexeme, std::string token);
std::string tolower(const std::string &str);
%}

%option c++ noyywrap yylineno nodefault yylineno

KEYWORD         (?i:ARRAY)|(?i:BEGIN)|(?i:BOOLEAN)|(?i:COMMENT)|(?i:CONTINUE)|(?i:DO)|(?i:DOUBLE)|(?i:ELSE)|(?i:END)|(?i:FALSE)|(?i:FOR)|(?i:IF)|(?i:INTEGER)|(?i:LABEL)|(?i:LIST)|(?i:LONG)|(?i:OWN)|(?i:PROCEDURE)|(?i:STEP)|(?i:SWITCH)|(?i:THEN)|(?i:TRUE)|(?i:UNTIL)|(?i:VALUE)|(?i:WHILE)
OPERATOR        (?i:AND)|(?i:OR)|(?i:LEQ)|(?i:LT)|(?i:GEQ)|(?i:GT)|(?i:NOT)|(?i:EQL)|(?i:NEQ)|[+\-*/%^|&]|(:=)|(«)|(»)|(<=)|(>=)
IDENTIFIER      [a-zA-Z][a-zA-Z0-9]*
STRING          (\"[^'"]*\")|(\'[^'"]*\')
DELIMITER       [;:,[\]{}()]
INTEGER         0|[1-9][0-9]*
FLOATING_POINT  {INTEGER}\.[0-9]{1,6}
HEXADECIMAL     0[xX](0|[1-9a-fA-F][0-9a-fA-F]*)
COMMENT         \{(.|\n)*\}
WHITESPACE      [ \t\f\n]+

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

.                   std::cout << "Unrecognized character: " << yytext << std::endl;

%%

void store(std::string lexeme, std::string token) {
    if (token == "KEYWORD") {
        std::string lexeme_lower = tolower(lexeme);
        keywords[lexeme_lower]++;
        lexemes[lexeme] = {0, token};
        return;
    }

    if (!lexemes.count(lexeme)) {
        lexemes[lexeme] = {1, token};
        return;
    }

    lexemes[lexeme].first++;
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

    std::cout << "TOKEN\t\tCOUNT\t\tLEXEME" << std::endl;
    for (auto &lexeme : lexemes) {
        int count = lexeme.second.second == "KEYWORD" ? keywords[tolower(lexeme.first)] : lexeme.second.first;
        std::cout << lexeme.second.second << "\t\t" << count << "\t\t" << lexeme.first << std::endl;
    }
    
    return 0;
}
