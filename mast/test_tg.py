from antlr4 import *
from testgrammar.TestGrammarParser import TestGrammarParser
from testgrammar.TestGrammarLexer import TestGrammarLexer
from MastErrorListener import MastErrorListener
import unittest
import io
import os

file_one = """
x = 2;
if x then
    x = 3;
else
    y =2;
    
        
y = 3;
"""


class TestTestGrammar(unittest.TestCase):

    def setup(self, text, file_name=""):        
        lexer = TestGrammarLexer(InputStream(text))        
        stream = CommonTokenStream(lexer)
        parser = TestGrammarParser(stream)
        
        self.output = io.StringIO()
        self.error = io.StringIO()
        errorListener = MastErrorListener(self.error, file_name)

        lexer.removeErrorListeners()        
        lexer.addErrorListener(errorListener)  

        parser.removeErrorListeners()        
        parser.addErrorListener(errorListener)  

        self.errorListener = errorListener              
        
        return parser
    

    def expect_valid(self, code, func, file_name=""):
        parser = self.setup(code, file_name)
        func = getattr(parser, func)
        self.assertIsNotNone(func)
        func()
        self.assertEqual(self.errorListener.count, 0)

    def test_valid_file(self):
        self.expect_valid(file_one, "file_input")
        #self.expect_valid(file_two, "file_input")
        """
        for root, dirs, files in os.walk('./mast/examples/basic'):
            for name in files:
                if name.endswith(".mast"):
                    with open(os.path.join(root, name)) as f:
                        s = f.read( )
                        self.expect_valid(s, "file_input", name)
"""

if __name__ == '__main__':
    unittest.main()