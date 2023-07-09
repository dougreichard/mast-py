import sys
from antlr4 import *
from antlr4.error.ErrorListener import *
import io

class MastErrorListener(ErrorListener):

    def __init__(self, output):
        self.output = output        
        self.msg = ''
        self.count = 0
    
    def syntaxError(self, recognizer, offendingSymbol, line, column, msg, e):        
        self.output.write(msg)
        print(msg)
        self.msg = msg
        self.line = line
        self.column = column
        self.count += 1


    def reportAmbiguity(self, recognizer, dfa, startIndex, stopIndex, exact, ambigAlts, configs):
        pass

    def reportAttemptingFullContext(self, recognizer, dfa, startIndex, stopIndex, conflictingAlts, configs):
        pass

    def reportContextSensitivity(self, recognizer, dfa, startIndex, stopIndex, prediction, configs):
        pass

    @property        
    def symbol(self):
        return self._symbol