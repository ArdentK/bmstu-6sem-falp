%exp([X]) --> [X].
%exp([H|T]) --> [H], oper, exp(T).

%oper --> [+].
%oper --> [-].
%%oper --> [*].
%oper --> [/].
%oper --> [''].


%ap(Numbers, Result, ToEval) :- 
%                    exp(Numbers, Expression, []),
%                    concat_atom([Result, =|Expression], At),
%                    term_to_atom(ToEval, At),
%                    call(ToEval).


%app(Numbers, Result, ToEval) :-
%                                        expression(Numbers, Expression, []),
%                                        concat_atom([Result, =:=|Expression], At),
%                                        term_to_atom(ToEval, At),
%                                        call(ToEval).

expression([X]) --> [X]. 
expression([H|T]) --> [H], op, expression(T).

op --> [+].
op --> [-].
op --> [*].
op --> [/].

op --> [" rem "].
op --> [" mod "].
op --> [" div "].
op --> [^].

op --> [''].


app(Numbers, Result, ToEval) :-
                                        expression(Numbers, Expression, []),
                                        concat_atom([Result, =:=|Expression], Atom),
                                        term_to_atom(ToEval, Atom),
                                        catch(ToEval, error(type_error(integer, _), _), fail).

arithmetic_puzzle(Numbers, Result, ToEval) :-
                                        permutation(Numbers, NumbersPerm),
                                        expression(NumbersPerm, Expression, []),
                                        concat_atom([Result, =:=|Expression], At),
                                        term_to_atom(ToEval, At),
                                        call(ToEval).
                                        
% Peters extension: we allow bracket constructions

number([X]) --> [X].
number([H|T]) --> [H], number(T).

expr_brackets(X) --> number(X).
expr_brackets([H|T])--> {append(Left, Right, T),
Right\=[]}, ['('],
expr_brackets([H|Left]), [')'], opbr, ['('],
expr_brackets(Right), [')'].

opbr --> [+].
opbr --> [-].
opbr --> [*].
opbr --> [/].

opbr --> [^].

arithmetic_puzzle_2(Numbers, Result, ToEval) :-
                                    permutation(Numbers, NumbersPerm),
                                    expr_brackets(NumbersPerm, Expression, []),
                                    concat_atom([Result, '=:= '|Expression], At),
                                    term_to_atom(ToEval, At),
                                    catch(ToEval, error(evaluation_error(zero_divisor),_), fail).

aap(Numbers, Result, ToEval) :-
                                    expr_brackets(Numbers, Expression, []),
                                    concat_atom([Result, '=:= '|Expression], Atom),
                                    term_to_atom(ToEval, Atom),
                                    catch(ToEval, error(type_error(integer, _), _), fail).
%we catch division by zero
