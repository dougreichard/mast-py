grammar Mast;
import MastLex, MastCore, MastSbs, MastStory;





stmt    : mast_core_stmt 
        | sbs_stmt
        | story_stmt
        ;

file_input: (NEWLINE | stmt)* EOF;


