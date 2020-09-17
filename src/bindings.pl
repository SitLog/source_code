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

%%%%%%%%%%%%%%%%%%%%%%%%% Utilites for variable bindings %%%%%%%%%%%%%%%%%%%%%%%%%
substitute_variables(Structure, New_Structure) :-
  listPreds2list(Structure, L, [], V),
  filter_duplicates(V, [], Variables),
  get_new_variables(Variables, New_Variables),
  replace_variables(Variables, New_Variables, Structure, New_Structure).

% Bind two list of variables or terms skiping pairs that cannot be unified
bind_vars([],[]).
bind_vars([H|T1],[H|T2]) :-
	    bind_vars(T1,T2).
bind_vars([_|T1],[_|T2]) :-
	    bind_vars(T1,T2).

get_new_variables([],[]).

get_new_variables([H|T],[NH|NT]) :-
  get_new_variables(T, NT).
		
replace_variables([],[],E,E).

replace_variables([H|T],[NH|NT], Exp, NExp) :-
  change_variable(H, NH, Exp, Next_Exp),
  replace_variables(T, NT, Next_Exp, NExp).

change_variable(VAR,NVAR,[],[]).

change_variable(VAR,NVAR,[H|T],NEXPS) :-
  change_var_exp(VAR,NVAR,H,NEXP),
  change_variable(VAR,NVAR,T,REST_EXPS),
  append([NEXP],REST_EXPS,NEXPS).

change_var_exp(VAR, NVAR, EXP, NEXP) :-
  var(EXP),
  VAR == EXP,
  NEXP = NVAR.

change_var_exp(VAR, NVAR, EXP, EXP) :-
  var(EXP).

change_var_exp(VAR, NVAR, EXP, NEXP) :-
  nonvar(EXP),
  EXP =.. [FUNC|ARGS],
  change_var_args(VAR, NVAR, ARGS, NARGS),
  NEXP =.. [FUNC|NARGS].

change_var_args(VAR, NVAR, [], []).

change_var_args(VAR, NVAR, [H|T], NARGS) :-
  change_var_exp(VAR, NVAR, H, NEXP),
  change_var_args(VAR, NVAR, T, REXPS),
  append([NEXP],REXPS,NARGS).

%%%%%%% Terms predicate structure %%%%%%%%%%%%%%%

ground_term(TERM,false) :- var(TERM).

ground_term(TERM,true) :- atom(TERM).

ground_term(EXP,VAL) :- 
  nonvar(EXP),
  EXP =.. [FUNC|ARGS],
  ground_args(ARGS,VAL).

ground_term(EXP,false).

ground_args([],true).

ground_args([H|T],true) :-
  ground_term(H,true),
  ground_args(T,true).

ground_args(_,false).


%%%%%%% Predicates for obtainig term variables %%%%%%%%%%%%%%%

%Predicate to convert a list of terms into a list
%Terms are variables, atoms, nummers or predicates
%Predicates can be any number of arguments,
%this arguments can be terms or lists of terms

%Predicate returns a variable list into the predicate from left to right
%Into exit list is inserted an id for every variable of form "varId" (e.g. "var1")
%also from left to right
 
%"VarsIn" argument starts with an empty list (when the predicate is called)

%Base case
listPreds2list([],[],Vars,Vars).

% if actual element is a variable
listPreds2list([Var|RestPreds],ListPreds,VarsIn,VarsOut) :-
  var(Var),
  gensym(var,VarId),
  name(VarId,VarIdList),
  append(VarsIn,[Var],FrontVars),	
  listPreds2Rest(VarIdList, RestPreds, ListPreds, FrontVars, VarsOut).

listPreds2Rest(StringH, RestPreds, ListPreds, FrontVars, VarsOut) :-
  listPreds2list(RestPreds, Rest, FrontVars, VarsOut),
  add_comma(StringH, Rest, StringH_Comma),
  append(StringH_Comma, Rest, ListPreds),!.

% if actual element is an atom or number 
listPreds2list([HPred|RestPreds],ListPreds,VarsIn,VarsOut) :-
  (atom(HPred);number(HPred)),
  name(HPred,ListHPred),
  listPreds2Rest(ListHPred, RestPreds, ListPreds, VarsIn, VarsOut).

% if actual element is a dot pair
listPreds2list([[H|T]|RestList], ListPreds, VarsIn, VarsOut) :-
  listPreds2list([H], ListPredsH, VarsIn, VarsCont),
  listPreds2list([T], ListPredsT, VarsCont, VarsCont1),
  name('|', Bar),
  append(ListPredsH, Bar, ListPredsBar),
  append(ListPredsBar, ListPredsT, ListPredsHead),
  listPreds2Rest(ListPredsHead, RestList, ListPreds, VarsCont1, VarsOut).

% if actual element is a list
listPreds2list([ListH|T],ListPreds,VarsIn,VarsOut) :-
  is_list(ListH,ok),
  name('[',Izq),
  name(']',Der),
  listPreds2list(ListH,ListPredsH,VarsIn,VarsCont),
  append(Izq,ListPredsH,ListPredsHIzq),
  append(ListPredsHIzq,Der,ListPar),
  listPreds2Rest(ListPar, T, ListPreds, VarsIn, VarsOut).

% if actual element is a predicate
listPreds2list([HPred|RestPreds],ListPreds,VarsIn,VarsOut) :-
  pred2list(HPred,ListHPred,VarsIn,VarsCont),
  listPreds2list(RestPreds,Rest,VarsCont,VarsOut),
  add_comma(ListHPred,Rest,ListHPredComma),
  append(ListHPredComma,Rest,ListPreds),!.

pred2list(Pred, List, VarsIn, VarsOut) :-
  Pred =.. [Func|Args],
  name(Func,LFunc),
  listPreds2list(Args,ListArgs,VarsIn, VarsOut),
  name('(',Izq),
  name(')',Der),
  append(Izq,ListArgs,ArgsIzq),
  append(ArgsIzq,Der,ArgsDer),
  append(LFunc,ArgsDer,List),!.
  
% auxiliary routines

% Build a list of N new variables 
bild_list_N_vars(0, List, List).

bild_list_N_vars(N, Acc, List) :-
  M is N - 1,
  append([V], Acc, New_Acc),
  bild_list_N_vars(M, New_Acc, List).

is_list(X,no) :- 
  var(X);atom(X);number(X).

is_list([],ok).

is_list([_|T],ok) :-
  is_list(T,ok),!.
  
add_comma(Symbol,[],Symbol).

add_comma(Symbol,_,SymbolComma) :- 
  name(',',Comma),
  append(Symbol,Comma,SymbolComma),!.

