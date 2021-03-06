-module(csvs).
-export([open/1, open/2, name_to_field/1, service_loop/1, next/1, close/1]).

open (FileName) ->
    Lines = csv:process_file (FileName, fun identity/1),
    spawn (csvs, service_loop, [Lines]).

open (FileName, true) ->
    Pid = open(FileName),
    [next(Pid)] ++ [Pid];
open (FileName, false) ->
    open(FileName).

name_to_field (Options) ->
    Fields = hd (Options),
    Handle = hd (tl (Options)),
    Tuple = next(Handle),
    lists:zip (tuple_to_list (Fields), tuple_to_list(Tuple)).

%% The interface expects a function parameter, so why not just pass in
%% an indentity operation? Works for this, I guess.
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

next (Handle) ->
    Handle ! {next_record, self()},
    receive
        {ok, eof} -> "Done";
        {ok, Tuple} -> Tuple;
        {error, bad_request} -> "Bad request"
    end.
    
close (Handle) ->
    Handle ! {close, self()},
    receive
        {ok, closed} -> "Closed";
        {error, bad_request} -> "Bad request"
    end. 

