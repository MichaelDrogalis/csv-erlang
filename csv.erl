-module(csv).
-export([process/2, process_file/2]).

parse_csv (Line) ->
    Lines = re:split(Line, ",", [{return, list}]).

parse (Lines) ->
    lists:map (fun (Line) -> parse_csv (Line) end, Lines).

process (Lines, F) ->
    lists:map (fun (Tokens) -> F (list_to_tuple(Tokens)) end, parse (Lines)).

process_file (FileName, F) ->
    {ok, Device} = file:open (FileName, [read]),
    Lines = re:split (get_all_lines (Device), "\n", [{return, list}]),
    file:close (Device),
    process (Lines, F).

get_all_lines (Device) ->
        case io:get_line (Device, "") of
            eof  -> [];
            Line -> Line ++ get_all_lines (Device)
        end.

