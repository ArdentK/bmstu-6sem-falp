:- use_module(library(clpfd)).

operation("+",A,B,R):-R#=A+B.
operation("-",A,B,R):-R#=A-B.
operation("*",A,B,R):-R#=A*B.
operation("mod",A,B,R):-R#=A mod B.
eqq([Res],[],Res).
eqq([A,B|Lst], [Op|Solver], Res):- operation(Op,A,B,R),
				eqq([R|Lst],Solver,Res).
equation(Coeffs, Solver, Res) :- equation_helper(Coeffs, Solver, 0, Res).
   
equation_helper([H|[M|T]], Solver, 0, ["+"|Res]) :- 
    NewAcc #= H + M, 
    equation_helper(T, Solver, NewAcc, Res).
equation_helper([H|[M|T]], Solver, 0, ["-"|Res]) :- 
    NewAcc #= H - M, 
    equation_helper(T, Solver, NewAcc, Res).
equation_helper([H|[M|T]], Solver, 0, ["*"|Res]) :- 
    NewAcc #= H * M, 
    equation_helper(T, Solver, NewAcc, Res).
equation_helper([H|[M|T]], Solver, 0, ["div"|Res]) :- 
    NewAcc #= H div M, 
    equation_helper(T, Solver, NewAcc, Res).
equation_helper([H|[M|T]], Solver, 0, ["mod"|Res]) :- 
    NewAcc #= H mod M, 
    !, 
    equation_helper(T, Solver, NewAcc, Res).

equation_helper([H|T], Solver, Acc, ["+"|Res]) :- 
    NewAcc #= Acc + H, 
    equation_helper(T, Solver, NewAcc, Res).
equation_helper([H|T], Solver, Acc, ["-"|Res]) :- 
    NewAcc #= Acc - H, 
    equation_helper(T, Solver, NewAcc, Res).
equation_helper([H|T], Solver, Acc, ["*"|Res]) :- 
    NewAcc #= Acc * H, 
    equation_helper(T, Solver, NewAcc, Res).
equation_helper([H|T], Solver, Acc, ["div"|Res]) :- 
    NewAcc #= Acc div H, 
    equation_helper(T, Solver, NewAcc, Res).
equation_helper([H|T], Solver, Acc, ["mod"|Res]) :- 
    NewAcc #= Acc mod H, 
    equation_helper(T, Solver, NewAcc, Res).

equation_helper([], Solver, Acc, Res) :- 
    Solver = Acc, 
    Res = [].

%?-equation([5, 2, 3, 7, 8], 2, Res).



expression([X]) --> [X]. 
expression([H|T]) --> [H], op, expression(T).

op --> [+]|[-]|[*]|[/].
op --> [" rem "]|[" mod "]|[" div "]|[^]|[''].

app(Numbers, Result, ToEval) :-
                        expression(Numbers, Expression, []),
                        concat_atom([Result, =:=|Expression], Atom),
                        term_to_atom(ToEval, Atom),
                        catch(ToEval, error(type_error(integer, _), _), fail).
                        
