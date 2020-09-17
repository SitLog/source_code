
%Load parser

initializing_parser:-
	write('Starting parser'),nl,
	load_parser_human,
	load_parser_object,
	load_parser_location,
	load_parser_room,
	load_parser_object_category,
	load_grammar_rules.
	
initializing_parser_general:-
	write('Starting general parser'),nl,
	load_parser_human,
	load_parser_object,
	load_parser_location,
	load_parser_room,
	load_parser_object_category,
	load_grammar_rules_general.
	

%Loading humans

load_parser_human:-
	write('Loading humans: '),
	open_kb(KB),
	objects_of_a_class(human,KB,List),
	write(List),nl,
	add_human_items(List),
	!.

add_human_items([]).

add_human_items([H|T]):-
    atomic_list_concat([Word1],' ',H),
	assertz( human([Word1|X]-X,human(H)) ),
	add_human_items(T).
	
add_human_items([H|T]):-
    atomic_list_concat([Word1,Word2],' ',H),
	assertz( human([Word1,Word2|X]-X,human(H)) ),
	add_human_items(T).
	
add_human_items([H|T]):-
    atomic_list_concat([Word1,Word2,Word3],' ',H),
	assertz( human([Word1,Word2,Word3|X]-X,human(H)) ),
	add_human_items(T).


%Loading objects

load_parser_object:-
	write('Loading object: '),
	open_kb(KB),
	objects_of_a_class(object,KB,List),
	write(List),nl,
	add_object_items(List),
	!.

add_object_items([]).

add_object_items([H|T]):-
    atomic_list_concat([Word1],' ',H),
	assertz( object([Word1|X]-X,object(H)) ),
	add_object_items(T).
	
add_object_items([H|T]):-
    atomic_list_concat([Word1,Word2],' ',H),
	assertz( object([Word1,Word2|X]-X,object(H)) ),
	add_object_items(T).
	
add_object_items([H|T]):-
    atomic_list_concat([Word1,Word2,Word3],' ',H),
	assertz( object([Word1,Word2,Word3|X]-X,object(H)) ),
	add_object_items(T).


%Loading locations

load_parser_location:-
	write('Loading location: '),
	open_kb(KB),
	objects_of_a_class(location,KB,List),
	write(List),nl,
	add_location_items(List),
	!.

add_location_items([]).

add_location_items([H|T]):-
    atomic_list_concat([Word1],' ',H),
	assertz( location([Word1|X]-X,location(H)) ),
	add_location_items(T).
	
add_location_items([H|T]):-
    atomic_list_concat([Word1,Word2],' ',H),
	assertz( location([Word1,Word2|X]-X,location(H)) ),
	add_location_items(T).
	
add_location_items([H|T]):-
    atomic_list_concat([Word1,Word2,Word3],' ',H),
	assertz( location([Word1,Word2,Word3|X]-X,location(H)) ),
	add_location_items(T).


%Loading rooms

load_parser_room:-
	write('Loading room: '),
	open_kb(KB),
	objects_of_a_class(room,KB,List),
	write(List),nl,
	add_room_items(List),
	!.

add_room_items([]).

add_room_items([H|T]):-
    atomic_list_concat([Word1],' ',H),
	assertz( room([Word1|X]-X,room(H)) ),
	add_room_items(T).
	
add_room_items([H|T]):-
    atomic_list_concat([Word1,Word2],' ',H),
	assertz( room([Word1,Word2|X]-X,room(H)) ),
	add_room_items(T).
	
add_room_items([H|T]):-
    atomic_list_concat([Word1,Word2,Word3],' ',H),
	assertz( room([Word1,Word2,Word3|X]-X,room(H)) ),
	add_room_items(T).


%Loading object categories

load_parser_object_category:-
	write('Loading object category: '),
	open_kb(KB),
	descendants_of_a_class(object,KB,List),
	write(List),nl,
	add_object_category_items(List),
	!.

add_object_category_items([]).

add_object_category_items([H|T]):-
    atomic_list_concat([Word1],' ',H),
	assertz( object_category([Word1|X]-X,object_category(H)) ),
	add_object_category_items(T).
	
add_object_category_items([H|T]):-
    atomic_list_concat([Word1,Word2],' ',H),
	assertz( object_category([Word1,Word2|X]-X,object_category(H)) ),
	add_object_category_items(T).
	
add_object_category_items([H|T]):-
    atomic_list_concat([Word1,Word2,Word3],' ',H),
	assertz( object_category([Word1,Word2,Word3|X]-X,object_category(H)) ),
	add_object_category_items(T).




%Load rules of grammar

load_grammar_rules:-
	write('Loading all productions from parser KB'),nl,
	open_parser_kb(KB),
	property_extension(rule_descriptor,KB,List),
	add_production_rules(List),
	!.

load_grammar_rules_general:-
	write('Loading all productions from general parser KB'),nl,
	open_parser_kb_general(KB),
	property_extension(rule_descriptor,KB,List),
	add_production_rules(List),
	!.

add_production_rules([]).

add_production_rules([_:H|T]):-
	assertz(H),
	add_production_rules(T).
	

open_parser_kb(KB):-
	getenv('GOLEM_IIMAS_HOME',GOLEM_IIMAS_HOME),
	atomic_concat(GOLEM_IIMAS_HOME,'/rosagents/SitLog/knowledge_base/parser_KB.txt',KBPATH),
	open(KBPATH,read,Stream),
	readclauses(Stream,X),
	close(Stream),
	atom_to_term_conversion(X,KB).

open_parser_kb_general(KB):-
	getenv('GOLEM_IIMAS_HOME',GOLEM_IIMAS_HOME),
	atomic_concat(GOLEM_IIMAS_HOME,'/rosagents/SitLog/knowledge_base/parser_KB_general.txt',KBPATH),
	open(KBPATH,read,Stream),
	readclauses(Stream,X),
	close(Stream),
	atom_to_term_conversion(X,KB).


%Calling parser


from_atom_to_list(Atom,List):-
	atomic_list_concat(List,' ',Atom).

gpsr_command_2015(Atom,Res):-
	atomic_list_concat(List,' ',Atom),
	command(List-[],Res).
