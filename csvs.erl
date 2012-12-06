-module(csvs).
-export([open/1, service_loop/1, test_connection/0]).

open (FileName) ->
    Lines = csv:process_file (FileName, fun identity/1),
    spawn (csvs, service_loop, [Lines]).

identity (X) ->
    X.

service_loop ([]) ->
    receive
        {next_record, Pid} -> Pid ! {ok, eof}
    end;
service_loop (Lines) ->
    receive
        {next_record, Pid} ->
                    Pid ! {ok, hd(Lines)},
                    service_loop(tl(Lines));
        {close, Pid} -> Pid ! {ok, closed};
        {_, Pid} -> Pid ! {error, bad_request}
    end.

test_connection () ->
    Pid = open("file.csv"),
    Pid ! {closex, self()},
    receive
        {ok, eof} -> io:format("Aaaand we're done.~n");
        {ok, closed} -> io:format("Closed.~n");
        {ok, Tuple} -> io:format("~p ~n", [Tuple]);
        {error, bad_request} -> io:format("Bad request..~n")
    end.

