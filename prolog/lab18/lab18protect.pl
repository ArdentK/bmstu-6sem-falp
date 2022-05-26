battle("B", "A", "A").
battle("C", "A", "C").
battle("D", "A", "A").
battle("D", "A", "D").
battle("E", "A", "A").
battle("E", "A", "E").
battle("F", "A", "A").
battle("F", "A", "F").
battle("G", "A", "A").
battle("G", "A", "G").
battle("H", "A", "A").
battle("H", "A", "H").

battle("A", "B", "A").
battle("C", "B", "B").
battle("D", "B", "B").
battle("D", "B", "D").
battle("E", "B", "B").
battle("E", "B", "E").
battle("F", "B", "B").
battle("F", "B", "F").
battle("G", "B", "B").
battle("G", "B", "G").
battle("H", "B", "B").
battle("H", "B", "H").

battle("A", "C", "C").
battle("B", "C", "B").
battle("D", "C", "C").
battle("D", "C", "D").
battle("E", "C", "C").
battle("E", "C", "E").
battle("F", "C", "C").
battle("F", "C", "F").
battle("G", "C", "C").
battle("G", "C", "G").
battle("H", "C", "C").
battle("H", "C", "H").
 
battle("A", "D", "A").
battle("A", "D", "D").
battle("B", "D", "B").
battle("B", "D", "D").
battle("C", "D", "C").
battle("C", "D", "D").
battle("E", "D", "E").
battle("E", "D", "D").
battle("F", "D", "F").
battle("F", "D", "D").
battle("G", "D", "G").
battle("G", "D", "D").
battle("H", "D", "H").
battle("H", "D", "D").

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
battle("E", "F", "E").
battle("E", "F", "F").
battle("G", "F", "G").
battle("G", "F", "F").
battle("H", "F", "H").
battle("H", "F", "F").

battle("A", "G", "A").
battle("A", "G", "G").
battle("B", "G", "B").
battle("B", "G", "G").
battle("C", "G", "C").
battle("C", "G", "G").
battle("D", "G", "D").
battle("D", "G", "G").
battle("E", "G", "E").
battle("E", "G", "G").
battle("F", "G", "F").
battle("F", "G", "G").
battle("H", "G", "H").
battle("H", "G", "G").

battle("A", "H", "A").
battle("A", "H", "H").
battle("B", "H", "B").
battle("B", "H", "H").
battle("C", "H", "C").
battle("C", "H", "H").
battle("D", "H", "D").
battle("D", "H", "H").
battle("E", "H", "E").
battle("E", "H", "H").
battle("F", "H", "F").
battle("F", "H", "H").
battle("G", "H", "G").
battle("G", "H", "H").

del([], _, []).
del([H|T], N, [H|TR]) :- H =\= N, del(T, N, TR).
del([_|T], N, Res) :- del(T, N, Res), !.

notIn(_, []).
notIn(Elem, [H|T]) :- Elem =\= H, notIn(Elem, T).

in(Elem, [Elem|_]).
in(Elem, [H|T]) :- Elem =\= H, in(Elem , T).

deleteList([], _, []) :- !.
deleteList([H|T], List, [H|TR]) :- notIn(H, List), deleteList(T, List, TR).
deleteList([_|T], List, Res) :- deleteList(T, List, Res), !.

round([], Res, Res, NW, NW, _) :- !.
round([H|T], Res, Acc, NW, W, Partic) :-
    battle(H, Oppos, H),
    notIn(Oppos, T),
    notIn(Oppos, W),
    in(Oppos, Partic),
    NewW = [H, Oppos | W],
    NewAcc = [(H, Oppos) | Acc],
    round(T, Res, NewAcc, NW, NewW, Partic).

winHelper(_, ResAll, ResAll, []) :- !.
winHelper(Winners, ResAll, Acc, Partic) :-
    round(Winners, Res, [], NewWinners, [], Partic),
    NewAcc = [Res | Acc],
    deleteList(Partic, NewWinners, NewP),
    winHelper(NewWinners, ResAll, NewAcc, NewP).

win(Name, Res, Partic) :-
    winHelper([Name], Res, [Name], Partic).


%?- win("A", R, ["A", "B", "C", "D", "E", "F", "G", "H"]).
%?- win("A", R, ["A", "B", "C", "D"]).
