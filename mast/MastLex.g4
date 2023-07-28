lexer grammar MastLex;
//import MastKeywords;


FACE    : 'face' ;
COLOR   : 'color' ;
TITLE   : 'title' ;
FOG     : 'fog';
SCAN    : 'scan';
RESULT  : 'result';
TAB     : 'tab';
CREATE  : 'create';
PAUSE   : 'pause';
RESUME  : 'resume';
TIMEOUT : 'timeout' ;
FAIL    : 'fail' ;
SUCCESS : 'success' ;
YIELD   : 'yield' ;
CANCEL  : 'cancel' ;
SCHEDULE : 'schedule' ;
VAR      : 'var' ;

// sbs allowed keywords
DESTROY : 'destroy';
DAMAGE : 'damage';
INTERNAL : 'internal';
SPAWN : 'spawn';
OBJECT : 'object';
COMMS : 'comms';
SCIENCE : 'science';
WEAPONS : 'weapons';
SELECT : 'select';
GRID : 'grid';
CONSOLE : 'console';
CHANGE : 'change';
TRANSMIT : 'transmit' ;
RECEIVE : 'receive' ;
FOLLOW  : 'follow' ;
ROUTE   : 'route' ;
SIMULATION : 'simulation' ;
COMMS_INFO : 'comms_info' ;

// Story
STYLE           : 'style' ;
DATA            : 'data' ;
CLICKABLE       : 'clickable' ;
END_CLICKABLE   : 'end_clickable' ;
ROW             : 'row' ;
HOLE            : 'hole' ;
BLANK           : 'blank' ;
REFRESH         : 'refresh' ;
SECTION         : 'section' ;
SHIP            : 'ship' ;
GUI             : 'gui' ;
SET             : 'set' ;
CHOICE          : 'choice' ;
BUTTON          : 'button';
END_BUTTON      : 'end_button' ;
SLIDER          : 'slider' ;
INTSLIDER       : 'intslider' ;
SCROLLBAR       : 'scrollbar' ;
CHECKBOX        : 'checkbox' ;
RADIO           : 'radio'   ;
VRADIO          : 'vradio' ;
REROUTE         : 'reroute' ;
SERVER          : 'server' ;
CLIENTS         : 'clients' ;
CLIENT          : 'client' ;
INPUT           : 'input' ;
IMAGE           : 'image' ;
DROPDOWN        : 'dropdown' ;
END_DROPDOWN    : 'end_dropdown' ;
WIDGET_LIST     : 'widget_list' ;
WIDGET          : 'widget' ;
LAYOUT          : 'layout' ;
CLEAR           : 'clear' ;
ACTIVATE        : 'activate' ;
ON              : 'on' ;
END_ON          : 'end_on' ;
CONTROL         : 'control' ;
DISCONNECT      : 'disconnect' ;
NAME_KW         : 'name' ;




fragment COMMENT
 : '#' ~[\r\n\f]*
 ;

 fragment SPACES              
 : [ \t];                 // line whitespace



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
SKIP_              : (SPACES | COMMENT | INLINE_CODE_MARKER | NEWLINE) -> skip;                 
//
///
///
LABEL_MARKER    : '==' '='+
                | '??' '?'+;
NEWLINE        : ( '\r'? '\n' | '\r' | '\f' );
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



