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

%%%%%%%%%%%%%%%%%%%%%%%%% Execution of basic actions rutines %%%%%%%%%%%%%%%%%%%%%%%%%
% Execution of action lists
%
% There are two kinds of basic actions acording to definition of the "break" as "si" o "no"
% While "break = yes" basic action is defined as a returning parameter in "Out_Args"
% and system call waits for the parameter before continues. It can be only one basic action 
% with "break = 1" in each arc
%
% Otherwise basic action is performed, process continues and is not defined by any returned  
% parameter.
%

%Action is a term
execute_actions_arc(Action) :- 
  %print('Atom'),nl,
  Action =.. [Action_ID|_],
  atom(Action_ID),
  '.' \== Action_ID,
  %print('Action_ID: '),print(Action_ID),nl,
  % Get Basic Actions definitions
  basic_actions(Basic_Actions),

  % Selects and execute the action
  execute_action(Action, Basic_Actions).
execute_actions_arc([]). 
execute_actions_arc(List_of_Actions) :-
  %print('List'),nl,
  basic_actions(Basic_Actions),

  % Exectute the list of actions
  execute_basic_actions(List_of_Actions, Basic_Actions).

execute_basic_actions([], _).
execute_basic_actions([Action|Rest_Actions], Basic_Actions) :-
  execute_action(Action, Basic_Actions),
  execute_basic_actions(Rest_Actions, Basic_Actions).
 
execute_action(Action, Basic_Actions) :-
  Action =.. [Action_ID|Args],
  %print('Action_ID: '),print(Action_ID),nl,
  %print('Args: '),print(Args),nl,

  % Check whether action is defined
  get_action_def(Action_ID, Basic_Actions, Basic_Action),
  %print('Basic_Actions: '),print(Basic_Actions),nl,
  %print('Action_ID: '),print(Action_ID),nl,
  %print('Basic_Action: '),print(Basic_Action),nl,

  manage_system_call(Action, Basic_Action).

% The action is not defined: finish (it is an expression in the arc already evaluated)
manage_system_call(_, []).

manage_system_call(Action, Basic_Action) :-

  % Get action's features
  get_feature_value(arity, Basic_Action, Arity),
  get_feature_value(mod, Basic_Action, Modality),
  get_feature_value(break, Basic_Action, Break), 
	
  %print('Action Features: '),nl,		
  %print('Action: '),print(Action),nl,
  %print('Arity: '),print(Arity),nl,
  %print('Modality: '), print(Modality), nl,
  %print('Break: '), print(Break), nl, 

  % Check arity action
  Action =.. [Action_ID|Args],

  %length_list(Args, N),
  %length_list(Arity, N),
 
  systems_service_call(Modality, Action, Break).

manage_system_call(_, _) :- 
  print('Fatal error: Wrong number of args in action def. '), 
  end_diag_manager.

% Get the definiton of action in Basic Actions
get_action_def(Action_ID, [], []).
get_action_def(Action_ID, [Current_Action|Rest_Actions], Current_Action) :-
  get_feature_value(id, Current_Action, Action_ID).
get_action_def(Action_ID, [_|Rest_Actions], Current_Action) :-
  get_action_def(Action_ID, Rest_Actions, Current_Action).
