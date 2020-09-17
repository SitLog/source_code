diag_mod(detecting_pointing_bag(Status),
	[

		[
      			id ==> is,	
      			type ==> neutral,
      			out_arg ==> [ok],
      			arcs ==> [
        				empty : empty => recognize
      				]
    	], 
    	
    	[
      			id ==> recognize,	
      			type ==> recognize_follow,
      			arcs ==> [
        				success : [say('Please put the bag in my hand'),switcharm(1),grasp(0.0,0.5,Result)] => success,
        				error : empty => error 
      				]
    	], 
    	
    	%[
      	%		id ==> see_pointing,	
      	%		type ==> see_pointing_follow,
      	%		arcs ==> [
        %				pointing_coords(X,Y,Z) : [say('Please put the bag in my hand'),switcharm(2),grasp_bag(0.0,0.5,Result)] => success,
        %				pointing_coords(0,0,0) : empty => error 
      	%			]
    	%], 
    		
    		% Final Situations
		[
			id ==> success, 
			type ==> final,
			in_arg ==> [StatusFollow],
			diag_mod ==> detecting_pointing_bag(StatusFollow)
		],

		[
			id ==> error, 
			type ==> final,
			in_arg ==> [StatusFollow],
			diag_mod ==> detecting_pointing_bag(StatusFollow)
		]
	],
		
	[]
).
