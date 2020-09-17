diag_mod(detect_face_cognitive(Command), 
	    
	    [	[
	    	 id ==> is,
	    	 type ==> neutral,
	    	 arcs ==>[
	    	 		empty : [sleep] => detect
	    	 ]
	    
	    	],
		% Detect head
		[
		 id ==> detect,
		 type ==> detect_face_cognitive(detect),
		 arcs ==> [		
					faceId(X) : [say(['I detected somebody'])] => identify(X),
					faceId('no detected') : empty => error
			  ]
		 ],
		 %[
	    	 %id ==> wait(X),
	    	 %type ==> neutral,
	    	 %arcs ==>[
	    	 %		empty : [sleep] => identify(X)
	    	 %]
	    
	    	%],
		[
		 id ==> identify(X),
		 type ==> identify_face_cognitive(identify,X),
		 arcs ==> [		
					identified_face(A,B,C,D,E) : [say(['I identified somebody'])] => prueba(A,B,C,D,E),
					status(Status) : [say('Error empty scene')] => success
					%faceId('no detected') : empty => error
			  ]
		 ],
		 [
		 id ==> prueba(A,B,C,D,E),
		 type ==> neutral,
		 arcs ==> [		
					empty: say('It entered') => success
					%identified_face('no detected') : empty => error
			  ]
		 ],
		 [
		 id ==> prueba([]),
		 type ==> neutral,
		 arcs ==> [		
					empty: say('It did not enter') => success
					%identified_face('no detected') : empty => error
			  ]
		 ],
		 %isIdentical, confidence, distanciaX, distanciaY,distanciaZ

		% Final Situations
		[id ==> success, type ==> final],

		[id ==> error, type ==> final]

	    ], 

	% List of Local Variables
	[]

   ). 
