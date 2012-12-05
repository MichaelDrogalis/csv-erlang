-module(csv).
-export([parse_csv/1, parse/1]).

parse_csv (Line) ->
    Lines = re:split(Line, ",", [{return, list}]).

parse (Lines) ->
    lists:map (fun (Line) -> parse_csv (Line) end, Lines).

