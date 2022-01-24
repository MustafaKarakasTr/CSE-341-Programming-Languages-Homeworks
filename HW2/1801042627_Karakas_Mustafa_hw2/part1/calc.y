%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>



//---------------
int counter = 0;
int sizeIdentifiers = 1;
void createUpdateVariable(char *str,int val);
int indexOf(char *str);

void freeArray(char ** identifiers,int counter);
void printArray(char ** identifiers,int counter);
void freeSpaces();

int identifierValue(char * str);
void resize();
char *  makeUpperCase(char * str);

char ** identifiers;
int * values;

// list
char ** listIdentifiers;
int ** listValues;
int * listSizes;
int sizeListIdentifiers = 1;
int listCounter = 0;
void createUpdateListVariable(char *str,int* list,int size);
int indexOfList(char *str);
void freeArrayList();
void resizeList();
void printListArray();
char* deletedElement = "#";
//int* identifierValue(char * str);

//void printArrayList(char ** identifiers,int counter);


//if statement
int shouldBeEvaluated();
int inIf = 0;
int flag = 1; // any operation which has side effect will check if this flag is true or not, it is used for if statements, if we are not in if statement (inIf == 0) then it has no effect 


//list
int listElementCounter = 0;
int * listElements = NULL;
const int MAX_LIST_ELEMENTS = 20;
void displayAllLists();
int itIsList = 0; // to print elements we check this value  
int *arrTaken;
int arrTakenSize;


void addElement(int * list,int element,int oldSize);
void printList(int *list,int size);

int * createdArray;
int createdArraySize;
int shouldListBePrinted = 1;
int * concatArrays[2];
int concatArraySizes[] = {0,0};
int concatArrayIndex=0;

%}

%union {int num; char* id;int* listPointer;}         /* Yacc definitions */
%start line
//%token print
%token exit_command
%token <num> number
%token <id> identifier

%token KW_AND KW_OR KW_NOT KW_EQUAL KW_LESS KW_IF
//%token   KW_DEFFUN KW_DEFVAR KW_FOR  KW_EXIT KW_LOAD KW_NIL  
//%token  KW_TRUE KW_FALSE 
%token OP_PLUS OP_MINUS OP_DIV  OP_MULT OP_DBLMULT OP_OP OP_CP KW_SET KW_DISP KW_TRUE KW_FALSE KW_LIST KW_CONCAT KW_APPEND
 
//%token OP_MULT OP_OC OP_CC OP_COMMA COMMENT IDENTIFIER VALUE

%type <num> line EXPI     if_statement EXPB_IF line_if singleLine   EXPIL
%type <listPointer> list numberList
%type <id> assignment 

%%


line    :   
			singleLine	{$$ = $1;}

		|   line assignment  					{;}
		|   line OP_OP KW_DISP EXPI OP_CP  		{
													if(shouldBeEvaluated()){
														if(itIsList == 0) // if it is list it is already printed
															printf("Result: %d\n", $4);
														else{
															//arrTaken and arrTakenSize holds information about taken list
															printf("Result: (");
															
															for(int i=0;i<arrTakenSize;i++){
																printf("%d ",arrTaken[i]);
															}
															printf(")\n");
															itIsList=0;
														}
														
													}
												}
		|   line OP_OP exit_command OP_CP	  	{
													if(shouldBeEvaluated()){
 														freeSpaces();
														exit(EXIT_SUCCESS);
													}
												}

		//boolean expressions

		| if_statement							{;}
		| line if_statement  					{;}
		| EXPI									{
													if(shouldBeEvaluated()){
														printf("%d\n", $1);
													}
												}
		| line EXPI									{
													if(shouldBeEvaluated()){
														printf("%d\n", $2);
													}
												}

		|list									{
												 if(shouldBeEvaluated()){
													if(createdArray == NULL){// 
													 
													printf("(");
														for(int i=0;i<listElementCounter;i++)
															printf("%d ", listElements[i]);
														printf(")\n");
													} 
												 }
												 if(createdArray == NULL)
												 	free(listElements);
												 createdArray = NULL;
												}
		
		| line list							    {
												 if(shouldBeEvaluated()){
													if(createdArray == NULL){// 
													 
													printf("(");
														for(int i=0;i<listElementCounter;i++)
															printf("%d ", listElements[i]);
														printf(")\n");
													}
												 }
												 if(createdArray == NULL)
												 	free(listElements);
												 createdArray = NULL;
												}
        ;

line_if	: 	singleLine 							{flag = !flag; $$ = $1;}
			| list								{
													
													if(shouldBeEvaluated()){
													printf("(");
														for(int i=0;i<listElementCounter;i++)
															printf("%d ", listElements[i]);
														printf(")\n");
													}
												 
												 
												 	flag = !flag;
												}
		;
singleLine:assignment  							{;}
		|   OP_OP KW_DISP EXPI OP_CP  			{
													if(shouldBeEvaluated()){
														if(itIsList == 0) // if it is list it is already printed
															printf("Result: %d\n", $3);
														
													}
												}
		|   OP_OP KW_DISP list OP_CP  			{
													if(shouldBeEvaluated()){
														printf("(");
														if(createdArray != NULL){
															for(int i=0;i<createdArraySize;i++){
																printf("%d,", createdArray[i]);
															}	
															/*temp = createdArray;
															size = createdArraySize;*/
															createdArray = NULL;
														} else{
														
															for(int i=0;i<listElementCounter;i++)
																printf("%d ", listElements[i]);
															free(listElements);
														}
														printf(")\n");
													}
													
													
												}
		|   OP_OP exit_command OP_CP			{
													 
													if(shouldBeEvaluated()){
														freeSpaces(); 
														exit(EXIT_SUCCESS);
													}
												}
		

		
		;
assignment : OP_OP KW_SET identifier  EXPI OP_CP  { //updateSymbolVal($3,$4); 
													if(shouldBeEvaluated()){
														
														int index = indexOfList($3);
														///printf("IDENTIFIER NAME EXPI: %s,Index: %d",$3,index);
														if(index != -1){
															strcpy(listIdentifiers[index], deletedElement);
															free(listValues[index]); // delete the list which has the same name with created variable
														}
														//printArray(identifiers,counter);
														createUpdateVariable($3,$4);
													}
												 }
			|OP_OP KW_SET identifier  list OP_CP  { //updateSymbolVal($3,$4); 
													if(shouldBeEvaluated()){
														//shouldListBePrinted = 0; // if append function is called do not print the createdList 2 times
														int index = indexOf($3);
														///printf("IDENTIFIER NAMELIST: %s,Index: %d",$3,index);

														if(index != -1){
															strcpy(identifiers[index], deletedElement); // variable which has the same name with created list is unreachable now.
														}
														//printf("LISTE SONU:\nListe Boyu: %d\n",listElementCounter );
														int * temp;
														int size = 0;
														if(createdArray != NULL){
															/*for(int i=0;i<createdArraySize;i++){
																///printf("%d,", createdArray[i]);
	
															}*/	
															temp = createdArray;
															size = createdArraySize;
															createdArray = NULL;
														}
														else{
															temp = (int *) malloc(sizeof(int)*listElementCounter);
															for(int i=0;i<listElementCounter;i++){
																///printf("%d,", listElements[i]);
																temp[i] = listElements[i];
															}
															free(listElements);
															size = listElementCounter;
														}
														createUpdateListVariable($3,temp,size ); // save 
														///displayAllLists();
													}

												 }

			;
if_statement:OP_OP KW_IF EXPB_IF line_if line_if OP_CP		{

														//printf("IF___1\n");
														if($3 == 1){
															
															$$ = $4;
														} else
															$$ = $5;
														
														inIf = 0;//end of if
													}
			|OP_OP KW_IF EXPB_IF line_if  OP_CP			{
														//printf("IF___2\n");
														if($3 == 1){
															$$ = $4;
														}
														inIf = 0;//end of if

													}

			;

EXPI    	: number                {$$ = $1;}
		| identifier			{
									//$$ = identifierValue(makeUpperCase($1));
									int index= indexOf($1);
									if(index != -1){ // it is number
										$$ = values[index];
										itIsList = 0;
									}else{
										
										index = indexOfList($1);
										if(index == -1){
											freeSpaces();
        									exit(1);
										} else { // it is list

											itIsList = 1;
											arrTaken = listValues[index];
											arrTakenSize = listSizes[index];
										}
									}		
								} 
       	| OP_OP OP_PLUS EXPI  EXPI OP_CP          {
 
			   											$$ = $3 + $4;
 
														   
														   }
       	| OP_OP OP_MINUS EXPI  EXPI OP_CP         {$$ = $3 - $4;}
		| OP_OP OP_MULT EXPI  EXPI  OP_CP        	{$$ = $3 * $4;}
       	| OP_OP OP_DIV EXPI  EXPI  OP_CP        	{$$ = $3 / $4;}
		| OP_OP OP_DBLMULT EXPI EXPI OP_CP	  	{
													if($4 == 0) // x^0 = 1
														$$ = 1;
													else {
														int temp = $3;
														for(int i=1;i<$4;i++)
															temp *=$3;
														$$ = temp;
													}
											   
											  	}
		| OP_OP KW_AND EXPI EXPI OP_CP 	{$$ = $3 & $4;}
		| OP_OP KW_OR EXPI EXPI OP_CP 	{$$ = $3 | $4;}
		| OP_OP KW_NOT EXPI OP_CP 		{$$ = !$3;}
		| OP_OP KW_EQUAL EXPI EXPI OP_CP {$$ = ($3 == $4);}
		| OP_OP KW_LESS EXPI EXPI OP_CP {$$ = ($3 < $4);}
		|KW_TRUE				{$$ = 1;}
		| KW_FALSE				{$$ = 0;}
       	;
EXPB_IF: EXPI 									{
													flag = $1; // do or do not do  first stamement flag
													inIf = 1;
													//printf("FLAG:%d",flag);
													$$=$1;
												}
		;
//list
EXPIL : EXPI {$$ =$1;}
	  ;
numberList: 	EXPIL { 
							if(shouldBeEvaluated()){
								listElementCounter = 0; 
								listElements = (int*) malloc(sizeof(int)*MAX_LIST_ELEMENTS); 
								listElements[listElementCounter++]=$1;
								$$ = listElements;
							}
						}
		  |		numberList EXPIL  { 
			  						 if(shouldBeEvaluated()){
			  						  listElements[listElementCounter++]=$2;
									   }
								  }
		  ;

list:	  OP_OP KW_LIST numberList OP_CP 		  {$$ = $3;}
	|	  OP_OP KW_APPEND identifier number OP_CP {
														if(shouldBeEvaluated()){
															int index=indexOfList($3);
															if(index != -1){
																int * list = listValues[index];
																int sizeOfList = listSizes[index];
																// adds the elements and puts the address of created list in : createdArray
																// puts the created array's size in : createdArraySize														
																addElement(list,$4,sizeOfList);
																if(shouldListBePrinted){
																	printList(createdArray,createdArraySize);
																	
																} else{
																	shouldListBePrinted = 1;
																}
																$$ = createdArray;

															} else{
																printf("%s is not a list\n",$3);
																freeSpaces();
																exit(1);
															}
															
														}
												  }
	|	  OP_OP KW_APPEND identifier identifier OP_CP {
														if(shouldBeEvaluated()){
															int index=indexOfList($3);
															if(index != -1){
																int * list = listValues[index];
																int sizeOfList = listSizes[index];
																// adds the elements and puts the address of created list in : createdArray
																// puts the created array's size in : createdArraySize														
																int index2 = indexOf($4);
																int val = values[index2];
																addElement(list,val,sizeOfList);
																if(shouldListBePrinted){
																	printList(createdArray,createdArraySize);
																	
																} else{
																	shouldListBePrinted = 1;
																}
																$$ = createdArray;

															} else{
																printf("%s is not a list\n",$3);
																freeSpaces();
																exit(1);
															}
															
														}
												  }
	| OP_OP KW_CONCAT concatList concatList OP_CP {
													 if(shouldBeEvaluated()){
														createdArraySize = concatArraySizes[0]+concatArraySizes[1];

														createdArray = (int*) malloc(sizeof(int)* (createdArraySize));
														for(int i=0;i<concatArraySizes[0];i++){
															createdArray[i] = concatArrays[0][i];
														}
														for(int i=concatArraySizes[0];i<createdArraySize;i++){
															createdArray[i] = concatArrays[1][i-concatArraySizes[0]];
														}

														$$ = createdArray;
													 }
												  } 

	;
/*
int * concatArrays[2];
int concatArraySizes[] = {0,0};
int concatArrayIndex=0;

*/
concatList: 	identifier{
							if(shouldBeEvaluated()){
								int index = indexOfList($1);
								if(index != -1){
									concatArrays	 [concatArrayIndex] = listValues[index];
									concatArraySizes [concatArrayIndex] = listSizes [index];
									
								} else{
									printf("Invalid identifier: %s",$1);
									freeSpaces();
									exit(1);
								}
							
							
								concatArrayIndex = (concatArrayIndex == 0) ? 1: 0;
							}
						  }
		  		/*|list	  {
					  		

				  		  }*/
%%                     /* C code */
int main (void) {
    identifiers= (char **) malloc(sizeof(char*) * sizeIdentifiers);
    values = (int *) malloc(sizeof(int) * sizeIdentifiers );
	// list holders
	listIdentifiers = (char **) malloc(sizeof(char*) * sizeListIdentifiers);
	listValues = (int **) malloc(sizeof(int*) * sizeListIdentifiers );
	listSizes = (int *) malloc(sizeof(int) * sizeListIdentifiers);

	int temp = yyparse ( );
	freeSpaces();
	return temp;
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 


//---------------------
int indexOf(char * str){
	makeUpperCase(str);
    for(int i=0;i<counter;i++)
        if(strcmp(identifiers[i],str) == 0)
            return i;
    return -1;

}
char *  makeUpperCase(char * str){
	for(int i=0; i<str[i] != '\0' ;i++){
		if(str[i]>='a' && str[i]<='z'){
			str[i] = str[i] - 'a' + 'A';
		}
	}
	return str;
}
void createUpdateVariable(char *str,int val){
	makeUpperCase(str);
    int index = indexOf(str);
    if(index != -1){
        values[index] = val;
        return;
    }

    if(counter == sizeIdentifiers){
        resize();
    }

    identifiers[counter] = (char *) malloc(sizeof(char) * (strlen(str)+1));
    strcpy(identifiers[counter],str);

    values[counter] = val;

    counter++;

}
void freeArray(char ** identifiers,int counter){
    for(int i=0;i<counter;i++)
        free(identifiers[i]);
}
void printArray(char ** identifiers,int counter){
    for(int i=0;i<counter;i++)
        printf("%s :%d \n",identifiers[i],values[i]);
}
void resize(){
    char ** temp = (char**) malloc(sizeof(char*) * (sizeIdentifiers * 2));
    int * tempValues = (int*) malloc(sizeof(int) * (sizeIdentifiers * 2));

    for(int i=0;i<sizeIdentifiers;i++){
        temp[i] = identifiers[i]; // copy addresses
        tempValues[i] = values[i]; // copy values
    }
    free(identifiers); // deallocate spaces for pointers
    free(values);
    identifiers = temp;
    values = tempValues;
    sizeIdentifiers *= 2;
    //printArray(identifiers,counter);

}

void freeSpaces(){

    freeArray(identifiers,counter);
    free(identifiers);
    free(values);
	freeArrayList();
	free(listIdentifiers);
	free(listValues);

	free(listSizes);
}
//if_statement
// if we are in if and flag is true return 1, if we are not in if return 1, if we are in if and flag is 0 return 0
int shouldBeEvaluated(){
	
	int ans= (!inIf || flag);
	return ans;
}

// list functions

void createUpdateListVariable(char *str,int* list,int size){	
	makeUpperCase(str);	
	int index = indexOfList(str);
	if(index != -1){
		free(listValues[index]); // free old values
		listValues[index] = list;
		listSizes[index] = size;
		return;
	}
	if(sizeListIdentifiers == listCounter){
		resizeList();
	}
	listIdentifiers[listCounter] = (char *) malloc(sizeof(char) * (strlen(str)+1));
	strcpy(listIdentifiers[listCounter],str);

	listValues[listCounter] = list;
	listSizes[listCounter] = size;
	listCounter++;
	
}
int indexOfList(char *str){
	makeUpperCase(str);
    for(int i=0;i<listCounter;i++)
        if(strcmp(listIdentifiers[i],str) == 0)
            return i;
    return -1;
}
void freeArrayList(){
	    for(int i=0;i<listCounter;i++){
			if(strcmp(listIdentifiers[i],deletedElement) != 0){ // if it is not labeled as deleted
				free(listValues[i]);
			}
        	free(listIdentifiers[i]);
			
		}
}
void resizeList(){
	char ** temp = (char**) malloc(sizeof(char*) * (sizeListIdentifiers * 2));
    int ** tempValues = (int**) malloc(sizeof(int*) * (sizeListIdentifiers * 2));
	int * tempSizes = (int *) malloc(sizeof(int)*(sizeListIdentifiers*2));

    for(int i=0;i<sizeListIdentifiers;i++){
        temp[i] = listIdentifiers[i]; // copy addresses
        tempValues[i] = listValues[i]; // copy addresses
		tempSizes[i] = listSizes[i];
    }
    free(listIdentifiers); // deallocate spaces for pointers
    free(listValues);
	free(listSizes);
    listIdentifiers = temp;
    listValues = tempValues;
	listSizes = tempSizes;
    sizeListIdentifiers *= 2;
}
void printListArray(){
	for(int i=0;i<listCounter;i++){
		printf("name: %s\n",listIdentifiers[i]);
		printf("elements: ");
		
		for(int j = 0;j<listSizes[i];j++){
			printf("%d ",listValues[i][j]);
		}
		printf("\n");

	}
}
void displayAllLists(){
	for(int i=0;i<listCounter;i++){
		printf("List %d:",(i+1));
		for(int j = 0;j<listSizes[i];j++){
			printf("%d,",listValues[i][j]);
		}
		printf("\n");
	}
}
// adds the elements and puts the address of created list in : createdArray
// puts the created array's size in : createdArraySize														
void addElement(int * list,int element,int oldSize){
	createdArray = (int *) malloc(sizeof(int)*(oldSize + 1));
	for(int i=0;i<oldSize;i++){
		createdArray[i] = list[i];
	}
	createdArray[oldSize] = element;
	createdArraySize = oldSize +1;
}
void printList(int *list,int size){
	printf("(");
	for(int i=0;i<size;i++){
		printf("%d ",list[i]);														
	}
	printf(")\n");


}