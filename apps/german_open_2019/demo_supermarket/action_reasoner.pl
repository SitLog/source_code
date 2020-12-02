%%%%%%%%%%%%%%%%%% GPSR Action Reasoner DEMO%%%%%%%%%%%%%%%%%%%%%%%%

action_reasoner_demo(Speech_Acts):-
	flatten(Speech_Acts,Speech_Acts_Flattened),
	convert_to_commands_demo(Speech_Acts_Flattened,Logic_Form),
	assign_func_value(Logic_Form).

convert_to_commands_demo([],[]).

convert_to_commands_demo([H|T],Final):-
	construct_commands_demo(H,NewH),
	convert_to_commands_demo(T,NewT),
	append(NewH,NewT,Final).



%%%%%%%%% AVALIABLES COMMANDS %%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%

construct_commands_demo(find(object(X)),[
	consult_kb(value_object_property, [golem,in], Pos, _),    
    consult_kb(object_with_prop_value, [position,Pos], Name_Pos, _),
	consult_kb(value_object_relation, [Name_Pos,in_room], Room, _),
	consult_kb(value_object_property, [Room,object_path], Positions, _),
	say(['I will search for the', X], _),	
	find(object, [X], Positions, [0.0], [-30.0], object, [FoundObj|Rest], _, false, false, false, _),
	consult_kb(change_object_property, [golem,found,X], _, _), 
	consult_kb(value_object_property, [golem,found], Obj_Name, _), 
	say(['Here is the ', Obj_Name],_)
	]).
	
%Find(object)
construct_commands_demo(find(object(X),place(Y)),[
	say(['I will search the', X, 'in the', Y],_),
	consult_kb(value_object_property, [Y,object_path], Positions, _),
	find(object, [X], Positions, [0.0, -35.0, 35.0], [-30.0, -5.0], object, [FoundObject|Rest], _, false,false,false, _),
	consult_kb(change_object_property, [golem,found, X], _, _),
	consult_kb(value_object_property, [golem,found], Obj_Name, _),
	say(['Here is the ', Obj_Name],_)
	]).


%Move(start)
construct_commands_demo(move(start),[
	consult_kb(value_object_property, [start,name], NameLoc, _),
	say(['I will move to', NameLoc],_),
	consult_kb(value_object_property, [Loc,position], Position, _),
	move(Position,_),
	consult_kb(change_object_property, [golem,position,Position], _, _)
	]).


%Move(location)	
construct_commands_demo(move(Loc),[
	consult_kb(value_object_property, [Loc,name], NameLoc, _),
	say(['I will move to', NameLoc],_),
	consult_kb(value_object_property, [Loc,position], Position, _),
	move(Position,_),
	consult_kb(change_object_property, [golem,position,Position], _, _),
	scan(object, X, [0.0], [-30.0], object, FoundObjects, false, false, _),
	consult_kb(value_object_property, [golem,position],Position, _),
	consult_kb(update_kb_demo, [Position,FoundObjects], _, _)
	]).


%Grasp(X,right)
construct_commands_demo(grasp(X,right),[
	take(X, right, _, _),
	consult_kb(change_object_property, [golem,right_arm,X], _, _)
	]).


%Grasp(X,left)
construct_commands_demo(grasp(X,left),[
	take(X, left, _, _),
	consult_kb(change_object_property, [golem,left_arm,X], _, _)
	]).


%Deliver(Object,right)
construct_commands_demo(deliver(Object,right),[	
	say(['I will deliver the',Object],_),
	relieve_arg(-20.0, 0.45, right, _),
	consult_kb(change_object_property, [golem,right_arm,free], _, _)	    
	]).



%Deliver(Object,left)
construct_commands_demo(deliver(Object,left),[
	say(['I will deliver the',Object],_),    
	relieve_arg(20.0, 0.45, left, _),
	consult_kb(change_object_property, [golem,left_arm,free], _, _)	    
	]).


%DEFAULT
construct_commands_demo(X,[say('Sorry, I dont know how to resolve the command demo',_)]).

