diag_mod(solve_plan(Plan),
[

     [
            id ==> is,	
            type ==> neutral,
            arcs ==> [
                    empty : empty => convert_plan_to_dialog_models
                    ]
     ],
     
     [
		    id ==> convert_plan_to_dialog_models,
     		type ==> neutral,
     		arcs ==> [ 
				    empty:empty => dispatch( apply(from_plan_to_dialog_model(P), [Plan]) )
			]
     ],

	 % Dispatcher's base case 
     [
	        id ==> dispatch([]),
    	    type ==> neutral,
    	    arcs ==> [
				  	empty: [ say('I finish my plan'), apply(ddp_remove_orders,[]) ] => success
	        ]
     ],
		
     % Dispatcher's inductive case 
     [
		    id ==> dispatch([Current_Task|Rest_Tasks]),
      		type ==> recursive,
      		embedded_dm ==> Current_Task,
      		arcs ==> [
			        success:empty => dispatch(Rest_Tasks),
                	error:[say('There is something wrong. The situation is not as I expected')] => error
			]
     ],
     
     [
            id ==> success,
            type ==> final
     ],
     
     [
            id ==> error,
            type ==> final
     ]
     
  ],

  % Second argument: list of local variables
  [
  
  ]

).	
