% Competition, Rulebook 2017
%
% Copyright (C) 2017 UNAM (Universidad Nacional Autónoma de México)
% Caleb Rascon (http://calebrascon.info)
% Based on the 2016 work of:
%       Gibran Fuentes-Pineda (http://turing.iimas.unam.mx/~gibranfp)

% THIS DM IS NAMED ask_for_table FOR COMPATBILITY REASONS
% 1.- Head to table
% 2.- Recover if need be

diag_mod(ask_for_table(Status),
[% list of situations

	[% initial situation
		id ==> is,
		type ==> neutral,
		arcs ==> [
			empty : [
				say('Heading to customer now.')
			] => move_to_table
		]
	],

	[% moving to customer table
		id ==> move_to_table,
		type ==> recursive,
		out_arg ==> [MoveStatus],
		embedded_dm ==> move(customer,MoveStatus),
		arcs ==> [
			success : empty => success,
			error : [
				say('I could not reach the table. Recovering.')
			] => move_to_table_recovery
		]
	],

	[% retrying moving to customer table
		id ==> move_to_table_recovery,
		type ==> recursive,
		out_arg ==> [MoveStatus],
		embedded_dm ==> move(customer,MoveStatus),
		arcs ==> [
			success : empty => success,
			error : [
				say('I could not arrive properly to the table.')
			] => error
		]
	],

	% final situations
	[
		id ==> success,
		type ==> final,
		in_arg ==> [FinalStatus],
		diag_mod ==> ask_for_table(ok)
	],

	[
		id ==> error,
		type ==> final,
		in_arg ==> [FinalStatus],
		diag_mod ==>  ask_for_table(FinalStatus)
	]
],

% local variables
[]
).
