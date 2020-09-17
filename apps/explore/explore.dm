diag_mod(explore,
[
	[
		id ==> is,
		type ==> neutral,
		arcs ==> [
				empty : empty => send
		]
	],
	[
		id ==> send,
		type ==> neutral,
		arcs ==> [
				%empty : empty => visit([[0.5,0.0,0.0]])
				%empty : empty => visit([[0.5,0.0,0.0],[0.0,0.5,0.0],[0.0,0.0,0.0]])
				%empty : empty => visit([labb])
				empty : empty => visit([columna, compus1])
		]
	],

	[
		id ==> visit([]),
		type ==> neutral,
		arcs ==> [
			empty : [say('I had finished to visit the points')] => success
		]
	],

	[
		id ==> visit([Pos|Rest]),
		type ==> recursive,
		embedded_dm ==> move(Pos,Status),
		arcs ==> [
			%success : [say('I am exploring a position.')] => inspect(Rest),
			%error : [say('I could not arrive at first position.')] => error
			success : empty => inspect(Rest),
			error : empty => error
		]
	],

	[
		id ==> inspect(Rest),
		type ==> neutral,
		arcs ==> [
			empty : [say('I will inspect here for some text'),take_photo] => visit(Rest)
		]
	],

	% Final Situations
	[
		id ==> success,
		type ==> final
	],

	[
		id ==> error,
		type ==> final
	]

],

% local vars
[
]

).
