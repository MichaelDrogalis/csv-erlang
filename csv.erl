-module(csv).
-export([parse_csv/1]).

parse_csv (Line) ->
    Lines = re:split(Line, ",", [{return, list}]).

