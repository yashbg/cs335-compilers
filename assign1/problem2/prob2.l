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

KEYWORD         (?i:allocatable)|(?i:allocate)|(?i:assign)|(?i:associate)|(?i:asynchronous)|(?i:backspace)|(?i:bind)|(?i:call)|(?i:case)|(?i:class)|(?i:close)|(?i:common)|(?i:contains)|(?i:continue)|(?i:cycle)|(?i:codimension)|(?i:contiguous)|(?i:critical)|(?i:data)|(?i:deallocate)|(?i:deferred)|(?i:dimension)|(?i:do)|(?i:else)|(?i:elsewhere)|(?i:end)|(?i:endfile)|(?i:endif)|(?i:entry)|(?i:equivalence)|(?i:exit)|(?i:external)|(?i:enum)|(?i:enumerator)|(?i:extends)|(?i:forall)|(?i:final)|(?i:flush)|(?i:format)|(?i:function)|(?i:goto)|(?i:generic)|(?i:import)|(?i:if)|(?i:implicit)|(?i:inquire)|(?i:intrinsic)|(?i:include)|(?i:interface)|(?i:intent)|(?i:lock)|(?i:module)|(?i:nopass)|(?i:namelist)|(?i:nullify)|(?i:open)|(?i:only)|(?i:operator)|(?i:optional)|(?i:parameter)|(?i:pause)|(?i:print)|(?i:program)|(?i:pointer)|(?i:private)|(?i:pass)|(?i:protected)|(?i:procedure)|(?i:public)|(?i:read)|(?i:return)|(?i:recursive)|(?i:result)|(?i:rewind)|(?i:rewrite)|(?i:save)|(?i:stop)|(?i:subroutine)|(?i:select)|(?i:sequence)|(?i:submodule)|(?i:target)|(?i:then)|(?i:use)|(?i:value)|(?i:unlock)|(?i:volatile)|(?i:while)|(?i:write)
NAME            [a-zA-Z][a-zA-Z0-9_]{0,62}
INT_LITERAL
REAL_LITERAL
LOGICAL_LITERAL
CHAR_LITERAL    \"[^'"]*\"
OPERATOR
DELIMITER       [()[\]]|"(/"|"/)"
COMMENT         !.*\n
SPECIAL_CHAR    
WHITESPACE      [ \t\f\n]+

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

.                   std::cout << "Line " << yylineno << ": Unrecognized character: " << yytext << std::endl;

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
