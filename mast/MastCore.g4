grammar MastCore;
import MastLex;

////////////////////
// This is needed to allow some keywords
// to be legal variable names
name    : NAME
        // SBS keywords allowed to be variables?
        | FACE
        | COLOR
        | TITLE
        | FOG
        | SCAN
        | RESULT
        | TAB
        | CREATE
        | PAUSE
        | RESUME
        | DESTORY
        | SPAWN
        | OBJECT
        | DAMAGE 
        | INTERNAL
        | DAMAGE
        | COMMS
        | SCIENCE
        | WEAPONS
        | SELECT
        | GRID
        | GRID
        | CHANGE
        | CONSOLE
        ;

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



inline_if       : test;


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
if_stmt: 'if' test ':'; 
elif_stmt: 'elif' test ':' ;
else_stmt: 'else' ':';
end_if_stmt: 'end_if';


//
// match (case, end_match)
//
match_stmt: 'match' atom_expr ':'; 
case_stmt: 'case' atom_expr ':' ;
//else_stmt: 'else' ':';
end_match_stmt: 'end_match';

// loop - start, break, end, 
for_stmt: 'for' name 'in' test ':';
while_stmt: 'for' name 'while' test ':';
next_stmt: 'next' name;
break_stmt: 'break';
continue_stmt: 'continue';
// timeout
timeout_stmt: 'timeout' SECONDS_TIME_NUMBER MINUTES_TIME_NUMBER? ':'
            | 'timeout' MINUTES_TIME_NUMBER SECONDS_TIME_NUMBER? ':'
            ;
// log (Expr is different than original MAST regex parser)
log_stmt        : 'log' expr
                | 'log' 'name' name expr
                ;
// delay
//seconds         : INTEGER 's';
//minutes         : INTEGER 'm';

delay_stmt      :  'delay' name  SECONDS_TIME_NUMBER
                |  'delay'  name MINUTES_TIME_NUMBER
                |  'delay'  name SECONDS_TIME_NUMBER MINUTES_TIME_NUMBER
                |  'delay'  name MINUTES_TIME_NUMBER SECONDS_TIME_NUMBER
                ;


//
// Assign
//
shared_assign_stmt: 'shared' name trailer* augassign expr ;
assign_stmt:  name trailer* augassign expr ;
function_stmt:  name trailer*;
do_stmt:  'do' name trailer*;

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
cancel_stmt     : 'cancel' name ;

// Not top level stmt
await_fail_stmt : 'fail' ':' ;

await_condition_stmt : 'await' 'until' expr ':' ;


// parallel
await_task_complete_stmt    : 'await'  name ;

dictionary_data : '{' (dictorsetmaker)? '}' ;

schedule_task_stmt  : ('schedule'| '=>') name dictionary_data? ; 
schedule_all_stmt  : ('schedule'| '=>') 'all' ('&' name)* dictionary_data?  ; 
await_schedule_task : 'await' ('var' name)? schedule_task_stmt 
                    ;
await_all_stmt      : 'await' ('var' name)? 'all' name ('&' name)* dictionary_data? 
                    ;
await_any_stmt      : 'await' ('var' name)? 'any' name ('|' name)* dictionary_data? 
                    ;

////////////////////////////////////
// Behavior tree syntax
//// not released so can change
////
// yield bt sel a|b   [data]

// await bt until fail seq a&b [data] 
// await bt until success seq a&b [data]
bt_sel_stmt     :  'bt' ('invert')?  'sel' name ('|' name)* dictionary_data? ;
bt_seq_stmt     :  'bt' ('invert')?  'seq' 'until' ('success'|'fail') name ('&' name)* dictionary_data? ;
// bt_yield_stmt   :  'yield' ('success'|'fail') inline_if? ;





mast_core_stmt  : label_stmt 
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
                | match_stmt
                | case_stmt
                | end_match_stmt
                | timeout_stmt
                
                | log_stmt
                | logger_stmt
                
                // -- behavior stmts --

                // parallel
                | schedule_task_stmt
                | schedule_all_stmt
                | await_schedule_task
                | await_all_stmt
                | await_any_stmt
                //
                | end_await_stmt
                | await_fail_stmt
                | await_condition_stmt

                | bt_sel_stmt
                | bt_seq_stmt
                // have Later in list?
                | shared_assign_stmt
                | assign_stmt
                | function_stmt
                ;

