%{
    #include<stdio.h>
    #include "gpp_lexer.h"

    int isItCloseQuate = 0;
    const char token[][11] = { "", "KW_AND", "KW_OR", "KW_NOT", "KW_EQUAL", "KW_LESS", "KW_NIL", "KW_LIST", "KW_APPEND", "KW_CONCAT", "KW_SET", "KW_DEFFUN", "KW_FOR",
    					 "KW_IF", "KW_EXIT", "KW_LOAD", "KW_DISP", "KW_TRUE", "KW_FALSE", "OP_PLUS", "OP_MINUS", "OP_DIV","OP_DIV2",  "OP_MULT", "OP_OP", "OP_CP",
    					 "OP_DBLMULT","OP_OC", "OP_CC", "OP_COMMA", "COMMENT",  "VALUE","IDENTIFIER"};

    int isItCommentLine = 0;
    
%}


%%
[aA][nN][dD]            printf("%s\n", token[KW_AND]);
[oO][rR]                printf("%s\n", token[KW_OR]);
[nN][oO][tT]            printf("%s\n", token[KW_NOT]);
[eE][qQ][uU][aA][lL]    printf("%s\n", token[KW_EQUAL]);
[lL][eE][sS][sS]        printf("%s\n", token[KW_LESS]);
[nN][iI][lL]            printf("%s\n", token[KW_NIL]);
[lL][iI][sS][tT]        printf("%s\n", token[KW_LIST]);
[aA][pP][pP][eE][nN][dD]		printf("%s\n", token[KW_APPEND]);
[cC][oO][nN][cC][aA][tT]		printf("%s\n", token[KW_CONCAT]);
[sS][eE][tT]					printf("%s\n", token[KW_SET]);
[dD][eE][fF][fF][uU][nN]		printf("%s\n", token[KW_DEFFUN]);
[fF][oO][rR]					printf("%s\n", token[KW_FOR]);
[iI][fF]						printf("%s\n", token[KW_IF]);
[eE][xX][iI][tT]				printf("%s\n", token[KW_EXIT]);
[lL][oO][aA][dD]				printf("%s\n", token[KW_LOAD]);
[dD][iI][sS][pP]				printf("%s\n", token[KW_DISP]);
[tT][rR][uU][eE]				printf("%s\n", token[KW_TRUE]);
[fF][aA][lL][sS][eE]			printf("%s\n", token[KW_FALSE]);

[+] 							printf("%s\n", token[OP_PLUS]);
[-] 							printf("%s\n", token[OP_MINUS]);
[/] 							printf("%s\n", token[OP_DIV]);
[?]                             printf("%s\n", token[OP_DIV2]);
[*] 							printf("%s\n", token[OP_MULT]);

[(] 							printf("%s\n", token[OP_OP]);
[)] 							printf("%s\n", token[OP_CP]);

[*][*] 							printf("%s\n", token[OP_DBLMULT]);

["] 							{
									int val = OP_OC + isItCloseQuate;
                                    isItCloseQuate = (isItCloseQuate == 0) ? 1 : 0;
                                    printf("%s\n", token[val]);
								}

[,]                             printf("%s\n", token[OP_COMMA]);
[;][;].*                        printf("%s\n", token[COMMENT]);
								
[a-zA-Z][a-zA-Z0-9]*            {
                                    /*
                                    Identifier: Any combination of alphabetical characters and digits with noleading digit.
                                    */
                                    printf("%s\n", token[IDENTIFIER]);
                                }       
(0)|([1-9][0-9]*)               printf("%s\n", token[VALUE]);
[0-9]+[a-zA-Z]+[0-9a-zA-Z]*     {
                                    //printf("Identifiers can not have digit as a leading character\n");
                                    printf("%s can not be tokenized\n",yytext);
                                    //return 1;
                                }
[ \t\n]           ;
.                 printf("%s can not be tokenized\n",yytext);
"\n\n"		  return 0;

%%

int yywrap(void){
    return 1;
}
