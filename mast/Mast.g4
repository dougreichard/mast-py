grammar Mast;

// Comment
fragment COMMENT
 : '#' ~[\r\n\f]*
 ;

 fragment SPACES              
 : [ \t];                 // line whitespace



STRING
 : STRING_LITERAL
 //| BYTES_LITERAL
 ;
STRING_LITERAL :  ( SHORT_STRING | LONG_STRING ) ;

fragment SHORT_STRING
        : '\'' (~[\\\r\n\f'] )* '\''
        | '"' ( ~[\\\r\n\f"] )* '"'
        ;

// Long String can have new lines
fragment LONG_STRING
        : '\'\'\'' .*? '\'\'\''
        | '"""' .*? '"""'
        ;

fragment GUI_TEXT_STRING
        : '\'\'\'' '\''+ .*? '\'\'\'' '\''+
        | '"""' '"'+ .*? '"""' '"'+
        ;




                
fragment ID_START       : '_' 
                        | [a-zA-Z] 
                        ;
fragment ID_CONTINUE    : ID_START
                        | [a-zA-Z0-9]
                        ;        // match usual identifier spec



// Things to ignore
SKIP_              : (SPACES | COMMENT) -> skip;                 
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
CLOCK : ('GUI' | 'SIM' | 'APP' | 'TEST') ;

NAME
                : ID_START ID_CONTINUE*
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





// label_stmt
label_stmt           : LABEL_MARKER 'replace:'? NAME LABEL_MARKER; 


//
/// EXPR
///
//
test: or_test ('if' or_test 'else' test)? ;
test_nocond: or_test ;
//test_nocond: or_test | lambdef_nocond;
//lambdef: 'lambda' (varargslist)? ':' test;
//lambdef_nocond: 'lambda' (varargslist)? ':' test_nocond;
or_test: and_test ('or' and_test)*;
and_test: not_test ('and' not_test)*;
not_test: 'not' not_test | comparison;
comparison: expr (comp_op expr)*;
// <> isn't actually a valid comparison operator in Python. It's here for the
// sake of a __future__ import described in PEP 401 (which really works :-)
comp_op: '<'|'>'|'=='|'>='|'<='|'<>'|'!='|'in'|'not' 'in'|'is'|'is' 'not';
star_expr: '*' expr;
expr: xor_expr ('|' xor_expr)*;
xor_expr: and_expr ('^' and_expr)*;
and_expr: shift_expr ('&' shift_expr)*;
shift_expr: arith_expr (('<<'|'>>') arith_expr)*;
arith_expr: term (('+'|'-') term)*;
term: factor (('*'|'@'|'/'|'%'|'//') factor)*;
factor: ('+'|'-'|'~') factor | power;
power: atom_expr ('**' factor)?;
//power: atom_expr ('**' factor)?;
atom_expr: atom trailer*;
//atom_expr: (AWAIT)? atom trailer*;
atom    : (
        //'(' (yield_expr|testlist_comp)? ')' 
        '(' (testlist_comp)? ')' 
        | '[' (testlist_comp)? ']' 
        | '{' (dictorsetmaker)? '}' 
        | NAME 
        | NUMBER 
        | STRING+ 
        | '...' 
        | 'None' 
        | 'True' 
        | 'False'
        )
        ;

testlist_comp: (test|star_expr) ( comp_for | (',' (test|star_expr))* (',')? );
trailer: '(' (arglist)? ')' | '[' subscriptlist ']' | '.' NAME;
subscriptlist: subscript (',' subscript)* (',')?;
subscript: test | (test)? ':' (test)? (sliceop)?;
sliceop: ':' (test)?;
exprlist: (expr|star_expr) (',' (expr|star_expr))* (',')?;
testlist: test (',' test)* (',')?;
dictorsetmaker: ( ((test ':' test | '**' expr)
                (comp_for | (',' (test ':' test | '**' expr))* (',')?)) |
                ((test | star_expr)
                (comp_for | (',' (test | star_expr))* (',')?)) );


arglist: argument (',' argument)*  (',')?;
argument: ( test (comp_for)? |
                test '=' test |
                '**' test |
                '*' test );

comp_iter: comp_for | comp_if;
comp_for: 'for' exprlist 'in' or_test (comp_iter)?;
//comp_for: (ASYNC)? 'for' exprlist 'in' or_test (comp_iter)?;
comp_if: 'if' test_nocond (comp_iter)?;






// end
end_stmt             : '->' 'END'  inline_if?;
// return if
return_stmt             : '->' 'RETURN'  inline_if?;
// yield
yield_stmt             : '->' 'YIELD'  inline_if?;
// fail
fail_stmt             : '->' 'FAIL'  inline_if?;

success_stmt             : '->' 'SUCCESS'  inline_if?;

inline_if       : 'if' test;

// jump, push , pop,
jump_stmt       : 'jump' NAME inline_if? 
                | '->' NAME inline_if?
                ;
//
// import
//
import_stmt: import_name | import_from;
import_name: 'import' file_name;
// note below: the ('.' | '...') is necessary because '...' is tokenized as ELLIPSIS
import_from: 'from' file_name 'import' file_name;
file_name: dotted_name ('/' dotted_name)*;
dotted_name: NAME ('.' NAME)*;
//
// if (else, elif, end_if)
//
if_stmt: 'if' test ':'; 
elif_stmt: 'elif' test ':' ;
else_stmt: 'else' ':';
end_if_stmt: 'end_if';

// loop - start, break, end, 
for_stmt: 'for' NAME 'in' test ':';
while_stmt: 'for' NAME 'while' test ':';
next_stmt: 'next' NAME;
break_stmt: 'break';
continue_stmt: 'continue';
// timeout
timeout_stmt: 'timeout:';
// log
log_stmt        : 'log' STRING
                | 'log' 'name' NAME STRING
                ;
// delay
//seconds         : INTEGER 's';
//minutes         : INTEGER 'm';

delay_stmt      :  'delay' CLOCK  NUMBER 's'
                //|  'delay'  minutes
                //|  'delay'  ('gui' | 'sim' | 'app' | 'test')  seconds minutes
                ;


//
// Assign
//
assign_stmt:  NAME trailer* augassign expr ;
function_stmt:  NAME trailer*;

augassign       : ('=' 
                |'+=' 
                | '-=' 
                | '*=' 
                | '@=' 
                | '/=' 
                | '%=' 
                | '&=' 
                | '|=' 
                | '^=' 
                | '<<=' 
                | '>>=' 
                | '**=' 
                | '//='
                );




// logger
// match, case, end_match
// PyCode, do

// Marker - obsolete
// parallel
// end_await
// await fail 
// await cond
// cancel


stmt            : (label_stmt 
                | delay_stmt
                | end_stmt 
                | return_stmt 
                | yield_stmt 
                | fail_stmt
                | success_stmt
                | jump_stmt 
                | import_stmt 
                | if_stmt 
                | elif_stmt 
                | else_stmt 
                | end_if_stmt 
                | for_stmt 
                | while_stmt 
                | next_stmt
                | break_stmt
                | continue_stmt
                | timeout_stmt
                
                | log_stmt
                
                // Late
                
                | assign_stmt
                | function_stmt
                ) ;


file_input: (NEWLINE | stmt)* EOF;


