%{
#include "y.tab.h"
void yyerror (char *s);
int yylex();
%}
%%
[eE][xX][iI][tT]				   {return exit_command;}
     
[0-9]+                 {yylval.num = atoi(yytext); return number;}
[ \t\n]                ;
[+] 							return OP_PLUS;
[-] 							return OP_MINUS;
[/] 							return OP_DIV;
[*][*]						return OP_DBLMULT;
[*] 							return OP_MULT;
[(] 							return OP_OP;
[)] 							return OP_CP;
[sS][eE][tT]                    return KW_SET;
[dD][iI][sS][pP]				return KW_DISP;


[tT][rR][uU][eE]				return KW_TRUE;
[fF][aA][lL][sS][eE]			return KW_FALSE;

[aA][nN][dD][ ]					return KW_AND;
[oO][rR][ ]						return KW_OR;
[nN][oO][tT][ ]					return KW_NOT;
[eE][qQ][uU][aA][lL][ ] 		return KW_EQUAL;
[lL][eE][sS][sS][ ]				return KW_LESS;
[iI][fF]						return KW_IF;

[lL][iI][sS][tT]				return KW_LIST;
[aA][pP][pP][eE][nN][dD]		return KW_APPEND;
[cC][oO][nN][cC][aA][tT]		return KW_CONCAT;

[a-zA-Z][a-zA-Z0-9]*            {
                                    /*
                                    Identifier: Any combination of alphabetical characters and digits with noleading digit.
                                    */
                                    yylval.id = (char*) malloc(sizeof(char)*(strlen(yytext)+1));
                                    strcpy(yylval.id, yytext);
                                    
                                    return( identifier );
                                }  
.                      {ECHO; yyerror ("unexpected character");}


%%
int yywrap (void) {return 1;}

//[-+=;]           	   {return yytext[0];}
