/*******************************************************************************
    SitLog (Situation and Logic) 
    
    Copyright (C) 2012 UNAM (Universidad Nacional Autónoma de México)
    Copyright (C) 2012  Luis Pineda (http://turing.iimas.unam.mx/~lpineda/)

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

i_am(gensym).

/* Create a new atom with a root provided and finishing
   with a unique number */

numsym(Root,Num,Atom) :-
  name(Root,Name1),
  integer_name(Num,Name2),
  append(Name1,Name2,Name),
  name(Atom,Name),
  !.

gensym(Root,Atom) :-
  get_num(Root,Num),
  name(Root,Name1),
  integer_name(Num,Name2),
  append(Name1,Name2,Name),
  name(Atom,Name),
  !.

get_num(Root,Num) :-
  /* This root encountered before */
  retract(current_num(Root,Num1)), !,
  Num is Num1 + 1,
  asserta(current_num(Root,Num)).

/* first time for this root */
get_num(Root,1) :- 
  asserta(current_num(Root,1)).

/* convert from an integer to a list of characters */

integer_name(Int,List) :- integer_name(Int,[],List).

integer_name(I,Sofar,[C|Sofar]) :-
  I < 10, !, C is I + 48.

integer_name(I,Sofar,List) :-
  Tophalf is I//10,
  Bothalf is I mod 10,
  C is Bothalf+48,
  integer_name(Tophalf,[C|Sofar],List).

