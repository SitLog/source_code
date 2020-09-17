diag_mod(place(LeftLocation, RightLocation, PlacedObjects, DeliverMode, Status),
[
	[
	 id ==> is,
	 type ==> neutral,      
	 arcs ==> [
		   empty : empty => place(get(left_arm,Left),get(right_arm,Right))
		  ]     
	],	
 
        [% all products gotten have been delivered
	 id ==> place(free, free),
	 type ==> neutral,
	 arcs ==> [
		   empty : empty => success
		  ]
	],

        [
	 id ==> place(Object,free),
	 type ==> neutral,
	 arcs ==> [
		   empty : empty => deliver(Object,LeftLocation)
		  ]
	 ],

        [
	 id ==> place(_,Object),
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
					get(placed ,PrevPlaced),
			                append(PrevPlaced,[order(Object,Location)],NewPlaced),
					set(placed, NewPlaced)
			      ] => place(get(left_arm,Left), get(right_arm,Right)),
		    error : empty => error
		   ]
	  ],

	[
		id ==> success,
		type ==> final,
		in_arg ==> [FinalStatus],
		diag_mod ==> place(_, _, get(placed,Placed), _, FinalStatus)
	],
	     
	[
		id ==> error,
		type ==> final,
		in_arg ==> [FinalStatus],
		diag_mod ==> place(_, _, get(placed,Placed), _, FinalStatus)
	]
], % En situation list

% List of Local Variables
[
 placed ==> []
]

). % End Get Task DM
