/*****************************************************************************

		Copyright (c) My Company

 Project:  LAB17PROTECT
 FileName: LAB17PROTECT.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "lab17protect.inc"

domains

  intlist = integer*

predicates

  reverse(intlist, intlist, intlist).
  
  rec_len(integer, integer, intlist).
  len(integer, intlist).
  
  halfsOfList(intlist, intlist, intlist).
  
  n1Helper(intlist, intlist, intlist).
  n1(intlist, intlist).
  n2(intlist, intlist).
  n3(intlist, intlist).
  
  loop(intlist, intlist, intlist, integer, integer, intlist).
  merge(intlist, intlist, intlist).
  
  firstReversePair(intlist, intlist, intlist, integer, intlist).
  
clauses
  
  merge(L1, [H|T], Res) :- merge([H|L1], T, TmpRes), reverse(TmpRes, Res, []).
  merge(L1, [], L1).

  loop([H|T], L1, Acc, I, End, L2) :- I < End, NewI = I + 1, !, loop(T, L1, [H|Acc], NewI, End, L2).
  loop(T, L1, L1, _, _, T).
  
  halfsOflist(List, L1, L2) :-
          len(Len, List), 
          Center = Len div 2,
          loop(List, L1Tmp, [], 0, Center, L2Tmp),
          reverse(L1Tmp, L1, []),
          reverse(L2Tmp, L2, []).

  n2(List, Res) :- halfsOfList(List, L1, L2), merge(L2, L1, Res).
  n3(List, Res) :- halfsOfList(List, L1Tmp, L2), reverse(L1Tmp, L1, []), merge(L2, L1, Res).
   
  firstReversePair(Tail, Res, Res, 2, Tail).
  firstReversePair([H|T], Res, Acc, I, Tail) :- I < 2, NewI = I + 1, !, firstReversePair(T, Res, [H|Acc], NewI, Tail).
  
  n1Helper([], Res, Res).
  n1Helper([H|[]], Res, TmpRes) :- merge([H], TmpRes, Res2), reverse(Res2, Res, []).
  n1Helper(List, Res, L) :- firstReversePair(List, TmpRes, [], 0, Tail), merge(L, TmpRes, NewRes), n1Helper(Tail, Res, NewRes).
  n1(List, Res) :- n1Helper(List, TmpRes, []), reverse(TmpRes, Res, []).

  rec_len(Res, Len, [_ | Tail]) :- NewLen = Len + 1, !, rec_len(Res, NewLen, Tail).
  rec_len(Res, Len, []) :- Res = Len.
  len(Res, List) :- rec_len(Res, 0, List).

  reverse([],Z,Z).
  reverse([H|T],Z,Acc) :- reverse(T,Z,[H|Acc]).

goal

  %len(Res, [1, 2, 3, 4, 5, 6]).
  %reverse([1, 2, 3, 4, 5, 6], Res, []).
  %halfsOfList([1, 2, 3, 4, 5, 6], L1, L2).
  %firstReversePair([1, 2, 3, 4, 5, 6], Res, [], 0, Tail).  
  
  %n2([1, 2, 3, 4, 5, 6], Res).
  %n2([1, 2, 3, 4, 5], Res).
  %n3([1, 2, 3, 4, 5, 6], Res).
  %n3([1, 2, 3, 4, 5], Res).
  
  n1([1, 2, 3, 4, 5, 6], Res).
  %n1([1, 2, 3, 4, 5], Res).