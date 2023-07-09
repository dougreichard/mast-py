from antlr4 import *
from parser.MastParser import MastParser
from parser.MastLexer import MastLexer
from MastErrorListener import MastErrorListener
import unittest
import io

class TestMastParser(unittest.TestCase):

    def setup(self, text):        
        lexer = MastLexer(InputStream(text))        
        stream = CommonTokenStream(lexer)
        parser = MastParser(stream)
        
        self.output = io.StringIO()
        self.error = io.StringIO()
        errorListener = MastErrorListener(self.error)

        lexer.removeErrorListeners()        
        lexer.addErrorListener(errorListener)  

        parser.removeErrorListeners()        
        parser.addErrorListener(errorListener)  

        self.errorListener = errorListener              
        
        return parser
    

    def expect_valid(self, code, func):
        parser = self.setup(code)
        func = getattr(parser, func)
        self.assertIsNotNone(func)
        func()
        self.assertEqual(self.errorListener.count, 0)

    def test_valid_label(self):
        self.expect_valid("=== fred ====", "label")
        



    def test_valid_jump(self):
        self.expect_valid("jump fred", "jump_stmt")
        self.expect_valid("jump fred if fred()", "jump_stmt")
        self.expect_valid("jump fred if fred(f)", "jump_stmt")
        self.expect_valid("jump fred if fred(f,w+e)", "jump_stmt")
        self.expect_valid("->    fred", "jump_stmt")
        self.expect_valid("->fred", "jump_stmt")

    
        
    def test_valid_end(self):
        self.expect_valid("->END", "end")
        self.expect_valid("->  END", "end")

    def test_valid_import(self):
        self.expect_valid("import story.mast", "import_stmt")
        self.expect_valid("from test.mastlib import story.mast", "import_stmt")
        self.expect_valid("from example/test.mastlib import story.mast", "import_stmt")
        self.expect_valid("from example/test.mastlib import example/story.mast", "import_stmt")


    def test_invalid_jump(self):
        parser = self.setup("jump +fre")
        tree = parser.jump_stmt()  

        # let's check the symbol in errorListener
        self.assertEqual(self.errorListener.line, 1)
        self.assertEqual(self.errorListener.column, 5)

if __name__ == '__main__':
    unittest.main()