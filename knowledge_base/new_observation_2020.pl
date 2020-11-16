%%%%%%%%%%%%%%%%%%%%%%%%%
%%                     %%
%%   NEW OBSERVATION   %%
%%                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%


%Input: 
%	KB   A knowledge base with information about the scenario (before the observation)
%       Shelf=>Objects  Information about the new observation in the form shelf=>[object_1,...,object_n]

%Output:
%	NewKB   A new KB with modifications based in the information of the new observation. In this new KB the changes are:
%

new_observation_dlic(KB,ObservedShelf=>ObservedObjects,NewKB10):-
	
	%Loading beliefs from KB
	nl,write('El shelf observado es:'),nl,write(ObservedShelf), nl,
	object_property_value(ObservedShelf,original_reported,KB,Reported),
	write('According to the report these objects should be in the shelf and belongs to the class of the shelf: '),write(Reported),nl,

	%Observed objects in the shelf
	write('Observed shelf: '),write(ObservedShelf),nl,
	write('Observed objects (P): '),write(ObservedObjects),nl,
	change_value_object_property(ObservedShelf,observed_objects,ObservedObjects,KB,NewKB1),

	%Get the list of unseen objects
	%Unseen = Reported - Observed
	rest_of_lists_dlic(ObservedObjects,Reported,Unseen),
	write('Unseen objects (Q): '),write(Unseen),nl,
	change_value_object_property(ObservedShelf,unseen_objects,Unseen,NewKB1,NewKB2),

	%Get the list of misplaced objects
	%Misplaced = Observed - Reported
	rest_of_lists_dlic(Reported,ObservedObjects,Misplaced),
	write('Misplaced objects (M): '),write(Misplaced),nl,
	change_value_object_property(ObservedShelf,misplaced_objects,Misplaced,NewKB2,NewKB3),

	%Add the new misplaced objects to the list of all misplaced objects
	object_property_value(all_misplaced_objects,list,KB,PreviousMisplaced),
	append(PreviousMisplaced,Misplaced,NewAllMisplaced),
	write('All misplaced objects (MKB): '),write(NewAllMisplaced),nl,
	change_value_object_property(all_misplaced_objects,list,NewAllMisplaced,NewKB3,NewKB4),

	%Get the missing objects (unseen objects of the current shelf which position is unknown)
	%Missing = Unseen - NewAllMisplaced
	rest_of_lists_dlic(NewAllMisplaced,Unseen,Missing),	
	write('Missing objects of the current shelf (Missing): '),write(Missing),nl,
	change_value_object_property(ObservedShelf,missing_objects,Missing,NewKB4,NewKB5),

	%All observed objects are registered in last_corrobored_position
	register_position_objects_dlic(NewKB5,ObservedShelf,ObservedObjects,NewKB6),	

	%Change the logic flag was_observed to yes the current shelf
	change_value_object_property(ObservedShelf,was_observed,yes,NewKB6,NewKB7),

	%Initialize the objects_after_manipulation with the current observation
	change_value_object_property(ObservedShelf,objects_after_manipulation,ObservedObjects,NewKB7,NewKB8),

	%Add the current shelf to the list of observed shelfs
	object_property_value(observed_shelves,list,KB,AllPreviousObservedShelves),
	append(AllPreviousObservedShelves,[ObservedShelf],AllObservedShelves),
	change_value_object_property(observed_shelves,list,AllObservedShelves,NewKB8,NewKB9),

	%Get the pending tasks
	object_property_value(pending_tasks,list,KB,PreviousPendingTasks),
	append(PreviousPendingTasks,Unseen,AuxList),
	append(AuxList,Misplaced,AuxList2),
	list_to_set(AuxList2,NewPendingTasks),
	change_value_object_property(pending_tasks,list,NewPendingTasks,NewKB9,NewKB10),	

	write(NewKB10).	


%Implementacion of a difference of list L1-L2
%All elements of list L2 are deleted from L1
%Examples
% [b,a,n,a,n,a,s]-[a,s] = [b,n,n]
% [b,a,n,a,n,a,s]-[b,n] = [a,a,a,s]
%Arguments are in this order: L2,L1,L1-L2

rest_of_lists_dlic([],L1,L1).

rest_of_lists_dlic([H|T],L1,NewL1):-
	deleteElement(H,L1,LAux),
	rest_of_lists_dlic(T,LAux,NewL1).


%Register in KB that the objects are in the shelf. The result is NewKB
%Arguments are in order: KB, Shelf, List of objects, NewKB

register_position_objects_dlic(KB,_,[],KB).

register_position_objects_dlic(KB,Shelf,[H|T],NewKB):-
	change_value_object_relation(H,last_corroborated_position,Shelf,KB,AuxKB),
	register_position_objects_dlic(AuxKB,Shelf,T,NewKB).
	
	







