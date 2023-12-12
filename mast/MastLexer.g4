lexer grammar MastLexer;
//https://github.com/wevre/wry/blob/master/grammars/DentLexer.g4


//https://github.com/yshavit/antlr-denter/tree/main
tokens { INDENT, DEDENT }

@lexer::header{
from .denterhelper import DenterHelper
from .MastParser import MastParser
}
@lexer::members {
class MastDenter(DenterHelper):
    def __init__(self, lexer, nl_token, indent_token, dedent_token, ignore_eof):
        super().__init__(nl_token, indent_token, dedent_token, ignore_eof)
        self.lexer: MastLexer = lexer

    def pull_token(self):
        return super(MastLexer, self.lexer).nextToken()

denter = None

def nextToken(self):
    if not self.denter:
        self.denter = self.MastDenter(self, self.NEWLINE, MastParser.INDENT, MastParser.DEDENT, False)
    return self.denter.next_token()

}

WS : [ \t]+ -> skip ;
NEWLINE: ('\r'? '\n' ' '*); //For tabs just switch out ' '* with '\t'*



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
SKIP_              : (COMMENT | INLINE_CODE_MARKER  ) -> skip;                 
//
///
///
LABEL_MARKER    : '==' '='+
                | '??' '?'+;
// NEWLINE        : ( '\r'? '\n' | '\r' | '\f' );
// handle characters which failed to match any other token
//ERROR : . ;
// fragment MATH_OPER       
//                 : '+'
//                 | '-'
//                 | '*'
//                 | '/'
//                 | '%'
//                 | '**'
//                 | '//'
//                 ;

// fragment LOGIC_OPER       
//                 : '>'
//                 | '<'
//                 | '=='
//                 | '!='
//                 | '<='
//                 | '>='
//                 | 'and'
//                 | 'or'
//                 | 'not'
//                 | 'is' 'not'
//                 | 'is'
//                 | 'in' 'not'
//                 | 'in'
//                 ;

// fragment BITWISE_OPER       
//                 : '&'
//                 | '|'
//                 | '^'
//                 | '~'
//                 | '<<'
//                 | '>>'
//                 ;


// OPER            : MATH_OPER
//                 | LOGIC_OPER
//                 | BITWISE_OPER
//                 ;

//// I don't know how else to allow these as names
//// as well as arguments for commands
// This means story and sbs elements need to be known 
// Which I don't like



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

IF_KW : 'if' ;
IN_KW : 'in' ;
IS_KW : 'is' ;
ELIF_KW : 'elif' ;
ELSE_KW : 'else' ;
OR_KW : 'or' ;
AND_KW : 'and' ;
NOT_KW : 'not' ;
TRUE_KW : 'True' ;
FALSE_KW : 'False' ;
NONE_KW : 'None' ;
DOT_DOT_DOT : '...' ;
FOR_KW : 'for' ;
WHILE_KW : 'while' ;
MATCH_KW : 'match' ;
CASE_KW : 'case' ;
CONTINUE_KW : 'continue' ;
BREAK_KW : 'break' ;

SHARED_KW :  'shared' ;

AWAIT_KW : 'await' ;
UNTIL_KW : 'until' ;
JUMP_ARROW : '->' ;
JUMP_KW : 'jump' ;
IMPORT_KW : 'import' ;
FROM_KW : 'from' ;

END_KW : 'END' ;
RETURN_KW : 'RETURN' ;
YIELD_KW : 'YIELD' ;
FAIL_KW : 'FAIL' ;
SUCCESS_KW : 'SUCCESS' ;


LABEL_REPLACE : 'replace:' ;
STYLE           : 'style' ;
COLOR           : 'color' ;

ON_KW              : 'on' ;
CHANGE_KW          : 'change' ;
END_ON          : 'end_on' ;
NAME_KW         : 'name' ;


/////////////////
// OPERATORS + Delim
COLON_OP : ':' ;
DSTAR_OP : '**' ;
STAR_OP : '*' ;

PLUS_OP : '+' ;
MINUS_OP : '-' ;
DIV_OP : '/' ;
INT_DIV_OP : '//' ;

// Bitwise
MOD_OP : '%' ;
BAND_OP : '&' ;
BOR_OP : '|' ;
BXOR_OP : '^' ;
BNOT_OP : '~' ;
SHIFT_LEFT_OP : '<<' ;
SHIFT_RIGHT_OP : '>>' ;
MAT_MUL_OP : '@' ;


// COMP
LESS_OP : '<' ;
GREAT_OP : '>' ;
COMP_EQ_OP : '==' ;
NOT_EQ_OP : '!=' | '<>' ;
LESS_EQ_OP : '<=' ;
GREAT_EQ_OP : '>=' ;



COMMA_OP : ',' ;
DOT_OP : '.' ;
EQ_OP : '=' ;
PLUS_EQ_OP : '+=' ;
MINUS_EQ_OP : '-=' ;
MUL_EQ_OP : '*=' ;
DIV_EQ_OP : '/=' ;
EXP_EQ_OP : '**=' ;
INT_DIV_EQ_OP : '//=' ;
// Bitwise
MOD_EQ_OP : '%=' ;
BAND_EQ_OP : '&=' ;
BOR_EQ_OP : '|=' ;
BXOR_EQ_OP : '^=' ;
SHIFT_LEFT_EQ_OP : '<<=' ;
SHIFT_RIGHT_EQ_OP : '>>=' ;
MAT_MUL_EQ_OP : '@=' ;


NAME            : ID_START ID_CONTINUE*
                ;



START_DICT : '{'  ;
START_ARRAY : '[' ;
START_TUPLE : '('  ;
END_DICT: '}' ;
END_ARRAY: ']';
END_TUPLE: ')';
//WS_EXPR : [ \t\n] -> skip;



// START_DICT : '{' -> pushMode(INEPR) ;
// START_ARRAY : '[' -> pushMode(INEPR) ;
// START_TUPLE : '(' -> pushMode(INEPR) ;

// mode INEPR;

//         END_DICT: '}' -> skip, popMode ;
//         END_ARRAY: ']' -> skip, popMode ;
//         END_TUPLE: ')' -> skip, popMode ;
//         WS_EXPR : [ \t\n] -> skip;




