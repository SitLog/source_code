/*******************************************************************************
    SitLog (Situation and Logic) 
    
    Copyright (C) 2012 UNAM (Universidad Nacional AutÃ³noma de MÃ©xico)
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

load :-
  % Files from behaviors
  user:file_search_path(sictusdir,SitLogDir),
  %% load_file(SitLogDir,'behaviors/basic_actions.pl',Basic_ActionsB),
  %% load_file(SitLogDir,'behaviors/expectation_types.pl',Expectation_TypesB),
  %% atom_concat(SitLogDir,'behaviors/user_functions.pl',UserFunctionB),
  %% consult(UserFunctionB),

  user:file_search_path(projdir,ProjDir),
  models(ModelFiles),
  global_varsf(In_Global_VarsF),
  basic_actions(Basic_ActionsF),
  expectationtypes(ExpectationTypes),
  templates(TemplatesFile),
  userfunctions(UserFunctionsFile),
  knowledge_base(KBFile),


  % Loading dialogue files
  load_list_of_files(ProjDir,ModelFiles,Dialogues),
  assert(dialogues(Dialogues)),

  % Loading external files to DM    
  load_file(ProjDir,Basic_ActionsF,Basic_ActionsDM),
  append(Basic_ActionsDM,Basic_ActionsB,Basic_Actions),
  assert(basic_actions(Basic_Actions)), 
  load_file(ProjDir,In_Global_VarsF,In_Global_Vars),
  assert(global_vars(In_Global_Vars)),
  %print('In_Global_Vars: '),print(In_Global_Vars),nl,

  % load list of intention's types
  load_file(ProjDir,ExpectationTypes,Expectation_TypeDM),
  append(Expectation_TypeDM,Expectation_TypesB,Expectation_Types),
  assert(expectation_types(Expectation_Types)),

  consult(projdir(TemplatesFile)),
  consult(projdir(UserFunctionsFile))
.
  
main :-                  

  % Starts main cycle
    
  % History is the sequence of pairs diag_ID: situation visited during the dialogue model interpretation
      
  % read main dialogue model
  %print('Input main dialogue model: '),
  %read(Main),  
  main(Main),

  %print('Type input DM parameter: '),
  %read(In_Arg),
  int_arg(In_Arg),
  global_vars(In_Global_Vars),
  print('In Arg for model: '),print(In_Arg),nl,
  print('Global Vars: '),print(In_Global_Vars),nl,

  % Args: diag_model_ID, Final_Situation, In_Arg, Out_Arg, In_Global_Vars, Out_Global_Vars, In_Hist, Out_Hist
  % Second and tird argument are called de embeded DM into recursive situation
  %print('Main: '),print(Main),nl,
  execute_md(Main, _, In_Arg, Out_Arg, In_Global_Vars, Out_Global_Vars, [], History),

  % Dialogue finishes
  write_log(inflog,'Ending dialogue: ~w',[Main]),
  print('Execution history: '),nl,
  print_list(History),nl,
  
  %print('Out Arg: '),print(Out_Arg),nl,

  %print('Out Global Vars: '),print(Out_Global_Vars),nl,
  
  reset.

end_dm :- 
  print('Dialogue manager ends'),nl.

reset :- 
	   abolish(dialogues/1),
	   abolish(global_vars/1),
	   abolish(basic_actions/1),
	   abolish(expectation_types/1),
	   abolish(knowledge_base/1).

execute_md(Dialogue_ID, Final_Situation, In_Arg, Out_Arg, In_Global_Vars, Out_Global_Vars, In_History, Out_History) :-

  write_log(inflog,'Executing dialogue: ~w',[Dialogue_ID]),
  save_info(first_level,'START DIALOGUE',[]),
  save_info(feat,'TIME',[]),
  save_info(first_level,'SITUATUATIONS',[]),

  print('In execute_diagmod: '), print(Dialogue_ID), nl,

  dialogues(Dialogues),

  %substitute_variables(Dialogues, Aux_Dialogues),
  %print('Aux_Dialogues: '),print(Aux_Dialogues),nl,
  %get_dialogue(Dialogue_ID, Aux_Dialogues, Situations, In_Local_Vars),
  %get_dialogue(Dialogue_ID, Dialogues, Situations, In_Local_Vars),
  get_dialogue(Dialogue_ID, Dialogues, Dialogue, Situations, In_Local_Vars),

  %Get initial situation: The first in the list for all DM
  %idx_object(0, Situations, New_Current_Situation),
  idx_object(0, Situations, Current_Situation),
  write_log(inflog,'Defined local vars: ~w',[In_Local_Vars]),

  % Provides Actual Situation new variables
  %substitute_variables(Current_Situation, New_Current_Situation),
  substitute_variables([Dialogue, Current_Situation], [Aux_Dialogue, Aux_Current_Situation]),
  %print('Current_Situation: '),print(New_Current_Situation),nl,

	    % Bind Dialogue_ID for execution of current situation
	    Dialogue_ID = Aux_Dialogue,

  write_log(infolog,'Situtation: is',[]),
  write_log(structlog,'Executing situtation: ~w',[New_Current_Situation]),
 
 %execute_situation(New_Current_Situation, Final_Situation, Dialogue_ID, In_Arg, New_Arg, In_Local_Vars, 
 %New_Local_Vars, In_Global_Vars, New_Global_Vars, Next_Situation_ID, In_History, New_History),
  execute_situation(Aux_Current_Situation, Final_Situation, Dialogue_ID, In_Arg, New_Arg, In_Local_Vars, 
  New_Local_Vars, In_Global_Vars, New_Global_Vars, Next_Situation_ID, In_History, New_History),    
	    
  %next_situation(Next_Situation_ID, Final_Situation, Dialogue_ID, Situations, New_Arg, Out_Arg, 
  %New_Local_Vars, Out_Local_Vars, New_Global_Vars, Out_Global_Vars, New_History, Out_History),
  %print('Out_History: '),print(Out_History),nl,
  next_situation(Next_Situation_ID, Final_Situation, Dialogue_ID, Dialogue, Situations, New_Arg, 
  Out_Arg, New_Local_Vars, Out_Local_Vars, New_Global_Vars, Out_Global_Vars, New_History, Out_History),

  print('Dialogue Model ends: '), print(Dialogue_ID),nl,
  write_log(inflog,'.Output ~w',[Out_Local_Vars]),
  save_info(first_level,'END DIALOGUE',[]),
  save_info(feat,'OUTSYS',[Out_Local_Vars]),
  %print('Local Variables: '), print(Out_Local_Vars), nl,
  save_info(feat,'TIME',[]),!.
	    

execute_md(Dialogue_ID,_,_,_,_,_,_,_) :- 
  warning_msg(dialogue,Dialogue_ID),
  write_log(errlog,'There is not dialogue: ~w',[Dialogue_ID]),
  warning_msg(dialogue,Dialogue_ID).

% MD ends
next_situation(empty, _, Dialogue_ID, Dialogue, Situations, Arg, Arg, Local_Vars, Local_Vars, Global_Vars, Global_Vars, History, History):-
  write_log(inflog,'Dialogue ends',[])
.

%next_situation(Current_Situation_ID, Final_Situation, Dialogue_ID, Situations, In_Arg, Out_Arg, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, In_History, Out_History) :-
next_situation(Current_Situation_ID, Final_Situation, Dialogue_ID, Dialogue, Situations, In_Arg, Out_Arg, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, In_History, Out_History) :-

   %print('Current_Situation_ID: '), print(Current_Situation_ID),nl,

  % Provee variable nuevas para la situacin actual
  %substitute_variables(Situations, Aux_Situations),
	    substitute_variables([Dialogue, Situations], [Aux_Dialogue, Aux_Situations]),
   %print('Aux_Situations: '), print(Aux_Situations),nl,

  % Select Current Situation from Aux_Sitution
  % i.e., get_situation can propagate inf. from Current_Situation_ID to the Situation's Type
  % which needs to be unaltered always
  %get_situation(Current_Situation_ID, Aux_Situations, New_Current_Situation),
  get_situation(Current_Situation_ID, Aux_Situations, Current_Situation),
  %print('Current_Situation: '),nl,
  %print(Current_Situation),nl,

  % Bind Vars of Dialogue_ID with current Aux_Dialogue (skiping arguments already grounded)
  % The grounded arguments take different values within a recursion cycle and only the variables need to be bounded
  Dialogue_ID =.. [Diag|Args1],
  Aux_Dialogue =.. [Diag|Args2],
  bind_vars(Args1, Args2),


 %execute_situation(New_Current_Situation, Final_Situation, Dialogue_ID, In_Arg, New_Arg, In_Local_Vars, 
 %New_Local_Vars, In_Global_Vars, New_Global_Vars, Next_Situation_ID, In_History, New_History),
  execute_situation(Current_Situation, Final_Situation, Dialogue_ID, In_Arg, New_Arg, In_Local_Vars, 
  New_Local_Vars, In_Global_Vars, New_Global_Vars, Next_Situation_ID, In_History, New_History),
  %print('Next_Situation_ID: '),print(Next_Situation_ID),nl,
  write_log(inflog,'Situation ends',[]),
	    
  %next_situation(Next_Situation_ID, Final_Situation, Dialogue_ID, Situations, New_Arg, Out_Arg, 
  %New_Local_Vars, Out_Local_Vars, New_Global_Vars, Out_Global_Vars, New_History, Out_History).
  next_situation(Next_Situation_ID, Final_Situation, Dialogue_ID, Dialogue, Situations, New_Arg, 
  Out_Arg, New_Local_Vars, Out_Local_Vars, New_Global_Vars, Out_Global_Vars, New_History, Out_History).

% STARTS SITUATION'S INTERPRETATION

%Execute final situation: next situation is "empty"
%execute_situation(Current_Situation, Final_Situation, Dialogue_ID, Arg, Arg, Local_Vars, Local_Vars, Global_Vars, Global_Vars, empty, In_History, Out_History) :-
execute_situation(Current_Situation, Final_Situation, Dialogue_ID, In_Arg, Out_Arg, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, empty, In_History, Out_History) :-

  % Check final situation
  get_feature_value(type, Current_Situation, final),
  get_feature_value(id, Current_Situation, Final_Situation),

  write_log(deblog,'In situation ~w of type ~w.',[Current_Situation,final]),
  write_log(debstruct,'Situation to execute ~w.',[Final_Situation]),
  save_info(second_level,'SIT',[]),
  save_info(feat,'NAME',[Current_Situation]),
  save_info(feat,'TYPE',[final]),

  %print('In final situation: '),print(Final_Situation),nl,
  
  % Links int arguments of Situation
  bind_arguments_situation(in_arg, Current_Situation, In_Arg),
  %print('In_Arg: '),print(In_Arg),nl,
  % Gets out_arg value of situation
  get_feature_value(out_arg, Current_Situation, Out_Arg_Situation),
  %print('Out_Arg_Situation: '),print(Out_Arg_Situation),nl,

  % Executes local programm of situation
  execute_local_prog(Current_Situation, In_Arg, Out_Arg_Situation, In_Local_Vars, Out_Local_Vars, 
  In_Global_Vars, Out_Global_Vars, In_History),

  % Propagates In_Arg to Out_Arg if necesary
  propagate_args(In_Arg, Out_Arg_Situation, Out_Arg),
  %print('Out_Arg: '),print(Out_Arg),nl,

  % Bind diag_mod feature with Dialogue_ID
  bind_diag_mod_id(Dialogue_ID, Current_Situation, Out_Local_Vars),
  %print('Out_Local_Vars: '),print(Out_Local_Vars),nl,
  % Register history
  %append(In_History,[Dialogue_ID:(Final_Situation,empty:empty)],Out_History)%,
  append(In_History,[Dialogue_ID:(Final_Situation,empty:empty)],Out_History)%,
  %print('Out_History: '),print(Out_History),nl,nl
.

% Execute generic situation
execute_situation(Current_Situation, Final_Situation, Dialogue_ID, In_Arg, Out_Arg, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, Next_Situation_ID, In_History, Out_History) :-
	   
  %Verify generic multimodal situation (Not recursive or final)
  get_feature_value(type, Current_Situation, Situation_Type),
  Situation_Type \== recursive,
  Situation_Type \== final,
  Situation_Type \== doesnt_exist,
  get_feature_value(id, Current_Situation, Situation_ID),
	
  print('In generic situation: '), print(Situation_ID),nl,
  % print('In_Arg: '), print(In_Arg), nl,
  % read(_),
  write_log(deblog,'In situation ~w of type ~w.',[Situation_ID,Situation_Type]),
  write_log(debstruct,'Situation to execute ~w.',[Current_Situation]),
  save_info(second_level,'SIT',[]),
  save_info(feat,'NAME',[Situation_ID]),
  save_info(feat,'TYPE',[Situation_Type]),

  % Links int arguments to situation 
  bind_arguments_situation(in_arg, Current_Situation, In_Arg),

  %print('In situation: '),print(Current_Situation),nl,

  % Obtains situation out_arg value
  get_feature_value(out_arg, Current_Situation, Out_Arg_Situation),

  % Executes local program to situation
  execute_local_prog(Current_Situation, In_Arg, Out_Arg_Situation, In_Local_Vars, Next_Local_Vars, 
  In_Global_Vars, Next_Global_Vars, In_History),
  %print('Out_Arg_Situation: '),print(Out_Arg_Situation),nl,

  % Produces new variables arcs, with evaluated expectation and a variable per arc associated to situation
  analize_expectation(Current_Situation, Out_Arg_Situation, Next_Local_Vars, Next_Global_Vars, 
  In_History, List_Out_Arg, Reconstructed_Arcs),

  %print('Current situation: '),print(Current_Situation),nl,
  % call input mm-interpreter 
  % Expressed intention assigns a value to every variable and "Expressed_Intention" most be grounded

  %print('Collecting Input Intention... '), nl,
  get_feature_value(type, Current_Situation, Situation_Type),
  test_interpret_input(Situation_Type, In_History, List_Out_Arg, Reconstructed_Arcs, New_Out_Arg, 
  Expressed_Intention, Action, Next_Situation),

  % Exectute situation's action and next situation
  situations_action(Current_Situation, Situation_ID, Dialogue_ID, In_Arg, New_Out_Arg, Out_Arg, 
  Next_Local_Vars, Out_Local_Vars, Next_Global_Vars, Out_Global_Vars, Expressed_Intention, Action, 
  Next_Situation, Next_Situation_ID, In_History, Out_History).

%Execute recursive situation
execute_situation(Current_Situation, Final_Situation, Dialogue_ID, In_Arg, Out_Arg, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, Next_Situation_ID, In_History, Out_History) :-
	    
  % Check situation type
  get_feature_value(id, Current_Situation, Situation_ID),
  get_feature_value(type, Current_Situation, recursive),

  % print('In recursive situation '),
  % print('Situation: '), nl,
  % print('Current Situation: '),nl,
  % print_list(Current_Situation),nl,
  % read(_),
	
  % Get MD embebido
  bind_arguments_situation(in_arg, Current_Situation, In_Arg),

  %get_feature_value(embedded_dm, Current_Situation, Embedded_DM),


  % Executes local programm to situation
  execute_local_prog(Current_Situation, In_Arg, Out_Arg_Situation, In_Local_Vars, Next_Local_Vars, 
  In_Global_Vars, Next_Global_Vars, In_History),

  %print('Embedded_DM: '),print(Embedded_DM),nl,
 
  % Links in arguments to Situation
  %bind_arguments_situation(in_arg, Current_Situation, In_Arg),
  get_feature_value(embedded_dm, Current_Situation, Embedded_DM),

  % Evaluate Emmdedded_DM (e.g. DM may be stated in the local prog and stored in a Local Var)
  eval_term(Embedded_DM, Actual_DM, Next_Local_Vars, Next_Local_Vars, _, _, _),
  %print('Actual_DM: '),print(Actual_DM),nl,

  write_log(deblog,'In situation ~w of type ~w.',[Actual_DM,recursive]),
  write_log(debstruct,'Situation to execute ~w.',[Actual_DM]),
  save_info(second_level,'SIT',[]),
  save_info(feat,'NAME',[Actual_DM]),
  save_info(feat,'TYPE',[recursive]),

  % Interpretates embedded dialogue model
  % Out_Arc corresponds to final situation of embedded DM
  execute_md(Actual_DM, Selected_Out_Arc, In_Arg, New_Arg, Next_Global_Vars, New_Global_Vars, [], 
  Embedded_DM_History),
  %print('Embedded_DM_History: '),print(Embedded_DM_History),nl,
  %execute_md(Embedded_DM, Selected_Out_Arc, In_Arg, New_Arg, Next_Global_Vars, New_Global_Vars, [], Embedded_DM_History),


  % Update embedded history
  append(In_History, [Embedded_DM_History], Next_History),
	
  % Gets situation out_arg value 
  get_feature_value(out_arg, Current_Situation, Out_Arg_Situation),

  % Produces new variables arcs, with evaluated expectation and a variable per arco asocited to situation exit argument
  analize_expectation(Current_Situation, Out_Arg_Situation, Next_Local_Vars, New_Global_Vars, 
  Next_History, List_Out_Args, Reconstructed_Arcs),

  % Selects arc with Out_Arc (final situation DM embedded) as its expectation
  % New_Out_Arg is exit argument linked to selected arc variable

  select_arc(Selected_Out_Arc, List_Out_Args, Reconstructed_Arcs, New_Out_Arg, Action, Next_Situation),

  % Exectute situation's action and next situation
  situations_action(Current_Situation, Situation_ID, Dialogue_ID, New_Arg, New_Out_Arg, Out_Arg, 
  Next_Local_Vars, Out_Local_Vars, New_Global_Vars, Out_Global_Vars, Selected_Out_Arc, Action, 
  Next_Situation, Next_Situation_ID, Next_History, Out_History)
.

% Selects Out_Arc in recursive situation
select_arc(Out_Arc, [], [], _, _, _) :- 
  print('Error >> There is no exit situation: '), print(Out_Arc), nl,
  end_diag_manager.

select_arc(Out_Arc, [Out_Argument|_], [Out_Arc:Action => Next_Situation|_], Out_Argument, Action, Next_Situation).

select_arc(Out_Arc, [_|Rest_Arguments], [_|Rest_Arcs], Out_Argument, Action, Next_Situation) :-
  select_arc(Out_Arc, Rest_Arguments, Rest_Arcs, Out_Argument, Action, Next_Situation).


% Not confirmed Expectation: No expectation found, executes actual situation again
situations_action(Current_Situation, Situation_ID, Dialogue_ID, In_Arg, _, In_Arg, In_Local_Vars, In_Local_Vars, In_Global_Vars, In_Global_Vars, non, empty, current_situation, Situation_ID, In_History, In_History) :-

  print('No satisfied expected intention!'),nl%,
  %print('Current Situation: '),print(Situation_ID),nl
.

% Confirmed Expectation 
situations_action(Current_Situation, Situation_ID, Dialogue_ID, In_Arg, New_Out_Arg, Out_Arg, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, Expressed_Intention, Action, Next_Situation, Next_Situation_ID, In_History, Out_History) :-

  % Eval structured actions in relation to the context
  eval_term(Action, Evaluated_Action, In_Local_Vars, New_Local_Vars, In_Global_Vars, New_Global_Vars, 
  In_History),


  print('En situation action despues de eval_term: '), nl,
  
  % Realize action
  %execute_actions_arc(Evaluated_Action, New_Out_Arg),
  execute_actions_arc(Evaluated_Action),


  print('En situation action despues de execute action: '), nl,
  
  
  %print('Evaluated_Action: '),print(Evaluated_Action),nl,
  % Evaluate next situation
  eval_term(Next_Situation, Next_Situation_ID, New_Local_Vars, Out_Local_Vars, New_Global_Vars, 
  Out_Global_Vars, In_History),

 
  print('En situation action despues de eval_next_situation: '), nl,
  print('Next Situation ID: '), print(Next_Situation_ID), nl,

  
  % Spreads In_Arg to Out_Arg if necesary
  propagate_args(In_Arg, New_Out_Arg, Out_Arg),

  % Evaluate Global program (the situation variables are not encapsulated)
  bind_diag_mod_id(Dialogue_ID, Current_Situation, Out_Local_Vars),

  %register history
  append(In_History, [Dialogue_ID:(Situation_ID,Expressed_Intention:Evaluated_Action)], Out_History).


%%%%%%%%%%%%%%%%%%%%%%%%% Auxilary Rutines for situation interpretation %%%%%%%%%%%%%%%%%%%%%%%%%

% Executes program defined as a list of terms assigned to the feature "prog"
execute_local_prog(Current_Situation, In_Arg, Out_Arg, In_Local_Vars, Out_Local_Vars, In_Global_Vars, Out_Global_Vars, History) :-
  get_feature_value(prog, Current_Situation, Local_Prog),
  Local_Prog \== doesnt_exist,

  % Changes programm variables (doesnt link arcs variables)
  substitute_variables([In_Arg, Out_Arg, Local_Prog], [New_In_Arg, New_Out_Arg, New_Local_Prog]),

  % Siatuation arguments have scope into local programm (exit arg is linked after)
  New_In_Arg = In_Arg,
  New_Out_Arg = Out_Arg,

  % Evaluates local program linked with every term list variables
  eval_list_of_terms(New_Local_Prog, [], Local_Prog_Values, In_Local_Vars, Out_Local_Vars, 
  In_Global_Vars, Out_Global_Vars, History)
.

execute_local_prog(Current_Situation, _, _, Local_Vars, Local_Vars, Global_Vars, Global_Vars, History) :-
  get_feature_value(prog, Current_Situation, Local_Prog),
  Local_Prog == doesnt_exist
.

execute_local_prog(_, _, _, _, _, _, _, _) :- 
  print('error in exectute_local_prog'), nl, 
  end_diag_manager.


% Gives new variables for every arc, also an asociated variable to exit argument per arc, evaluates expectation
% List_Out_Args contains associated variable list to exit argument per arc
% Reconstructed_Arcs is evaluated expectation arc, but action and next situation without evaluation

analize_expectation(Current_Situation, Out_Args_Situation, Local_Vars, Global_Vars, In_History, List_Out_Args, Reconstructed_Arcs) :-  
	
  % Obtains situation exit arcs
  get_feature_value(arcs, Current_Situation, Arcs),
  %print('Arcs: '),print(Arcs),nl,

  % Obtains new variables for every arc, associated to exit argument with new argument for every arc
  new_variables_arcs(Arcs, Out_Args_Situation, [], New_Arcs, [], List_Out_Args),
  %print('New_Arcs: '),print(New_Arcs),nl,
  %print('Expectations: '),print(Expectations),nl,
  % Separate arcs into expactions and actions (with next situation)
  split_expectations_and_actions(New_Arcs, [], Expectations, [], Action_Parts),
  %print('Action_Parts: '),print(Action_Parts),nl,
	   
  % Evaluates expectations.
  % List_Out_Args has a new exit parameter for every arc
  % Updates local variables and global variables are not considered (Only selected arc updates are considered)

  eval_list_of_terms(Expectations,[],Evaluated_Expectations,Local_Vars,_,Global_Vars,_,In_History),

  % Filter out control information in expectations list
  filter_expectations(Evaluated_Expectations, [], Filtered_Expectations),
  %print('Evaluated_Expectations: '),print(Evaluated_Expectations),nl,
  %print('Filtered_Expectations: '),print(Filtered_Expectations),nl,
  % Rebuilds arcs with evaluated expectation, but action (and next sit) without evaluation
  join_expectations_action_part(Filtered_Expectations, Action_Parts, [], Reconstructed_Arcs)%,
  %join_expectations_action_part(Evaluated_Expectations, Action_Parts, [], Reconstructed_Arcs).
  %print('Reconstructed_Arcs: '),print(Reconstructed_Arcs),nl
.

split_expectations_and_actions([], Expectations, Expectations, Actions, Actions).
split_expectations_and_actions([Current_Expectation:Action => Next_Situation|Rest_Arcs], Acc_Expectations, Expectations_List, Acc_Actions, Actions_List) :-
  append(Acc_Expectations, [Current_Expectation], New_Expectations),
  append(Acc_Actions, [Action => Next_Situation], New_Actions),
  split_expectations_and_actions(Rest_Arcs,New_Expectations,Expectations_List,New_Actions,Actions_List).

join_expectations_action_part([], [], Reconstructed_Arcs, Reconstructed_Arcs).
join_expectations_action_part([Expectation|Rest_Expectations], [Action => Next_Situation|Rest_Action_Part], Acc_New_Arcs, Reconstructed_Arcs) :-
  append(Acc_New_Arcs, [Expectation:Action => Next_Situation], New_Arcs_List),
  join_expectations_action_part(Rest_Expectations, Rest_Action_Part, New_Arcs_List, Reconstructed_Arcs).

filter_expectations([], Filtered_Expectations, Filtered_Expectations).
filter_expectations([Current_Expectation|Rest_Expec], Acc_Expectations, Filtered_Expectations) :-
  var(Current_Expectation),
  filter_expectations(Rest_Expec, Acc_Expectations, Filtered_Expectations).
filter_expectations([Current_Expectation|Rest_Expec], Acc_Expectations, Filtered_Expectations) :-
  Current_Expectation =.. ['.'|_],
  filter_expectations(Current_Expectation, [], Head_Expectations),
  filter_expectations(Rest_Expec, Acc_Expectations, Next_Expectations),
  append([Head_Expectations], Next_Expectations, Filtered_Expectations).
filter_expectations([Current_Expectation|Rest_Expec], Acc_Expectations, Filtered_Expectations) :-
  defined_expectation_type(Current_Expectation),
  filter_expectations(Rest_Expec, Acc_Expectations, Next_Expectations),
  append([Current_Expectation], Next_Expectations, Filtered_Expectations).
filter_expectations([_|Rest_Expec], Acc_Expectations, Filtered_Expectations) :- 
  filter_expectations(Rest_Expec, Acc_Expectations, Filtered_Expectations).

defined_expectation_type(Current_Expectation) :-
  expectation_types(Expectation_Types),
  Current_Expectation =.. [Type|_],
  member(Type, Expectation_Types).

new_variables_arcs([], _, Arcs, Arcs, Args, Args).
new_variables_arcs([Current_Arc|Rest_Arcs], Out_Arg_Sit, Acc_Arcs, New_Arcs, Acc_Args, List_Out_Args_Sit) :-
  % Gives actual situations new variables
  substitute_variables([Out_Arg_Sit, Current_Arc], [New_Current_Out_Arg, New_Current_Arc]),
  append(Acc_Arcs, [New_Current_Arc], New_List_Arcs),
  append(Acc_Args, [New_Current_Out_Arg], New_List_Args),
  new_variables_arcs(Rest_Arcs, Out_Arg_Sit, New_List_Arcs, New_Arcs, New_List_Args, List_Out_Args_Sit).


%%%%%%%%%%%%%%%%%%%%%%%%% diag_manager Binding rutines %%%%%%%%%%%%%%%%%%%%%%%%%

bind_arguments_situation(Feature, Situation, Arg) :-
  get_feature_value(Feature, Situation, Arg_Situation),
  Arg_Situation \== doesnt_exist,
  Arg = Arg_Situation.

% In case Feature is not defined
bind_arguments_situation(Feature, Situation, _) :-
  get_feature_value(Feature, Situation, doesnt_exist).

% In case Out_Arg is a variable or doesnt_exist, spreads in to out
propagate_args(In_Arg, New_Arg, Out_Arg) :-
  (var(New_Arg); New_Arg == 'doesnt_exist'),
  Out_Arg = In_Arg.

% In other case Out_Arg has a value
propagate_args(In_Arg, Out_Arg, Out_Arg).

% Bind Dialogue_ID (i.e., in case there are output arguments)
bind_diag_mod_id(Dialogue_ID, Current_Situation, Local_Vars) :-
  get_feature_value(diag_mod, Current_Situation, Diag_Mod_Exp),
  Diag_Mod_Exp \== doesnt_exist,

  %print('Dialogue_ID: '), print(Dialogue_ID), nl,
  %print('Diag_Mod_Exp: '), print(Diag_Mod_Exp), nl,

  % Evaluates local programm linked to every variable into every list term
  eval_term(Diag_Mod_Exp, Diag_Mod_Exp_Value, Local_Vars, Local_Vars, _, _, _), !,

  % Bind 
  %Dialogue_ID = Diag_Mod_Exp_Value.
  % Bind diag_mod
  perform_dm_unification(Dialogue_ID, Diag_Mod_Exp_Value).

bind_diag_mod_id(Dialogue_ID, Current_Situation, _) :-
  get_feature_value(diag_mod, Current_Situation, Diag_Mod_Exp),
  Diag_Mod_Exp == doesnt_exist%,
  %print('Dialogue_ID: '), print(Dialogue_ID), nl,
  %print('Diag_Mod_Exp: '), print(Diag_Mod_Exp), nl
.
bind_diag_mod_id(_, _, _) :- 
  print('Dialogue_ID cannot be bounded! '), nl, 
  end_diag_manager.

perform_dm_unification(Dialogue_ID, Dialogue_ID).

perform_dm_unification(Dialogue_ID, Diag_Mod_Exp) :- 
  %print('Dialogue_ID: '),  print(Dialogue_ID), nl,
  %print('Diag_Mod_Exp: '),  print(Diag_Mod_Exp), nl,
  print(' cannot be bounded! '), nl, 
  end_diag_manager.

%%%%%%%%%%%%%%%%%%%%%%%%% Administration rutines for DMs %%%%%%%%%%%%%%%%%%%%%%%%%
%Get Dialogue: Dialogue_ID, Dialogues, Current_Dialogue
%get_dialogue(ID, [diag_mod(ID, Situations, Local_Vars)|_], Situations, Local_Vars).
get_dialogue(ID_IDX, [diag_mod(ID, Situaciones, Local_Vars)|_], ID, Situaciones, Local_Vars) :-
  ID_IDX =.. [Diag_ID|_],
  ID =.. [Diag_ID|_].
%get_dialogue(ID,[_|Rest], Situations, Local_Vars) :- 
get_dialogue(ID_IDX,[_|Rest], ID, Situaciones, Local_Vars) :- 
  %get_dialogue(ID, Rest, Situations, Local_Vars).
  get_dialogue(ID_IDX, Rest, ID, Situaciones, Local_Vars).
%get_dialogue(ID, [], _, _) :- 
get_dialogue(ID, [], _, _, _) :-
  fatal_msg(dialogue, ID).

%Get Situation
get_situation(ID, [], _) :- 
  fatal_msg(situation, ID).
get_situation(ID, [Situation|_], Situation) :-
  get_feature_value(id, Situation, ID).
get_situation(ID, [_|Rest], Situation) :- 
  get_situation(ID, Rest, Situation).

%Get Feature Value
get_feature_value(Feature, [], doesnt_exist).
get_feature_value(Feature, [Feature ==> Value|Rest], Value).
get_feature_value(Feature, [_|Rest], Value) :- 
  get_feature_value(Feature, Rest, Value).

% End error menssages
fatal_msg(Type, ID) :- 
  print('Fatal error: No such '), print(Type), print(': '), print(ID), nl,
  end_diag_manager.

warning_msg(feature,  Feature) :- 
  print('warning: No such feature in Situation: '), print(Feature), nl.

end_diag_manager:-
  reset,
  print('Press Ctrl. C, Abort'), nl,
  read(_).

