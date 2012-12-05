-module(csvs).
-export([open/1]).

some_func(X) ->
    X.

open (FileName) ->
    spawn (csv, process_file, [FileName, fun some_func/1]).

