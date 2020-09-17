%%%%%%%%%%%%%%%%%%%%%%%
%%                   %%
%%   DIAGNOSTICIAN   %%
%%                   %%
%%%%%%%%%%%%%%%%%%%%%%%


%Input: 
%	KB.- which includes the current beliefs of the robot about the position of objects,
%		the observations done by the robot, and the dialogs with the assistant
%Output: 
%	Explanation.- The sequence of actions performed by the assistant 
%	New_KB.- and actualized KB with the new beliefs about the position objects, according to the
%		produced explanation 


diagnostician(KB,Explanation,NewKB):-
	nl,
	write('Starting Diagnostician'),
	nl,nl,
	write('Loading data from KB'), 
	object_property_value(dialog1,content,KB,ReportedAssistantActions),
	nl,
	write('Reported Actions by the Assistant: '),
	write(ReportedAssistantActions),
	nl, 
	property_extension(observed_objects,KB,Observed_Objects),
	write('Observed objects: '),
	write(Observed_Objects),
	nl,  
	dg_get_list_of_objects(ReportedAssistantActions,ImportantObjects),
	write('Important objects: '),
	write(ImportantObjects),
	nl, 
	dg_get_list_of_locations(ReportedAssistantActions,ImportantLocs),	
	delete_duplicates(ImportantLocs,ImportantLocations),
	write('Important locations: '),
	write(ImportantLocations),
	nl,
	dg_get_list_of_actions_infered_by_observation(Observed_Objects,ActionsByObservation),
	write('Actions infered by direct observation: '),
	write(ActionsByObservation),
	nl,
	dg_get_rest_of_locations(ImportantLocations,ActionsByObservation,RestLocations),
	write('Rest of locations: '),
	write(RestLocations),
	nl,	
	dg_get_rest_of_objects(ImportantObjects,ActionsByObservation,RestObjects),
	write('Rest of objects: '),
	write(RestObjects), 
	nl,nl,nl,write('Starting search'),nl,nl,
	dg_search_explanation([[ActionsByObservation,RestObjects,RestLocations]],ReportedAssistantActions,[ActionsByObservation,RestObjects,RestLocations],[Explanation,_,_]),
	nl,nl,
	write('Result: '),
	write(Explanation),
	dg_actualize_KB(KB,Explanation,NewKB),  
	nl,nl,nl.	


dg_get_list_of_objects([],[]).

dg_get_list_of_objects([bring(X,_)|T],[X|NewT]):-
	dg_get_list_of_objects(T,NewT).	



dg_get_list_of_locations([],[]).

dg_get_list_of_locations([bring(_,X)|T],[X|NewT]):-
	dg_get_list_of_locations(T,NewT).	



dg_get_list_of_actions_infered_by_observation(ObservedObjects,ActionsByObservation):-
	dg_observed_actions(ObservedObjects,ABO),
	append_list_of_lists(ABO,ActionsByObservation).

dg_observed_actions([],[]).

dg_observed_actions([O|T],[PartialPlan|NewT]):-
	dg_process_observation_in_plan(O,PartialPlan),
	dg_observed_actions(T,NewT).

dg_process_observation_in_plan(observation(Location):Objects,PartialPlan):-
	append([move(Location)],ObjectDecomposition,PartialPlan),
	dg_decompose_objects_in_delivers(Objects,ObjectDecomposition).

dg_decompose_objects_in_delivers([],[]).

dg_decompose_objects_in_delivers([H|T],[deliver(H)|NewT]):-
	dg_decompose_objects_in_delivers(T,NewT).	



dg_get_rest_of_locations(X,[],X).

dg_get_rest_of_locations(X,[deliver(_)|T],Y):-
	dg_get_rest_of_locations(X,T,Y).

dg_get_rest_of_locations(X,[move(Location)|T],Z):-	
	deleteElement(Location,X,Y),
	dg_get_rest_of_locations(Y,T,Z).
	


dg_get_rest_of_objects(X,[],X).

dg_get_rest_of_objects(X,[move(_)|T],Y):-
	dg_get_rest_of_objects(X,T,Y).

dg_get_rest_of_objects(X,[deliver(Object)|T],Z):-	
	deleteElement(Object,X,Y),
	dg_get_rest_of_objects(Y,T,Z).



dg_show_state([X,Y,Z]):-
	nl,write('Final actions: '),write(X),tab(4),
	write('Rest objects: '),write(Y),tab(4),
	write('Rest locations: '),write(Z). 


%Start searching algorithm
%The first argument is the list of nodes in the frontier. Each node contains the List of final actions of the plan, 
%the rest of objects to deliver and the rest of locations to visit.
%Second argument is the list of reported actions by the assistant, which is used to determine the evaluation function
%The third argument is the current best node
%The result of the plan is retrieved in the third argument.

dg_search_explanation([],_,BestNode,BestNode).

dg_search_explanation([Node|T],ReportedAssistantActions,CurrentBestNode,Result):-
	%dg_show_state(Node), 
	dg_evaluate_node(Node,ReportedAssistantActions,Evaluation),
	%tab(3),write('E='),write(Evaluation),nl,
	dg_sucesor_function(Node,PossibleActions),
	%nl,write('Possible actions: '),write(PossibleActions), 
	dg_determine_all_sucesor_nodes(Node,PossibleActions,SucesorNodes),
	%nl,write('Sucesor nodes: '),write(SucesorNodes), 
	append(T,SucesorNodes,AllNodesInFrontier),
	%nl,write('All nodes in frontier: '),write(AllNodesInFrontier),
	dg_choose_best_node(Node,CurrentBestNode,ReportedAssistantActions,NewBestNode),
	dg_search_explanation(AllNodesInFrontier,ReportedAssistantActions,NewBestNode,Result).


%Sucesor function

%EMPTY case (there are no objects or locations to deliver)
dg_sucesor_function([_,[],[]],[]).

%EMPTY PREACTION CASE (there are no last actions)
dg_sucesor_function([[],RestObjects,_],ListOfPossibleActions):-
	dg_decompose_deliver_list(RestObjects,ListOfPossibleActions).

%MOVE postconditions

%Case 1 First action is move, and there are still objects in the list, but there are no more locations to deliver
dg_sucesor_function([[move(_)|_],_,[]],[]).

%Case 2 First action is move, and there are still locations in the list, but there are no more objects to deliver
dg_sucesor_function([[move(_)|_],[],_],[]).

%Case 3 First action is move, and there are still objects in the list and locations to deliver
dg_sucesor_function([[move(_)|_],RestObjects,_],ListOfPossibleActions):-
	dg_decompose_deliver_list(RestObjects,ListOfPossibleActions).


%DELIVER postconditions

%Case 3 First action is deliver, and there are still objects in the list and locations to deliver

dg_sucesor_function([[deliver(_)|_],RestObjects,RestLocations],ListOfPossibleActions):-
	dg_decompose_deliver_list(RestObjects,List1),
	dg_decompose_move_list(RestLocations,List2),
	append(List1,List2,ListOfPossibleActions).

%EMPTY PLAN postconditions

dg_sucesor_function([[],RestObjects,RestLocations],ListOfPossibleActions):-
	dg_decompose_deliver_list(RestObjects,List1),
	dg_decompose_move_list(RestLocations,List2),
	append(List1,List2,ListOfPossibleActions).


dg_decompose_deliver_list([],[]).

dg_decompose_deliver_list([H|T],[deliver(H)|NewT]):-
	dg_decompose_deliver_list(T,NewT).


dg_decompose_move_list([],[]).

dg_decompose_move_list([H|T],[move(H)|NewT]):-
	dg_decompose_move_list(T,NewT).		



%NEXT STATE 

dg_next_state([LastActions,RestObjects,RestLocations],move(X),[NewLastActions,RestObjects,NewRestLocations]):-
	append([move(X)],LastActions,NewLastActions),
	deleteElement(X,RestLocations,NewRestLocations).

dg_next_state([LastActions,RestObjects,RestLocations],deliver(X),[NewLastActions,NewRestObjects,RestLocations]):-
	append([deliver(X)],LastActions,NewLastActions),
	deleteElement(X,RestObjects,NewRestObjects).


%ALL SUCESOR NODES

dg_determine_all_sucesor_nodes(_,[],[]).

dg_determine_all_sucesor_nodes(Node,[Action|T],[NextNode|NewT]):-
	dg_next_state(Node,Action,NextNode),
	dg_determine_all_sucesor_nodes(Node,T,NewT).
	
	
	
%EVALUATION FUNCTION

dg_evaluate_node([LastActions,RestObjects,_],ReportedAssistantActions,Evaluation):-
	dg_determine_delivers(LastActions,DeliversRealized),
	%nl,write('Realized Delivers: '),write(DeliversRealized),
	dg_determine_number_of_corrects_delivers(DeliversRealized,ReportedAssistantActions,Result1),
	%nl,write('Number of correct delivers: '),write(Result1),
	dg_determine_incorrect_distribution(DeliversRealized,ReportedAssistantActions,Result2),
	%nl,write('Number of incorrect distribution: '),write(Result2),
	dg_determine_restant_objects(RestObjects,Result3),
	%nl,write('Objects still not delivered: '),write(Result3),
	Evaluation is (Result1 - Result2)*Result3,!.

%Reconstruct the delivers from the list of LastActions

dg_determine_delivers([],[]).

dg_determine_delivers([move(X),deliver(Y)],[bring(Y,X)]).

dg_determine_delivers([deliver(_)|T],R):-
	dg_determine_delivers(T,R).

dg_determine_delivers([move(X),deliver(Y),deliver(Z)|T],[bring(Y,X)|R]):-
	dg_determine_delivers([move(X),deliver(Z)|T],R).

dg_determine_delivers([move(X),deliver(Y),move(Z)|T],[bring(Y,X)|R]):-
	dg_determine_delivers([move(Z)|T],R).


%Determine the number of correct delivers

dg_determine_number_of_corrects_delivers([],_,0).

dg_determine_number_of_corrects_delivers([DeliverRealized|T],ReportedAssistantActions,X):-
	isElement(DeliverRealized,ReportedAssistantActions),
	dg_determine_number_of_corrects_delivers(T,ReportedAssistantActions,Y),
	X is Y+1.

dg_determine_number_of_corrects_delivers([_|T],ReportedAssistantActions,X):-
	dg_determine_number_of_corrects_delivers(T,ReportedAssistantActions,X).
	

%Determine incorrect distribution in scenario
		
dg_determine_incorrect_distribution(DeliversRealized,ReportedAssistantActions,DistribDifference):-
	dg_get_list_of_locations(ReportedAssistantActions,ImportantLocs),
	delete_duplicates(ImportantLocs,ImportantLocations),
	dg_get_distribution(ImportantLocations,DeliversRealized,DistribDeliversRealized),
	%nl,write('Distribution of delivers: '),write(DistribDeliversRealized),
	dg_get_distribution(ImportantLocations,ReportedAssistantActions,DistribDeliversExpected),
	%nl,write('Expected distribution of delivers: '),write(DistribDeliversExpected),
	dg_calculate_diference_between_distributions(DistribDeliversRealized,DistribDeliversExpected,DistribDifference).

dg_get_distribution([],_,[]).

dg_get_distribution([Location|T],DeliversRealized,[Number|NewT]):-
	dg_get_number_objects_by_location(Location,DeliversRealized,Number),
	dg_get_distribution(T,DeliversRealized,NewT).	


dg_get_number_objects_by_location(_,[],0).

dg_get_number_objects_by_location(X,[bring(_,X)|T],N):-
	dg_get_number_objects_by_location(X,T,M),
	N is M+1.

dg_get_number_objects_by_location(X,[_|T],N):-
	dg_get_number_objects_by_location(X,T,N).	


dg_calculate_diference_between_distributions([],[],0).

dg_calculate_diference_between_distributions([H1|T],[H2|T2],X):-
	dg_calculate_diference_between_distributions(T,T2,Y),
	X is Y + abs(H1-H2).
	

%Determine if there are objects still not delivered
dg_determine_restant_objects([],1).

dg_determine_restant_objects(_,0).


%COMPARING NODES

dg_choose_best_node(Node,CurrentBestNode,ReportedAssistantActions,Node):-
	dg_evaluate_node(Node,ReportedAssistantActions,Evaluation1),
	dg_evaluate_node(CurrentBestNode,ReportedAssistantActions,Evaluation2),
	%write('Compara: '),write(Evaluation1),write(','),write(Evaluation2),
	Evaluation1>Evaluation2.

dg_choose_best_node(_,X,_,X).



%ACTUALIZE KB

dg_actualize_KB(KB,Explication,NewKB):-
	dg_determine_delivers(Explication,ListOfDelivers),
	objects_of_a_class('grasp object',KB,ObjectsGraspedByRobot),
	dg_remove_objects_grasped_by_robot(ListOfDelivers,ObjectsGraspedByRobot,FinalListOfDelivers),
	dg_actualize_objects_positions(FinalListOfDelivers,KB,NewKB).

dg_actualize_objects_positions([],KB,KB).

dg_actualize_objects_positions([bring(Object,Location)|T],KB,NewKB):-
	dg_get_object_of_the_brand(Object,KB,ID),
	change_value_object_property(ID,in,Location,KB,KB2),
	dg_actualize_objects_positions(T,KB2,NewKB).

dg_get_object_of_the_brand(Object,KB,ID):-
	property_extension(brand,KB,Answer),
	dg_extract_ID_with_brand(Answer,Object,ID).
	
dg_extract_ID_with_brand([],_,[]).

dg_extract_ID_with_brand([ID:Brand|_],Brand,ID).
	
dg_extract_ID_with_brand([_|T],Brand,ID):-
	dg_extract_ID_with_brand(T,Brand,ID).


dg_remove_objects_grasped_by_robot(X,[],X).

dg_remove_objects_grasped_by_robot(X,[grasp(Object)|T],Z):-
	deleteElement(bring(Object,_),X,Y),
	dg_remove_objects_grasped_by_robot(Y,T,Z).
	
