- in third section of Tiger.lex:
    - bulk of code will go here
    - code in form of a reg ex., followed by Java code in curly braces.
    - could add other regular expressions for other tokens we have
    - repeat the lines there for all special characters as well as all keyboards
    - gets more complicated with identifiers or other stuff, like comments, etc.
- YY-initial:
    - JLex recognizes each token in one piece.
    - for comments/strings, recognize them in multiple pieces; will need %STATE declarations
    - <YYINITIAL>

- to run the analyzer, I believe we need to do what make does; so run if that works, if not, type out the second command (java JLex.Main Tiger.lex)
- then use cat > test.tig, or name it whatever, write some stuff
- then use java Parse.Main test.tig

- need to work on:
    - escape sequences (ignore state I think)
    - comments?
    - strings