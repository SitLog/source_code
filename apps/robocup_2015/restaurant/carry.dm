diag_mod(carry(LeftLocation, RightLocation, CarriedObjects, DeliverMode, Status),
[
	[
	 id ==> is,
	 type ==> neutral,      
	 arcs ==> [
		   empty : empty => carry(get(left_arm,Left),get(right_arm,Right))
		  ]     
	],	
 
        [% all products gotten have been delivered
	 id ==> carry(free, free),
	 type ==> neutral,
	 arcs ==> [
		   empty : empty => success
		  ]
	],

        [
	 id ==> carry(Object,free),
	 type ==> neutral,
	 arcs ==> [
		   empty : empty => deliver(Object,LeftLocation)
		  ]
	 ],

        [
	 id ==> carry(_,Object),
	 type ==> neutral,
	 arcs ==> [
		   empty : empty => deliver(Object,RightLocation)
		  ]
	 ],

         [
	  id ==> deliver(Object,Location),

	  type ==> recursive,

	  out_arg ==> [DeliverStatus],

	  embedded_dm ==> deliver(Object,Location,Location,DeliverMode,DeliverStatus),

	  arcs ==> [
		    success : [
					say(['Here is the ', Object]),
					get(carried ,PrevCarried),
			                append(PrevCarried,[order(Object,Location)],NewCarried),
					set(carried, NewCarried)
			      ] => carry(get(left_arm,Left), get(right_arm,Right)),
		    error : empty => error
		   ]
	  ],

	[
		id ==> success,
		type ==> final,
		in_arg ==> [FinalStatus],
		diag_mod ==> carry(_, _, get(carried,Carried), _, FinalStatus)
	],
	     
	[
		id ==> error,
		type ==> final,
		in_arg ==> [FinalStatus],
		diag_mod ==> carry(_, _, get(carried,Carried), _, FinalStatus)
	]
], % En situation list

% List of Local Variables
[
 carried ==> []
]

). % End Get Task DM
