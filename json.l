%{
    #include<stdio.h>
    //#include "json.tab.h"
    char *strclone(char *str);
    int nb_token = 0;
    #define DEBUG 1
    #define STRING "str"
    #define NUMBER "number"
    #define TRUE "true"
    #define FALSE "false"
    #define null "null"
    #define O_BEGIN "o_begin"
    #define O_END "o_end"
    #define A_BEGIN "a_begin"
    #define A_END "a_end"
    #define COMMA "comma"
    #define COLON "colon"
%}
DIGIT1to9 [1-9]
DIGIT [0-9]
DIGITS {DIGIT}+
INT {DIGIT}|{DIGIT1to9}{DIGITS}|-{DIGIT}|-{DIGIT1to9}{DIGITS}
FRAC [.]{DIGITS}
EXP {E}{DIGITS}
E [eE][+-]?
HEX_DIGIT [0-9a-f]
NUMBER {INT}|{INT}{FRAC}|{INT}{EXP}|{INT}{FRAC}{EXP}
UNESCAPEDCHAR [ -!#-\[\]-~]
ESCAPEDCHAR \\["\\bfnrt/]
UNICODECHAR \\u{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}
CHAR {UNESCAPEDCHAR}|{ESCAPEDCHAR}|{UNICODECHAR}
CHARS {CHAR}+
DBL_QUOTE ["]

%%
{DBL_QUOTE}{DBL_QUOTE} |
{DBL_QUOTE}{CHARS}{DBL_QUOTE} {
    //yylval=strclone(yytext);
    printf("attr or value");
    nb_token++;
    return STRING;
};
{NUMBER} {
    //yylval=strclone(yytext);
    nb_token++;
    return NUMBER;
}
true {
    return TRUE;
};
false {
    return FALSE;
};
null {
    return null;
};
\{ {
    printf("new object\n");
    nb_token++;
    return O_BEGIN;
};

\} {
    nb_token++;
    printf("\nNumber of token %d\n", nb_token);
    return O_END;
};

\[ {
    nb_token++;
    return A_BEGIN;
};

\] {
    nb_token++;
    return A_END;
};

, {
    nb_token++;
    return COMMA;
};
: {
    nb_token++;
    return COLON;
};

[ \t\n]+ /* ignore whitespace */;

. {
    printf("Unexpected: %c\nExiting...\n",*yytext);
    exit(0);
}
%%

char *strclone(char *str)
{
    int len = strlen(str);
    char *clone = (char *)malloc(sizeof(char)*(len+1));
    strcpy(clone,str);
    return clone;
}
int yywrap(void)
{
  return 1;
}
int main(void)
{
  yylex();
  return 0;
}
