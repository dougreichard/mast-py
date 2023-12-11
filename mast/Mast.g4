grammar Mast;


import MastLex;

// label_stmt
label_stmt           : LABEL_MARKER 'replace:'? name LABEL_MARKER; 
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
        | name 
        | NUMBER 
        | STRING+ 
        | '...' 
        | 'None' 
        | 'True' 
        | 'False'
        )
        ;

testlist_comp: (test|star_expr) ( comp_for | (',' (test|star_expr))* (',')? );
trailer: '(' (arglist)? ')' | '[' subscriptlist ']' | '.' name;
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



inline_if       : 'if' test;


// end
end_stmt             : '->' 'END'  inline_if?;
// return if
return_stmt             : '->' 'RETURN'  inline_if?;
// yield
yield_stmt             : '->' 'YIELD'  inline_if?;
// fail
fail_stmt               : '->' 'FAIL'  inline_if?
                        | YIELD FAIL inline_if?;

success_stmt            : '->' 'SUCCESS' inline_if?
                        | YIELD SUCCESS inline_if?;



// jump, push , pop,
jump_stmt       : 'jump' name inline_if? 
                | '->' name inline_if?
                ;
//
// import
//
import_stmt: import_name | import_from;
import_name: 'import' file_name;
// note below: the ('.' | '...') is necessary because '...' is tokenized as ELLIPSIS
import_from: 'from' file_name 'import' file_name;
file_name: dotted_name ('/' dotted_name)*;
dotted_name: name ('.' name)*;
//
// if (else, elif, end_if)
//

block : ':' INDENT stmt+ DEDENT ;

elif_stmt: 'elif' test block elif_stmt?
        | 'else' block ;
if_stmt: 'if' test block elif_stmt?; 

//else_stmt: 'else' ':';
//end_if_stmt: 'end_if';


//
// match (case, end_match)
//
match_stmt: 'match' atom_expr ':' INDENT case_stmt+ DEDENT; 
case_stmt: 'case' atom_expr block ;
//else_stmt: 'else' ':';
//end_match_stmt: 'end_match';

// loop - start, break, end, 
for_stmt: 'for' name 'in' test block;
while_stmt: 'for' name 'while' test block;
next_stmt: NEXT name;
break_stmt: 'break' inline_if?;
continue_stmt: 'continue' inline_if?;
// timeout
timeout_stmt: 'timeout' SECONDS_TIME_NUMBER MINUTES_TIME_NUMBER? ':'
            | 'timeout' MINUTES_TIME_NUMBER SECONDS_TIME_NUMBER? ':'
            ;
// log (Expr is different than original MAST regex parser)
log_stmt        : 'log' expr
                | 'log' NAME_KW name expr
                ;

//
// Assign
//
shared_assign_stmt: 'shared' name trailer* augassign test_nocond ;
assign_stmt:  name trailer* augassign test_nocond ;
//function_stmt:  name '(' (arglist)? ')' ;
function_stmt:  name trailer+  ;

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
logger_stmt     : 'Logger' 'name' name 
                | 'Logger' 'name' name 'string' name
                | 'Logger' 'name' name 'file' STRING
                ;

end_await_stmt  : 'end_await' ;

// Not top level stmt
await_fail_stmt : 'fail' ':' ;

await_condition_stmt : 'await' 'until' expr ':' ;
await_stmt_block : 'await'  expr ':' ;
await_stmt_single : 'await'  expr ;


dictionary_data : '{' (dictorsetmaker)? '}' ;




mast_core_stmt  : label_stmt NEWLINE
                // have Later in list?
                | shared_assign_stmt NEWLINE
                | assign_stmt NEWLINE
                | function_stmt NEWLINE
                | end_stmt NEWLINE
                | return_stmt NEWLINE
                | yield_stmt NEWLINE
                | fail_stmt NEWLINE
                | success_stmt NEWLINE
                | jump_stmt NEWLINE
                | import_stmt NEWLINE

                | if_stmt 
                | elif_stmt 
                //| else_stmt 
                //| end_if_stmt 

                | for_stmt 
                //| next_stmt
                | while_stmt 
                
                | break_stmt NEWLINE
                | continue_stmt NEWLINE

                | match_stmt
                | case_stmt
                //| end_match_stmt
                | timeout_stmt
                
                | log_stmt NEWLINE
                | logger_stmt NEWLINE
                | await_stmt_block
                | await_stmt_single
                
                //
                | end_await_stmt
                | await_fail_stmt
                | await_condition_stmt

                ;

name    : NAME
        // SBS keywords allowed to be variables?
        | COMMS
        | SCAN
        | NEXT
        | NAME_KW
        | CHOICE
        | MESSAGE
        //| POINT
        | GUI
        | STYLE
        | COLOR
        ;

////////////////////////////////////////////////////////
/// SBSB rules
color_opts : COLOR STRING ;

timeout_opts    : TIMEOUT SECONDS_TIME_NUMBER MINUTES_TIME_NUMBER?
                | TIMEOUT MINUTES_TIME_NUMBER SECONDS_TIME_NUMBER?
                ;

// Allow options in any order



comms_opts      : color_opts timeout_opts?
                | timeout_opts color_opts?
                ;

await_comms_stmt    : 'await' COMMS comms_opts? ':'
                    | 'await' name COMMS name comms_opts? ':'
                    ;

await_scan_stmt  : 'await' SCAN ':'
                    | 'await' name SCAN name ':'
                    ;

change_stmt   : CHANGE test ':' ;

button_stmt         :  ('+'|'*') STRING color_opts? comp_for? inline_if? ':'
                    ;


sbs_stmt        : await_comms_stmt
                | await_scan_stmt
                | button_stmt
                | change_stmt
                ;
//////////////////////////////////////////////////////
// Story Rules

await_gui_stmt  : 'await' GUI timeout_opts?
                ;
// Original style opt, not sure how that is useful
// maybe thought it was like CSS on html or body
await_choice_stmt   : 'await' CHOICE ':'
                    // | 'await' CHOICE 'set' name ':'
                    ;
// Only legal in a complex await?
disconnect_stmt   : DISCONNECT ':' ;
focus_statement   : FOCUS ':' ;


on_change_stmt  : ON CHANGE expr ':' INDENT + stmt + DEDENT ;
//on_change_stmt  : ON CHANGE expr ':' ;
on_message_stmt  : ON MESSAGE expr ':' ;
end_on_stmt :  END_ON ;

style_opts : STYLE '=' STRING_LITERAL ;
gui_text_stmt : LONG_STRING_LITERAL | STRING style_opts?;
gui_append_text_stmt : GUI_APPEND_TEXT_STRING style_opts?;


// BLOCK STATEMENT DON'T need newlines
// But top level do
// e.g. assign needs a newline, if doesn't

story_stmt  :   gui_text_stmt
            |   gui_append_text_stmt
            |   await_choice_stmt
            |   disconnect_stmt
            |   focus_statement
            |   await_gui_stmt
            |   on_change_stmt
            |   on_message_stmt
            |       end_on_stmt
            ;






stmt    : story_stmt 
        | sbs_stmt 
        | mast_core_stmt 
        ;

file_input: ( stmt)* ;


