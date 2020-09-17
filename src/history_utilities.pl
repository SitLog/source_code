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

% History format:
% list of objets of form: 
%
%	[Dialogue_ID:(Situation_ID,Concrete_Expectation:Concrete_Action),] 
%
% Embedded DM are enclosed in a stack structure according to the structure of the current task
%
%	[history_entry, history_entry]
%
% The history of the interaction is accessible from the body of user_functions with the predicate:
%
%	get_history(History)
% 
% where the first element is the initial transition in the main DM and 
% the last is the previous transition in the current DM


% Collect transitions in current DM since the begging or the last embedded DM 
get_current_DM([], []).
get_current_DM(History, Current_DM) :-
  reverse(History, Rev_History),
  get_current_DM_Transitions(Rev_History, Current_DM).

% Collect transitions until a list is found or the list is empty
get_current_DM_Transitions([], []).
get_current_DM_Transitions([[]|_], []).
get_current_DM_Transitions([List|_], []) :-
  List =.. ['.'|_].
get_current_DM_Transitions([H|T], Current_DM) :-
  get_current_DM_Transitions(T, Rest),
  append(Rest, [H], Current_DM).

% Get last transition in current DM
get_last_transition([], none).
get_last_transition(History, Exp:Act) :-
  get_current_DM(History, Current_DM),
  reverse(Current_DM, [_:(_,Exp:Act)|Rest]).

% Get last situation in current DM
get_last_situation([], none).
get_last_situation(History, Last_Sit) :-
  get_current_DM(History, Current_DM),
  get_current_DM(History, [_:(Last_Sit,_)|Rest]).



