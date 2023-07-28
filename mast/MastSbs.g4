grammar MastSbs;

import MastCore;


route_stmt      : 'route' (
                        DESTORY
                        | SPAWN
                        | DAMAGE INTERNAL
                        | DAMAGE  OBJECT
                        | COMMS  SELECT
                        | SCIENCE  SELECT
                        | WEAPONS  SELECT
                        | GRID  SELECT
                        | GRID  SPAWN
                        | CHANGE  CONSOLE
                        )
                    name
                ;

follow_stmt      : 'follow' 'route' (
                        DESTORY
                        | SPAWN
                        | DAMAGE INTERNAL
                        | DAMAGE  OBJECT
                        | GRID  SPAWN
                        )
                        name
                | 'follow' 'route' (
                        | COMMS  SELECT
                        | SCIENCE  SELECT
                        | WEAPONS  SELECT
                        | GRID  SELECT
                        )
                        name name
                ;

face_opts : FACE STRING ;
color_opts : COLOR STRING ;
title_opts : TITLE STRING;
timeout_opts    : TIMEOUT SECONDS_TIME_NUMBER MINUTES_TIME_NUMBER?
                | TIMEOUT MINUTES_TIME_NUMBER SECONDS_TIME_NUMBER?
                ;

// Allow options in any order
trans_recv_opts : face_opts? color_opts ? title_opts?
                | face_opts?  title_opts? color_opts ?
                | color_opts ? title_opts? face_opts?
                | color_opts ? face_opts? title_opts?
                | title_opts? color_opts? face_opts?
                | title_opts? face_opts? color_opts?
                ;

trans_recv_stmt       : ('transmit'| 'receive') STRING trans_recv_opts
                    | ('transmit'| 'receive') name name STRING trans_recv_opts
                    ;

broadcast_stmt       : 'have' name 'broadcast' STRING color_opts?
                    ;

comms_info_stmt     : 'comms_info' STRING color_opts?
                    ;


comms_opts      : color_opts timeout_opts?
                | timeout_opts color_opts?
                ;

await_comms_stmt    : 'await' COMMS STRING comms_opts? ':'
                    | 'await' name COMMS name STRING comms_opts? ':'
                    ;

await_scan_stmt  : 'await' SCAN STRING (FOG NUMBER)? ':'
                    | 'await' name SCAN name STRING (FOG NUMBER)? ':'
                    ;

scan_result_stmt   :  SCAN RESULT STRING
                    ;

scan_tab_stmt       :  SCAN TAB STRING comp_for? comp_if? ':'
                    ;

button_stmt         :  ('+'|'*') STRING color_opts? comp_for? comp_if? ':'
                    ;

simulation_stmt     : 'simulation' (CREATE|PAUSE|RESUME) ;

sbs_stmt        : route_stmt
                | follow_stmt
                | trans_recv_stmt
                | broadcast_stmt
                | comms_info_stmt
                | await_comms_stmt
                | await_scan_stmt
                | scan_result_stmt
                | scan_tab_stmt
                | button_stmt
                | simulation_stmt
                ;
