
diag_mod(goto_bar_and_detect_drinks(FinalStatus),
[% list of situations

	[% going to the bar (known location)   
		id ==> goto_bar,	
		type ==> recursive,
		embedded_dm ==> move(bar, _),
		arcs ==> [
			 success : [
			 	 tiltv(-30.0),
				 set(last_tilt,-30.0)
				 ] => see_drinks,
			 error   : empty => goto_bar
		         ]
	],
	[% see drinks in the bar 
		id ==> see_drinks,
		type ==> yolo_object_detection(last_tilt,drinks),
		arcs ==> [
			 objects(ObjectList) : 	[
			                        tiltv(0.0),
			                        set(last_tilt,0.0),
	                                        say('I see some drinks'),
	                                        say('Now I will go to the living room')
	                                        ] 
	                                        => save_objects(ObjectList),
			status(Status)       :	[say('I did not see any drinks. The task is finished.')] => error
			
		]
	],
	% save object list
	[
		id ==> save_objects([]),
		type ==> neutral,
		arcs ==> [
			 empty : empty => success	
		         ]
	],
	[
		id ==> save_objects([object(Name,Rq1,Rq2,Rq3,Rq4,Score,X,Y,Z)|More]),
		type ==> neutral,
		arcs ==> [
			 empty: [
				assign(ListaAntes,get(available_drinks,_)),
				append([Name],ListaAntes,ListaDespues),
				set(available_drinks,ListaDespues)
				] 
				=> save_objects(More)	
		         ]
	],
	% final situations
	[
		id ==> success,
		type ==> final,
		diag_mod ==> goto_bar_and_detect_drinks(ok)
	],

	[
		id ==> error,
		type ==> final,
		in_arg ==> [FinalStatus],
		diag_mod ==>  goto_bar_and_detect_drinks(FinalStatus)
	]
],

% local variables
[
	
]
).
