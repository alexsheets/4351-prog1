package Parse;
import ErrorMsg.ErrorMsg;

%% 

%implements Lexer
%function nextToken
%type java_cup.runtime.Symbol
%char

%{
private void newline() {
  errorMsg.newline(yychar);
}

private void err(int pos, String s) {
  errorMsg.error(pos,s);
}

private void err(String s) {
  err(yychar,s);
}

private java_cup.runtime.Symbol tok(int kind) {
    return tok(kind, null);
}

private java_cup.runtime.Symbol tok(int kind, Object value) {
    return new java_cup.runtime.Symbol(kind, yychar, yychar+yylength(), value);
}

private ErrorMsg errorMsg;

Yylex(java.io.InputStream s, ErrorMsg e) {
  this(s);
  errorMsg=e;
}

// we can add our own necessary values here
// such as a way to count comments, etc.
private String string;
private char c;
private int nestCount = 0;
private java_cup.runtime.Symbol tempTok;

%}

%eofval{
	{
	 return tok(sym.EOF, null);
        }
%eofval}       

%state STRING 
%state IGNORE
%state COMMENT

%%

<YYINITIAL> " "	{}
<YYINITIAL> \n	{newline();}

<YYINITIAL> "while" {return tok(sym.WHILE);}
<YYINITIAL> "for" {return tok(sym.FOR);}
<YYINITIAL> "to" {return tok(sym.TO);}
<YYINITIAL> "break" {return tok(sym.BREAK);}
<YYINITIAL> "let" {return tok(sym.LET);}
<YYINITIAL> "in" {return tok(sym.IN);}
<YYINITIAL> "end" {return tok(sym.END);}
<YYINITIAL> "function" {return tok(sym.FUNCTION);}
<YYINITIAL> "var" {return tok(sym.VAR);}
<YYINITIAL> "type" {return tok(sym.TYPE);}
<YYINITIAL> "array" {return tok(sym.ARRAY);}
<YYINITIAL> "if" {return tok(sym.IF);}
<YYINITIAL> "then" {return tok(sym.THEN);}
<YYINITIAL> "else" {return tok(sym.ELSE);}
<YYINITIAL> "do" {return tok(sym.DO);}
<YYINITIAL> "of" {return tok(sym.OF);}
<YYINITIAL> "nil" {return tok(sym.NIL);}

<YYINITIAL> ","	{return tok(sym.COMMA, null);}
<YYINITIAL> ":"	{return tok(sym.COLON, null);}
<YYINITIAL> ";"	{return tok(sym.SEMICOLON, null);}
<YYINITIAL> "("	{return tok(sym.LPAREN, null);}
<YYINITIAL> ")"	{return tok(sym.RPAREN, null);}
<YYINITIAL> "["	{return tok(sym.LBRACK, null);}
<YYINITIAL> "]"	{return tok(sym.RBRACK, null);}
<YYINITIAL> "{"	{return tok(sym.LBRACE, null);}
<YYINITIAL> "}"	{return tok(sym.RBRACE, null);}
<YYINITIAL> "."	{return tok(sym.DOT, null);}
<YYINITIAL> "+"	{return tok(sym.PLUS, null);}
<YYINITIAL> "-"	{return tok(sym.MINUS, null);}
<YYINITIAL> "*"	{return tok(sym.TIMES, null);}
<YYINITIAL> "/"	{return tok(sym.DIVIDE, null);}
<YYINITIAL> "="	{return tok(sym.EQ, null);}
<YYINITIAL> "<>" {return tok(sym.NEQ, null);}
<YYINITIAL> ">" {return tok(sym.GT, null);}
<YYINITIAL> "<" {return tok(sym.LT, null);}
<YYINITIAL> ">=" {return tok(sym.GE, null);}
<YYINITIAL> "<=" {return tok(sym.LE, null);}
<YYINITIAL> "&" {return tok(sym.AND, null);}
<YYINITIAL> "|" {return tok(sym.OR, null);}
<YYINITIAL> ":=" {return tok(sym.ASSIGN, null);}

<YYINITIAL> [a-zA-Z][a-zA-Z0-9_]* { return tok(sym.ID, yytext()); }
<YYINITIAL> [0-9]+ { return tok(sym.INT, new Integer(yytext())); }

<YYINITIAL> \" {yybegin(STRING); string = ""; tempTok = tok(sym.STRING, null);}
<YYINITIAL> "/*" {yybegin(COMMENT); nestCount++;}


<COMMENT> "/*" {nestCount++; yybegin(COMMENT);}
<COMMENT> "*/" {nestCount--; if (nestCount == 0) {yybegin(YYINITIAL);}}
<COMMENT> . {}

<STRING> "\^"[@-_] {c = (char)(yytext().charAt(2) - '@'); string = string + c;}
<STRING> "\^"[a-z] {c = (char)(yytext().charAt(2) - '`'); string = string + c;}
<STRING> "\^?" {c = (char)(yytext().charAt(2) + '@'); string = string + c;}
<STRING> "\n" {newline(); string = string + "\n";}
<STRING> "\t" {newline(); string = string + "\t";}
<STRING> \\[0-9][0-9][0-9] {
  // c = (char)(Integer.parseInt(yytext().substring(1,3))); 
  // string = string + c;

  StringBuffer numStr = new StringBuffer(yytext());
  int num;
  char ch;

  numStr = numStr.substring(1, numStr.length());
  num = Integer.parseInt(string);
  ch = (char) num;
  string = string + ch;
}
<STRING> \\\" {string = string + (char)34;}
<STRING> \\\\ {string = string + "\\";}
<STRING> \" {yybegin(YYINITIAL); tempTok.value = string; return tempTok;}
<STRING> . {string = string + yytext();}


. { err("Illegal character: " + yytext()); }
