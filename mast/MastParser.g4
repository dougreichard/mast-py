parser grammar MastParser;

//import MastLex;
options {  tokenVocab = MastLexer; }

// label_stmt
label_stmt           : LABEL_MARKER LABEL_REPLACE? name LABEL_MARKER; 
//
/// EXPR
///
//
test: or_test (IF_KW or_test ELSE_KW test)? ;
test_nocond: or_test ;
//test_nocond: or_test | lambdef_nocond;
//lambdef: 'lambda' (varargslist)? COLON_OP test;
//lambdef_nocond: 'lambda' (varargslist)? COLON_OP test_nocond;
or_test: and_test (OR_KW and_test)*;
and_test: not_test (AND_KW not_test)*;
not_test: NOT_KW not_test | comparison;
comparison: expr (comp_op expr)*;
// <> isn't actually a valid comparison operator in Python. It's here for the
// sake of a __future__ import described in PEP 401 (which really works :-)
comp_op: LESS_OP|GREAT_OP|COMP_EQ_OP|GREAT_EQ_OP|LESS_EQ_OP|NOT_EQ_OP|IN_KW|NOT_KW IN_KW|IS_KW|IS_KW NOT_KW;
star_expr: STAR_OP expr;
expr: xor_expr (BOR_OP xor_expr)*;
xor_expr: and_expr (BXOR_OP and_expr)*;
and_expr: shift_expr (BAND_OP shift_expr)*;
shift_expr: arith_expr ((SHIFT_LEFT_OP|SHIFT_RIGHT_OP) arith_expr)*;
arith_expr: term ((PLUS_OP|MINUS_OP) term)*;
term: factor ((STAR_OP|MAT_MUL_OP|DIV_OP|MOD_OP|INT_DIV_OP) factor)*;
factor: (PLUS_OP|MINUS_OP|BNOT_OP) factor | power;
power: atom_expr (DSTAR_OP factor)?;
//power: atom_expr (DSTAR_OP factor)?;
atom_expr: atom trailer*;
//atom_expr: (AWAIT)? atom trailer*;
atom    : (
        START_TUPLE  (testlist_comp)? END_TUPLE
        | START_ARRAY (testlist_comp)? END_ARRAY 
        | START_DICT (dictorsetmaker)? END_DICT
        | name 
        | NUMBER 
        | STRING+ 
        | DOT_DOT_DOT
        | NONE_KW
        | TRUE_KW
        | FALSE_KW
        )
        ;

testlist_comp: (test|star_expr) ( comp_for | (COMMA_OP (test|star_expr))* (COMMA_OP)? );
trailer: START_TUPLE (arglist)? END_TUPLE | START_ARRAY subscriptlist END_ARRAY | DOT_OP name;
subscriptlist: subscript (COMMA_OP subscript)* (COMMA_OP)?;
subscript: test | (test)? COLON_OP (test)? (sliceop)?;
sliceop: COLON_OP (test)?;
exprlist: (expr|star_expr) (COMMA_OP (expr|star_expr))* (COMMA_OP)?;
testlist: test (COMMA_OP test)* (COMMA_OP)?;
dictorsetmaker: ( ((test COLON_OP test | DSTAR_OP expr)
                (comp_for | (COMMA_OP (test COLON_OP test | DSTAR_OP expr))* (COMMA_OP)?)) |
                ((test | star_expr)
                (comp_for | (COMMA_OP (test | star_expr))* (COMMA_OP)?)) );


arglist: argument (COMMA_OP argument)*  (COMMA_OP)?;
argument: ( test (comp_for)? |
                test EQ_OP test |
                DSTAR_OP test |
                STAR_OP test );

comp_iter: comp_for | comp_if;
comp_for: FOR_KW exprlist IN_KW or_test (comp_iter)?;
//comp_for: (ASYNC)? FOR_KW exprlist IN_KW or_test (comp_iter)?;
comp_if: IF_KW test_nocond (comp_iter)?;



inline_if       : IF_KW test;


// end
end_stmt             : JUMP_ARROW END_KW  inline_if?;
// return if
return_stmt             : JUMP_ARROW RETURN_KW  inline_if?;
// yield
yield_stmt             : JUMP_ARROW YIELD_KW  inline_if?;
// fail
fail_stmt               : JUMP_ARROW FAIL_KW  inline_if?
                        | YIELD_KW FAIL_KW inline_if?;

success_stmt            : JUMP_ARROW SUCCESS_KW inline_if?
                        | YIELD_KW SUCCESS_KW inline_if?;



// jump, push , pop,
jump_stmt       : JUMP_KW name inline_if? 
                | JUMP_ARROW name inline_if?
                ;
//
// import
//
import_stmt: import_name | import_from;
import_name: IMPORT_KW file_name;
// note below: the (DOT_OP | '...') is necessary because '...' is tokenized as ELLIPSIS
import_from: FROM_KW file_name IMPORT_KW file_name;
file_name: dotted_name ('/' dotted_name)*;
dotted_name: name (DOT_OP name)*;
//
// if (else, elif, end_if)
//

block : COLON_OP INDENT stmt+ DEDENT ;

elif_stmt: ELIF_KW test block elif_stmt?
        | ELSE_KW block ;
if_stmt: IF_KW test block elif_stmt?; 

//else_stmt: ELSE_KW COLON_OP;
//end_if_stmt: 'end_if';


//
// match (case, end_match)
//
match_stmt: MATCH_KW atom_expr COLON_OP INDENT case_stmt+ DEDENT; 
case_stmt: CASE_KW atom_expr block ;
//else_stmt: ELSE_KW COLON_OP;
//end_match_stmt: 'end_match';

// loop - start, break, end, 
for_stmt: FOR_KW name IN_KW test block;
while_stmt: FOR_KW name WHILE_KW test block;
break_stmt: BREAK_KW inline_if?;
continue_stmt: CONTINUE_KW inline_if?;

//
// Assign
//
shared_assign_stmt: SHARED_KW name trailer* augassign test_nocond ;
assign_stmt:  name trailer* augassign test_nocond ;
//function_stmt:  name '(' (arglist)? ')' ;
function_stmt:  name trailer+  ;

augassign       : (EQ_OP 
                |PLUS_EQ_OP 
                | MINUS_EQ_OP 
                | MUL_EQ_OP 
                | MAT_MUL_EQ_OP 
                | DIV_EQ_OP 
                | MOD_EQ_OP 
                | EXP_EQ_OP 
                | INT_DIV_EQ_OP
                | BAND_EQ_OP 
                | BOR_EQ_OP
                | BXOR_EQ_OP
                | SHIFT_LEFT_EQ_OP 
                | SHIFT_RIGHT_EQ_OP 
                );




dictionary_data : START_DICT (dictorsetmaker)? END_DICT ;


name    : NAME
        // SBS keywords allowed to be variables?
        //| POINT
        | STYLE
        | COLOR
        | NAME_KW
        ;

////////////////////////////////////////////////////////
/// SBSB rules
color_opts : COLOR STRING ;



inline_label   : EQ_OP  test  block ;
button_stmt    :  (PLUS_OP|STAR_OP) STRING color_opts? comp_for? inline_if?  block
               ;
await_stmts 
        : button_stmt
        | inline_label
        ;


await_condition_stmt : AWAIT_KW UNTIL_KW expr COLON_OP ;
await_stmt_block : AWAIT_KW  expr COLON_OP INDENT await_stmts+ DEDENT;
await_stmt_single : AWAIT_KW  expr ;


//////////////////////////////////////////////////////
// Story Rules

on_change_stmt  : ON_KW CHANGE_KW? expr COLON_OP INDENT + stmt + DEDENT ;

style_opts : STYLE EQ_OP STRING_LITERAL ;
gui_text_stmt : LONG_STRING_LITERAL | STRING style_opts?;
gui_append_text_stmt : GUI_APPEND_TEXT_STRING style_opts?;



stmt    : gui_text_stmt
        | gui_append_text_stmt
        | on_change_stmt
        | label_stmt NEWLINE
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

        | for_stmt 
        | while_stmt 
        
        | break_stmt NEWLINE
        | continue_stmt NEWLINE

        | match_stmt
        | case_stmt
        
        | await_stmt_block
        | await_stmt_single
        //
        | await_condition_stmt
;



file_input: ( stmt)* ;


