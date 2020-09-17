%--------------------------------------------------
% Initializing the cognitive model
%--------------------------------------------------

initializing_cognitive_model:-
	write('Starting cognitive model'),nl,
	initializing_parser_general.

% Basic structure for the commands related to speech and person 
% recognition
% Cognitive command recieve a question in natural language and produces an answer in natural language
% cognitive_command(Question in natural language, answer in natural language)
% e.g., Question_NL: 'How many people are in the crowd'
%		Answer_NL: 'There are 6 persons in the crowd'
cognitive_command(Question_NL,Answer_NL):-
	write(Question_NL),nl,
	gpsr_command_2015(Question_NL,Question_LF),
	consult_LF(Question_LF, Answer_LF),
	nl_generator(Question_LF, Answer_LF, Answer_NL),
	write(Answer_NL),nl.


% count_property --> count the amount of persons type in the class
% count_property(List of types of persons, Object where to find the properties, Knowledge Base, Amount)
count_property([],_,_,0):-!.
count_property([H|T], Object, KB, Amount):-
	count_property(T, Object, KB, Aux),
	object_property_value(Object, H, KB, Aux_Amount),
	Amount is Aux + Aux_Amount.


% consult_LF --> Consult logical form
% consult_LF(Question in Logical Form, Answer in Logical Form)
% e.g., Question_LF : [count([size],crowd)]
%		Answer_LF: 6
consult_LF([],0):-!.
consult_LF([count(List, Object)|_], Answer_LF):-
	open_kb(KB),
	count_property(List, Object, KB, Answer_LF),!.

consult_LF(_,0):-!.
	
% concat and --> concatenates a sentence with the objects of the list
% concat_and(List of objects, Entrance list, Exit List)
% e.g., List: [men, women]
%		In: ['there', 'are', '6']
%		Out: ['there', 'are', '6', 'men', 'and', 'women']
concat_and([], In, In) :-!.
concat_and([H|[]], In, Out) :- 
	append(In, ['and', H], Out).
concat_and([H|T], In, Out):-
	append(In, [H], Aux),
	concat_and(T, Aux, Out).


% nl_generator --> generates an answer in natural language
% nl_generator(Question in Logical Form, Answer Logical Form, Answer in natural language)
% e.g., Question in LF: count([men, women], crowd)
%		Answer in LF: 6
%		Answer in natural language: ['there', 'are', '6', 'men', 'and', 'women', 'in', 'the', 'crowd']
nl_generator([],_,''):-!.

nl_generator([count([persons], Object)|_], 1, Answer_NL):-
	Aux =  ['there', 'is', 1, 'person', 'in', 'the', Object],
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([count([persons], Object)|_], Answer_LF, Answer_NL):-
	Aux = ['there', 'are', Answer_LF, 'persons', 'in', 'the', Object],
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([count([Type], Object)|_], 1, Answer_NL):-
	Aux =  ['there', 'is', 1, Type, 'in', 'the', Object],
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([count(List, Object)|_], 1, Answer_NL):-
	Aux =  ['there', 'is', 1],
	concat_and(List, Aux, Aux2),
	append(Aux2, ['in', 'the', Object], Aux3),
	atomic_list_concat(Aux3, ' ', Answer_NL).

nl_generator([count([Type], Object)|_], Answer_LF, Answer_NL):-
	Aux =  ['there', 'are', Answer_LF, Type, 'in', 'the', Object],
	atomic_list_concat(Aux, ' ', Answer_NL).

nl_generator([count(List, Object)|_], Answer_LF, Answer_NL):-
	Aux =  ['there', 'are', Answer_LF],
	concat_and(List, Aux, Aux2),
	append(Aux2, ['in', 'the', Object], Aux3),
	atomic_list_concat(Aux3, ' ', Answer_NL).

