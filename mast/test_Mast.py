from antlr4 import *
from parser.MastParser import MastParser
from parser.MastLexer import MastLexer
from MastErrorListener import MastErrorListener
import unittest
import io
from file_data import file_one, file_two

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
        self.expect_valid("=== fred ====", "label_stmt")
        self.expect_valid("=== replace: fred ====", "label_stmt")
        # as stmt
        self.expect_valid("=== replace: fred ====", "stmt")

    def test_valid_jump(self):
        self.expect_valid("jump fred", "jump_stmt")
        self.expect_valid("jump fred if fred()", "jump_stmt")
        self.expect_valid("jump fred if fred(f)", "jump_stmt")
        self.expect_valid("jump fred if fred(f,w+e)", "jump_stmt")
        self.expect_valid("->    fred", "jump_stmt")
        self.expect_valid("->fred", "jump_stmt")
        # as stmt
        self.expect_valid("->fred", "stmt")

    def test_valid_assign(self):
        self.expect_valid("fred = 3", "assign_stmt")
        self.expect_valid("fred += 3", "assign_stmt")
        # as stmt
        self.expect_valid("fred += 3", "stmt")

    
        
    def test_valid_end(self):
        self.expect_valid("->END", "end_stmt")
        self.expect_valid("->  END", "end_stmt")
        # as stmt
        self.expect_valid("->END", "stmt")

    def test_valid_import(self):
        self.expect_valid("import story.mast", "import_stmt")
        self.expect_valid("from test.mastlib import story.mast", "import_stmt")
        self.expect_valid("from example/test.mastlib import story.mast", "import_stmt")
        self.expect_valid("from example/test.mastlib import example/story.mast", "import_stmt")
        # as stmt
        self.expect_valid("from example/test.mastlib import example/story.mast", "stmt")

    def test_valid_delay(self):
        self.expect_valid("delay sim 5s", "delay_stmt")
        self.expect_valid("delay sim 5m", "delay_stmt")
        self.expect_valid("delay sim 3s 5m", "delay_stmt")
        self.expect_valid("delay sim 5m 2s", "delay_stmt")
        self.expect_valid("damage = 5", "assign_stmt")


    def test_valid_file(self):
        self.expect_valid(file_one, "file_input")
        self.expect_valid(file_two, "file_input")
        

    def test_invalid_jump(self):
        parser = self.setup("jump +fre")
        tree = parser.jump_stmt()  

        # let's check the symbol in errorListener
        self.assertEqual(self.errorListener.line, 1)
        self.assertEqual(self.errorListener.column, 5)

if __name__ == '__main__':
    unittest.main()