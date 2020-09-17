%%%%%%%%%%%%%%%%%%%%%%%%
%%                    %%
%%   DECISION MAKER   %%
%%                    %%
%%%%%%%%%%%%%%%%%%%%%%%%

%Input: 
%	KB
%Output: 
%	Decision

decision_maker_dlic(KB,Decision):-
	nl,nl,write('Starting module of decision'),nl,
	
	%Get the list of misplaced objects
	object_property_value(pending_tasks,list,KB,MisplacedObjects),
	write('All misplaced objects: '),write(MisplacedObjects),nl, 

	%Get the list of orders of the client
	object_property_value(pending_client_orders,list,KB,ClientOrders),
	write('Objects ordered by the client: '),write(ClientOrders),nl,

	%Get the list of objects to realocate in the scenario
	rest_of_lists_dlic(ClientOrders,MisplacedObjects,ObjectsToRealocate),
	write('Objects to realocate in the scenario: '),write(ObjectsToRealocate),nl,

	%Get the power set of Objects to Realocate
	power_set_dlic(ObjectsToRealocate,_,PowerSetRealocate),
	write('Possible elections of objects to realocate: '),write(PowerSetRealocate),nl,

	%Assign a calification to each possible subset of realocated
	grade_possible_realocations_dlic(PowerSetRealocate,GradedPowerSetRealocate,KB),
	sort(GradedPowerSetRealocate,OrderedGradedPowerSetRealocate),
	reverse(OrderedGradedPowerSetRealocate,DescendingOrderedGradedPowerSetRealocate),
	write('Graded possible elections of objects to realocate: '),write(DescendingOrderedGradedPowerSetRealocate),nl,

	%Generate final decision
	generate_final_decision_dlic(ClientOrders,DescendingOrderedGradedPowerSetRealocate,Decision),
	write('Decision: '),write(Decision),nl. 

	

%Power Set
%Input:  Set, Empty list
%Output:  Powerset

power_set_dlic([],X,X).

%First element
power_set_dlic([H|T],[],NewList):-
	power_set_dlic(T,[[],[H]],NewList).

%Rest of elements
power_set_dlic([H|T],List,NewList):-
	add_element_to_each_list_of_list_dlic(H,List,AuxList1),
	append(List,AuxList1,AuxList2),
	power_set_dlic(T,AuxList2,NewList).
			
%Add element X to each list of list
%Example add_element_to_each_list_of_list_dlic(a,[[b,c],[d,e],[m,n,c]],Result).
%Result= [[b, c, a], [d, e, a], [m, n, c, a]] .

add_element_to_each_list_of_list_dlic(_,[],[]).

add_element_to_each_list_of_list_dlic(X,[H|T],[NewH|NewT]):-
	append(H,[X],NewH),
	add_element_to_each_list_of_list_dlic(X,T,NewT).


%Grade possible realocations

grade_possible_realocations_dlic([],[],_).

grade_possible_realocations_dlic([H|T],[Val=>H|NewT],KB):-
	write('Evaluating '),write(H),
	evaluate_proposal_dlic(H,Val,KB),
	write(' Score: '),write(Val),nl,
	grade_possible_realocations_dlic(T,NewT,KB).

evaluate_proposal_dlic([],0,_).

evaluate_proposal_dlic([H|T],NewVal,KB):-
	%Get the probability of taking the current object
	take_action_dlic(H,_,Probability),

	%Verify if realing this object is a good idea (0/1)
	is_a_good_idea_dlic(H,KB,IsGoodIdea),
	
	evaluate_proposal_dlic(T,Val,KB),
	NewVal is Val + ((Probability/100)*IsGoodIdea).	


%Is a Good Idea to realign this object when:
%The object to realign is in the current shelf
%The object CorrectShelfPosition is the NextShelf to be visited (the nearest)

is_a_good_idea_dlic(Object,KB,Value):-
	object_relation_value(Object,last_corroborated_position,KB,ObjectCurrentShelf),
	object_relation_value(Object,associated_shelf,KB,ObjectCorrectShelf),	
	object_property_value(golem,position,KB,RobotCurrentPosition),
	object_relation_value(RobotCurrentPosition,nearest_shelf,KB,NearestShelf),
	evaluate_if_is_a_good_realign_dlic(RobotCurrentPosition,NearestShelf,ObjectCurrentShelf,ObjectCorrectShelf,Value).

evaluate_if_is_a_good_realign_dlic(X,Y,X,Y,1).

evaluate_if_is_a_good_realign_dlic(_,_,_,_,-1).


%Generate final decision

generate_final_decision_dlic(ClientOrders,[_=>RealignObjects|_],Decision):-
	generate_bring_list_dlic(ClientOrders,Aux1),
	generate_rearrange_list_dlic(RealignObjects,Aux2),
	append(Aux1,Aux2,Decision).
	
generate_bring_list_dlic([],[]).

generate_bring_list_dlic([H|T],Result):-
	generate_bring_list_dlic(T,Aux),
	append([bring(H)],Aux,Result).

generate_rearrange_list_dlic([],[]).

generate_rearrange_list_dlic([H|T],Result):-
	generate_rearrange_list_dlic(T,Aux),
	append([rearrange(H)],Aux,Result).











