diag_mod(identify_face_cognitive(Command), 
	    
	    [	[
	    	 id ==> is,
	    	 type ==> neutral,
	    	 arcs ==>[
	    	 		empty : [sleep] => identify
	    	 ]
	    
	    	],
		% Detect head
		[
		 id ==> identify,
		 type ==> identify_face_cognitive(detect,faceId),
		 arcs ==> [		
					faceId(X) : [say(['I detected somebody',X])] => success,
					faceId('no detected') : empty => error
			  ]
		 ],


		% Final Situations
		[id ==> success, type ==> final],

		[id ==> error, type ==> final]

	    ], 

	% List of Local Variables
	[]

   ). 
