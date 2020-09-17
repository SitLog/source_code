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

:- assert(operators_on_variables([get,set,inc])).
:- assert(arithmetic_pred(['==', '\\==', '>', '<', '>=', '=<'])).
:- assert(list_operators([append, reverse, length_list, first, rest, last, rotate_list, push, pop, filter_element, filter_duplicates, idx_object, get_options, get_random_element, empty_list, print_list, msg_format, cam2nav, cam2arm, timeOver, statistics, arrived_posit])).
:- assert(list_predicates([member, not_member])).

clean_ops :- retract(operators_on_variables(Op_List)).

% evaluates every element variable in the list
eval_list_of_terms([], Evaluated_Terms, Evaluated_Terms, Local_Vars, Local_Vars, Global_Vars, Global_Vars,_).
eval_list_of_terms([], [], Evaluated_Terms, Local_Vars, Local_Vars, Global_Vars, Global_Vars,_).

eval_list_of_terms([Term|T], Acc_Values, Evaluated_Terms, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History) :-
  eval_term(Term, Value, In_Local_Vars, New_Local_Vars, In_Global_Vars, New_Global_Vars, History),
  %print('Eval list New_Local_Vars: '),print(New_Local_Vars),nl,
  %print('Term: '),print(Term),nl,
  append(Acc_Values, [Value], New_Acc_Values),
  eval_list_of_terms(T, New_Acc_Values, Evaluated_Terms, New_Local_Vars, Out_Local_Vars, 
  New_Global_Vars, Out_Global_Vars, History).

eval_list_of_terms(L, Acc, Evaluated_Terms, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars,_) :-
  print('Error in eval_list_of_terms '),nl,
  print('Ilegal list of terms: '),nl,
  (print_list(L);print(L),nl),
  end.

% Term is a Variable
eval_term(Term, Term, Local_Vars, Local_Vars, Global_Vars, Global_Vars, _) :- 
  var(Term).

% Term is a number	
eval_term(Term, Term, Local_Vars, Local_Vars, Global_Vars, Global_Vars, _) :- 
  number(Term).

% Term is an atom
eval_term(Term, Term, Local_Vars, Local_Vars, Global_Vars, Global_Vars, _) :- 
  atom(Term).

% Variable assignation 
eval_term(assign(Var, Body), Val, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History) :-
  var(Var),
  eval_term(Body, Val, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History),

  % assign variable value
  Var = Val.

eval_term(assign(Var, Body), _, _, _, _, _, _) :-
  print('error in assigning: '),
  print(Var),print(' it is not a variable '),nl,
  end.

% Unification
eval_term(X=Y,  X, Local_Vars, Local_Vars, Global_Vars, Global_Vars, _) :- 
  X = Y.

eval_term(X=Y, _, _, _, _, _, _) :-
  print('Unification error: X & Y are not unificable'),
  print('X = '),print(X),nl,
  print('Y = '),print(Y),nl,
  end.

% Term "is" (i.e. arithmetic op; the arguments must be grounded)
eval_term(Term, Val, Local_Vars, Local_Vars, Global_Vars, Global_Vars,_) :- 
  Term =.. [is|[Val, Body]],

  % Execute op.
  Term.

% Term is an opertion on lists
eval_term(Term, Val, Local_Vars, Local_Vars, Global_Vars, Global_Vars,_) :- 
  list_operators(List_Ops),
  Term =.. [OP|Args],
  member(OP, List_Ops),

  % Execute append operation
  Term,

  % The value is the last argument of the list op.
  last(Args, Val).

% Term is list predicate
eval_term(Term, Val, Local_Vars, Local_Vars, Global_Vars, Global_Vars,_) :- 
  list_predicates(List_Ops),
  Term =.. [OP|Args],
  member(OP, List_Ops),

  % Execute append operation
  verify_predicate_value(Term, Val).

verify_predicate_value(Term, true) :- Term.
verify_predicate_value(Term, false).

% Term is "append"
%eval_term(Term, Val, Local_Vars, Local_Vars, Global_Vars, Global_Vars,_) :- 
%  Term =.. [append|Args],
% Execute append operation
% Term,
%Val = Term.

%  Term is "append"
%  eval_term(Term, Val, Local_Vars, Local_Vars, Global_Vars, Global_Vars,_) :- 
%  Term =.. [member|Args],
%  % Execute append operation
%  Term,
%  Val = Term.

%  Term es "reverse"
%  eval_term(Term, Val, Local_Vars, Local_Vars, Global_Vars, Global_Vars,_) :- 
%  Term =.. [reverse|Args],
%  Execute reverse operation
%  Term,
%  Val = Term.

% Term is an arithmetic predicate
eval_term(Term, Val, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History) :- 
  Term =.. [OP|Args],
  arithmetic_pred(Arith_Pred),
  member(OP, Arith_Pred),
  eval_list_of_terms(Args, [], Evaluated_Args, In_Local_Vars, Out_Local_Vars, In_Global_Vars,  
  Out_Global_Vars, History),
  New_Term =.. [OP|Evaluated_Args], !,	
	
  % Execute term
  execute_arith_pred(New_Term, Val).

execute_arith_pred(Term, true) :- Term.
execute_arith_pred(Term, false).

% Term is a condicional if C then P else Q
eval_term(Term, Val, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History) :- 
  Term =.. [';'|[Then_Part, Else_Part]],
  Then_Part =.. ['->'|[Cond, Body1]],
  Else_Part =.. ['->'|[otherwise, Body2]],

  % Evaluate the conditional
  Cond =.. [OP|Args],
  %print('In eval term conditional '),nl,
  eval_list_of_terms(Args, [], Evaluated_Args, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, 
  History),
  New_Cond =.. [OP|Evaluated_Args], !,

  execute_if(New_Cond, Body1, Body2, Val, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History).   

%Term is a predicate 
eval_term(Term, Val, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History) :- 

  Term =.. [Pred|Args],
  atom(Pred),
  Pred \== '.', % it is not a list
  Pred \== apply,
  operators_on_variables(Local_Ops),
  not_member(Pred, Local_Ops),
  eval_list_of_terms(Args, [], Evaluated_Args, In_Local_Vars, New_Local_Vars, In_Global_Vars, New_Global_Vars, 
  History),
  ( Args == [],
    Val = Pred
  | otherwise,
    Val =.. [Pred|Evaluated_Args]
  ),
	    
  % Spreads In to Out
  Out_Local_Vars = New_Local_Vars,
  Out_Global_Vars = New_Global_Vars
  .

%Term is a function
eval_term(apply(Func, Pars), Func_Value, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History) :-

  print('In eval fun. '),nl,
  print('In Local Vars: '),print(In_Local_Vars),nl,

  % Evaluates parameter list
  eval_list_of_terms(Pars, [], Val_Pars, In_Local_Vars, New_Local_Vars, In_Global_Vars, New_Global_Vars, History),

  print('New Local Vars: '),print(New_Local_Vars),nl,
  %print('Func: '),print(Func),nl,

  % Replace variables and links arguments
  Func =.. [Name|Args],
  get_new_variables(Args, NArgs),
  replace_variables(Args, NArgs, [Func], [NFunc]),
  bind_vars(Val_Pars, NArgs),

  %print('NFunc: '),print(NFunc),nl,

  % Evaluates function body
  % Value must be assign with 
  %
  %	assign_func_value(Func_Value)
  %
  % in the function body "Func"
  %
  % Variables In_Local_Vars and Out_Local_Vars are accessed in function body 

  % Creates function evaluation enviorment
  assert(current_local_vars(New_Local_Vars)),
  assert(current_global_vars(New_Global_Vars)),
  assert(current_history(History)),

  NFunc,
	  
  % Eliminates function evaluation enviorment
  retract(current_local_vars(Out_Local_Vars)),
  retract(current_global_vars(Out_Global_Vars)),
  retract(current_history(History)),
  %print('Out Local Vars: '),print(Out_Local_Vars),nl,
  %print('Func_Value: '),print(Func_Value),nl,
  % returns function value
  (retract(function_value(Func_Value));
  print('Error in function definition: No Value defined'),nl).

% Assign function's value (call from within the function's body)
assign_func_value(Val) :-
  assert(function_value(Val)).		

% Operations on variables within the function's body
var_op(Term) :-
  % Define evaluation's environment
  current_local_vars(In_Local_Vars),
  current_global_vars(In_Global_Vars),
 		
  % The history is red-only
  current_history(History),

  eval_term(Term, Val, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History),

  % Update local evaluation environment
  retract(current_local_vars(In_Local_Vars)),
  assert(current_local_vars(Out_Local_Vars)),

  retract(current_global_vars(In_Global_Vars)),
  assert(current_global_vars(Out_Global_Vars)).

var_op(Term) :- 
  Term =.. [Op|[Var, Val]],
  print('Op "'),print(Op),print('" '),print('is not defined '),nl.

% Recove the history from within the function's body
get_history(History) :- current_history(History).

% Term is an operation over a local variable of form:
%
%   		local_op_id(local_Var_name, Value)
%
% eg:		set(time, Time_Val)
%		get(cycle, Num_Cycle)
%		inc(cont, Cont_Val)
%
% The operation scope is the local variables and In_Local_Vars is updated to Out_Local_Vars
%
% The operations are defined in the list:
%
%		local_operators(OP_List)
%

% Operations on local variables
eval_term(Term, Value, In_Local_Vars, Out_Local_Vars, Global_Vars, Global_Vars, _) :-
  operation_on_vars(Term, Op, Var, In_Value),
  check_variable(Var, In_Local_Vars),
	
  % Perform operation on list of local vars
  execute_op(Op, Var, In_Value, Value, In_Local_Vars, [], Out_Local_Vars).

% Operations on global variables
eval_term(Term, Value, Local_Vars, Local_Vars, In_Global_Vars, Out_Global_Vars, _) :-
  operation_on_vars(Term, Op, Var, In_Value),
  check_variable(Var, In_Global_Vars),

  % Perform  operation on list of Global Vars
  execute_op(Op, Var, In_Value, Value, In_Global_Vars, [], Out_Global_Vars).

eval_term(Term, _, _, _, _, _, _) :-
  operation_on_vars(Term, Op, Var, In_Value),
  print('Error: Variable "'), print(Var),print('"'), print(' is not defined. '),nl, 
  end.

%Term is a list
eval_term([], [], Local_Vars, Local_Vars, Global_Vars, Global_Vars, History) :-
 print('In eval term empty '),nl.

% Variables from sublist are linked in higher level
eval_term(List_of_Terms, List_of_Values, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History) :-
  %print('In eval term List_of_Terms: '),print(List_of_Terms),nl,
  eval_list_of_terms(List_of_Terms, [], List_of_Values, In_Local_Vars, Out_Local_Vars, In_Global_Vars, 
  Out_Global_Vars, History).

eval_term(Term, _, _, _, _, _, _) :-
  print('Error in eval_term: ilegal term'),nl,
  print('Term: '),print(Term),nl,
  end.

operation_on_vars(Term, Op, Var, Val) :- 
  Term =.. [Op|[Var, Val]],
  operators_on_variables(Loc_Op),
  member(Op, Loc_Op).

check_variable(Var, []) :- fail.
check_variable(Var, [Var ==> _|_]).
check_variable(Var, [_|Rest]) :-
  check_variable(Var, Rest).

% Search Var in In_Vars, apply op. and returns Out_Vars
execute_op(Op, Var, In_Value, New_Value, [Var ==> DM_Value|Rest], Acc_Vars, Out_Vars) :-
  % Op. semantics
  semantics_op(Op, Var, In_Value, DM_Value, New_Value),

  % Create list of previous Local Vars and New var
  append(Acc_Vars, [Var ==> New_Value], New_List_Vars),

  % Append current list and Rest List
  append(New_List_Vars, Rest, Out_Vars).

execute_op(Op, Var, In_Value, New_Value, [H|Rest], Acc_Vars, Out_Local_Vars) :-
  append(Acc_Vars, [H], New_Acc_Vars),
  execute_op(Op, Var, In_Value, New_Value, Rest, New_Acc_Vars, Out_Local_Vars).
		
execute_arith_pred(Term, true) :- 
  Term.
execute_arith_pred(Term, false).

execute_if(Cond, Body, _, Val, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History) :-
  execute_cond(Cond, true),
  eval_term(Body, Val, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History).

execute_if(_, _, Body, Val, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History) :-
  eval_term(Body, Val, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History).

execute_cond(Cond, true) :- 
  Cond.
execute_cond(Cond, false).


% Assign function value (called from function body)
assign_func_value(Val) :-
  assert(function_value(Val)).  

% Operation on variable of function body 
var_op(Term) :-
  % Defines evaluation enviorment
  current_local_vars(In_Local_Vars),
  current_global_vars(In_Global_Vars),
  
  % History can be only read
  current_history(History),

  eval_term(Term, Val, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History),

  % Updates enviorments local evaluation
  retract(current_local_vars(In_Local_Vars)),
  assert(current_local_vars(Out_Local_Vars)),

  retract(current_global_vars(In_Global_Vars)),
  assert(current_global_vars(Out_Global_Vars)).

var_op(Term) :- 
  Term =.. [Op|[Var, Val]],
  print('Op "'),print(Op),print('" '),print('is not defined '),nl.

% Recovers history from body 
get_history(History) :- 
  current_history(History).

% Term is an operation on local variable with form
%
%     local_op_id(local_Var_name, Value)
%
% eg:  set(time, Time_Val)
%  get(cycle, Num_Cycle)
%  inc(cont, Cont_Val)
%
% Operations reflex local variables and  In_Local_Vars is updated as Out_Local_Vars
%
% Operations are defined into a list:
%

%  local_operators(OP_List)

% Op. upon local variables
eval_term(Term, Value, In_Local_Vars, Out_Local_Vars, Global_Vars, Global_Vars, _) :-
  operation_on_vars(Term, Op, Var, In_Value),
  check_variable(Var, In_Local_Vars),
	
  % Perform operation on list of local vars
  execute_op(Op, Var, In_Value, Value, In_Local_Vars, [], Out_Local_Vars).

% Op. upon global variables
eval_term(Term, Value, Local_Vars, Local_Vars, In_Global_Vars, Out_Global_Vars, _) :-
  operation_on_vars(Term, Op, Var, In_Value),
  check_variable(Var, In_Global_Vars),

  % Perform  operation on list of Global Vars
  execute_op(Op, Var, In_Value, Value, In_Global_Vars, [], Out_Global_Vars).

eval_term(Term, _, _, _, _, _, _) :-
  operation_on_vars(Term, Op, Var, In_Value),
  print('Error: The variable "'), print(Var),print('"'), print(' is not defined. '),nl, 
  end.

operation_on_vars(Term, Op, Var, Val) :- 
  Term =.. [Op|[Var, Val]],
  operators_on_variables(Loc_Op),
  member(Op, Loc_Op).

check_variable(Var, []) :- 
  fail.

check_variable(Var, [Var ==> _|_]).

check_variable(Var, [_|Rest]) :-
  check_variable(Var, Rest).

% Search Var in In_Vars, apply op. and returns Out_Vars
execute_op(Op, Var, In_Value, New_Value, [Var ==> DM_Value|Rest], Acc_Vars, Out_Vars) :-
  % Op. semantics
  semantics_op(Op, Var, In_Value, DM_Value, New_Value),

  % Create list of previous Local Vars and New var
  append(Acc_Vars, [Var ==> New_Value], New_List_Vars),

  % Append current list and Rest List
  append(New_List_Vars, Rest, Out_Vars).

execute_op(Op, Var, In_Value, New_Value, [H|Rest], Acc_Vars, Out_Local_Vars) :-
  append(Acc_Vars, [H], New_Acc_Vars),
  execute_op(Op, Var, In_Value, New_Value, Rest, New_Acc_Vars, Out_Local_Vars).
  
% Semantics of ops:

%get: la variable de entrada se unifica con en valor de la expresion
semantics_op(get, Var, Value, Value, Value).

%set		
semantics_op(set, Var, In_Value, DM_Value, In_Value).

% inc; the input variable is unified with the expression's value
semantics_op(inc, Var, Value, DM_Value, Value) :-
  number(DM_Value),
  Value is DM_Value + 1.

semantics_op(inc, Var, Value, DM_Value, Value) :-
  print('Error: the variable "'), print(Var), print('"'), print(' is not numeric. '),nl.

%Term is a list
eval_term([], [], Local_Vars, Local_Vars, Global_Vars, Global_Vars, History).

% the variable of a sublist are bound in the upper level
eval_term(List_of_Terms, List_of_Values, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History) :-
  eval_list_of_terms(List_of_Terms, [], List_of_Values, In_Local_Vars, Out_Local_Vars, In_Global_Vars, 
  Out_Global_Vars, History).

eval_term(Term, _, _, _, _, _, _) :-
	print('Error is eval_term: ill-defined term'),nl,
	print('Term: '),print(Term),nl,
	end.

end :- 
  print('Press Ctrl. C and abort'),nl,
  read(_).


