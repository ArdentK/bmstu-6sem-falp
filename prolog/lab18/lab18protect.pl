battle("A", "B", "A").
battle("A", "C", "C").
battle("B", "C", "B").
 
battle("A", "D", "A").
battle("A", "D", "D").
battle("B", "D", "B").
battle("B", "D", "D").
battle("C", "D", "C").
battle("C", "D", "D").

battle("A", "E", "A").
battle("A", "E", "E").
battle("B", "E", "B").
battle("B", "E", "E").
battle("C", "E", "C").
battle("C", "E", "E").
battle("D", "E", "D").
battle("D", "E", "E").

battle("A", "F", "A").
battle("A", "F", "F").
battle("B", "F", "B").
battle("B", "F", "F").
battle("C", "F", "C").
battle("C", "F", "F").
battle("D", "F", "D").
battle("D", "F", "F").

battle("A", "G", "A").
battle("A", "G", "G").
battle("B", "G", "B").
battle("B", "G", "G").
battle("C", "G", "C").
battle("C", "G", "G").
battle("D", "G", "D").
battle("D", "G", "G").

battle("A", "H", "A").
battle("A", "H", "H").
battle("B", "H", "B").
battle("B", "H", "H").
battle("C", "H", "C").
battle("C", "H", "H").
battle("D", "H", "D").
battle("D", "H", "H").

del([H|T], N, [H|TR]) :- H =\= N, del(T, N, TR).
del([_|T], N, Res) :- del(T, N, Res).
del([], _, []).

notIn(_, []) :- !.
notIn(Elem, [H|T]) :- Elem =\= H, notIn(Elem, T).

in(Elem, [Elem|_]) :- !.
in(Elem, [H|T]) :- Elem =\= H, in(Elem , T).

deleteList([], List, List) :- !.
deleteList([H|T], List, Res) :- 
    del(List, H, NewList),
    deleteList(T, NewList, Res), !.

round([], Res, Res, NW, NW) :- !.
round([H|T], Res, Acc, NW, W) :-
    battle(H, Oppos, H),
    %del(Partic, Oppos, NewPartic),
    notIn(Oppos, T),
    notIn(Oppos, W),
    NewW = [H, Oppos | W],
    NewAcc = [(H, Oppos) | Acc],
    round(T, Res, NewAcc, NW, NewW).

winHelper(_, ResAll, ResAll, []) :- !.
winHelper(Winners, ResAll, Acc, Partic) :-
    round(Winners, Res, [], NewWinners, []),
    NewAcc = [Res | Acc],
    deleteList(NewWinners, Partic, NewP),
    winHelper(NewWinners, ResAll, NewAcc, NewP).

win(Name, Res, Partic) :-
    winHelper([Name], Res, [Name], Partic).


%?- win("A", R, ["A", "B", "C", "D", "E", "F", "G", "H"]).
%?- win("A", R, ["A", "B", "C", "D"]).
