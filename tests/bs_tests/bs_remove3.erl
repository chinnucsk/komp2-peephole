%%%-------------------------------------------------------------------
%%% File    : bs_remove3.erl
%%% Author  : Per Gustafsson <pergu@fan.it.uu.se>
%%% Description : 
%%%
%%% Created : 13 Apr 2004 by Per Gustafsson <pergu@fan.it.uu.se>
%%%-------------------------------------------------------------------
-module(bs_remove3).

-export([test/0, compile/1]).

compile(O) ->
  hipe:c(?MODULE,O).

test() ->
  Bin1 =
    <<30,16,0,90,0,1,0,0,255,255,255,255,81,67,101,7,0,
      0,0,96,6,12,146,18,14,0,15,252,16,0,0,17,0,0>>,
  Bin = <<Bin1/binary,Bin1/binary>>,
  Ans = loop(Bin, 10, fun run_list/1),
  Ans = loop(Bin, 10, fun run_bin/1),
  X = loop(Bin, 10, fun r31/1),
  {Ans, X}.

loop(Arg, 0, F) ->
  F(Arg);
loop(Arg, N, F) ->
  F(Arg),
  loop(Arg, N-1, F).

run_list(Bin) ->
  List = run1(Bin),
  list_to_binary(List).
run1(<<A1:2,_:1,A2:2,_:1,A3:2,_:1,A4:2,_:1,
     A5:2,_:1,A6:2,_:1,A7:2,_:1,A8:2,_:1,Rest/binary>>) ->
  [<<A1:2,A2:2,A3:2,A4:2,A5:2,A6:2,A7:2,A8:2>>|run2(Rest)];
run1(<<A1:2,_:1,A2:2,_:1,A3:2,_:1,A4:2,_:1,A5:2,_:1,A6:1>>) -> 
  [<<A1:2,A2:2,A3:2,A4:2,A5:2,A6:1,0:5>>];
run1(<<A1:2,_:1,A2:2,_:1,A3:2>>) ->
  [<<A1:2,A2:2,A3:2,0:2>>];
run1(<<>>) ->
  [].

run_bin(Bin) ->
  run2(Bin).
run2(<<A1:2,_:1,A2:2,_:1,A3:2,_:1,A4:2,_:1,
      A5:2,_:1,A6:2,_:1,A7:2,_:1,A8:2,_:1,Rest/binary>>) ->
  Bin = run2(Rest),
  <<A1:2,A2:2,A3:2,A4:2,A5:2,A6:2,A7:2,A8:2,Bin/binary>>;
 run2(<<A1:2,_:1,A2:2,_:1,A3:2,_:1,A4:2,_:1,A5:2,_:1,A6:1>>) -> 
   <<A1:2,A2:2,A3:2,A4:2,A5:2,A6:1,0:5>>;
 run2(<<A1:2,_:1,A2:2,_:1,A3:2>>) ->
   <<A1:2,A2:2,A3:2,0:2>>;
run2(<<>>) ->
  <<>>.

r31(Bin) ->
  List = remove3rd1(0, 0, Bin, [-1]),
  build(List, Bin, 0, <<>>).

build([N1, N2|Rest], Bin, N, Present) ->
  X = N1+1, Y = N2-X,
  S = rest(N2),    
  <<_:X,A:Y,_:S,_/binary>> = Bin,
  S1 = rest(N+Y),
  NewPresent = <<Present:N/binary-unit:1, A:Y, 0:S1>>, 
  build([N2|Rest], Bin, N+Y, NewPresent);

build([_], _Bin, _N, Present) ->
  Present.

rest(X) ->
  case 8-(X rem 8) of
      8 -> 0;
      H -> H
  end.

remove3rd1(N, 2, Bin, List) ->
  S = rest(N+1), 
  case Bin of
    <<_:N, 1:1, _:S,_/binary>> ->
      remove3rd1(N+1, 0, Bin, [N|List]);
    <<_:N, 0:1, _:S,_/binary>> ->
      remove3rd1(N+1, 2, Bin, List);
    _ ->
      Size = size(Bin)*8,
      lists:reverse([Size|List])
  end;
remove3rd1(N, I, Bin, List) ->
  S = rest(N+1), 
  case Bin of
    <<_:N, 1:1, _:S,_/binary>> ->
      remove3rd1(N+1, I+1, Bin, List);
    <<_:N, 0:1, _:S,_/binary>> ->
      remove3rd1(N+1, I, Bin, List);
    _ ->
      Size = size(Bin)*8,
      lists:reverse([Size|List])
  end.

