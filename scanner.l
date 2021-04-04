%option noyywrap

%x END_WITH_SQ
%x END_WITH_DQ
%x STRING_LIT
%x SLINECOMMENT
%x MULTILINECOMMENT
%x MSCOMMENT

%{
#include<stdio.h>
#include<stdlib.h>
#include<iostream>
#include "SymbolTable.cpp"

using namespace std;



int line_count=1;
SymbolTable sTable(7);
string c;
string String_literals1;
string String_literals2;

string const_character;


FILE *logout;
FILE *tokenout;

%}
NEWLINE \n
IDENTIFIER [a-zA-Z][a-zA-Z0-9]*

IDENTIFIER_ERROR [0-9]+[a-zA-Z]+[a-zA-Z0-9]*

DECIMAL_POINT_ERROR ([0-9]*[.][0-9]*[.]+[0-9]*)+

ILL_FORMAT_ERROR ([0-9]*\.?[0-9]+[.]?)*[eE][-+]?[0-9]+[.][0-9]*


SPECIALS ['][\\][a-z]+[']
TAB ['][\\][t][']

CONST_c ['][a-zA-Z][']
IF_DQ [\"]
IF_END_DQ ((.*)[\\]?(.*)[\r\n]*(.*))*[\"]
DQ_CHECK  [\r\n]*(.*)[\r\n]*
DQ_ESCAPE [\\][ \r\n\t]*
DQ_END [\"]

ANYTHING ([^\r\n]|{NEWLINE})
STRINGERROR \"([^"\\\r\n]|[\\]{ANYTHING})*

STRINGLITERALS {STRINGERROR}\"

LITERALS [\"]((.*)[\\]?(.*)[\r\n]*)*[\"]

LIT [\"](.*)[\\]+?[\r\n]*?[\\]+?[\"]




LITERALS1 ^[^"]*?('[^"]+?')[\r\n]*[^"]*

CONST_INT [0-9]+[ \t]?
CONST_FLOAT [0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?

MULOP [*/%]
ADDOP [+-]
INCOP [+][+]|[-][-]
RELOP [<]|[<][=]|[>]|[>][=]|[=][=]|[!][=]
ASSIGNOP [=]
LOGICOP [&][&]

NOT [!]
LPAREN [(]
RPAREN [)]

LCURL [{]
RCURL [}]

LTHIRD [\[]	
RTHIRD [\]]

COMMA [,]
SEMICOLON [;]

CHECKNOTFINISHED ['][a-zA-Z]['](.*)

SQ_CHECK (['](.*)['])
END_SQ [a-zA-Z][']
SQ_MULTI_CHAR ['][a-zA-Z](.+)[']



SKIP [/][/]+(.*)[\\][\r\n].*

SKIP1 ([/])+[*/]+(.*)([\*][/])?

SKIP2 ([/][\*]([^*]|[\r\n]|(\*([^/]|[\r\n])))*[\*][/\\])|[/][/]+(.*)[\\]?[\r\n][\w+]?[\r\n]?

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]


%%
{NEWLINE} {line_count++;}

["] {BEGIN STRING_LIT;}
<STRING_LIT>(.*)[\\] {}
<STRING_LIT>[\\][n] {} 



['] {
	
	string str(yytext);
	c = str;
	BEGIN END_WITH_SQ;

	}

['][\\]['] {printf("sq UNFINISHED Error at line %d: %s\n",line_count,yytext);}

<END_WITH_SQ>[a-zA-Z0-9]  {
						    string str(yytext);
						    const_character = str;
						    c = c + str;

						  }

<END_WITH_SQ>[\r\n]       {
							char output[c.length()+1];
							strcpy(output,c.c_str());
							printf("UNFINISHED ERROR at Line: %d: %s\n",line_count, output);
							line_count++;
							BEGIN INITIAL;

					      }


<END_WITH_SQ>['] {

			char output[const_character.length()+1];

			strcpy(output,const_character.c_str());
			printf("<CONST_C, %s> at Line: %d\n",output,line_count);
			fprintf(tokenout,"<CONST_CHAR, %s> ",output);
		   
			//fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count,const_character);
			BEGIN INITIAL;
		       
		        }

<END_WITH_SQ>[\\][t]['] {

	cout<<"CONST_CHAR: \t\n";

	BEGIN INITIAL;
}		        
<END_WITH_SQ>.          {
								printf("UNFINISHED ERROR at Line: %d\n",line_count);

								
								fprintf(logout,"Line no %d: TOKEN <Error> Lexeme %s found\n",line_count,yytext);
			
								BEGIN INITIAL;
						  
						  }





{SQ_MULTI_CHAR}    {
							printf("CONST_MULTI_CHAR ERROR at Line: %d: %s\n",line_count,yytext);
							//fprintf(tokenout,"<CONST_MULTI_CHAR, %s> ",yytext);
							fprintf(logout,"Line no %d: ERROR <CONST_MULTI_CHAR> Lexeme %s found\n",line_count,yytext);
			//sTable.push("COsMMA",yytext);
									BEGIN INITIAL;

							    }



<END_WITH_DQ>{IF_END_DQ} {
							printf("LITERALS FOUND: <%s> \n",yytext);
							fprintf(tokenout,"<STRING, %s> ",yytext);
							fprintf(logout,"Line no %d: TOKEN <STRING> Lexeme %s found\n",line_count,yytext);
			//sTable.push("COMMA",yytext);
							BEGIN INITIAL;
					     }

<END_WITH_DQ>. {printf("DQ NOT finished"); BEGIN INITIAL;}




[/][\*]+ {BEGIN MSCOMMENT;}
<MSCOMMENT>(.*)[\*][/] {}
<MSCOMMENT>. {printf("UNFINISHED COMMENT\n");}

[/][/]+ {BEGIN SLINECOMMENT;}
[\/][\*]+ {line_count++; BEGIN MULTILINECOMMENT; }

<SLINECOMMENT>[\\][\r\n](.*)[\r\n]  {line_count++;line_count++; BEGIN INITIAL;}
<SLINECOMMENT>(.*)[\r\n]            {line_count++; BEGIN INITIAL;}
<MULTILINECOMMENT>(.*) {}
<MULTILINECOMMENT>[\r\n] 		{line_count++;}
<MULTILINECOMMENT>[\*]+[/]   		{BEGIN INITIAL;}


	



[ \t\v]+ {}

{IDENTIFIER_ERROR} {printf("\n%s is an IDENTIFIER_ERROR\n",yytext);}
{DECIMAL_POINT_ERROR} {printf("\n%s DECIMALPOINTER_ERROR\n",yytext);}
{ILL_FORMAT_ERROR} {printf("\n%s is an ILL_FORMAT_ERROR\n",yytext);}


(switch) {printf(" <%s> found\n",yytext);
		  //outputfile<<"<SWITCH> ";	
			fprintf(tokenout,"<SWITCH> ");
			fprintf(logout,"Line no %d: TOKEN <SWITCH> Lexeme %s found\n",line_count,yytext);
			//sTable.push("SWITCH",yytext);
		  }
(default) {printf(" <%s> found\n",yytext);  
			//outputfile<<"<DEFAULT> ";
			fprintf(tokenout,"<DEFAULT> ");
			fprintf(logout,"Line no %d: TOKEN <DEFAULT> Lexeme %s found\n",line_count,yytext);
		
        }
(if) {printf(" <%s> found\n",yytext);
		//outputfile<<"<IF> "; 
			fprintf(tokenout,"<IF> ");
			fprintf(logout,"Line no %d: TOKEN <IF> Lexeme %s found\n",line_count,yytext);
		}
(else) {printf(" <%s> found\n",yytext);
			//	outputfile<<"<ELSE> ";
		    fprintf(tokenout,"<ELSE> ");
			fprintf(logout,"Line no %d: TOKEN <ELSE> Lexeme %s found\n",line_count,yytext);
			}
(for) {printf(" <%s> found\n",yytext);
				//outputfile<<"<FOR> ";
		    fprintf(tokenout,"<FOR>");
			fprintf(logout,"Line no %d: TOKEN <FOR> Lexeme %s found\n",line_count,yytext);
				}
(do) {printf(" <%s> found\n",yytext);
			//outputfile<<"<DO> ";
			fprintf(tokenout,"<DO> ");
			fprintf(logout,"Line no %d: TOKEN <DO> Lexeme %s found\n",line_count,yytext);
			}
(float) {printf(" <%s> found\n",yytext);
				//	outputfile<<"<FLOAT> ";
			fprintf(tokenout,"<FLOAT> ");
			fprintf(logout,"Line no %d: TOKEN <FLOAT> Lexeme %s found\n",line_count,yytext);
					
					}
(void) {printf(" <%s> found\n",yytext);
			SymbolTable sTable(7);
				// outputfile<<"<VOID> ";
			fprintf(tokenout,"<VOID> ");
			fprintf(logout,"Line no %d: TOKEN <VOID> Lexeme %s found\n",line_count,yytext);
				}
(int) {printf(" <%s> found\n",yytext);
		//outputfile<<"<INT> ";	
			fprintf(tokenout,"<INT>");
			fprintf(logout,"Line no %d: TOKEN <INT> Lexeme %s found\n",line_count,yytext);
		
			}
(char) {printf(" <%s> found\n",yytext);
			//outputfile<<"<CHAR> ";
			fprintf(tokenout,"<CHAR> ");
			fprintf(logout,"Line no %d: TOKEN <CHAR> Lexeme %s found\n",line_count,yytext);
			}
(while) {   printf("<%s> found\n",yytext);
			//outputfile<<"<WHILE> ";
			fprintf(tokenout,"<WHILE> ");
			fprintf(logout,"Line no %d: TOKEN <WHILE> Lexeme %s found\n",line_count,yytext);
	
		}
(break) {

			printf("<%s> found\n",yytext);
			fprintf(tokenout,"<BREAK>");
			fprintf(logout,"Line no %d: TOKEN <BREAK> Lexeme %s found\n",line_count,yytext);
	//outputfile<<"<BREAK> ";
}

(double) {

	printf("<%s> found\n",yytext);
				fprintf(tokenout,"<DOUBLE> ");
			fprintf(logout,"Line no %d: TOKEN <DOUBLE> Lexeme %s found\n",line_count,yytext);
	//outputfile<<"<DOUBLE> ";
}

(return) {

	printf("<%s> found\n",yytext);
	//outputfile<<"<RETURN> ";
				fprintf(tokenout,"<RETURN> ");
			fprintf(logout,"Line no %d: TOKEN <RETURN> Lexeme %s found\n",line_count,yytext);
}
(case) {

	printf("<%s> found\n",yytext);
	//outputfile<<"<CASE> ";
				fprintf(tokenout,"<CASE> ");
			fprintf(logout,"Line no %d: TOKEN <CASE> Lexeme %s found\n",line_count,yytext);
}
(continue) {

	printf("<%s> found\n",yytext);
				fprintf(tokenout,"<CONTINUE> ");
			fprintf(logout,"Line no %d: TOKEN <CONTINUE> Lexeme %s found\n",line_count,yytext);
	//outputfile<<"<CONTINUE> ";
}


{TAB} {printf("TAB <\t> found\n");
			fprintf(tokenout,"<CONST_CHAR, \t> ");
			fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme \t found\n",line_count);
			//sTable.push("COMMA",yytext);
	//	outputfile<<"<COMMA, "<<yytext;
		}
{SPECIALS} {printf("SPECIALS <%s> found\n",yytext);
			fprintf(tokenout,"<SPECIALS, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <SPECIALS> Lexeme %s found\n",line_count,yytext);
			//sTable.push("COMMA",yytext);
	//	outputfile<<"<COMMA, "<<yytext;
		}

{COMMA} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<COMMA, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <COMMA> Lexeme %s found\n",line_count,yytext);
			//sTable.push("COMMA",yytext);
	//	outputfile<<"<COMMA, "<<yytext;
		}
{LTHIRD} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<LTHIRD, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <LTHIRD> Lexeme %s found\n",line_count,yytext);
			//sTable.push("LTHIRD",yytext);
	//	outputfile<<"<LTHIRD, "<<yytext;
	}
{RTHIRD} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<RTHIRD, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <RTHIRD> Lexeme %s found\n",line_count,yytext);	
			//sTable.push("RTHIRD",yytext);	

		//outputfile<<"<RTHIRD, "<<yytext;
	}


{SEMICOLON} {printf(" <SEMICOLON, %s> found\n",yytext);
			fprintf(tokenout,"<SEMICOLON, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <SEMICOLON> Lexeme %s found\n",line_count,yytext);
			//sTable.push("SEMICOLON",yytext);
		
		//outputfile<<"<SEMICOLON, "<<yytext;
	}
{LCURL} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<LCURL, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <LCURL> Lexeme %s found\n",line_count,yytext);
		
		//outputfile<<"<LCURL, "<<yytext;
	}
{RCURL} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<RCURL, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <RCURL> Lexeme %s found\n",line_count,yytext);
		
		//outputfile<<"<LCURL, "<<yytext;
	}
{LPAREN} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<LPAREN, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <LPAREN> Lexeme %s found\n",line_count,yytext);
		
		//outputfile<<"<LPAREN, "<<yytext;
	}
{RPAREN} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<RPAREN, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <RPAREN> Lexeme %s found\n",line_count,yytext);
		//outputfile<<"<RPAREN, "<<yytext;
	}
{NOT} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<NOT, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <NOT> Lexeme %s found\n",line_count,yytext);
		
		//outputfile<<"<NOT, "<<yytext;
	}


{LOGICOP} {

		printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<LOGICOP, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n",line_count,yytext);		
		///outputfile<<"<LOGICOP, "<<yytext;
	}




{LITERALS} {

					printf("<STRING , %s>\n",yytext);
					string str(yytext);

					char output[str.length()];
					char output2[str.length()];

					strcpy(output,str.c_str());
					char qq;
					
					fprintf(tokenout,"<STRING, ");

					for(int i=0;i<str.length();i++){
						printf("%c",output[i]);
					}
					cout<<endl<<endl;

					
					for(int i=0;i<strlen(yytext);i++){
						if(output[i]=='\\' && output[i+1]=='t'){
							  output2[i]='\t';
							  qq = '\t';
							  printf("%c",qq);
							 
							  i++;
							  continue;

						}
						else if (output[i]=='\\' && output[i+1]=='n') {
							output2[i] = '\n';
							qq = '\n';
							  printf("%c",qq);
							i++;
							continue;
						}
						
						else if (output[i]=='\\' && output[i+1]=='b') {
							output2[i]='\b';
							qq = '\b';
							  printf("%c",qq);
							i++;
							continue;
						}
						else if(output[i]=='\n'){
							if(output[i-1]=='\\'){
								line_count++;
								
								continue;
							}

							output2[i]='\n';
							qq = '\n';
							  printf("%c",qq);
							line_count++;
							
							continue;
						}
						else if(output[i]=='\\'){
							
							

						}
						

						
						else {
							output2[i] = output[i];

							printf("%c",output[i]);
						}

					}
					cout<<endl;
					
				
				
					
					

				}


{CONST_INT} {printf("%s CONST_INT\n",yytext);
			fprintf(tokenout,"<CONST_INT, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <INT> Lexeme %s found\n",line_count,yytext);
			}

{CONST_FLOAT} {printf("%s CONST_FLOAT\n",yytext);
			fprintf(tokenout,"<CONST_FLOAT, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <CONST_FLOAT> Lexeme %s found\n",line_count,yytext);
			}

{ASSIGNOP} {printf("ASSIGNOP <%s> found\n",yytext);
			fprintf(tokenout,"<ASSIGNOP, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <ASSIGNOP> Lexeme %s found\n",line_count,yytext);
		
		//outputfile<<"<ASSIGNOP, "<<yytext;
	}


{IDENTIFIER} {printf("IDENTIFIER <%s> found\n",yytext);
			fprintf(tokenout,"<ID, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <ID> Lexeme %s found\n",line_count,yytext);
		
		//outputfile<<"<ID, "<<yytext;
	}






{MULOP} {printf("<%s, MULOP>\n",yytext);
			fprintf(tokenout,"<MULOP, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <MULOP> Lexeme %s found\n",line_count,yytext);
			}
{ADDOP} {printf("<%s, ADDOP>\n",yytext);
			fprintf(tokenout,"<ADDOP, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <ADDOP> Lexeme %s found\n",line_count,yytext);
			}

{INCOP} {printf("<%s incop>\n",yytext);
			fprintf(tokenout,"<INCOP, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <INCOP> Lexeme %s found\n",line_count,yytext);
			}
{RELOP} {printf("%s RELOP\n",yytext);
			fprintf(tokenout,"<RELOP, %s> ",yytext);
			fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n",line_count,yytext);
			}



<<EOF>> {printf("Total Line Number: %d \n",line_count); return 0;}
. {}

%%


int main(int argc,char *argv[]){

	
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	

	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL)
	{
		printf("Cannot open specified file\n");
		return 0;
	}
	
	logout= fopen("log.txt","w");
	tokenout= fopen("token.txt","w");

	yyin= fin;
	yylex();
	fclose(yyin);
	fclose(tokenout);
	fclose(logout);
	return 0;
}

