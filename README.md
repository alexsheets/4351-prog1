- Group Members
    - Cameron Martin
    - Alex Sheets

- in third section of Tiger.lex:
    - bulk of code here
    - code in form of a reg ex., followed by Java code in curly braces
    - could add other regular expressions for other tokens we have
    - gets more complicated with identifiers or other stuff, like comments, etc.
        - comments use counter to determine level during nesting
        - strings implemented using STRING state
        - ignore escape sequence implemented using IGNORE state
- YY-initial:
    - JLex recognizes each token in one piece.
    - for comments/strings, recognize them in multiple pieces; will need %STATE declarations
    - <YYINITIAL>

- Implemented
    - escape sequences
        - \n = end-of-line
        - \t = Tab
        - \^c = Control Characters
        - \ddd = Character with ASCII code ddd 0-255
        - \" = Double quote
        - \\ = Backslash character
        - \f___f\ = f___f is formatting characters, ignore
    - comments
    - strings
    - keywords
    - ints
    - IDs
