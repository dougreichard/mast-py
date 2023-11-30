lexer grammar MastLex;
//import MastKeywords;

//https://github.com/wevre/wry/blob/master/grammars/DentLexer.g4
@lexer::members {

INDENT_TOKEN = INDENT
DEDENT_TOKEN = DEDENT

# Initializing `pendingDent` to true means any whitespace at the beginning
# of the file will trigger an INDENT, which will probably be a syntax error,
# as it is in Python.
pendingDent = True

indentCount = 0

#private java.util.LinkedList<Token> tokenQueue = new java.util.LinkedList<>();
tokenQueue = []

#private java.util.Stack<Integer> indentStack = new java.util.Stack<>();
indentStack = []

initialIndentToken = None

#private int getSavedIndent() { return indentStack.isEmpty() ? 0 : indentStack.peek(); }
def getSaveIndent():
        return 0 if len(MastLexer.indentStack)==0 else MastLexer.indentStack[-1]

#private CommonToken createToken(int type, String text, Token next) {
#        CommonToken token = new CommonToken(type, text);
#        if (null != initialIndentToken) {
#                token.setStartIndex(initialIndentToken.getStartIndex());
#                token.setLine(initialIndentToken.getLine());
#                token.setCharPositionInLine(initialIndentToken.getCharPositionInLine());
#                token.setStopIndex(next.getStartIndex()-1);
#        }
#        return token;
#}
def createToken(type, text, next):
        pass

def nextToken(self):
        return super().nextToken()


#@Override
#public Token nextToken() {
#
#        // Return tokens from the queue if it is not empty.
#        if (!tokenQueue.isEmpty()) { return tokenQueue.poll(); }
#
#        // Grab the next token and if nothing special is needed, simply return it.
#        // Initialize `initialIndentToken` if needed.
#        Token next = super.nextToken();
#        //NOTE: This could be an appropriate spot to count whitespace or deal with
#        //NEWLINES, but it is already handled with custom actions down in the
#        //lexer rules.
#        if (pendingDent && null == initialIndentToken && NEWLINE != next.getType()) { initialIndentToken = next; }
#        if (null == next || HIDDEN == next.getChannel() || NEWLINE == next.getType()) { return next; }
#       // Handle EOF. In particular, handle an abrupt EOF that comes without an
#        // immediately preceding NEWLINE.
#        if (next.getType() == EOF) {
#                indentCount = 0;
#                // EOF outside of `pendingDent` state means input did not have a final
#                // NEWLINE before end of file.
#                if (!pendingDent) {
#                        initialIndentToken = next;
#                        tokenQueue.offer(createToken(NEWLINE, "NEWLINE", next));
#                }
#        }
#
###        // Before exiting `pendingDent` state queue up proper INDENTS and DEDENTS.
#        while (indentCount != getSavedIndent()) {
#                if (indentCount > getSavedIndent()) {
#                        indentStack.push(indentCount);
#                        tokenQueue.offer(createToken(INDENT, "INDENT" + indentCount, next));
#                } else {
#                        indentStack.pop();
#                        tokenQueue.offer(createToken(DEDENT, "DEDENT"+getSavedIndent(), next));
#                }
#        }
#        pendingDent = false;
#        tokenQueue.offer(next);
#        return tokenQueue.poll();
#}
#
}




SCAN    : 'scan';
RESULTS  : 'results';
TAB     : 'tab';
TIMEOUT : 'timeout' ;
FAIL    : 'fail' ;
SUCCESS : 'success' ;
YIELD   : 'yield' ;
COMMS : 'comms';
SCIENCE : 'science';
CHANGE : 'change';
FOCUS  : 'focus' ;

DATA            : 'data' ;
//SHIP            : 'ship' ;
GUI             : 'gui' ;
//SET             : 'set' ;
CHOICE          : 'choice' ;
STYLE           : 'style' ;
COLOR           : 'color' ;
//CLEAR           : 'clear' ;
ON              : 'on' ;
END_ON          : 'end_on' ;
DISCONNECT      : 'disconnect' ;
NAME_KW         : 'name' ;
NEXT            : 'next' ;
MESSAGE         : 'message' ;




fragment COMMENT
 : '#' ~[\r\n\f]*
 ;

// fragment SPACES : [ \t];                 // line whitespace




STRING
 : STRING_LITERAL
 //| BYTES_LITERAL
 ;
STRING_LITERAL : ( [rR] | [uU] | [fF] | ( [fF] [rR] ) | ( [rR] [fF] ) )? ( SHORT_STRING | LONG_STRING ) ;
LONG_STRING_LITERAL :  ( GUI_TEXT_STRING ) ;

/// stringescapeseq ::=  "\" <any source character>
fragment STRING_ESCAPE_SEQ
 : '\\' .
 | '\\' NEWLINE
 ;

fragment SHORT_STRING
 : '\'' ~[\\\r\n\f']* '\''
 | '"'  ~[\\\r\n\f"]* '"'
 ;


// fragment SHORT_STRING
//         : '\'' (~[\\\r\n\f'] )* '\''
//         | '"' ( ~[\\\r\n\f"] )* '"'
//         ;

// Long String can have new lines
fragment LONG_STRING
        : '\'\'\'' .*? '\'\'\''
        | '"""' .*? '"""'
        ;

fragment GUI_TEXT_STRING
        : '\'\'\'' '\''+ .*? '\'\'\'' '\''+
        | '"""' '"'+ .*? '"""' '"'+
        ;

GUI_APPEND_TEXT_STRING
        : '^^^' '^'* .*? '^^^' '^'*
        ;

                
fragment ID_START       : '_' 
                        | [a-zA-Z] 
                        ;
fragment ID_CONTINUE    : ID_START
                        | [a-zA-Z0-9]
                        ;        // match usual identifier spec
// snake markers are now obsolete, ignore them!
fragment INLINE_CODE_MARKER
        : '~' '~'+ 
        ;

// Things to ignore
SKIP_              : (COMMENT | INLINE_CODE_MARKER | NEWLINE) -> skip;                 
//
///
///
LABEL_MARKER    : '==' '='+
                | '??' '?'+;
// NEWLINE        : ( '\r'? '\n' | '\r' | '\f' );
// handle characters which failed to match any other token
//ERROR : . ;
fragment MATH_OPER       
                : '+'
                | '-'
                | '*'
                | '/'
                | '%'
                | '**'
                | '//'
                ;

fragment LOGIC_OPER       
                : '>'
                | '<'
                | '=='
                | '!='
                | '<='
                | '>='
                | 'and'
                | 'or'
                | 'not'
                | 'is' 'not'
                | 'is'
                | 'in' 'not'
                | 'in'
                ;

fragment BITWISE_OPER       
                : '&'
                | '|'
                | '^'
                | '~'
                | '<<'
                | '>>'
                ;


OPER            : MATH_OPER
                | LOGIC_OPER
                | BITWISE_OPER
                ;

//// I don't know how else to allow these as names
//// as well as arguments for commands
// This means story and sbs elements need to be known 
// Which I don't like




NAME            : ID_START ID_CONTINUE*
                ;

fragment NON_ZERO_DIGIT
                : [1-9]
                ;

/// digit          ::=  "0"..."9"
fragment DIGIT
                : [0-9]
                ;

/// octdigit       ::=  "0"..."7"
fragment OCT_DIGIT
                : [0-7]
                ;

/// hexdigit       ::=  digit | "a"..."f" | "A"..."F"
fragment HEX_DIGIT
                : [0-9a-fA-F]
                ;

/// bindigit       ::=  "0" | "1"
fragment BIN_DIGIT
                : [01]
                ;

/// pointfloat    ::=  [intpart] fraction | intpart "."
fragment POINT_FLOAT
 : INT_PART? FRACTION
 | INT_PART '.'
 ;

/// exponentfloat ::=  (intpart | pointfloat) exponent
fragment EXPONENT_FLOAT
 : ( INT_PART | POINT_FLOAT ) EXPONENT
 ;

/// intpart       ::=  digit+
fragment INT_PART
 : DIGIT+
 ;

/// fraction      ::=  "." digit+
fragment FRACTION
 : '.' DIGIT+
 ;

/// exponent      ::=  ("e" | "E") ["+" | "-"] digit+
fragment EXPONENT
 : [eE] [+-]? DIGIT+
 ;



NUMBER
 : INTEGER
 | FLOAT_NUMBER
 //| IMAG_NUMBER
 ;

INTEGER
 : DECIMAL_INTEGER
 | OCT_INTEGER
 | HEX_INTEGER
 | BIN_INTEGER
 ;

DECIMAL_INTEGER
 : NON_ZERO_DIGIT DIGIT*
 | '0'+
 ;

OCT_INTEGER
 : '0' [oO] OCT_DIGIT+
 ;

HEX_INTEGER
 : '0' [xX] HEX_DIGIT+
 ;

BIN_INTEGER
 : '0' [bB] BIN_DIGIT+
 ;

FLOAT_NUMBER
 : POINT_FLOAT
 | EXPONENT_FLOAT
 ;

IMAG_NUMBER
 : ( FLOAT_NUMBER | INT_PART ) [jJ]
 ;

SECONDS_TIME_NUMBER
 :  INT_PART  [s]
 ;
MINUTES_TIME_NUMBER
:  INT_PART  [m]
 ;





NEWLINE : ( '\r'? '\n' | '\r' ) {
if self.pendingDent: 
        self.skip()
self.pendingDent = True
self.indentCount = 0
self.initialIndentToken = None
};


WS : [ \t]+ {
self.skip()
if self.pendingDent: 
        self.indentCount += len(self.text)
} ;

INDENT : 'INDENT' {self.skip() };
DEDENT : 'DEDENT' {self.skip() };