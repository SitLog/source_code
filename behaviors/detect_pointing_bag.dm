diag_mod(detecting_pointig_bag(Status),
	[

		[
      			id ==> is,	
      			type ==> neutral,
      			out_arg ==> [ok],
      			arcs ==> [
        				empty : empty => success
      				]
    		], 
    		
    		% Final Situations
		[
			id ==> success, 
			type ==> final,
			in_arg ==> [StatusFollow],
			diag_mod ==> detecting_pointig_bag(StatusFollow)
		],

		[
			id ==> error, 
			type ==> final,
			in_arg ==> [StatusFollow],
			diag_mod ==> detecting_pointig_bag(StatusFollow)
		]
	],
		
	[]
).
