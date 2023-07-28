grammar Mast;
import MastStory,MastSbs, MastCore;





stmt    : story_stmt
        | sbs_stmt
        | mast_core_stmt 
        ;

file_input: ( stmt)* EOF;


