-module(csv).
-export([process/2]).

parse_csv (Line) ->
    Lines = re:split(Line, ",", [{return, list}]).

parse (Lines) ->
    lists:map (fun (Line) -> parse_csv (Line) end, Lines).

process (Lines, F) ->
    lists:map (fun (Tokens) -> F (Tokens) end, parse (Lines)).

