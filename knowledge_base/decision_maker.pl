%%%%%%%%%%%%%%%%%%%%%%%%
%%                    %%
%%   DECISION MAKER   %%
%%                    %%
%%%%%%%%%%%%%%%%%%%%%%%%


%Input: 
%	KB.- which includes the current beliefs of the robot about the position of objects,
%		and the list of orders of the client
%Output: 
%	Decision.- list of decisions, which includes delivers in atention to the client and
%		realigns of objects in the scenario
%	Result.- is the decision in a format compatible with the planner module



decision_maker(KB,Decision,Result):-
	nl,
	write('Starting Decision Maker'),
	nl,nl,    
	write('Loading data from KB'),nl,
	objects_of_a_class(orders,KB,OrdersID),  
	dm_get_list_or_orders_from_ids(OrdersID,Orders), 
	write('Orders: '),write(Orders),nl,   
	dm_get_list_of_realigns(KB,Realigns),
	write('Realigns: '),write(Realigns),nl,
	append(Realigns,Orders,Actions),
	dm_search_decision([[[],Actions]],[[],Actions],[Decision,[]]),
	nl, write('Decision: '),write(Decision),
	dm_translate_decision_from_brand_to_ID(Decision,KB,Result),
	nl, write('Output: '),write(Result), 
	nl,nl,nl.	

dm_get_list_or_orders_from_ids([],[]).

dm_get_list_or_orders_from_ids([bring(H)|T],[bring(H,client)|NewT]):-
	dm_get_list_or_orders_from_ids(T,NewT).


dm_get_list_of_realigns(KB,Realigns):-
	objects_of_a_class(object,KB,AllObjects),
	dm_colect_data_objects(AllObjects,KB,DataObjects),
	dm_select_objects_to_realign(DataObjects,Realigns).

dm_colect_data_objects([],_,[]).

dm_colect_data_objects([ID|T],KB,[obj(Brand,IsIn,Shelf)|NewT]):-
	object_property_value(ID,brand,KB,Brand),
	object_property_value(ID,in,KB,IsIn),
	object_property_value(ID,shelf,KB,Shelf),
	dm_colect_data_objects(T,KB,NewT).	

dm_select_objects_to_realign([],[]).

dm_select_objects_to_realign([obj(_,storage,_)|T],NewT):-
	dm_select_objects_to_realign(T,NewT).

dm_select_objects_to_realign([obj(_,X,X)|T],NewT):-
	dm_select_objects_to_realign(T,NewT).

dm_select_objects_to_realign([obj(ID,_,Y)|T],[realign(ID,Y)|NewT]):-
	dm_select_objects_to_realign(T,NewT).



dm_translate_decision_from_brand_to_ID([],_,[]).

dm_translate_decision_from_brand_to_ID([bring(X,client)|T],KB,[bring(ID,start)|NewT]):-
	dg_get_object_of_the_brand(X,KB,ID),
	dm_translate_decision_from_brand_to_ID(T,KB,NewT).

dm_translate_decision_from_brand_to_ID([bring(X,Y)|T],KB,[bring(ID,Y)|NewT]):-
	dg_get_object_of_the_brand(X,KB,ID),
	dm_translate_decision_from_brand_to_ID(T,KB,NewT).

dm_translate_decision_from_brand_to_ID([realign(X,Y)|T],KB,[bring(ID,Y)|NewT]):-
	dg_get_object_of_the_brand(X,KB,ID),
	dm_translate_decision_from_brand_to_ID(T,KB,NewT).



%Search decision tree
%A state includes Rest of Actions 

dm_search_decision([],Best,Best).

dm_search_decision([[ActionsSelected, RestActions]|T],Best,Result):-
	nl,write('Actions: '),write(ActionsSelected),tab(4),write('RestActions: '),write(RestActions),
	dm_evaluate_state([ActionsSelected,RestActions],Eval),
	tab(4),write('Eval: '),write(Eval),
	dm_generate_next_states(ActionsSelected,RestActions,RestActions,NextStates),
	append(T,NextStates,NewStates),
	dm_choose_new_best([ActionsSelected, RestActions],Best,NewBest),
	dm_search_decision(NewStates,NewBest,Result).

%Generate next states

dm_generate_next_states(_,_,[],[]).

dm_generate_next_states(ActionsSelected,RestActions,[Action|T],[[NewActions,FilterNewRestActions]|NewT]):-
	append(ActionsSelected,[Action],NewActions),
	deleteElement(Action,RestActions,NewRestActions),
	dm_filter_repeated_objects(Action,NewRestActions,FilterNewRestActions),
	dm_generate_next_states(ActionsSelected,RestActions,T,NewT).
	
dm_filter_repeated_objects(bring(Object,_),NewRestActions,FilterNewRestActions):-
	deleteElement(bring(Object,X),NewRestActions,Aux),
	deleteElement(realign(Object,X),Aux,FilterNewRestActions).

dm_filter_repeated_objects(realign(Object,_),NewRestActions,FilterNewRestActions):-
	deleteElement(bring(Object,X),NewRestActions,Aux),
	deleteElement(realign(Object,X),Aux,FilterNewRestActions).
		

%State Evaluation

dm_evaluate_state([[],_],0).

dm_evaluate_state([[bring(_,_)|T],_],Eval):-
	dm_evaluate_state([T,_],Eval2),
	Eval is Eval2 + 3.	

dm_evaluate_state([[realign(_,_)|T],_],Eval):-
	dm_evaluate_state([T,_],Eval2),
	Eval is Eval2 + 1.


%Choose new best

dm_choose_new_best(CurrentNode,Best,Best):-
	dm_evaluate_state(CurrentNode,Res1),
	dm_evaluate_state(Best,Res2),
	Res2 >= Res1.

dm_choose_new_best(CurrentNode,Best,CurrentNode):-
	dm_evaluate_state(CurrentNode,Res1),
	dm_evaluate_state(Best,Res2),
	Res2 < Res1.

