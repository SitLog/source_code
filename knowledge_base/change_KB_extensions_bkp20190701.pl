%--------------------------------------------------
% Load and Save from files
%--------------------------------------------------


%KB open and save

open_original_kb(KB):-
    print('originalkb'),nl,
	getenv('SITLOG_HOME',SITLOG_HOME),
	atomic_concat(SITLOG_HOME,'/knowledge_base/golem_KB_original.txt',KBPATH),
	open(KBPATH,read,Stream),
	readclauses(Stream,X),
	close(Stream),
	atom_to_term_conversion(X,KB).
	
open_supermarket_kb(KB):-
    print('supermarketkb'),nl,
	getenv('SITLOG_HOME',SITLOG_HOME),
	atomic_concat(SITLOG_HOME,'/knowledge_base/supermarket_KB.txt',KBPATH),
	open(KBPATH,read,Stream),
	readclauses(Stream,X),
	close(Stream),
	atom_to_term_conversion(X,KB).
	
open_inference_kb(KB):-
    print('inferencekb'),nl,
	getenv('SITLOG_HOME',SITLOG_HOME),
	atomic_concat(SITLOG_HOME,'/knowledge_base/inference_KB.txt',KBPATH),
	open(KBPATH,read,Stream),
	readclauses(Stream,X),
	close(Stream),
	atom_to_term_conversion(X,KB).
	
open_preferences_kb(KB):-
    print('kb'),nl,
	getenv('SITLOG_HOME',SITLOG_HOME),
	atomic_concat(SITLOG_HOME,'/knowledge_base/preferences_KB.txt',KBPATH),
	open(KBPATH,read,Stream),
	readclauses(Stream,X),
	close(Stream),
	atom_to_term_conversion(X,KB).

open_gpsr_kb(KB):-
    print('kb gpsr'),nl,
	getenv('SITLOG_HOME',SITLOG_HOME),
	atomic_concat(SITLOG_HOME,'/knowledge_base/gpsr_KB.txt',KBPATH),
	open(KBPATH,read,Stream),
	readclauses(Stream,X),
	close(Stream),
	atom_to_term_conversion(X,KB).

open_whereis_kb(KB):-
        print('kb where is this'),nl,
        getenv('SITLOG_HOME',SITLOG_HOME),
        atomic_concat(SITLOG_HOME,'/knowledge_base/whereis_KB.txt',KBPATH),
        open(KBPATH,read,Stream),
        readclauses(Stream,X),
        close(Stream),
        atom_to_term_conversion(X,KB).


open_kb(KB):-
    print('kb'),nl,
	getenv('SITLOG_HOME',SITLOG_HOME),
	atomic_concat(SITLOG_HOME,'/knowledge_base/golem_KB.txt',KBPATH),
	open(KBPATH,read,Stream),
	readclauses(Stream,X),
	close(Stream),
	atom_to_term_conversion(X,KB).

save_kb(KB):- 
	getenv('SITLOG_HOME',SITLOG_HOME),
	atomic_concat(SITLOG_HOME,'/knowledge_base/golem_KB.txt',KBPATH),
	open(KBPATH,write,Stream),
	writeq(Stream,KB),
	close(Stream).

readclauses(InStream,W) :-
        get0(InStream,Char),
        checkCharAndReadRest(Char,Chars,InStream),
	atom_chars(W,Chars).
 

checkCharAndReadRest(-1,[],_) :- !.  % End of Stream	
checkCharAndReadRest(end_of_file,[],_) :- !.

checkCharAndReadRest(Char,[Char|Chars],InStream) :-
        get0(InStream,NextChar),
        checkCharAndReadRest(NextChar,Chars,InStream).

atom_to_term_conversion(ATOM, TERM) :-
	 atom(ATOM),
	 atom_to_chars(ATOM,STR),
	 atom_to_chars('.',PTO),
	 append(STR,PTO,STR_PTO),
	 read_from_chars(STR_PTO,TERM).


%----------------------------------------
% Administration of lists
%----------------------------------------


%Change all ocurrences of an element X in a list for the value Y
%changeElement(X,Y,InputList,OutputList).
%Example (p,b,[p,a,p,a,y,a],[p,b,p,b,y,b])

changeElement(_,_,[],[]).

changeElement(X,Y,[X|T],[Y|N]):-
	changeElement(X,Y,T,N).

changeElement(X,Y,[H|T],[H|N]):-
	changeElement(X,Y,T,N).


%Delete all ocurrences of an element X in a list
%deleteElement(X,InputList,OutputList).
%Example (a,[p,a,p,a,y,a],[p,p,y])

deleteElement(_,[],[]).

deleteElement(X,[X|T],N):-
	deleteElement(X,T,N).

deleteElement(X,[H|T],[H|N]):-
	deleteElement(X,T,N),
	X\=H.



%Verify if an element X is in a list 
%isElement(X,List)
%Example (n,[b,a,n,a,n,a])

isElement(X,[X|_]).
isElement(X,[_|T]):-
	isElement(X,T).


%Convert in a single list a list of lists
%Example ([[a],[b,c],[],[d]],[a,b,c,d]).

append_list_of_lists([],[]).

append_list_of_lists([H|T],X):-
	append(H,TList,X),
	append_list_of_lists(T,TList).


%Delete all elements with a specific property in a property-value list
%deleteAllElementsWithSameProperty(P,InputList,OutputList).
%Example (p2,[p1=>v1,p2=>v2,p3=>v3,p2=>v4,p4=>v4],[p1=>v1,p3=>v3,p4=>v4])

deleteAllElementsWithSameProperty(_,[],[]).

deleteAllElementsWithSameProperty(X,[[X=>_,_]|T],N):-
	deleteAllElementsWithSameProperty(X,T,N).

deleteAllElementsWithSameProperty(X,[H|T],[H|N]):-
	deleteAllElementsWithSameProperty(X,T,N).

%%Single without weights
deleteAllElementsWithSamePropertySingle(_,[],[]).

deleteAllElementsWithSamePropertySingle(X,[X=>_|T],N):-
	deleteAllElementsWithSamePropertySingle(X,T,N).

deleteAllElementsWithSamePropertySingle(X,[H|T],[H|N]):-
	deleteAllElementsWithSamePropertySingle(X,T,N).


%Delete all elements with a specific negated property in a property-value list
%deleteAllElementsWithSameNegatedProperty(P,InputList,OutputList).
%Example (p2,[p1=>v1,not(p2=>v2),not(p3=>v3),p2=>v4,p4=>v4],[p1=>v1,not(p3=>v3),p2=>v4,p4=>v4])

deleteAllElementsWithSameNegatedProperty(_,[],[]).

deleteAllElementsWithSameNegatedProperty(X,[[not(X=>_),_]|T],N):-
	deleteAllElementsWithSameNegatedProperty(X,T,N).

deleteAllElementsWithSameNegatedProperty(X,[H|T],[H|N]):-
	deleteAllElementsWithSameNegatedProperty(X,T,N).

%Single version 

deleteAllElementsWithSameNegatedPropertySingle(_,[],[]).

deleteAllElementsWithSameNegatedPropertySingle(X,[not(X=>_)|T],N):-
	deleteAllElementsWithSameNegatedPropertySingle(X,T,N).

deleteAllElementsWithSameNegatedPropertySingle(X,[H|T],[H|N]):-
	deleteAllElementsWithSameNegatedPropertySingle(X,T,N).




%--------------------------------------------------------------------------------------------------
%Operations for adding classes, objects or properties into the Knowledge Base
%--------------------------------------------------------------------------------------------------

%Add new class

add_class(NewClass,Mother,OriginalKB,NewKB) :-
	append(OriginalKB,[class(NewClass,Mother,[],[],[])],NewKB).


%Add new class property

add_class_property(Class,NewProperty,Value,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,NewProps,Rels,Objects),OriginalKB,NewKB),
	append_property(Props,NewProperty,Value,NewProps).

append_property(Props,NewProperty,yes,NewProps):-
	append(Props,[[NewProperty,0]],NewProps).

append_property(Props,NewProperty,no,NewProps):-
	append(Props,[[not(NewProperty),0]],NewProps).

append_property(Props,NewProperty,Value,NewProps):-
	append(Props,[[NewProperty=>Value,0]],NewProps).

%%Add new class property preference
add_class_property_preference(Class,NewPreference,Weight,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,NewProps,Rels,Objects),OriginalKB,NewKB),
	append_preference(Props,NewPreference,Weight,NewProps).

append_preference(Props,NewPreference,Weight,NewProps):-
	append(Props,[[NewPreference,Weight]],NewProps).


%Add new class relation

add_class_relation(Class,NewRelation,OtherClass,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,NewRels,Objects),OriginalKB,NewKB),
	append_relation(Rels,NewRelation,OtherClass,NewRels).

append_relation(Rels,not(NewRelation),OtherClass,NewRels):-
	append(Rels,[[not(NewRelation=>OtherClass),0]],NewRels).

append_relation(Rels,NewRelation,OtherClass,NewRels):-
	append(Rels,[[NewRelation=>OtherClass,0]],NewRels).

%%Add new class relation preference
add_class_relation_preference(Class,NewPreference,Weight,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,NewRels,Objects),OriginalKB,NewKB),
	append_preference(Rels,NewPreference,Weight,NewRels).


%Add new object

add_object(NewObject,Class,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	append(Objects,[[id=>NewObject,[],[]]],NewObjects).


%Add new object property

add_object_property(Object,NewProperty,Value,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	isElement([id=>Object,Properties,Relations],Objects),
	changeElement([id=>Object,Properties,Relations],[id=>Object,NewProperties,Relations],Objects,NewObjects),
	append_property(Properties,NewProperty,Value,NewProperties).

%Add new object property preference
add_object_property_preference(Object,NewPreference,Weight,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	isElement([id=>Object,Properties,Relations],Objects),
	changeElement([id=>Object,Properties,Relations],[id=>Object,NewProperties,Relations],Objects,NewObjects),
	append_preference(Properties,NewPreference,Weight,NewProperties).


%Add new object relation

add_object_relation(Object,NewRelation,OtherObject,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	isElement([id=>Object,Properties,Relations],Objects),
	changeElement([id=>Object,Properties,Relations],[id=>Object,Properties,NewRelations],Objects,NewObjects),
	append_relation(Relations,NewRelation,OtherObject,NewRelations).

%Add new object relation preference

add_object_relation_preference(Object,NewPreference,Weight,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	isElement([id=>Object,Properties,Relations],Objects),
	changeElement([id=>Object,Properties,Relations],[id=>Object,Properties,NewRelations],Objects,NewObjects),
	append_preference(Relations,NewPreference,Weight,NewRelations).


%--------------------------------------------------------------------------------------------------
%Operations for removing classes, objects or properties into the Knowledge Base
%--------------------------------------------------------------------------------------------------


%Remove a class property

rm_class_property(Class,Property,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,NewProps,Rels,Objects),OriginalKB,NewKB),
	deleteAllElementsWithSameProperty(Property,Props,Aux),
	deleteElement([not(Property),_],Aux,Aux2),
	deleteElement([Property,_],Aux2,NewProps).

%Remove a class property preference

rm_class_property_preference(Class,Preference,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,NewProps,Rels,Objects),OriginalKB,NewKB),
	deleteElement([Preference,_],Props,NewProps).




%Remove a class relation

rm_class_relation(Class,not(Relation),OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,NewRels,Objects),OriginalKB,NewKB),
	deleteAllElementsWithSameNegatedProperty(Relation,Rels,NewRels).

rm_class_relation(Class,Relation,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,NewRels,Objects),OriginalKB,NewKB),
	deleteAllElementsWithSameProperty(Relation,Rels,NewRels).

%Remove a class relation preference
rm_class_relation_preference(Class,Preference,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,NewRels,Objects),OriginalKB,NewKB),
	deleteElement([Preference,_],Rels,NewRels).

%Remove an object property

rm_object_property(Object,Property,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	isElement([id=>Object,Properties,Relations],Objects),
	changeElement([id=>Object,Properties,Relations],[id=>Object,NewProperties,Relations],Objects,NewObjects),
	deleteAllElementsWithSameProperty(Property,Properties,Aux),
	deleteElement([not(Property),_],Aux,Aux2),
	deleteElement([Property,_],Aux2,NewProperties).

%REmove an object property preference
rm_object_property_preference(Object,Preference,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	isElement([id=>Object,Properties,Relations],Objects),
	changeElement([id=>Object,Properties,Relations],[id=>Object,NewProperties,Relations],Objects,NewObjects),
	deleteElement([Preference,_],Properties,NewProperties).


%Remove an object relation

rm_object_relation(Object,not(Relation),OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	isElement([id=>Object,Properties,Relations],Objects),
	changeElement([id=>Object,Properties,Relations],[id=>Object,Properties,NewRelations],Objects,NewObjects),
	deleteAllElementsWithSameNegatedProperty(Relation,Relations,NewRelations).

rm_object_relation(Object,Relation,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	isElement([id=>Object,Properties,Relations],Objects),
	changeElement([id=>Object,Properties,Relations],[id=>Object,Properties,NewRelations],Objects,NewObjects),
	deleteAllElementsWithSameProperty(Relation,Relations,NewRelations).

%Remove an object relation preference
rm_object_relation_preference(Object,Preference,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,NewKB),
	isElement([id=>Object,Properties,Relations],Objects),
	changeElement([id=>Object,Properties,Relations],[id=>Object,Properties,NewRelations],Objects,NewObjects),
	deleteElement([Preference,_],Relations,NewRelations).
	

%Remove an object

rm_object(Object,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,TemporalKB),
	isElement([id=>Object|Properties],Objects),
	deleteElement([id=>Object|Properties],Objects,NewObjects),
	delete_relations_with_object(Object,TemporalKB,NewKB).
	
delete_relations_with_object(_,[],[]).

delete_relations_with_object(Object,[class(C,M,P,R,O)|T],[class(C,M,P,NewR,NewO)|NewT]):-
	cancel_relation(Object,R,NewR),
	del_relations(Object,O,NewO),
	delete_relations_with_object(Object,T,NewT).

del_relations(_,[],[]).

del_relations(Object,[[id=>N,P,R]|T],[[id=>N,P,NewR]|NewT]):-
	cancel_relation(Object,R,NewR),
	del_relations(Object,T,NewT).

cancel_relation(_,[],[]).

cancel_relation(Object,[[_=>Object,_]|T],NewT):-
	cancel_relation(Object,T,NewT).

cancel_relation(Object,[[not(_=>Object),_]|T],NewT):-
	cancel_relation(Object,T,NewT).

cancel_relation(Object,[H|T],[H|NewT]):-
	cancel_relation(Object,T,NewT).


% Remove a class

rm_class(Class,OriginalKB,NewKB) :-
	deleteElement(class(Class,Mother,_,_,_),OriginalKB,TemporalKB),
	changeMother(Class,Mother,TemporalKB,TemporalKB2),
	delete_relations_with_object(Class,TemporalKB2,NewKB).

changeMother(_,_,[],[]).

changeMother(OldMother,NewMother,[class(C,OldMother,P,R,O)|T],[class(C,NewMother,P,R,O)|N]):-
	changeMother(OldMother,NewMother,T,N).

changeMother(OldMother,NewMother,[H|T],[H|N]):-
	changeMother(OldMother,NewMother,T,N).



%--------------------------------------------------------------------------------------------------
%Operations for changing classes, objects or properties into the Knowledge Base
%--------------------------------------------------------------------------------------------------


change_value_object_property(Object,Property,NewValue,KB,NewKB):-
	rm_object_property(Object,Property,KB,TemporalKB),
	add_object_property(Object,Property,NewValue,TemporalKB,NewKB).

change_value_object_relation(Object,Relation,NewObjectRelated,KB,NewKB):-
	rm_object_relation(Object,Relation,KB,TemporalKB),
	add_object_relation(Object,Relation,NewObjectRelated,TemporalKB,NewKB).
		
change_value_class_property(Class,Property,NewValue,KB,NewKB):-
	rm_class_property(Class,Property,KB,TemporalKB),
	add_class_property(Class,Property,NewValue,TemporalKB,NewKB).

change_value_class_relation(Class,Relation,NewClassRelated,KB,NewKB):-
	rm_class_relation(Class,Relation,KB,TemporalKB),
	add_class_relation(Class,Relation,NewClassRelated,TemporalKB,NewKB).

%%Preferences change weights

change_weight_object_property_preference(Object,Preference,NewWeight,KB,NewKB):-
	rm_object_property_preference(Object,Preference,KB,TemporalKB),
	add_object_property_preference(Object,Preference,NewWeight,TemporalKB,NewKB).

change_weight_object_relation_preference(Object,Preference,NewWeight,KB,NewKB):-
	rm_object_relation_preference(Object,Preference,KB,TemporalKB),
	add_object_relation_preference(Object,Preference,NewWeight,TemporalKB,NewKB).

change_weight_class_property_preference(Class,Preference,NewWeight,KB,NewKB):-
	rm_class_property_preference(Class,Preference,KB,TemporalKB),
	add_class_property_preference(Class,Preference,NewWeight,TemporalKB,NewKB).

change_weight_class_relation_preference(Class,Preference,NewWeight,KB,NewKB):-
	rm_class_relation_preference(Class,Preference,KB,TemporalKB),
	add_class_relation_preference(Class,Preference,NewWeight,TemporalKB,NewKB).


%Change the name of an object	

change_object_name(Object,NewName,OriginalKB,NewKB) :-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(Class,Mother,Props,Rels,NewObjects),OriginalKB,TemporalKB),
	isElement([id=>Object|Properties],Objects),
	changeElement([id=>Object|Properties],[id=>NewName|Properties],Objects,NewObjects),
	change_relations_with_object(Object,NewName,TemporalKB,NewKB).
	
change_relations_with_object(_,_,[],[]).

change_relations_with_object(Object,NewName,[class(C,M,P,R,O)|T],[class(C,M,P,NewR,NewO)|NewT]):-
	change_relations(Object,NewName,O,NewO),
	change_relation(Object,NewName,R,NewR),
	change_relations_with_object(Object,NewName,T,NewT).

change_relations(_,_,[],[]).

change_relations(Object,NewName,[[id=>N,P,R]|T],[[id=>N,P,NewR]|NewT]):-
	change_relation(Object,NewName,R,NewR),
	change_relations(Object,NewName,T,NewT).

change_relation(_,_,[],[]).

change_relation(OldName,NewName,[[R=>OldName,Weight]|T],[[R=>NewName,Weight]|NewT]):-
	change_relation(OldName,NewName,T,NewT).

change_relation(OldName,NewName,[[not(R=>OldName),Weight]|T],[[not(R=>NewName),Weight]|NewT]):-
	change_relation(OldName,NewName,T,NewT).

change_relation(OldName,NewName,[H|T],[H|NewT]):-
	change_relation(OldName,NewName,T,NewT).


%Change the name of a class

change_class_name(Class,NewName,KB,NewKB):-
	changeElement(class(Class,Mother,Props,Rels,Objects),class(NewName,Mother,Props,Rels,Objects),KB,TemporalKB),
	changeMother(Class,NewName,TemporalKB,TemporalKB2),
	change_relations_with_object(Class,NewName,TemporalKB2,NewKB).



%--------------------------------------------------------------------------------------------------
%Operations for consulting 
%--------------------------------------------------------------------------------------------------


%Verify if a class exists

there_is_class(_,[],unknown).

there_is_class(Class,[class(not(Class),_,_,_,_)|_],no).

there_is_class(Class,[class(Class,_,_,_,_)|_],yes).

there_is_class(Class,[_|T],Answer):-
	there_is_class(Class,T,Answer).



%Verify if an object exists

there_is_object(_,[],unknown).

there_is_object(Object,[class(_,_,_,_,O)|_],no):-
	isElement([id=>not(Object),_,_],O).

there_is_object(Object,[class(_,_,_,_,O)|_],yes):-
	isElement([id=>Object,_,_],O).

there_is_object(Object,[_|T],Answer):-
	there_is_object(Object,T,Answer).



%Consult the mother of a class

mother_of_a_class(_,[],unknown).

mother_of_a_class(Class,[class(Class,Mother,_,_,_)|_],Mother).

mother_of_a_class(Class,[_|T],Mother):-
	mother_of_a_class(Class,T,Mother).



%Consult the ancestors of a class

class_ancestors(Class,KB,ClassAncestors):-
	there_is_class(Class,KB,yes),
	list_of_ancestors(Class,KB,ClassAncestors).

class_ancestors(Class,KB,unknown):-
	there_is_class(Class,KB,unknown).

list_of_ancestors(top,_,[]).

list_of_ancestors(Class,KB,Ancestors):-
	mother_of_a_class(Class,KB,Mother),
	append([Mother],GrandParents,Ancestors),
	list_of_ancestors(Mother,KB,GrandParents).



%Consult the properties of a class

class_properties(top,KB,Properties):-
	properties_only_in_the_class(top,KB,Properties).

class_properties(Class,KB,AllProperties):-
	there_is_class(Class,KB,yes),
	list_of_ancestors(Class,KB,Ancestors),
	concat_ancestors_properties([Class|Ancestors],KB,Temp),
	prefer(Temp,TempPref),
	delete_repeated_properties(TempPref,AllProperties).

class_properties(Class,KB,unknown):-
	there_is_class(Class,KB,unknown).

class_all_properties(top,KB,Properties):-
        properties_only_in_the_class(top,KB,Properties).
	
class_all_properties(Class,KB,AllProperties):-
        there_is_class(Class,KB,yes),
	list_of_ancestors(Class,KB,Ancestors),
	concat_ancestors_properties([Class|Ancestors],KB,Temp),
	prefer(Temp,AllProperties).




properties_only_in_the_class(_,[],[]).

properties_only_in_the_class(Class,[class(Class,_,Properties,_,_)|_],Properties).

properties_only_in_the_class(Class,[_|T],Properties):-
	properties_only_in_the_class(Class,T,Properties).


concat_ancestors_properties([],_,[]).

concat_ancestors_properties([Ancestor|T],KB,TFinal):-
	concat_ancestors_properties(T,KB,NewT),
	properties_only_in_the_class(Ancestor,KB,Properties),
	append(Properties,['?'],NewProperties),
	append(NewProperties,NewT,TFinal).


delete_repeated_properties([],[]).

delete_repeated_properties([P=>V|T],[P=>V|NewT]):-
	deleteAllElementsWithSamePropertySingle(P,T,L1),
	deleteElement(not(P=>V),L1,L2),
	delete_repeated_properties(L2,NewT),!.

delete_repeated_properties([not(P=>V)|T],[not(P=>V)|NewT]):-
	deleteAllElementsWithSameNegatedPropertySingle(P,T,L1),
	deleteElement(P=>V,L1,L2),
	delete_repeated_properties(L2,NewT),!.

delete_repeated_properties([not(H)|T],[not(H)|NewT]):-
	deleteElement(not(H),T,L1),
	deleteElement(H,L1,L2),
	delete_repeated_properties(L2,NewT),!.

delete_repeated_properties([H|T],[H|NewT]):-
	deleteElement(H,T,L1),
	deleteElement(not(H),L1,L2),
	delete_repeated_properties(L2,NewT),!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copied from github branch Abductive reasoning beta
%% on 20190528
delete_repeated_abductions([],[]).

delete_repeated_abductions([El:Pref|T],[El:Pref|NewT]):-
	deleteAbduction(El,T,L2),
	delete_repeated_abductions(L2,NewT),!.

deleteAbduction(_,[],[]):-!.
deleteAbduction(Abd,[Abd:_|T],NewL):-
	deleteAbduction(Abd,T,NewL).
deleteAbduction(Abd,[H:HV|T],[H:HV|NewL]):-
        deleteAbduction(Abd,T,NewL).

%% Finished copy from github branch Abductive reasoning beta
%% on 20190528
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Unir Lista
unir_lista([],L,L).
unir_lista([H|T],L,[H|M]):-
	unir_lista(T,L,M).

%Parte de lista
parte_de(E,[E|_]).
parte_de(E,[_|T]):-
	parte_de(E,T).

%%Algoritmo de ordenamiento
ordenar(L, S):- 
	permutacion(L, S), 
	ordered(S). 
permutacion([], []). 
permutacion(L, [H|R]):- 
	uno(L, H, L1), 
	permutacion(L1, R). 
uno([H|T], H, T). 
uno([X|R], H, [X|T]):- 
	uno(R, H, T). 
ordered([]). 
ordered([_]). 
ordered([X,Y|T]):-
	X=[_,ValX],
	Y=[_,ValY],
	ValX=<ValY,
	ordered([Y|T]). 

%%preordenar
preordenar([],_,[]).
preordenar(['?'|Pref],Aux,PrefF):-
	ordenar(Aux,AuxO),
	preordenar(Pref,[],PrefO),
	unir_lista(AuxO,PrefO,PrefF).
preordenar([H|Pref],Aux,PrefO):-
	preordenar(Pref,[H|Aux],PrefO).

%%%Prefer handler

prefer(Prop,NewProp):-
	%print(Prop),
	prefer_extract(Prop,PropE,Pref),
	delete_repeated_properties(PropE,PropEE),
	preordenar(Pref,[],PrefO),
	prefer_handler(PrefO,PropEE,NewProp).
	


prefer_extract([],[],[]).
prefer_extract([[H,Peso]|T],TProp,[[H,Peso]|TP]):-
	Peso\=0,
	prefer_extract(T,TProp,TP).
prefer_extract([[H,0]|T],[H|TProp],TP):-
	prefer_extract(T,TProp,TP).
prefer_extract([_|T],TProp,['?'|TP]):-
	prefer_extract(T,TProp,TP).


prefer_handler([],NewProp,NewProp).
%Caso 1.1 preferencia x,y => x,y
prefer_handler([[(Pref=>'-')=>>(El=>'-'),_]|T],Prop,NewProp):-
	delete_repeated_properties(Prop,NProp),
	parte_de((Pref=>Val),NProp),
	unir_lista(Prop,[El=>Val],NP),
	prefer_handler(T,NP,NewProp).
%Caso 1.2 preferencia x,y => x,val
prefer_handler([[(Pref=>'-')=>>(El=>ValE),_]|T],Prop,NewProp):-
	parte_de((Pref=>_),Prop),
	unir_lista(Prop,[El=>ValE],NP),
	prefer_handler(T,NP,NewProp).
%caso 2 preferencia x,val=>x,valE
prefer_handler([[(Pref=>Val)=>>(El=>ValE),_]|T],Prop,NewProp):-
	delete_repeated_properties(Prop,NProp),
	parte_de((Pref=>Val),NProp),
	unir_lista(Prop,[El=>ValE],NP),
	prefer_handler(T,NP,NewProp).
%caso 3.1 preferencia x => x , x,val=>x, x=>x,val
prefer_handler([[Pref=>>El,_]|T],Prop,NewProp):-
	parte_de(Pref,Prop),
	unir_lista(Prop,[El],NP),
	prefer_handler(T,NP,NewProp).
%caso 3.2 preferencia x,y=>x
prefer_handler([[(Pref=>'-')=>>El,_]|T],Prop,NewProp):-
	parte_de((Pref=>_),Prop),
	unir_lista(Prop,[El],NP),
	prefer_handler(T,NP,NewProp).
%caso 3.3 preferencia '-'=>x,val
prefer_handler([['-'=>>(El=>Val),_]|T],Prop,NewProp):-
	unir_lista(Prop,[El=>Val],NP),
	prefer_handler(T,NP,NewProp).
%caso 3.4 preferencia '-'=>x
prefer_handler([['-'=>>El,_]|T],Prop,NewProp):-
	unir_lista(Prop,[El],NP),
	prefer_handler(T,NP,NewProp).
%caso 4.1 antecedentes de preferencia caso 1 x,y => x,y
prefer_handler([[(Pref=>'-')=>>(El=>'-'),_]|T],Prop,NewProp):-
	parte_de([_=>>(Pref=>_),_],T),
	prefer_handler(T,Prop,PropA),
	delete_repeated_properties(PropA,NPropA),
	parte_de((Pref=>Val),NPropA),
	unir_lista(Prop,[El=>Val],NP),
	prefer_handler(T,NP,NewProp).
%caso 4.2 antecedentes de preferencia caso 2 x,val=>x,valE
prefer_handler([[(Pref=>Val)=>>(El=>ValE),_]|T],Prop,NewProp):-
	parte_de([_=>>(Pref=>Val),_],T),
	prefer_handler(T,Prop,PropA),
	delete_repeated_properties(PropA,NPropA),
	parte_de((Pref=>Val),NPropA),
	unir_lista(Prop,[El=>ValE],NP),
	prefer_handler(T,NP,NewProp).
%caso 4.3 antecedentes de preferencia caso x => x
prefer_handler([[Pref=>>El,_]|T],Prop,NewProp):-
	parte_de([_=>>Pref,_],T),
	prefer_handler(T,Prop,PropA),
	parte_de(Pref,PropA),
	unir_lista(Prop,[El],NP),
	prefer_handler(T,NP,NewProp).
%caso 5.1 lista caso =>x,y
prefer_handler([[PrefL=>>(El=>'-'),_]|T],Prop,NewProp):-
	prefer_handlerL(PrefL,T,Prop,Val),
	unir_lista(Prop,[El=>Val],NP),
	prefer_handler(T,NP,NewProp).
%caso 5.2 lista caso =>x,val
prefer_handler([[PrefL=>>(El=>Val),_]|T],Prop,NewProp):-
	prefer_handlerL(PrefL,T,Prop,Val),
	unir_lista(Prop,[El=>Val],NP),
	prefer_handler(T,NP,NewProp).
%caso 5.3 lista caso =>x
prefer_handler([[PrefL=>>El,_]|T],Prop,NewProp):-
	prefer_handlerL(PrefL,T,Prop),
	unir_lista(Prop,[El],NP),
	prefer_handler(T,NP,NewProp).
%caso default, si no la encuentra.
prefer_handler([_|T],Prop,NewProp):-
	prefer_handler(T,Prop,NewProp).

%%manejo de lista
prefer_handlerL([],_,_).
%caso x
prefer_handlerL([Pref|T],LPref,Prop):-
	parte_de(Pref,Prop),
	prefer_handlerL(T,LPref,Prop).
%caso antecedentes x
prefer_handlerL([Pref|T],LPref,Prop):-
	parte_de([_=>>Pref,_],LPref),
	prefer_handler(LPref,Prop,PropA),
	parte_de(Pref,PropA),
	prefer_handlerL(T,LPref,Prop).
prefer_handlerL([],_,_,_).
%caso x,y
prefer_handlerL([(Pref=>'-')|T],LPref,Prop,Val):-
	delete_repeated_properties(Prop,NProp),
	parte_de((Pref=>Val),NProp),
	prefer_handlerL(T,LPref,Prop,Val),!.
%caso x,val
prefer_handlerL([(Pref=>Val)|T],LPref,Prop,Val):-
	delete_repeated_properties(Prop,NProp),
	parte_de((Pref=>Val),NProp),
	prefer_handlerL(T,LPref,Prop,Val).
%caso antecedentes x,y
prefer_handlerL([(Pref=>'-')|T],LPref,Prop,Val):-
	parte_de([_=>>(Pref=>_),_],LPref),
	prefer_handler(LPref,Prop,PropA),
	delete_repeated_properties(PropA,NPropA),
	parte_de((Pref=>Val),NPropA),
	prefer_handlerL(T,LPref,Prop,Val).
%caso antecedentes x,val
prefer_handlerL([(Pref=>Val)|T],LPref,Prop,Val):-
	parte_de([_=>>(Pref=>Val),_],LPref),
	prefer_handler(LPref,Prop,PropA),
	delete_repeated_properties(PropA,NPropA),
	parte_de((Pref=>Val),NPropA),
	prefer_handlerL(T,LPref,Prop,Val).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copied from github branch Abductive reasoning beta
%% on 20190528

%%Abductive Handler
abductive(Prop,Adb):-
	%print(Prop),
	prefer_extract(Prop,PropE,Pref),
	delete_repeated_properties(PropE,PropEE),
	preordenar(Pref,[],PrefO),print(PrefO),
	abductive_handler(PrefO,PropEE,Adb).

abductive_handler([],_,[]).
%Case 0 conclusion of type prop=>x
abductive_handler([[(Pref=>'-')=>>(El=>'-'),_]|T],Prop,NewAbd):-
	parte_de((El=>Val),Prop),
	abductive_handler(T,Prop,Adb),
	unir_lista([(El=>Val):(Pref=>Val)],Adb,NewAbd).
%Case0.2
abductive_handler([[(Pref=>'-')=>>(El=>ValE),_]|T],Prop,NewAbd):-
	parte_de((El=>ValE),Prop),
	abductive_handler(T,Prop,Adb),
	unir_lista([(El=>ValE):(Pref=>ValE)],Adb,NewAbd).
%Case 1 conclusion of type prop=>x
abductive_handler([[Pref=>>(El=>'-'),_]|T],Prop,NewAbd):-
	parte_de((El=>Val),Prop),
	abductive_handler(T,Prop,Adb),
	unir_lista([(El=>Val):Pref],Adb,NewAbd).
%Case 2 conclusion of type prop=>val
abductive_handler([[Pref=>>(El=>ValE),_]|T],Prop,NewAdb):-
	parte_de((El=>ValE),Prop),
	abductive_handler(T,Prop,Adb),
	unir_lista([(El=>ValE):Pref],Adb,NewAdb).
%case 3 conclusion of type prop
abductive_handler([[Pref=>>El,_]|T],Prop,NewAdb):-
	parte_de(El,Prop),
	abductive_handler(T,Prop,Adb),
	unir_lista([El:Pref],Adb,NewAdb).
%caso default, si no la encuentra.
abductive_handler([_|T],Prop,Adb):-
       abductive_handler(T,Prop,Adb).

%% Finished copy from github branch Abductive reasoning beta
%% on 20190528
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Verify if a class has a specific property

class_has_property(Class,Property,KB,Answer):-
	class_properties(Class,KB,Properties),
	incomplete_information(Property,Properties,Answer).

incomplete_information(_,[], unknown).

incomplete_information(Atom, List, yes):- isElement(Atom,List).

incomplete_information(not(Atom), List, no):- isElement(Atom,List).

incomplete_information(Atom, List, no):- isElement(not(Atom),List).

incomplete_information(_, _, unknown).



%Return the value of a class property

class_property_value(Class,Property,KB,Value):-
	class_properties(Class,KB,ClassProperties),
	find_value(Property,ClassProperties,Value).

%Return list of values of a class property

class_property_list(Class,Property,KB,Values):-
        class_all_properties(Class,KB,ClassProperties),
	find_list_value(Property,ClassProperties,Values).

class_property_list(_,_,_,unknown).


find_value(_,[],unknown).

find_value(Attribute,[Attribute=>Value|_],Value).

find_value(Attribute,[not(Attribute)|_],no).

find_value(Attribute,[Attribute|_],yes).

find_value(Attribute,[_|T],Value):-
	find_value(Attribute,T,Value).


find_list_value(_,[],[]).

find_list_value(Attribute,[Attribute=>Value|T],[Value|TV]):-
	find_list_value(Attribute,T,TV).

find_list_value(Attribute,[_|T],Value):-
	find_list_value(Attribute,T,Value).
	
find_weight(_,[],unknown).

find_weight(Preference,[[Preference,Weight]|_],Weight).

find_weight(Preference,[_|PT],Weight):-
	find_weight(Preference,PT,Weight).


%Shows the class of an object

class_of_an_object(_,[],unknown):-!.

class_of_an_object(Object,[class(C,_,_,_,O)|_],C):-
	isElement([id=>Object,_,_],O).

class_of_an_object(Object,[_|T],Class):-
	class_of_an_object(Object,T,Class).



%List all the properties of an object

object_properties(Object,KB,AllProperties):-
	there_is_object(Object,KB,yes),
	properties_only_in_the_object(Object,KB,ObjectProperties),
	class_of_an_object(Object,KB,Class),
	list_of_ancestors(Class,KB,Ancestors),
	concat_ancestors_properties([Class|Ancestors],KB,ClassProperties),
	append(ObjectProperties,['?'],ObjectProperties2),
	append(ObjectProperties2,ClassProperties,Temp),
	prefer(Temp,TempPref),
	delete_repeated_properties(TempPref,AllProperties).

object_properties(_,_,unknown).

object_all_properties(Object,KB,AllProperties):-
	there_is_object(Object,KB,yes),
	properties_only_in_the_object(Object,KB,ObjectProperties),
	class_of_an_object(Object,KB,Class),
	list_of_ancestors(Class,KB,Ancestors),
	concat_ancestors_properties([Class|Ancestors],KB,ClassProperties),
	append(ObjectProperties,['?'],ObjectProperties2),
	append(ObjectProperties2,ClassProperties,Temp),
	prefer(Temp,AllProperties).
	%delete_repeated_properties(TempPref,AllProperties).

object_all_properties(_,_,unknown).


object_property_preferences(Object,KB,AllPreferences):-
	there_is_object(Object,KB,yes),
	properties_only_in_the_object(Object,KB,ObjectProperties),
	class_of_an_object(Object,KB,Class),
	list_of_ancestors(Class,KB,Ancestors),
	concat_ancestors_properties([Class|Ancestors],KB,ClassProperties),
	append(ObjectProperties,['?'],ObjectProperties2),
	append(ObjectProperties2,ClassProperties,Temp),
	prefer_extract(Temp,_,Pref),
	preordenar(Pref,[],AllPreferences).

object_property_preferences(_,_,[]).


properties_only_in_the_object(_,[],[]).

properties_only_in_the_object(Object,[class(_,_,_,_,O)|_],Properties):-
	isElement([id=>Object,Properties,_],O).

properties_only_in_the_object(Object,[_|T],Properties):-
	properties_only_in_the_object(Object,T,Properties).
	


%Return the value of an object property

object_property_value(Object,Property,KB,Value):-
	there_is_object(Object,KB,yes),
	object_properties(Object,KB,Properties),
	find_value(Property,Properties,Value).

object_property_value(_,_,_,unknown).

%Return list of values of an object property

object_property_list(Object,Property,KB,Values):-
	there_is_object(Object,KB,yes),
	object_all_properties(Object,KB,Properties),
	find_list_value(Property,Properties,Values).

object_property_list(_,_,_,[]).

%Return the weight of an object property preference

object_property_preference_value(Object,Preference,KB,Value):-
	there_is_object(Object,KB,yes),
	object_property_preferences(Object,KB,Preferences),
	find_weight(Preference,Preferences,Value).

object_property_preference_value(_,_,_,unknown).


%Consult the relations of a class


class_relations(top,KB,Relations):-
	relations_only_in_the_class(top,KB,Relations).

class_relations(Class,KB,Relations):-
	there_is_class(Class,KB,yes),
	list_of_ancestors(Class,KB,Ancestors),
	concat_ancestors_relations([Class|Ancestors],KB,Temp),
	prefer(Temp,TempPref),
	delete_repeated_properties(TempPref,Relations).


class_relations(_,_,unknown).


relations_only_in_the_class(_,[],[]).

relations_only_in_the_class(Class,[class(Class,_,_,Relations,_)|_],Relations).

relations_only_in_the_class(Class,[_|T],Relations):-
	relations_only_in_the_class(Class,T,Relations).


concat_ancestors_relations([],_,[]).

concat_ancestors_relations([Ancestor|T],KB,TFinal):-
	concat_ancestors_relations(T,KB,NewT),
	relations_only_in_the_class(Ancestor,KB,Relations),
	append(Relations,['?'],NewRelations),
	append(NewRelations,NewT,TFinal).



%Return the value of a class relation

class_relation_value(Class,Relation,KB,Value):-
	there_is_class(Class,KB,yes),
	class_relations(Class,KB,Relations),
	find_value_relation(Relation,Relations,Value).

class_relation_value(_,_,_,unknown).


find_value_relation(not(Relation),Relations,Value):-
	find_value_negative_relation(Relation,Relations,Value).

find_value_relation(Relation,Relations,Value):-
	find_value_positive_relation(Relation,Relations,Value).


find_value_negative_relation(_,[],unknown).

find_value_negative_relation(Attribute,[not(Attribute=>Value)|_],Value).

find_value_negative_relation(Attribute,[_|T],Value):-
	find_value_negative_relation(Attribute,T,Value).


find_value_positive_relation(_,[],unknown).

find_value_positive_relation(Attribute,[Attribute=>Value|_],Value).

find_value_positive_relation(Attribute,[_|T],Value):-
	find_value_positive_relation(Attribute,T,Value).



%List all the relations of an object

object_relations(Object,KB,AllRelations):-
	there_is_object(Object,KB,yes),
	relations_only_in_the_object(Object,KB,ObjectRelations),
	class_of_an_object(Object,KB,Class),
	list_of_ancestors(Class,KB,Ancestors),
	concat_ancestors_relations([Class|Ancestors],KB,ClassRelations),
	append(ObjectRelations,['?'],ObjectRelations2),
	append(ObjectRelations2,ClassRelations,Temp),
	prefer(Temp,TempPref),
	delete_repeated_properties(TempPref,AllRelations).

object_relations(_,_,unknown).


relations_only_in_the_object(_,[],[]).

relations_only_in_the_object(Object,[class(_,_,_,_,O)|_],Relations):-
	isElement([id=>Object,_,Relations],O).

relations_only_in_the_object(Object,[_|T],Relations):-
	relations_only_in_the_object(Object,T,Relations).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copied from github branch Abductive reasoning beta
%% on 20190528

%%List of all abduvtive reasoning answers

object_abductive(Object,KB,AllAdbuctive):-
	there_is_object(Object,KB,yes),
	properties_only_in_the_object(Object,KB,ObjectProperties),
	class_of_an_object(Object,KB,Class),
	list_of_ancestors(Class,KB,Ancestors),
	concat_ancestors_properties([Class|Ancestors],KB,ClassProperties),
	append(ObjectProperties,['?'],ObjectProperties2),
	append(ObjectProperties2,ClassProperties,Temp),
	abductive(Temp,AllAdbuctive).
        %delete_repeated_abductions(TempR,AllAdbuctive).

%% Finished copy from github branch Abductive reasoning beta
%% on 20190528
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Return the value of an object relation

object_relation_value(Object,Relation,KB,Value):-
	there_is_object(Object,KB,yes),
	object_relations(Object,KB,Relations),
	find_value_relation(Relation,Relations,Value).

object_relation_value(_,_,_,unknown).



% Return the son classes of a class

sons_of_class(Class,KB,Answer):-
	there_is_class(Class,KB,yes),
	sons_of_a_class(Class,KB,Answer).

sons_of_class(_,_,unknown).

sons_of_a_class(_,[],[]).

sons_of_a_class(Class,[class(Son,Class,_,_,_)|T],Sons):-
	sons_of_a_class(Class,T,Brothers),	
	append([Son],Brothers,Sons).

sons_of_a_class(Class,[_|T],Sons):-
	sons_of_a_class(Class,T,Sons).	
	

% Return the sons of a list of classes of a class

sons_of_a_list_of_classes([],_,[]).

sons_of_a_list_of_classes([Son|T],KB,Grandsons):-
	sons_of_a_class(Son,KB,Sons),
	sons_of_a_list_of_classes(T,KB,Cousins),
	append(Sons,Cousins,Grandsons).


% Return all the descendant classes of a class

descendants_of_a_class(Class,KB,Descendants):-
	there_is_class(Class,KB,yes),
	sons_of_a_class(Class,KB,Sons),
	all_descendants_of_a_class(Sons,KB,Descendants).

descendants_of_a_class(_,_,unknown).

all_descendants_of_a_class([],_,[]).

all_descendants_of_a_class(Classes,KB,Descendants):-
	sons_of_a_list_of_classes(Classes,KB,Sons),
	all_descendants_of_a_class(Sons,KB,RestOfDescendants),
	append(Classes,RestOfDescendants,Descendants).


% Return the names of the objects listed only in a specific class


objects_only_in_the_class(_,[],unknown).

objects_only_in_the_class(Class,[class(Class,_,_,_,O)|_],Objects):-
	extract_objects_names(O,Objects).

objects_only_in_the_class(Class,[_|T],Objects):-
	objects_only_in_the_class(Class,T,Objects).
	
extract_objects_names([],[]).

extract_objects_names([[id=>Name,_,_]|T],Objects):-
	extract_objects_names(T,Rest),
	append([Name],Rest,Objects).


% Return all the objects of a class

objects_of_a_class(Class,KB,Objects):-
	there_is_class(Class,KB,yes),
	objects_only_in_the_class(Class,KB,ObjectsInClass),
	descendants_of_a_class(Class,KB,Sons),
	objects_of_all_descendants_classes(Sons,KB,DescendantObjects),
	append(ObjectsInClass,DescendantObjects,Objects).

objects_of_a_class(_,_,unknown).

objects_of_all_descendants_classes([],_,[]).

objects_of_all_descendants_classes([Class|T],KB,AllObjects):-
	objects_only_in_the_class(Class,KB,Objects),
	objects_of_all_descendants_classes(T,KB,Rest),
	append(Objects,Rest,AllObjects).



%------------------------------------------------------------
% Main KB Services 
%------------------------------------------------------------

%Class extension

class_extension(Class,KB,Objects):-
	objects_of_a_class(Class,KB,Objects).	


% Property extension

property_extension(Property,KB,Result):-
	objects_of_a_class(top,KB,AllObjects),
	filter_objects_with_property(KB,Property,AllObjects,Objects),
	eliminate_null_property(Objects,Result).

filter_objects_with_property(_,_,[],[]).

filter_objects_with_property(KB,Property,[H|T],[H:Value|NewT]):-
	object_property_value(H,Property,KB,Value),
	filter_objects_with_property(KB,Property,T,NewT).

eliminate_null_property([],[]).

eliminate_null_property([_:unknown|T],NewT):-
	eliminate_null_property(T,NewT).

eliminate_null_property([X:Y|T],[X:Y|NewT]):-
	eliminate_null_property(T,NewT).



% Relation extension

relation_extension(Relation,KB,FinalResult):-
	objects_of_a_class(top,KB,AllObjects),
	filter_objects_with_relation(KB,Relation,AllObjects,Objects),
	eliminate_null_property(Objects,Result),
	expanding_classes_into_objects(Result,FinalResult,KB).

filter_objects_with_relation(_,_,[],[]).

filter_objects_with_relation(KB,Relation,[H|T],[H:Value|NewT]):-
	object_relation_value(H,Relation,KB,Value),
	filter_objects_with_relation(KB,Relation,T,NewT).

expanding_classes_into_objects([],[],_).

expanding_classes_into_objects([X:Y|T],[X:Objects|NewT],KB):-
	there_is_class(Y,KB,yes),
	objects_of_a_class(Y,KB,Objects),
	expanding_classes_into_objects(T,NewT,KB).

expanding_classes_into_objects([X:Y|T],[X:[Y]|NewT],KB):-
	expanding_classes_into_objects(T,NewT,KB).


%Classes of individual

classes_of_individual(Object,KB,Classes):-
	there_is_object(Object,KB,yes),
	class_of_an_object(Object,KB,X),
	class_ancestors(X,KB,Y),
	append([X],Y,Classes).

classes_of_individual(_,_,unknown).


% Properties of individual

properties_of_individual(Object,KB,Properties):-
	object_properties(Object,KB,Properties).


% Relations of individual

relations_of_individual(Object,KB,ExpandedRelations):-
	there_is_object(Object,KB,yes),
	object_relations(Object,KB,Relations),
	expand_classes_to_objects(Relations,ExpandedRelations,KB).

relations_of_individual(_,_,unknown).

expand_classes_to_objects([],[],_).

expand_classes_to_objects([not(X=>Y)|T],[not(X=>Objects)|NewT],KB):-
	there_is_class(Y,KB,yes),
	objects_of_a_class(Y,KB,Objects),
	expand_classes_to_objects(T,NewT,KB).

expand_classes_to_objects([X=>Y|T],[X=>Objects|NewT],KB):-
	there_is_class(Y,KB,yes),
	objects_of_a_class(Y,KB,Objects),
	expand_classes_to_objects(T,NewT,KB).

expand_classes_to_objects([not(X=>Y)|T],[not(X=>[Y])|NewT],KB):-
	expand_classes_to_objects(T,NewT,KB).

expand_classes_to_objects([X=>Y|T],[X=>[Y]|NewT],KB):-
	expand_classes_to_objects(T,NewT,KB).

	
