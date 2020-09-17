%%%%%%%%%%%%%%%%%% GPSR Action Reasoner %%%%%%%%%%%%%%%%%%%%%%%%

actions_reasoner(Speech_Acts):-
	flatten(Speech_Acts,Speech_Acts_Flattened),
	convert_to_commands(Speech_Acts_Flattened,Logic_Form),
	assign_func_value(Logic_Form).

convert_to_commands([],[]).

convert_to_commands([H|T],Final):-
	construct_commands(H,NewH),
	convert_to_commands(T,NewT),
	append(NewH,NewT,Final).



%%%%%%%%% GPSR 2020 %%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

%Find(object,room)
construct_commands(find(object(X),place(Y)),[
	say(['I will search the', X, 'in the', Y],_),
	consult_kb(value_object_property, [Y,object_path], Positions, _),
	find(object, [X], Positions, [0.0, -35.0, 35.0], [-30.0, -5.0], object, [FoundObject|Rest], _, false,false,false, _),
	consult_kb(change_object_property, [golem,found, X], _, _),
	consult_kb(value_object_property, [golem,found], Obj_Name, _),
	say(['Here is the ', Obj_Name],_)
	]).


%Answer
construct_commands(answer,[
	answer_question
	]).

		
%DEFAULT
construct_commands(X,[say('Sorry, I dont know how to resolve the command',_)]).

