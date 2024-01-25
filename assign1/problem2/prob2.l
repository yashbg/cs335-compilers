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

KEYWORD         ?i:allocatable|allocate|assign|associate|asynchronous|backspace|bind|call|case|class|close|common|contains|continue|cycle|codimension|contiguous|critical|data|deallocate|deferred|dimension|do|else|elsewhere|end|endfile|endif|entry|equivalence|exit|external|enum|enumerator|extends|forall|final|flush|format|function|goto|generic|import|if|implicit|inquire|intrinsic|include|interface|intent|lock|module|nopass|namelist|nullify|open|only|operator|optional|parameter|pause|print|program|pointer|private|pass|protected|procedure|public|read|return|recursive|result|rewind|rewrite|save|stop|subroutine|select|sequence|submodule|target|then|use|value|unlock|volatile|while|write
NAME            [a-zA-Z][a-zA-Z0-9_]{0,62}
INT_LITERAL     [+\-]?[0-9]+
significand     ([0-9]+\.[0-9]*)|(\.[0-9]+)
REAL_LITERAL    [+\-]?(({significand}([EDed]{INT_LITERAL})?)|([0-9]+[EDed]{INT_LITERAL}))
LOGICAL_LITERAL \.(?i:TRUE|FALSE)\.
CHAR_LITERAL    \"[^'"]*\"
OPERATOR        [=+\-*/<>%&]|"**"|"//"|==|"/="|<=|>=|&&|<<|>>|"||"|(\.(?i:EQ|NE|LT|LE|GT|GE|NOT|AND|OR|EQV|NEQV)\.)
DELIMITER       [()[\]]|"(/"|"/)"
COMMENT         ^[ \t]*![^\n]*
SPECIAL_CHAR    [\\{},.:;!~?'`^|$#@]
WHITESPACE      [ \t\f\n]
err-string1     \"[^"]*\"
err-string2     \"[^"]*

%%

{KEYWORD}           store(yytext, "KEYWORD");

{NAME}              store(yytext, "NAME");

{INT_LITERAL}       store(yytext, "INT_LITERAL");

{REAL_LITERAL}      store(yytext, "REAL_LITERAL");

{LOGICAL_LITERAL}   store(yytext, "LOGICAL_LITERAL");

{CHAR_LITERAL}      store(yytext, "CHAR_LITERAL");

{OPERATOR}          store(yytext, "OPERATOR");

{DELIMITER}         store(yytext, "DELIMITER");

{COMMENT}           /* ignore comment */

{SPECIAL_CHAR}      store(yytext, "SPECIAL_CHAR");

{WHITESPACE}        /* ignore whitespace */

{err-string1}       std::cout << "Error on line " << yylineno << ": Ill-formed string: " << yytext << std::endl;

{err-string2}       std::cout << "Error on line " << yylineno << ": Ill-formed string: " << yytext << std::endl;

.                   std::cout << "Error on line " << yylineno << ": Illegal character: " << yytext << std::endl;

%%

void store(const std::string &lexeme, const std::string &token) {
    token == "CHAR_LITERAL" ? counts[lexeme]++ : counts[tolower(lexeme)]++;
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
        int count = token.second == "CHAR_LITERAL" ? counts[token.first] : counts[tolower(token.first)];
        std::cout << std::left << std::setw(20) << token.second << std::setw(10) << count << token.first << std::endl;
    }
    
    return 0;
}
