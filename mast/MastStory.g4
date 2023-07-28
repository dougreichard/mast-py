grammar MastStory;

import MastSbs;


style_opts      : STYLE '=' STRING
                | STYLE '=' name
                ;

data_opts       :  DATA '=' name
                ;

gui_props       : STRING ;


gui_row_stmt        : ROW style_opts?
                    ;

gui_section_stmt    : SECTION style_opts?
                    ;
// Clickable, string is tool tip
gui_clickable_stmt  : SECTION style_opts? CLICKABLE gui_props data_opts? ':'
                    ;
gui_end_clickable_stmt  : END_CLICKABLE ;
                    

gui_refresh_stmt    : REFRESH name
                    ;

gui_hole_stmt       : HOLE style_opts?
                    ;

gui_blank_stmt      : BLANK style_opts?
                    ;

gui_face_stmt       : FACE gui_props style_opts?
                    | FACE name style_opts?
                    ;

gui_ship_stmt       : SHIP gui_props style_opts?
                    | SHIP name style_opts?
                    ;

gui_style_stmt      : style_opts
                ;

await_gui_stmt  : 'await' GUI timeout_opts?
                ;
// Original style opt, not sure how that is useful
// maybe thought it was like CSS on html or body
await_choice_stmt   : 'await' CHOICE ':'
                    | 'await' CHOICE SET name ':'
                    ;
// Only legal in a complex await?
disconnect_stmt   : DISCONNECT ':' ;

button_opts : data_opts inline_if? style_opts?
            | inline_if style_opts? data_opts?
            | style_opts data_opts? inline_if?
            ;

gui_button_control_stmt : BUTTON gui_props button_opts? ':' ;
gui_end_button_stmt : END_BUTTON ;

gui_slider_control_stmt : (SLIDER|INTSLIDER|SCROLLBAR) name gui_props style_opts? ;
gui_checkbox_control_stmt : CHECKBOX name gui_props style_opts? ;
gui_radio_control_stmt : (RADIO|VRADIO) name gui_props style_opts? ;
gui_text_input_control_stmt : INPUT name gui_props style_opts? ;
gui_image_control_stmt : IMAGE gui_props style_opts? ;
gui_dropdown_control_stmt : DROPDOWN name gui_props style_opts? ':' ;
gui_end_dropdown_stmt : END_DROPDOWN ;

gui_console_stmt    : CONSOLE name ;
// Are these obsolete?
gui_widget_list_clear_stmt : WIDGET_LIST CLEAR ;
gui_widget_list_stmt    : WIDGET_LIST STRING STRING ;

// build a console
gui_activate_console_stmt   : ACTIVATE CONSOLE name ;
gui_layout_widget_stmt      : LAYOUT WIDGET STRING ;

// Is this obsolete
await_select_stmt       : 'await' SELECT (COMMS|WEAPONS|SCIENCE) ;

on_change_stmt  : ON CHANGE expr ':' ;
end_on_stmt :  END_ON ;

gui_text_stmt : LONG_STRING_LITERAL | STRING ;
gui_append_text_stmt : GUI_APPEND_TEXT_STRING ;

// original had a page option, never implmented
gui_content_stmt    :   GUI CONTROL name expr style_opts?  
                    ;

reroute_gui_stmt    : REROUTE (SERVER|CLIENTS) name /*label*/
                    | REROUTE CLIENT name /*clientid*/ name /*label*/
                    ;

story_stmt  :   gui_row_stmt
            |   gui_text_stmt
            |   gui_append_text_stmt
            |   gui_face_stmt
            |   gui_ship_stmt
            |   gui_content_stmt
            |   gui_blank_stmt
            |   gui_hole_stmt
            |   gui_clickable_stmt
            |   gui_end_clickable_stmt
            |   gui_section_stmt
            |   gui_style_stmt
            |   await_choice_stmt
            |   disconnect_stmt
            |   await_gui_stmt
            |   on_change_stmt
            |       end_on_stmt
            |   await_select_stmt
            |   reroute_gui_stmt
            |   gui_button_control_stmt
            |       gui_end_button_stmt
            |   gui_slider_control_stmt
            |   gui_checkbox_control_stmt
            |   gui_radio_control_stmt
            |   gui_dropdown_control_stmt
            |       gui_end_dropdown_stmt
            |   gui_image_control_stmt
            |   gui_text_input_control_stmt
            |   gui_widget_list_stmt
            |       gui_widget_list_clear_stmt
            |   gui_console_stmt
            // builda console
            |   gui_activate_console_stmt
            |   gui_layout_widget_stmt
            |   gui_refresh_stmt
            ;
