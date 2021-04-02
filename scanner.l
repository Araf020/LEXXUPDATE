%option noyywrap

%{
#include<stdio.h>
#include<stdlib.h>

int line_count=1;

FILE *logout;
FILE *tokenout;

%}



IDENTIFIER [a-zA-Z][a-zA-Z0-9]*
LITERALS [\"](.*)[\"] 
LITERALS1 ^[^"]*?('[^"]+?')[^"]*

CONST_INT [0-9]+
CONST_FLOAT [0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?


MULOP [*/%]
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

SKIP [/][/]|[/][\*]
SKIP1 ([/])+[*/]+(.*)([\*][/])?

SKIP2 ([/][\*]([^*]|[\r\n]|(\*([^/]|[\r\n])))*[\*][/\\])|[/][/]+(.*)[\r\n]

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
NEWLINE \n

%%




{NEWLINE} {line_count++;}

[ \t\v]+ {}
(switch) {printf(" <%s> found\n",yytext);
		  //outputfile<<"<SWITCH> ";	
			fprintf(tokenout,"<SWITCH>");
			fprintf(logout,"Line no %d: TOKEN <SWITCH> Lexeme %s found\n",line_count,yytext);
		  }
(default) {printf(" <%s> found\n",yytext);  
			//outputfile<<"<DEFAULT> ";
			fprintf(tokenout,"<DEFAULT>");
			fprintf(logout,"Line no %d: TOKEN <DEFAULT> Lexeme %s found\n",line_count,yytext);
		
        }
(if) {printf(" <%s> found\n",yytext);
		//outputfile<<"<IF> ";
			fprintf(tokenout,"<IF>");
			fprintf(logout,"Line no %d: TOKEN <IF> Lexeme %s found\n",line_count,yytext);
		}
(else) {printf(" <%s> found\n",yytext);
			//	outputfile<<"<ELSE> ";
		    fprintf(tokenout,"<ELSE>");
			fprintf(logout,"Line no %d: TOKEN <ELSE> Lexeme %s found\n",line_count,yytext);
			}
(for) {printf(" <%s> found\n",yytext);
				//outputfile<<"<FOR> ";
		    fprintf(tokenout,"<FOR>");
			fprintf(logout,"Line no %d: TOKEN <FOR> Lexeme %s found\n",line_count,yytext);
				}
(do) {printf(" <%s> found\n",yytext);
			//outputfile<<"<DO> ";
			fprintf(tokenout,"<DO>");
			fprintf(logout,"Line no %d: TOKEN <DO> Lexeme %s found\n",line_count,yytext);
			}
(float) {printf(" <%s> found\n",yytext);
				//	outputfile<<"<FLOAT> ";
			fprintf(tokenout,"<FLOAT>");
			fprintf(logout,"Line no %d: TOKEN <FLOAT> Lexeme %s found\n",line_count,yytext);
					
					}
(void) {printf(" <%s> found\n",yytext);
				// outputfile<<"<VOID> ";
			fprintf(tokenout,"<VOID>");
			fprintf(logout,"Line no %d: TOKEN <VOID> Lexeme %s found\n",line_count,yytext);
				}
(int) {printf(" <%s> found\n",yytext);
		//outputfile<<"<INT> ";	
			fprintf(tokenout,"<INT>");
			fprintf(logout,"Line no %d: TOKEN <INT> Lexeme %s found\n",line_count,yytext);
		
			}
(char) {printf(" <%s> found\n",yytext);
			//outputfile<<"<CHAR> ";
			fprintf(tokenout,"<CHAR>");
			fprintf(logout,"Line no %d: TOKEN <CHAR> Lexeme %s found\n",line_count,yytext);
			}
(while) {   printf("<%s> found\n",yytext);
			//outputfile<<"<WHILE> ";
			fprintf(tokenout,"<WHILE>");
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
				fprintf(tokenout,"<DOUBLE>");
			fprintf(logout,"Line no %d: TOKEN <DOUBLE> Lexeme %s found\n",line_count,yytext);
	//outputfile<<"<DOUBLE> ";
}

(return) {

	printf("<%s> found\n",yytext);
	//outputfile<<"<RETURN> ";
				fprintf(tokenout,"<RETURN>");
			fprintf(logout,"Line no %d: TOKEN <RETURN> Lexeme %s found\n",line_count,yytext);
}
(case) {

	printf("<%s> found\n",yytext);
	//outputfile<<"<CASE> ";
				fprintf(tokenout,"<CASE>");
			fprintf(logout,"Line no %d: TOKEN <CASE> Lexeme %s found\n",line_count,yytext);
}
(continue) {

	printf("<%s> found\n",yytext);
				fprintf(tokenout,"<CONTINUE>");
			fprintf(logout,"Line no %d: TOKEN <CONTINUE> Lexeme %s found\n",line_count,yytext);
	//outputfile<<"<CONTINUE> ";
}



{COMMA} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<COMMA, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <COMMA> Lexeme %s found\n",line_count,yytext);
	//	outputfile<<"<COMMA, "<<yytext;
		}
{LTHIRD} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<LTHIRD, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LTHIRD> Lexeme %s found\n",line_count,yytext);
	//	outputfile<<"<LTHIRD, "<<yytext;
	}
{RTHIRD} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<RTHIRD, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RTHIRD> Lexeme %s found\n",line_count,yytext);		
		//outputfile<<"<RTHIRD, "<<yytext;
	}


{SEMICOLON} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<SEMICOLON, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <SEMICOLON> Lexeme %s found\n",line_count,yytext);
		
		//outputfile<<"<SEMICOLON, "<<yytext;
	}
{LCURL} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<LCURL, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LCURL> Lexeme %s found\n",line_count,yytext);
		
		//outputfile<<"<LCURL, "<<yytext;
	}
{RCURL} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<RCURL, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RCURL> Lexeme %s found\n",line_count,yytext);
		
		//outputfile<<"<LCURL, "<<yytext;
	}
{LPAREN} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<LPAREN, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LPAREN> Lexeme %s found\n",line_count,yytext);
		
		//outputfile<<"<LPAREN, "<<yytext;
	}
{RPAREN} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<RPAREN, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RPAREN> Lexeme %s found\n",line_count,yytext);
		//outputfile<<"<RPAREN, "<<yytext;
	}
{NOT} {printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<NOT, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <NOT> Lexeme %s found\n",line_count,yytext);
		
		//outputfile<<"<NOT, "<<yytext;
	}

{LOGICOP} {

		printf(" <%s> found\n",yytext);
			fprintf(tokenout,"<LOGICOP, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n",line_count,yytext);		
		///outputfile<<"<LOGICOP, "<<yytext;
	}


{LITERALS} {printf("LITERALS <%s> found\n",yytext);
			fprintf(tokenout,"<LITERALS, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LITERALS> Lexeme %s found\n",line_count,yytext);
			}

{IDENTIFIER} {printf("id <%s> found\n",yytext);
			fprintf(tokenout,"<ID, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <ID> Lexeme %s found\n",line_count,yytext);
		
		//outputfile<<"<ID, "<<yytext;
	}


{ASSIGNOP} {printf("ASSIGNOP <%s> found\n",yytext);
			fprintf(tokenout,"<ASSIGNOP, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <ASSIGNOP> Lexeme %s found\n",line_count,yytext);
		
		//outputfile<<"<ASSIGNOP, "<<yytext;
	}
{SKIP2} {printf("SKIP, NO ACTION\n%s\n",yytext);
		
		
	}
{CONST_INT} {printf("%s CONST_INT\n",yytext);
			fprintf(tokenout,"<CONST_INT, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <INT> Lexeme %s found\n",line_count,yytext);
			}
{CONST_FLOAT} {printf("%s CONST_FLOAT\n",yytext);
			fprintf(tokenout,"<CONST_FLOAT, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <CONST_FLOAT> Lexeme %s found\n",line_count,yytext);
			}

{MULOP} {printf("%s mulop\n",yytext);
			fprintf(tokenout,"<MULOP, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <MULOP> Lexeme %s found\n",line_count,yytext);
			}
{INCOP} {printf("%s incop\n",yytext);
			fprintf(tokenout,"<INCOP, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <INCOP> Lexeme %s found\n",line_count,yytext);
			}
{RELOP} {printf("%s RELOP\n",yytext);
			fprintf(tokenout,"<RELOP, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n",line_count,yytext);
			}
{LTHIRD} {printf("%s LTHIRD\n",yytext);
			fprintf(tokenout,"<LTHIRD, %s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LTHIRD> Lexeme %s found\n",line_count,yytext);
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