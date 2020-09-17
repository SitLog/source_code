diag_mod(main,
[
	[
		id ==> is,
		type ==> neutral,
		arcs ==> [
				empty : [initSpeech, say('Hello I am Golem and I will explore some places'), apply(initialize_KB,[])] => behavior
		]
	],

	[
		id ==> behavior,
		type ==> recursive,
		embedded_dm ==> explore,
		arcs ==> [
			success : [say('I have finished exploring, going back home.')] => home,
			error : [say('I could not finish exploring, going back home.')] => home
		]
	],

	[
		id ==> home,
		type ==> recursive,
		embedded_dm ==> move([0.0,0.0,0.0], Status),
		arcs ==> [
			success : [say('I am at home.')] => fs,
			error : [say('I could not arrive home.')] => fs
		]
	],

	[
		id ==> fs,
		type ==> final
	]

],

% local vars
[
]

).
