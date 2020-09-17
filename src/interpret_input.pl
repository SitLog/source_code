/*******************************************************************************
    SitLog (Situation and Logic) 
    
    Copyright (C) 2012 Luis Pineda (http://turing.iimas.unam.mx/~lpineda/)
    Copyright (C) 2012 Lisset Salinas (http://turing.iimas.unam.mx/~liz)

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

%%%%%%%%%%%%%%%%%%%%%%%%% Test input interpreters code %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test_interpret_input(Situation_Type, _, _, [], _, non, empty, current_situation).

test_interpret_input(Situation_Type, History, List_Out_Pars, [Current_Arc|Rest_Arcs], Out_Par, Expressed_Intention, Action, Next_Situation) :-
  print('In situation type: '),print(Situation_Type),nl,
  select_input(Situation_Type, History, List_Out_Pars, [Current_Arc|Rest_Arcs], [], 
  Out_Par, Expressed_Intention, Action, Next_Situation, CArcs).

select_input(Situation_Type, History, [Out_Par|Rest_Pars], [Expectation:BAction => Next_Situation|Rest_Arcs], [], Out_Par, Expressed_Intention, Action, Next_Situation, CArcs) :-
  RCArcs = [Expectation:BAction => Next_Situation],
  append(Expectation_List, Expectation, Expectation),
  select_input(Situation_Type, History, [Out_Par|Rest_Pars], Rest_Arcs, 
  Expectation, Out_Par, Expressed_Intention, Action, Next_Situation, RCArcs),
  !.
select_input(Situation_Type, History, [Out_Par|Rest_Pars], [NExpectation:NAction => NNext_Situation|NRest_Arcs], Expectation_List, Out_Par, Expressed_Intention, Action, Next_Situation, CArcs) :-
  RCArcs = [NExpectation:NAction => NNext_Situation],
  NNExpectation = [NExpectation],
  append(Expectation_List,NNExpectation,Result),
  append(RCArcs,CArcs,RRCArcs),
  select_input(Situation_Type, History, [Out_Par|Rest_Pars], NRest_Arcs, Result, Out_Par, Expressed_Intention, Action, Next_Situation,RRCArcs),
  !.

select_input(Situation_Type, History, [Out_Par|Rest_Pars], [], Expectation_List, Out_Par, Expressed_Intention, Action, Next_Situation, CArcs) :-
  communicate_int(Situation_Type, History, [Out_Par|Rest_Pars], Expectation_List, Out_Par, 
  Satisfied_Expectation, Action, Next_Situation),
  member(Satisfied_Expectation:Action=>Next_Situation,CArcs),
  print('In select input Action: '),print(Action),nl,
  print('Next_Situation: '),print(Next_Situation),nl
.

communicate_int(Situation_Type, History, [Out_Par|_], Expectation, Out_Par, Satisfied_Expectation, Action, Next_Situation) :- 
  print('Expectations: '), print(Expectation), nl,
 
  communication_int(Situation_Type, Expectation, Satisfied_Expectation),
  print('Satisfied Expectation: '), print(Satisfied_Expectation), nl,
  input_values(History, Satisfied_Expectation, Satisfied_Expectation).

input_values(History, Expectation, Satisfied_Expectation) :-
  get_variables_in_expectation(Expectation, Vars),
  filter_duplicates(Vars, [], Variables),
  read_variables(Expectation, Variables),
  Satisfied_Expectation = Expectation.

% Expectation is a variable
get_variables_in_expectation(Expectation, [Expectation]) :-
  var(Expectation).

% Expectation is a list
get_variables_in_expectation(Expectation, Variables) :-
  Expectation =.. ['.'|_],
  listPreds2list(Expectation, L, [], Variables).

% Expectation is a term
get_variables_in_expectation(Expectation, Variables) :-
  listPreds2list([Expectation], L, [], Variables).
	
read_variables(_, []).
read_variables(Expectation, [H|T]) :-
  %print('Actual Expectation: '), print(Expectation),nl,
  %print('Give the value for the varible '), print(H), nl,
  read(H),
  read_variables(Expectation, T).
 
