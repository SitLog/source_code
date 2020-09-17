
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%    PLANNER    %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%   Arturo Rodriguez Garcia   %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  INITIALIZE ACTIONS VALUES %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

initialize_function_actions_values(KB):-
	write('Action Values were taken from the KB'),nl,
	load_move_functions(KB), 
	load_search_functions(KB),
	load_grasp_functions(KB), 
	load_deliver_functions(KB),nl.

load_move_functions(KB):-
	objects_of_a_class(move,KB,X),
	load_move_action(KB,X).

load_move_action(_,[]).

load_move_action(KB,[H|T]):-
	object_relation_value(H,from,KB,X),
	object_relation_value(H,to,KB,Y),
	object_property_value(H,p,KB,P),
	object_property_value(H,c,KB,C),
	object_property_value(H,r,KB,R),
	write('move('),write(X),write(','),write(Y),write(')=('),write(P),write(','),write(C),write(','),write(R),write(')'),nl,
	assert(action(move(X,Y),P,C,R)),
	load_move_action(KB,T).
	
load_search_functions(KB):-
	objects_of_a_class(search,KB,X),
	load_search_action(KB,X).

load_search_action(_,[]).

load_search_action(KB,[H|T]):-
	object_relation_value(H,to,KB,X),
	object_property_value(H,p,KB,P),
	object_property_value(H,c,KB,C),
	object_property_value(H,r,KB,R),
	write('search('),write(X),write(')=('),write(P),write(','),write(C),write(','),write(R),write(')'),nl,
	assert(action(search(X),P,C,R)),
	load_search_action(KB,T).

load_grasp_functions(KB):-
	objects_of_a_class(grasp,KB,X),
	load_grasp_action(KB,X).

load_grasp_action(_,[]).

load_grasp_action(KB,[H|T]):-
	object_relation_value(H,to,KB,X),
	object_property_value(H,p,KB,P),
	object_property_value(H,c,KB,C),
	object_property_value(H,r,KB,R),
	write('grasp('),write(X),write(')=('),write(P),write(','),write(C),write(','),write(R),write(')'),nl,
	assert(action(grasp(X),P,C,R)),
	load_grasp_action(KB,T).

load_deliver_functions(KB):-
	objects_of_a_class(deliver,KB,X),
	load_deliver_action(KB,X).

load_deliver_action(_,[]).

load_deliver_action(KB,[H|T]):-
	object_relation_value(H,to,KB,X),
	object_property_value(H,p,KB,P),
	object_property_value(H,c,KB,C),
	object_property_value(H,r,KB,R),
	write('deliver('),write(X),write(')=('),write(P),write(','),write(C),write(','),write(R),write(')'),nl,
	assert(action(deliver(X),P,C,R)),
	load_deliver_action(KB,T).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% SUBOBJECTIVES %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Decompose commands into subobjectives
decompose_in_subobjectives([],_,[]).

decompose_in_subobjectives([bring(O,L)|T1],KB,[move_grasp_position(P),search(O,P),grasp(O,P),move_deliver_position(O,L),deliver(O,L)|T2]):- 
	object_property_value(O,in,KB,P),	
	decompose_in_subobjectives(T1,KB,T2).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% INITIAL STATE %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Given the objectives, creates the initial state containing only relevant information
create_initial_state(Objectives,KB,InitialState):- 
	append([robot_position(start),target(nothing),hand(left,free),hand(right,free)],ObjectPosition,InitialState), 
	add_object_position_initial_state(Objectives,KB,ObjectPosition).

%Each object in the objectives is added as relevant in the initial state
add_object_position_initial_state([],_,[]).

add_object_position_initial_state([bring(O,_)|T1],KB,[object_position(O,P)|T2]):- 
	object_property_value(O,in,KB,P), 	
	add_object_position_initial_state(T1,KB,T2).
	
	


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% POSSIBLE ACTIONS %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Given a list of subobjectives and a current state, verifies which actions can be applied

possible_actions(State,Subobjectives,Actions):-
	verify_possible_actions(State,Subobjectives,Aux),
	delete_duplicates(Aux,Actions),
	!.

%Check which actions can be used according the PRECONDITIONS

verify_possible_actions(_,[],[]).

verify_possible_actions(S,[H|T],[H|NewT]):-
	check_valid_preconditions(S,H),
	verify_possible_actions(S,T,NewT).
	
verify_possible_actions(S,[_|T],NewT):-
	verify_possible_actions(S,T,NewT).

%move_grasp_position preconditions

check_valid_preconditions(State,move_grasp_position(X)):-
	isElement(robot_position(P),State),
	P\==X.
	
%Search preconditions

check_valid_preconditions(State,search(O,P)):-
	isElement(robot_position(P),State),
	isElement(object_position(O,P),State).

%Grasp preconditions

check_valid_preconditions(State,grasp(O,P)):-
	isElement(robot_position(P),State),
	isElement(target(O),State),
	isElement(object_position(O,P),State),
	isElement(hand(_,free),State).

%Move_deliver_position preconditions

check_valid_preconditions(State,move_deliver_position(O,L)):-
	isElement(robot_position(P),State),
	P\==L,
	isElement(hand(_,O),State).

%Deliver preconditions

check_valid_preconditions(State,deliver(O,L)):-
	isElement(robot_position(L),State),
	isElement(hand(_,O),State).


%Delete duplicates
%Given a list, delete any duplicate
%For example, [b,a,n,a,n,i,t,a] is reduced to [b,a,n,i,t]

delete_duplicates([],[]).

delete_duplicates([H|T],[H|NewT]):-
	deleteElement(H,T,Aux),
	delete_duplicates(Aux,NewT).
	
	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% NEXT STATE FUNCTION %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Given the actual state and a choosen action, determines next state

next_state_function(State,Action,NextState):-
	apply_effect_of_action(State,Action,NextState),!.

%Move action effect

apply_effect_of_action(State,move_grasp_position(P),NextState):-
	changeElement(robot_position(_),robot_position(P),State,Aux),
	changeElement(target(_),target(nothing),Aux,NextState).

apply_effect_of_action(State,move_deliver_position(_,P),NextState):-
	changeElement(robot_position(_),robot_position(P),State,Aux),
	changeElement(target(_),target(nothing),Aux,NextState).
	
%Search action effect

apply_effect_of_action(State,search(O,_),NextState):-
	changeElement(target(_),target(O),State,NextState).
	
%Grasp action effect

%Left hand free
apply_effect_of_action(State,grasp(O,_),NextState):-
	isElement(hand(left,free),State),
	changeElement(hand(left,free),hand(left,O),State,Aux),
	changeElement(target(_),target(nothing),Aux,Aux2),
	changeElement(object_position(O,_),object_position(O,me),Aux2,NextState).

%Right hand free
apply_effect_of_action(State,grasp(O,_),NextState):-
	isElement(hand(right,free),State),
	changeElement(hand(right,free),hand(right,O),State,Aux),
	changeElement(target(_),target(nothing),Aux,Aux2),
	changeElement(object_position(O,_),object_position(O,me),Aux2,NextState).

%Deliver action effect
apply_effect_of_action(State,deliver(O,P),NextState):-
	isElement(hand(H,O),State),
	changeElement(hand(H,O),hand(H,free),State,Aux),
	changeElement(target(_),target(nothing),Aux,Aux2),
	changeElement(object_position(O,_),object_position(O,P),Aux2,NextState).
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% DELETE SUBOBJECTIVE %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Given a list of subobjectives and a performed action, deletes the subobjective

delete_subobjective(ActionPerformed,Subobjectives,ReducedSubobjectives):-
	deleteElementOnce(ActionPerformed,Subobjectives,ReducedSubobjectives).
	
%Delete first ocurrence of an element X in a list
%deleteElementOnce(X,InputList,OutputList).
%Example (a,[p,a,p,a,y,a],[p,p,a,y,a])

deleteElementOnce(_,[],[]).

deleteElementOnce(X,[X|T],T).

deleteElementOnce(X,[H|T],[H|N]):-
	deleteElementOnce(X,T,N),
	X\=H.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% TRANSLATOR OF ACTIONS  %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Write the action into its final form (free of unnecessary details)

translate_action_final_form(State,move_grasp_position(P),move(X,P)):-
	isElement(robot_position(X),State).	

translate_action_final_form(State,move_deliver_position(_,P),move(X,P)):-
	isElement(robot_position(X),State).

translate_action_final_form(_,search(O,_),search(O)).

translate_action_final_form(_,grasp(O,_),grasp(O)).

translate_action_final_form(_,deliver(O,_),deliver(O)).	



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% COST OF A PLAN  %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

calculates_cost_of_plan(NewCurrentPlan,Tmax,Probability,Cost,Reward,G):-
	determines_values_of_actions_in_the_plan(NewCurrentPlan,Probability,Cost,Reward),
	TimeBonus is 1 + ( (Tmax-Cost) / (2*Tmax) ),
	G is Reward*Probability*TimeBonus.


determines_values_of_actions_in_the_plan([],P,C,R):-
	P is 1,
	C is 0,
	R is 0.

determines_values_of_actions_in_the_plan([H|T],P,C,R):-
	action(H,P1,C1,R1),
	determines_values_of_actions_in_the_plan(T,P2,C2,R2),
	P is P1*P2,
	C is C1+C2,
	R is R1+R2.
		


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  SEARCHING WITH DFS %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	
%Search the best plan using Depth First Search
%Receive a command of the form [bring(o1,l1),bring(o2,l2),bring(o3,l3)] and a maximum time in seconds

dfs_planner(Command,Tmax,KB,CurrentPlan):-
	
	%Initialize KB
	nl,write('Starting planner...'),nl,nl,  

	%Load actions values in the KB
	initialize_function_actions_values(KB),nl,

	%Creates initial node

	%Generate initial state
	create_initial_state(Command,KB,InitialState), 
	
	%Get subobjectives from commands
	decompose_in_subobjectives(Command,KB,Subobjectives), 
	
	%Determine possible actions
	possible_actions(InitialState,Subobjectives,Actions),
	
	%Display information of the initial state
	write('Initial Node'),nl, 
	write('------------'),nl,nl,
	display_node_information([InitialState,[],[1,0,0,0],Subobjectives,Actions]),

	search_with_dfs([[InitialState,[],[1,0,0,0],Subobjectives,Actions]],Tmax,Counter,[State,CurrentPlan,[P,C,R,G],RestSubobjectives,PossibleActions]),
	write('Result'),nl,
	write('------'),nl,
	write('Number of expanded nodes: '),write(Counter),nl,
	write('The best solution found is: '),nl,display_node_information([State,CurrentPlan,[P,C,R,G],RestSubobjectives,PossibleActions]),nl,nl,
	write('Output: '),write(CurrentPlan),nl.


%Display the node information.

display_node_information([State,CurrentPlan,[P,C,R,G],RestSubobjectives,PossibleActions]):-
	write('State: '),write(State),nl,nl,
	write('Current plan: '),write(CurrentPlan),nl,nl,
	write('Cost of current plan: '),nl,
	write('Probability: '),write(P),nl,
	write('Cost: '),write(C),nl,
	write('Reward: '),write(R),nl,
	write('G(n): '),write(G),nl,nl,	
	write('Remaining suboobjectives to do: '),write(RestSubobjectives),nl,nl,
	write('Possible actions: '),write(PossibleActions),nl,nl.
	

%Search with DFS

search_with_dfs([],_,Counter,[]):-
	Counter is 0.

search_with_dfs(ListOfNodes,Tmax,Counter,TheBestNode):-
	choose_a_node(ListOfNodes,SelectedNode,RestNodes),
	expand_chosen_node(SelectedNode,Tmax,NewNodes),
	append(RestNodes,NewNodes,NewListOfNodes),
	search_with_dfs(NewListOfNodes,Tmax,C,BestNode),
	keep_best_node(SelectedNode,BestNode,TheBestNode),
	Counter is C+1.


%Keep track of the best node founded
keep_best_node(Node,[],Node).

keep_best_node([State1,CurrentPlan1,[P1,C1,R1,G1],RestSubobjectives1,PossibleActions1],[_,_,[_,_,_,G2],_,_],[State1,CurrentPlan1,[P1,C1,R1,G1],RestSubobjectives1,PossibleActions1]):-
	G1>=G2.

keep_best_node(_,Node2,Node2).


%Choose a node using DFS criteria

choose_a_node([],[],[]).

choose_a_node([H|T],H,T).


%Expand a chosen node, creating all its son (if there are)

%For every possible action creates a node
expand_chosen_node([State,CurrentPlan,[P,C,R,G],RestSubobjectives,PossibleActions],Tmax,SonNodes):-
	create_son_nodes([State,CurrentPlan,[P,C,R,G],RestSubobjectives,PossibleActions],Tmax,SonNodes).


create_son_nodes([_,_,[_,_,_,_],_,[]],_,[]).

create_son_nodes([State,CurrentPlan,[P,C,R,G],RestSubobjectives,[Action|T]],Tmax,NewNodes):-
	
	%Apply first action in list
	next_state_function(State,Action,NextState),
	
	%Delete satisficied subobjective
	delete_subobjective(Action,RestSubobjectives,NewRestSubobjectives),
	
	%Determine the possible actions in this point
	possible_actions(NextState,NewRestSubobjectives,NewActions),

	%Write current plan
	translate_action_final_form(State,Action,FinalFormAction),
	append(CurrentPlan,[FinalFormAction],NewCurrentPlan),
	
	%Estimates the cost of the actual plan
	calculates_cost_of_plan(NewCurrentPlan,Tmax,Probability,Cost,Reward,GFunction),

	%Verify if the Cost in time of this plan is less than Tmax
	Cost =< Tmax,

	%write(NewCurrentPlan),write('Costo=['),write(Probability),write(','),write(Cost),write(','),write(Reward),write(','),write(GFunction),write(']'),nl,

	%Determines rest of nodes
	create_son_nodes([State,CurrentPlan,[P,C,R,G],RestSubobjectives,T],Tmax,RestNodes),
	
	append([[NextState,NewCurrentPlan,[Probability,Cost,Reward,GFunction],NewRestSubobjectives,NewActions]],RestNodes,NewNodes).
	

%Throw away nodes with cost bigger than Tmax 

create_son_nodes([State,CurrentPlan,[P,C,R,G],RestSubobjectives,[_|T]],Tmax,NewNodes):-
	create_son_nodes([State,CurrentPlan,[P,C,R,G],RestSubobjectives,T],Tmax,NewNodes).


	
		
