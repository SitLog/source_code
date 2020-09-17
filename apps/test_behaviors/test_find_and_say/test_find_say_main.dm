

diag_mod(test_find_and_say_main,
[		
		[  
      			id ==> is,
      			type ==> recursive,
      			embedded_dm ==> find_and_say(jose,kitchen,ask_to_leave,Status),
			arcs ==> [
        			success: [say('Perfect I complete my task')] =>fs,
        			error: [say('There was an error')] =>fs
        							
      			]
    		],
    		[
	id ==> fs,
	type ==> final
    ]
		

  ],
  % Second argument: list of local variables
  [
  ]
).


