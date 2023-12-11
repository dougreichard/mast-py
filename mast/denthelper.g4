
tokens { INDENT, DEDENT }

@lexer::header{
from .denterhelper import DenterHelper
from MastParser import MastParser
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
        self.denter = self.MastDenter(self, self.NL, MastParser.INDENT, MastParser.DEDENT, True)
    return self.denter.next_token()

}

NL: ('\r'? '\n' ' '*); //For tabs just switch out ' '* with '\t'*
