expression([X]) --> [X]. 
expression([H|T]) --> [H], op, expression(T).

op --> [+]|[-]|[*]|[/].
op --> [" rem "]|[" mod "]|[" div "]|[^]|[''].

app(Numbers, Result, ToEval) :-
                        expression(Numbers, Expression, []),
                        concat_atom([Result, =:=|Expression], Atom),
                        term_to_atom(ToEval, Atom),
                        catch(ToEval, error(type_error(integer, _), _), fail).
