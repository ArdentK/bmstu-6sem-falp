do(L, S) :-
    put_arit(L, S, A),
    printer(A, S).

put_arit(L, S, A) :-                %Finds a solution (+Number list, +Sum, -Solution)
    gen(L, Ls),
    atomic_list_concat(Ls, A),
    read_term_from_atom(A, T, []),
    T =:= S.

printer(A, S) :-                    %Writes solutions to console
      writef('%w = %w\n',[A,S]),
      fail.

gen([X], [X]).                      %Generates all possible combinations
gen([H|T], L) :-
    ( L = [H|[+|Ns]]; L = [H|[-|Ns]];  L = [H|Ns]),
    gen(T, Ns).


%Example:
% ?- do([1,2,3], 6).
% 1+2+3 = 6;
% false.
