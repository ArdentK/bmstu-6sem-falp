% Удаление элемента из списка
del([H|T], N, [H|TR]) :- H =\= N, del(T, N, TR).
del([_|T], N, Res) :- del(T, N, Res).
del([], _, []).

notIn(_, []) :- !.
notIn(Elem, [H|T]) :- Elem =\= H, notIn(Elem, T).

battle("A", "B", "A").
battle("A", "C", "C").
battle("B", "C", "B").
 
battle("A", "D", "A").
battle("A", "D", "D").
battle("B", "D", "B").
battle("B", "D", "D").
battle("C", "D", "C").
battle("C", "D", "D").

round([], Res, Res, _, NW, NW) :- !.
round([H|T], Res, Acc, Partic, NW, W) :-
    battle(H, Oppos, H),
    del(Partic, Oppos, NewPartic),
    notIn(Oppos, T),
    notIn(Oppos, W),
    NewW = [H, Oppos | W],
    NewAcc = [(H, Oppos) | Acc],
    round(T, Res, NewAcc, NewPartic, NW, NewW).

winHelper(_, ResAll, ResAll, []) :- !.
winHelper(Winners, ResAll, Acc, Partic) :-
    round(Winners, Res, [], Partic, NewWinners, []),
    write(Partic),
    NewAcc = [Res | Acc],
    Partic = [],
    winHelper(NewWinners, ResAll, NewAcc, Partic).

win(Name, Res, Acc, Partic) :-
    winHelper([Name], Res, Acc, Partic).
