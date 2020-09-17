%%%% Parser %%%%

% This parser receives an intermediate decomposition of the original command into a set of tokens,
% and then convert them into the final logic form for the GPSR dispatcher

get_logic_form(In):-
	parse_to_logic_form(In,Out),
	assign_func_value(Out).		

parse_to_logic_form([],[]).

parse_to_logic_form([H1|T1],[H2|T2]):-
	convert_to_logic_form(H1,H2),
	parse_to_logic_form(T1,T2).

convert_to_logic_form(move(X),move(X)).
convert_to_logic_form(move2(X),move(X)).
convert_to_logic_form(exit,move(exit)).

convert_to_logic_form(find_object(X),find(X)).
convert_to_logic_form(find_person,find(human)).
convert_to_logic_form(find2(X),find(X)).
convert_to_logic_form(detect2(X),find(X)).

convert_to_logic_form(say,say).

convert_to_logic_form(ask_name,memorize).
convert_to_logic_form(memorize,memorize).

convert_to_logic_form(recognize,recognize).

convert_to_logic_form(follow_person,follow).

convert_to_logic_form(point2(X),point(X)).

convert_to_logic_form(grasp(X),take(X)).

convert_to_logic_form(get_item(X),get_item(X)).

convert_to_logic_form(carry_it(X),deliver(X)).
convert_to_logic_form(bring_me,deliver(me)).

convert_to_logic_form(retrieve(X,Y),carry(X,Y)).
convert_to_logic_form(bring2(X,Y),carry(X,Y)).
convert_to_logic_form(getme2(X),carry(X,me)).

convert_to_logic_form(X,X).

	

