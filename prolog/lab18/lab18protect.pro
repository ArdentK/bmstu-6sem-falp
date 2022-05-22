/*****************************************************************************

		Copyright (c) My Company

 Project:  LAB18PROTECT
 FileName: LAB18PROTECT.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "lab18protect.inc"

domains

  name = symbol.
  human = human(name).
  
  list = symbol*.
  table = list*.

predicates

  battle(human, human, human).
  win(human, list, table, table).
  
  del(list, name, list).

clauses

  del([H|T], N, [H|TR]) :- H <> N, !, del(T, N, TR).
  del([_|T], N, Res) :- del(T, N, Res), !.
  del([], _, []).

  win(_, [], Res, Res).
  win(human(Name), List, Res, Acc) :- 
            battle(human(Name), human(Oppos), human(Name)), !,
            del(List, Name, TmpList), !, del(TmpList, Oppos, NewList),
            win(human(Oppos), NewList, Res, [[Name, Oppos]|Acc]), !,
            win(human(Name), NewList, Res, [[Name, Oppos]|Acc]), !.

  battle(human("A"), human("B"), human("A")).
  battle(human("A"), human("C"), human("C")).
  battle(human("B"), human("C"), human("B")).
  
  battle(human("A"), human("D"), human("A")).
  battle(human("A"), human("D"), human("D")).
  battle(human("B"), human("D"), human("B")).
  battle(human("B"), human("D"), human("D")).
  battle(human("C"), human("D"), human("C")).
  battle(human("C"), human("D"), human("D")).

goal

  %battle(human("A"), human("C"), human(Winner)).
  %del(["A", "B", "C", "D"], "A", Res).
  win(human("A"), ["A", "B", "C", "D"], Res, []).
