diag_mod(main,
[
	[
		id ==> is,
		type ==> neutral,
		arcs ==> [
				empty : [initSpeech, say('Hello I am Golem and I will play marco polo with you'), apply(initialize_KB,[])] => behavior
		]
	],

	[
		id ==> behavior,
		type ==> recursive,
		embedded_dm ==> marcopolo,
		arcs ==> [
			success : [say('I have finished playing marco polo.')] => fs,
			error : [say('Something went wrong.')] => fs
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
