/*****************************************************************************

		Copyright (c) My Company

 Project:  LAB15PROTECT
 FileName: LAB15PROTECT.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "lab15protect.inc"

domains

  num = integer

predicates

  min2(num, num, num).

  min4(num, num, num, num, num).
  min4clipping(num, num, num, num, num).
  min4clipping2(num, num, num, num, num).

clauses

  min2(N1, N2, N2) :- N2 <= N1.
  min2(N1, N2, N1) :- N1 <= N2.

  min4(N1, N2, N3, N4, Res) :-
          min2(N1, N2, Tmp1),
          min2(N3, N4, Tmp2),
          min2(Tmp1, Tmp2, Res).
          
  min4clipping(N1, N2, N3, N4, N4) :- N4 <= N3, N4 <= N2, N4 <= N1, !.
  min4clipping(N1, N2, N3, _, N3) :- N3 <= N2, N3 <= N1, !.
  min4clipping(N1, N2, _, _, N2) :- N2 <= N1, !.
  min4clipping(N1, _, _, _, N1).
  
  min4clipping2(N1, N2, N3, N4, N4) :- N4 <= N3, N4 <= N2, N4 <= N1.
  min4clipping2(N1, N2, N3, _, N3) :- N3 <= N2, N3 <= N1.
  min4clipping2(N1, N2, _, _, N2) :- N2 <= N1.
  min4clipping2(N1, _, _, _, N1).

goal

  %min4(1, 2, 3, 4, Min).
  %min4(4, 3, -100, 2, Min).
  %min4(1, -100, 3, 4, Min).

  %min4clipping(1, 2, 3, 4, Min).
  %min4clipping(3, 4, -100, 1, Min).
  
  min4clipping2(3, 4, -100, 1, Min).
  %min4clipping2(-200, 4, -100, 1, Min).
