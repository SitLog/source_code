:- op(600,xfx,':').
:- op(800,xfx,'=>').
:- op(900,xfx,'==>').

:- consult(change_KB).
:- consult(parser).
:- consult(cognitive_model).

consult_kb :-		

		% load conceptual hierarchy
		load_kb(KB),
		
		% Create kb
		create_env(KB),

		print('Input top class'),nl,
		read(Top_Class),

		query_object(Top_Class),

		reset.

load_kb(KB) :- 	
		% print('Type KB: '),
		% read(File_Name),

		% Load the KB as a lits of terms in KB
		load_file('C:/Users/Arturo/Desktop/Programacion_Logica/Relational_Knowledge_Base/golem_KB.pl', KB).		

query_object(Top_Class) :- 
		print('input objecto a consultar: '),nl,
		read(Object),

		% consult KB top-down from top class 'object'
		class_of(Object, Top_Class, Class_List, Props_List),
		
		print('Class List: '), print(Class_List), nl,
		print('Properties: '), print(Props_List),nl,

		new_query(Top_Class).
		
query_object(Top_Class) :- 
		print('Object is not in KB'),nl,
		new_query(Top_Class).

new_query(Top_Class) :- 
		print('Otra consulta? :'),nl,
		read(Option),
		new_query_option(Option, Top_Class).

new_query_option(no, _). 		
new_query_option(_, Top_Class) :- query_object(Top_Class).
		
reset :- abolish(class/4).




% Format of KB entries:
%	
%	class(Class, Mother_Class, List_of_Class_Properties, List_of_Objects_of_class)
%
% where:
%	Class: atom
%	Mother_Class: atom
%	List_of_Class_Properties: list of attribute value pairs, where the attribute is the property name and the value is ist corresding value
%				  Form: [ prop1 => value1, prop2 => value2,É,propn => valuen]
%	List_of_Objects_of_class: objects of class with their specific properties
%				  Form: [obj1, obj2,É, objn]
%				  where obji is of form: [id => name, props => [ prop1 => value1, prop2 => value2,É,propn => valuen]  ]
%


% Find the set of classes of an object (botton to top) and its list of prop. (from specific to general) using a TOP-DOWN depth-first strategy
% Initial cal: class = top node
class_of(Object, Class, [Class], Prop_List) :-
			member_of_class(Object, Class, _, Prop_List).

class_of(Object, Class, Class_List, Props_List) :-
			% Search the tree depth-firts
			sons_of(Class, Sons_of_Class),
			explore_tree(Object, Class, Sons_of_Class, Classes_Son, Props_Son),
			class(Class, _, Class_Props, _),
			append(Classes_Son, [Class], Class_List),
			append(Props_Son, Class_Props, Props_List).

sons_of(Class, Sons_List) :- setof(Sons, class(Sons, Class, _, _), Sons_List). 

% No more sons in this branch
explore_tree(_, [], _, _) :- fail.

% Expand current son
explore_tree(Object, _, [Current_Son|_], Class_List, Props_List) :-
			class_of(Object, Current_Son, Class_List, Props_List).

% Explore next son
explore_tree(Object, Class, [_|Rest_Sons], Class_List, Props_List) :-
			explore_tree(Object, Class, Rest_Sons, Class_List, Props_List).

% Most specific class of an object with its list of props (from specific to class prop).
member_of_class(Object, Class, Is_a, Prop_List) :- 
			class(Class, Is_a, Class_Props, Instances), 
			check_object(Object, Instances, Object_Props),
			append(Object_Props, Class_Props, Prop_List). 

% Args: Object_ID, Instances, In_Props, Out_Props.
check_object(_, [], []) :- fail.
check_object(Object, [Instance|_], Local_Props) :- 
			get_feature_kb(id, Instance, Object),
			get_feature_kb(props, Instance, Props),
			check_empty_props(Props, Local_Props).
check_object(Object, [_|Rest], Local_Props) :- check_object(Object, Rest, Local_Props).

check_empty_props(not_defined, []).
check_empty_props(Props, Props).

% Find classes and proerties: strategy BOTTOM-UP

class_of_BU(Object, Top, Class_List, Props_List) :-
			member_of_class(Object, Class, Type, Props),
			collect_upwards(Type, Top, [Class], Props, Class_List,  Props_List).

collect_upwards(Top, Top, Class_List, Props_List, Class_List, Props_List).

collect_upwards(Class, Top, In_Classes, In_Props, Class_List, Props_List) :-
			class(Class, Type, Props, _),
			append(In_Classes, [Class], Next_Classes),
			append(In_Props, Props, Next_Props),
			collect_upwards(Type, Top, Next_Classes, Next_Props, Class_List, Props_List).

% Procedure to ask for whether an arbitrary object has an arbitrary property
% If the property is not defined Val = not_defined
property_value(Object, Top_Class, Property, Val) :- 
			class_of(Object, Top_Class, _, Object_Props),
			get_feature_kb(Property, Object_Props, Val).

%Get Feature Value
get_feature_kb(_, [], not_defined).
get_feature_kb(Feature, [Feature => Value|_], Value).
get_feature_kb(Feature, [_|Rest], Value) :- 
			get_feature_kb(Feature, Rest, Value), !.




:- use_module(library(charsio)).

%lee file con file IDs, y crea una lista con todas las clausulas en todos los files IDs.
load_list_of_files(Files_ids, Clause_List) :-
			load_file(Files_ids, Files_List),
			get_clauses_files(Files_List, Clause_List).

get_clauses_files([], _).
get_clauses_files([H|T], Clause_List) :-
			load_file(H, Clauses_File),
			get_clauses_files(T, Rest_Clauses),
			append(Clauses_File, Rest_Clauses, Clause_List).
			

%lee file de clausulas en una lista
	load_file(RULES,CLAUSE_LIST) :-
			seeing(IN),
			see(RULES),
			read_clause([],CLAUSE_LIST),
			seen,
			see(IN),
			!.

	read_clause(INLIST,OUTLIST) :-
			read(TERM),
			next_term(TERM,INLIST,OUTLIST).

	next_term(end_of_file,L,L).
	next_term(TERM,INLIST,OUTLIST) :-
			append(INLIST,[TERM],LIST),
			read_clause(LIST,OUTLIST).


 	update_nl(STR) :- 	build_term(TERM,STR),
				new_fact(TERM).


%creacion de ambiente de evaluacion
create_env([]).
create_env([H|T]) :-
	assert(H),
	create_env(T),
	!.



%compile a string of characters as a prolog term
       build_term(TERM,STR) :-
                        telling(OUT),
                        seeing(IN),
                        name(ATOM,STR),
                        tell('/tmp/gk_junk'),
                        write(ATOM),
                        write('.'),
                        nl,
                        told,
                        see('/tmp/gk_junk'),
                        read(TERM),
                        seen,
                        see(IN),
                        tell(OUT),
                        rename('/tmp/gk_junk',[]),
                        !.


:- use_module(library(random)).

% Random functions 

get_random_element(L,E) :-
    length_list(L,Size),
    random(0,Size,Id),
    idx_object(Id,L,E).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%			Operaciones sobre listas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
append([],L,L).
append([X|L1],L2,[X|L3]) :- append(L1,L2,L3), !.

reverse([],[]).
reverse([H|T],L) :- reverse(T,Z), append(Z,[H],L), !.

member(E, [E|_]).
member(E, [_|T]) :-  member(E, T).

not_member(_,[]).
not_member(E, [H|T]) :- 
		E \== H,
		not_member(E,T).

length_list([],0). 
length_list([_|T],N) :-
		length_list(T,M),
		N is M + 1, !.

empty_list(L) :-
		length_list(L,N),
		N == 0, !.

first([], non).
first([H|_],H).

rest([], []).
rest([_|T], T).

last([], []).
last(LIST,L) :-
		reverse(LIST,R),
		first(R,L), !.

rotate_list([H|T],R) :- append(T,[H],R).

% Stack
push(Element, In_Stack, Out_Stack) :- append([Element], In_Stack, Out_Stack).

pop([], empty).
pop([Element|_], Element). 


% filter_elment(E,L,F) filtra el elemento E de la lista L y regresa la lista F
filter_element(_,[],[]).
filter_element(E,[E|T],LIST) :-
		filter_element(E,T,LIST).

filter_element(E,[H|T],LIST) :-
		filter_element(E,T,R),
		append([H],R,LIST).

% Elimina duplicados en lista
filter_duplicates([], RL, L) :- reverse(RL,L).
filter_duplicates([H|T], A, NL) :-
		not_member(H, A),
		append([H], A, NewA), 
		filter_duplicates(T, NewA, NL),
		!.

filter_duplicates([_|T], A, NL) :-
		filter_duplicates(T, A, NL).

%return indexed object from list		
idx_object(0, [OBJECT|_], OBJECT).
idx_object(IDX, [_|OBJECTS_T], OBJECT) :-
			NEW_IDX is IDX - 1,
			idx_object(NEW_IDX, OBJECTS_T, OBJECT),
			!.

get_options(LC,_,E,Option) :-
		(member(E,LC)) ->
			Option = ok
		| otherwise ->
			Option = no.

% Print list
print_list([]).
print_list([List|T]) :-
		List =.. ['.'|_],
		print('['),nl,
		print_list(List),
		print(']'),nl,
		print_list(T).
		
print_list([H|T]) :-
	    	print(H),nl,
	   	print_list(T).





