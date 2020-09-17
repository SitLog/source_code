%%%%%%%%%%%%%%%%%%%%%%%
%%                   %%
%%     DIAGNOSIS     %%
%%                   %%
%%%%%%%%%%%%%%%%%%%%%%%


%Input: 
%	KB   A knowledge base with information about the scenario (before the observation)
%       MissedObject   Missed object which activated the DLIC when the robot didn't see it the current shelf to grasp it

%Output:
%       Diagnosis   The actions performed by the assistant to put the objects in the shelf. Is a list including the actions move(shelf) and place(object)
%	NewKB   A new KB with modifications based in the information of the new observation. In this new KB the changes are:
%               a) The beliefs of each unobserved shelf


diagnosis_dlic(KB,MissedObject,Diagnosis,NewKB):-
	nl,nl,write('Starting Diagnosis'),

	object_property_value(golem,position,KB,CurrentShelf),
	write('Current shelf: '),write(CurrentShelf),nl,

	%Missing objects in the shelf in relation to the belief content
	%MissingBelieved = Belief - Observed
	object_property_value(CurrentShelf,belief,KB,Belief),
	object_property_value(CurrentShelf,observed_objects,KB,Observed),
	rest_of_lists_dlic(Observed,Belief,MissingBelieved),
	write('Missing objects in current shelf in relation to the belief content: '),write(MissingBelieved),nl,

	%Get the list of unobserved shelves
	objects_of_a_class(shelf,KB,AllShelvesInKB),
	object_property_value(observed_shelves,list,KB,AllPreviousObservedShelves),
	rest_of_lists_dlic(AllPreviousObservedShelves,AllShelvesInKB,UnobservedShelves),
	write('Unobserved shelves in this moment: '),write(UnobservedShelves),nl,

	%Load information about move actions as predicates
	load_move_actions_dlic(KB),
        load_take_actions_dlic(KB),
	load_deliver_actions_dlic(KB),
	
	write('All move, take and deliver actions were loaded'),nl,

	%Get the distance from the current shelf to the rest of shelves
	nearest_unobserved_shelf_dlic(CurrentShelf,AllPreviousObservedShelves,OrderedUnobservedShelves),
	write('Unobserved shelves in this moment ordered from nearest to farthest: '),write(OrderedUnobservedShelves),nl,

	%Assign the MissedObject in the nearest shelf
	assign_missed_in_nearest_dlic(KB,OrderedUnobservedShelves,MissedObject,NewKB1),

	%Deleting the MissedObject from the list of MissingBelieved to get the rest of the objects 
	%The reasignation is done randomly in the unobserved shelves
	rest_of_lists_dlic([MissedObject],MissingBelieved,ObjectsToReasign),
	reasign_belief_missing_objects_dlic(NewKB1,ObjectsToReasign,OrderedUnobservedShelves,NewKB2),

	%Substract the observed objects from the beliefs of all unobserved shelfs
	substract_observed_from_beliefs(NewKB2,UnobservedShelves,Observed,NewKB),	

	%Generate the diagnosis
	recolect_all_observations_dlic(AllPreviousObservedShelves,[],ListObservations,NewKB),
	recolect_all_beliefs_dlic(UnobservedShelves,[],ListBeliefs,NewKB),
	append(ListObservations,ListBeliefs,Diagnosis),
	write(Diagnosis).
	
	
		

%Load info of all move actions as predicates in the form move_action_dlic(Origin,Destiny,Cost,Probability)

load_move_actions_dlic(KB):-
	objects_of_a_class(move,KB,AllMovesKB),
	load_move_action_dlic(AllMovesKB,KB).

load_move_action_dlic([],_).
	
load_move_action_dlic([H|T],KB):-
	object_relation_value(H,from,KB,From),
	object_relation_value(H,to,KB,To),
	object_property_value(H,cost,KB,Cost),
	object_property_value(H,probability,KB,Probability),
	assert(move_action_dlic(From,To,Cost,Probability)),
	load_move_action_dlic(T,KB).

%Load info of all take actions as predicates in the form take_action_dlic(Object,Cost,Probability)

load_take_actions_dlic(KB):-
	objects_of_a_class(take,KB,AllTakesKB),
	load_take_action_dlic(AllTakesKB,KB).

load_take_action_dlic([],_).
	
load_take_action_dlic([H|T],KB):-
	object_relation_value(H,to,KB,Object),
	object_property_value(H,cost,KB,Cost),
	object_property_value(H,probability,KB,Probability),
	assert(take_action_dlic(Object,Cost,Probability)),
	load_take_action_dlic(T,KB).


%Load info of all deliver actions as predicates in the form deliver_action_dlic(Object,Probability)

load_deliver_actions_dlic(KB):-
	objects_of_a_class(deliver,KB,AllDeliversKB),
	load_deliver_action_dlic(AllDeliversKB,KB).

load_deliver_action_dlic([],_).
	
load_deliver_action_dlic([H|T],KB):-
	object_relation_value(H,to,KB,Object),
	object_property_value(H,cost,KB,Cost),
	object_property_value(H,probability,KB,Probability),
	assert(deliver_action_dlic(Object,Cost,Probability)),
	load_deliver_action_dlic(T,KB).



%Get the nearest unobserved shelf

nearest_unobserved_shelf_dlic(CurrentShelf,AllPreviousObservedShelves,OrderedUnobservedShelves):-
	%Get the list in order from the current shelf to the rest of shelf
	setof(Y=>X,move_action_dlic(CurrentShelf,X,Y,_),DistanceToShelves),
	%Remove distances to get the list only with the ids
	transform_list_nearest_unobserved_dlic(DistanceToShelves,[],NewList),
	%Remove the start from the list
	rest_of_lists_dlic([start],NewList,NewList2),
	%Remove all previous observed shelves
	rest_of_lists_dlic(AllPreviousObservedShelves,NewList2,OrderedUnobservedShelves).			

transform_list_nearest_unobserved_dlic([],X,X).

transform_list_nearest_unobserved_dlic([_=>Y|T],PreviousList,NewList):-
	append(PreviousList,[Y],AuxList),
	transform_list_nearest_unobserved_dlic(T,AuxList,NewList).
	

%Assign the missed object in the nearest unobserved shelf, in case there are no more shelves it is registered as lost

assign_missed_in_nearest_dlic(KB,[],MissedObject,NewKB):-
	change_value_object_relation(MissedObject,last_corroborated_position,lost,KB,NewKB),
	write(MissedObject),write(' was registered as lost'),nl.
	
assign_missed_in_nearest_dlic(KB,[H|_],MissedObject,NewKB2):-
	object_property_value(H,belief,KB,Belief),
	append(Belief,[MissedObject],NewBelief),
	change_value_object_property(H,belief,NewBelief,KB,NewKB),
	write(MissedObject),write(' is now believed to be in '),write(H),nl,
	object_property_value(golem,position,KB,RobotCurrentPosition),
	add_object_relation(RobotCurrentPosition,nearest_shelf,H,NewKB,NewKB2),
	write(H),write(' was registered in KB as nearest shelf to '),write(RobotCurrentPosition),nl. 
	
%Modify beliefs about missign objects by assing them randomly in the unobserved shelves

reasign_belief_missing_objects_dlic(KB,[],_,KB).

reasign_belief_missing_objects_dlic(KB,[H|T],OrderedUnobservedShelves,NewKB):-
	reasign_a_missing_object_dlic(KB,H,OrderedUnobservedShelves,KBAux),
	reasign_belief_missing_objects_dlic(KBAux,T,OrderedUnobservedShelves,NewKB).

reasign_a_missing_object_dlic(KB,H,[],NewKB):-
	change_value_object_relation(H,last_corroborated_position,lost,KB,NewKB),
	write(H),write(' was registered as lost'),nl. 
	
reasign_a_missing_object_dlic(KB,H,Shelves,NewKB):-
	random_permutation(Shelves,[RandomShelf|_]),
	object_property_value(RandomShelf,belief,KB,Belief),
	append(Belief,[H],NewBelief),
	change_value_object_property(RandomShelf,belief,NewBelief,KB,NewKB),
	write(H),write(' is now believed to be in '),write(RandomShelf),nl. 
	

%Substract observed object from beliefs of unobserved shelfs

substract_observed_from_beliefs(X,[],_,X).

substract_observed_from_beliefs(KB,[Shelf|T],Observed,NewKB):-
	object_property_value(Shelf,belief,KB,BelievedObjects),
	rest_of_lists_dlic(Observed,BelievedObjects,NewBelief),	
	change_value_object_property(Shelf,belief,NewBelief,KB,AuxKB),
	substract_observed_from_beliefs(AuxKB,T,Observed,NewKB).


%Generating the diagnosis

recolect_all_observations_dlic([],X,X,_).
	
recolect_all_observations_dlic([Shelf|T],List,NewList,KB):-
	append(List,[move(Shelf)],AuxList),
	object_property_value(Shelf,observed_objects,KB,ObservedObjects),
	append(AuxList,[place(ObservedObjects)],AuxList2),
	recolect_all_observations_dlic(T,AuxList2,NewList,KB).

recolect_all_beliefs_dlic([],X,X,_).

recolect_all_beliefs_dlic([Shelf|T],List,NewList,KB):-
	append(List,[move(Shelf)],AuxList),
	object_property_value(Shelf,belief,KB,BelievedObjects),
	append(AuxList,[place(BelievedObjects)],AuxList2),
	recolect_all_beliefs_dlic(T,AuxList2,NewList,KB).












	
