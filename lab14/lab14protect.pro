/*****************************************************************************

		Copyright (c) My Company

 Project:  LAB14PROTECT
 FileName: LAB14PROTECT.PRO
 Purpose: No description
 Written by: Visual Prolog
 Comments:
******************************************************************************/

include "lab14protect.inc"

domains
   
   name, gender = symbol.
   human = human(name, gender).
 
 predicates
 
   isParent(human, human).
   isGrandparent(human, gender, human).
   isNParent(human, human, unsigned).
   
   isSibling(human, human).
   isSiblingMother(human, human).
   isSiblingFather(human, human).
   
   isSpouseParent(human, human).
   
   isCousin(human, human).
   
   isAncle(human, human).
   
   isMarried(human, human).
 
 clauses
 
   isMarried(human(NameM, GenderM), human(Name, Gender)) :-
   		isParent(human(Name, Gender), human(ChildName, _)),
   		isParent(human(NameM, GenderM), human(ChildName, _)),
   		NameM <> Name.
 
   isSibling(human(NameSibling, GenderSibling), human(Name, Gender)) :-
   		isParent(human(MotherName, woman), human(Name, Gender)),
   		isParent(human(FatherName, man), human(Name, Gender)),
   		isParent(human(MotherName, woman), human(NameSibling, GenderSibling)),
   		isParent(human(FatherName, man), human(NameSibling, GenderSibling)),
   		NameSibling <> Name.
   		
   isSiblingMother(human(NameSibling, GenderSibling), human(Name, Gender)) :-
   		isParent(human(MotherName, woman), human(Name, Gender)),
   		isParent(human(MotherName, woman), human(NameSibling, GenderSibling)),
   		NameSibling <> Name.
   		
   isSiblingFather(human(NameSibling, GenderSibling), human(Name, Gender)) :-
   		isParent(human(FatherName, man), human(Name, Gender)),
   		isParent(human(FatherName, man), human(NameSibling, GenderSibling)),
   		NameSibling <> Name.
 
   isGrandparent(human(GrandName, GrandGender), LineGender, human(Name, Gender)) :- 
   		isParent(human(GrandName, GrandGender), human(TmpName, LineGender)), 
   		isParent(human(TmpName, LineGender), human(Name, Gender)).
   		
   isSpouseParent(human(NameF, GenderF), human(Name, Gender)) :-
   		isParent(human(Name, Gender), human(NameChild, GenderChild)),
   		isParent(human(NameS, GenderS), human(NameChild, GenderChild)),
   		NameS <> Name,
   		isParent(human(NameF, GenderF), human(NameS, GenderS)).
   
   isCousin(human(NameC, GenderC), human(Name, Gender)) :-
   		isParent(human(NameP, _), human(Name, Gender)),
   		isSibling(human(SiblingName, _), human(NameP, _)),
   		isParent(human(SiblingName, _), human(NameC, GenderC)).
   		
   isAncle(human(NameA, GenderA), human(Name, Gender)) :-
   		isParent(human(NameP, _), human(Name, Gender)),
   		isSibling(human(NameA, GenderA), human(NameP, _)),
   		NameA <> NameP.
   	
   isNParent(human(ParentName, ParentGender), human(Name, Gender), N) :- 
   		N=0, 
   		isParent(human(ParentName, ParentGender), human(Name, Gender)).
   	
   isNParent(human(ParentName, ParentGender), human(Name, Gender), N) :- 
   		N=1,
   		isGrandparent(human(ParentName, ParentGender), _, human(Name, Gender)).
   
   isNParent(human(ParentName, ParentGender), human(Name, Gender), N) :- 
   		N>1, 
   		M=N-2,
   		isNParent(human(ParentName, ParentGender), human(TmpName, TmpGender), M),
   		isGrandparent(human(TmpName, TmpGender), _, human(Name, Gender)).
 
   isParent(human("Kek", woman), human("Ololo", woman)).
   isParent(human("Cheburek", man), human("Ololo", woman)).
   
   isParent(human("Kek", woman), human("NoOlolo", man)).
   isParent(human("Cheburek", man), human("NoOlolo", man)).
   
   isParent(human("Kek", woman), human("AAAAAA", man)).
   isParent(human("Cheburek2", man), human("AAAAAA", man)).
   
   isParent(human("Kek2", woman), human("Komo", man)).
   isParent(human("Cheburek", man), human("Komo", man)).
   
   isParent(human("Lol", man), human("Kek", woman)).
   isParent(human("Anna", woman), human("Kek", woman)).
   
   isParent(human("Lol", man), human("Apolon", man)).
   isParent(human("Anna", woman), human("Apolon", man)).
   
   isParent(human("Kukuruza", man), human("Lol", man)).
   isParent(human("Kapusta", woman), human("Lol", man)).
   
   isParent(human("Beliash", woman), human("Cheburek", man)).
   isParent(human("Pirodzok", man), human("Cheburek", man)).
   
   isParent(human("Beliash", woman), human("Mumu", man)).
   isParent(human("Pirodzok", man), human("Mumu", man)).
   
   isParent(human("Beliash", woman), human("Python", woman)).
   isParent(human("Pirodzok", man), human("Python", woman)).
   
   isParent(human("AAAAAAA", man), human("Zmeya", woman)).
   isParent(human("Python", woman), human("Zmeya", woman)).
   
   isParent(human("Stich", man), human("Pirodzok", man)).
   isParent(human("Lilo", woman), human("Pirodzok", man)).
   
   isParent(human("Stich", man), human("Genshin", man)).
   isParent(human("Lilo", woman), human("Genshin", man)).
   
   isParent(human("Genshin", man), human("Dima", man)).
   isParent(human("Sveta", woman), human("Dima", man)).
   
   isParent(human("Dima", man), human("Ira", woman)).
   isParent(human("Liza", woman), human("Ira", woman)).
 
 goal
   %isNParent(human(Human, woman), human("Ololo", woman), 2).
   %isSibling(human(Name, man), human("Ololo", woman)).
   %isSiblingMother(human(Name, Gender), human("Ololo", woman)).
   %isSiblingFather(human(Name, Gender), human("Ololo", woman)).
   %isSpouseParent(human(NameA, GenderA), human("Cheburek2", man)).
   %isCousin(human(NameC, GenderC), human("Ololo", woman)).
   %isAncle(human(NameA, GenderA), human("Ololo", woman)).
   isMarried(human(NameM, GenderM), human("Kek2", woman)).