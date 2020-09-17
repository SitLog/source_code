diag_mod(see_main,
	 [
	     [
		 id ==> is,	
		 type ==> neutral,
		 arcs ==> [
			  empty : [initSpeech,say('Hello I am Golem and I will see something'),
				   length([a,b,c],X),screen(X)] => behavior
		      ]
	     ],
	     
	     [  
      		 id ==> behavior,
      		 type ==> recursive,
      		 %embedded_dm ==> see(person, _, detect_body, Found_Persons, Status),
      		 %embedded_dm ==> see(person, james, memorize_body, Found_Persons, Status),
      		 embedded_dm ==> see(person, james, recognize_body, Found_Persons, Status),
      		 
      		 %embedded_dm ==> see(object, [soup,cereal], object, Found_Objects, Status),
      		 %embedded_dm ==> see(object, X, object, Found_Objects, Status),
      		 %embedded_dm ==> see(object, snack, category, Found_Objects, Status),
      		 %embedded_dm ==> see(person, X, detect, Found_Objects, Status),
      		 %embedded_dm ==> see(person, X, detect_with_approach, Found_Objects, Status),
      		 %embedded_dm ==> see(person, adrian, memorize, Found_Objects, Status),
      		 %embedded_dm ==> see(person, art, memorize_with_approach, Found_Objects, Status),
      		 %embedded_dm ==> see(person, art, recognize, Found_Objects, Status),
      		 %embedded_dm ==> see(person, gilberto, recognize_with_approach, Found_Objects, Status),
      		 %embedded_dm ==> see(gesture, hand_up, 15, Found_Objects, Status),
      		 %embedded_dm ==> see(gesture, X, 15, Found_Objects, Status),
      		 arcs ==> [
        		  success : [say('I found it')] => fs,
        		  error : [say('Is not here')] => fs
						       
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

