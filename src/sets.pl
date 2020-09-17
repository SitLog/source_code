/*******************************************************************************
    SitLog (Situation and Logic) 
    
    Copyright (C) 2012 UNAM (Universidad Nacional Autónoma de México)
    Copyright (C) 2012 Luis Pineda (http://turing.iimas.unam.mx/~lpineda/)
 
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

*********************************************************************************/

i_am_sets.

member_dots(dot(true,D1),[dot(true,D2)|T]) :-	
  equal_position(D1,D2).
member_dots(X,[_|T]):-		
  member_dots(X,T).

union_dots([],L,L).
union_dots([H|T],L,R):-		
  member_dots(H,L),
  !, 
  union_dots(T,L,R).
union_dots([H|T],L,[H|R]):-	
  union_dots(T,L,R).

/*
   standard set routines
*/
%member(X,[X|T]).
%member(X,[_|T]):-		member(X,T).
				

%% union([],L,L).
%% union([H|T],L,R):-		
%%   member(H,L),
%%   !, 
%%   union(T,L,R).
%% union([H|T],L,[H|R]):-		
%%   union(T,L,R).
	
%% intersection([],_,[]):-		
%%   !.
%% intersection([H|T],L,[H|R]):- 	
%%   member(H,L),
%%   !,
%%   intersection(T,L,R).
%% intersection([H|T],L,R):-	
%%   intersection(T,L,R).
	
difference([],_,[]).
difference([H|T],L,R):-		
  member(H,L),
  !,
  difference(T,L,R).
difference([H|T],L,[H|R]):-	
  difference(T,L,R).

power_set(SET,POWER_SET) :-
  %power set elements
  length(SET,LENGTH),
  M is 2**LENGTH,
  MAX is M - 1,
  reverse(SET,RSET),			
  next_set(RSET,LENGTH,MAX,[],POWER_SET),
  !.

next_set(_,_,0.0,PS,PS).
next_set(SET,L,N,CS,PS) :-	
  M is N - 1,
  next_set(SET,L,M,CS,NEXT),
  set_index(N,L,2,INDEX),
  I is L - 1,
  make_set(INDEX,I,SET,[],IDX_SET),
  append(NEXT,[IDX_SET],PS),
  !.

make_set(_,N,_,S,S) :- N < 0.			
make_set(INDEX,I,SET,HOLDS,IDX_SET) :-
  idx_object(I,INDEX,1),
  idx_object(I,SET,OBJ),
  append(HOLDS,[OBJ],NSET),
  J is I - 1,				
  make_set(INDEX,J,SET,NSET,IDX_SET),
  !.						
		
make_set(INDEX,I,SET,HOLDS,IDX_SET ) :-
  J is I - 1,
  make_set(INDEX,J,SET,HOLDS,IDX_SET),
  !.
/*
    Set(member,condition,bag)
*/

set(X,P,S):-			
  bag(X,P,B),
  setify(B,S).

setify([],[]).
setify([H|T],R):- 		
  member(H,T),
  !,
  setify(T,R).
setify([H|T],[H|R]):-		
  setify(T,R).

