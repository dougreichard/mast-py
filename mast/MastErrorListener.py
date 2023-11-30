import sys
from antlr4 import *
from antlr4.error.ErrorListener import *
import io

class MastErrorListener(ErrorListener):

    def __init__(self, output, file_name):
        self.output = output        
        self.msg = ''
        self.count = 0
        self.file_name = file_name
    
    def syntaxError(self, recognizer, offendingSymbol, line, column, msg, e):        
        self.output.write(msg)
        print(msg)
        self.msg = msg
        self.line = line
        self.column = column
        self.count += 1


    def reportAmbiguity(self, recognizer, dfa, startIndex, stopIndex, exact, ambigAlts, configs):
        #self.count += 1
        pass

    def reportAttemptingFullContext(self, recognizer, dfa, startIndex, stopIndex, conflictingAlts, configs):
        #self.count += 1
        pass

    def reportContextSensitivity(self, recognizer, dfa, startIndex, stopIndex, prediction, configs):
        #self.count += 1
        pass

    @property        
    def symbol(self):
        return self._symbol