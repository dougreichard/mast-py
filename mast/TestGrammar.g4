grammar TestGrammar;

tokens {
    INDENT,
    DEDENT
}

@lexer::header {
from .denterhelper import DenterHelper
from .TestGrammarParser import TestGrammarParser
}
@lexer::members {
class TestGrammarDenter(DenterHelper):
    def __init__(self, lexer, nl_token, indent_token, dedent_token, ignore_eof):
        super().__init__(nl_token, indent_token, dedent_token, ignore_eof)
        self.lexer: TestGrammarLexer = lexer

    def pull_token(self):
        return super(TestGrammarLexer, self.lexer).nextToken()

denter = None

def nextToken(self):
    if not self.denter:
        self.denter = self.TestGrammarDenter(self, self.NL, TestGrammarParser.INDENT, TestGrammarParser.DEDENT, False)
    return self.denter.next_token()

}
file_input : stat* EOF;
block: INDENT stat+ DEDENT;

stat: assign 
    | ifBlock
    | whileBlock
    | anonBlock
    ;

expr: ID
    | INT
    | STRING
    | funcCall
    | '(' expr ')'
    | expr ('*'|'/') expr
    | expr ('+'|'-') expr
    | expr ('=='|'<'|'>'|'<='|'>='|'!=') expr
    | ';'
    ;

funcCall: ID '(' argsList? ')';

argsList: expr (',' expr)*;

assign: ID '=' expr ';' NL;

ifBlock: 'if' expr 'then' block elseIfBlock?;
elseIfBlock: 'else' 'if' expr 'then' block elseIfBlock? 
        | 'else' block;
//elseBlock: 'else' block;

whileBlock: 'while' expr block;

anonBlock: 'scoped' block;

NL: ('\r'? '\n' ' '*); // note the ' '*


INT: [0-9]+;
STRING: '"' CHAR*? '"';
fragment CHAR:  ~["];
ID: [a-zA-Z]+;
WS: [ \t] -> skip;