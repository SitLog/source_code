diag_mod(inference_main,
[

    [  
      		id ==> move_origin,
      		type ==> recursive,
		embedded_dm ==> move(start,Status),
		  		arcs ==> [
        			success : empty => is,
        			error : say('Restart my navigation system') => is
			]
    ],

    [
      id ==> is,	
      type ==> neutral,
      arcs ==>  [
                empty : [apply(initialize_KB_inference,[]),
                        robotheight(1.30),set(last_height,1.30),tiltv(0.0),set(last_tilt,0.0),
                        say('Hello. My name is Golem and I am an assistant in the supermarket.'),
                        mood(talk),mood(talk),
                        say('I will wait for an instruction')] => diagnostic_decision_and_plan_without_explication
                ]
    ],
    
    [
      id ==> diagnostic_decision_and_plan_without_explication,	
      type ==> neutral,
      arcs ==>  [
                empty : empty => apply(inference_module_without_explication,[])
                ]
    ],
    
    [
      id ==> diagnostic_decision_and_plan_with_explication,	
      type ==> neutral,
      arcs ==>  [
                empty : empty => apply(inference_module,[])
                ]
    ],
   
    %Case 1 If the plan is empty, proceed with taking orders from the assistant or the client
    [
      id ==> solve_plan([],Dialog),	
      type ==> neutral,
      arcs ==>  [
                empty : Dialog => wait_instructions
                ]
    ],
    
    [  
      id ==> wait_instructions,
      type ==> recursive,
      embedded_dm ==> wait_instructions,
      arcs ==> [
      			    success : [apply(ddp_fix_id,[])] => diagnostic_decision_and_plan_without_explication,
      			    error : empty => fs				
      	       ]
    ],
    
    %Case 2 If there are actions in the plan procced to perform it
    [
      id ==> solve_plan(Plan,Dialog),	
      type ==> neutral,
      arcs ==>  [
                empty : Dialog => solve_plan(Plan)
                ]
    ],
    
    [  
      id ==> solve_plan(Plan),
      type ==> recursive,
      embedded_dm ==> solve_plan(Plan),
      arcs ==> [
      			    success : empty => manage_failed_orders,
      			    error : empty => diagnostic_decision_and_plan_with_explication				
      	       ]
    ],
    
    %Management of failed orders
    [  
      id ==> manage_failed_orders,
      type ==> recursive,
      embedded_dm ==> manage_failed_orders,
      arcs ==> [
      			    success : say('Anything else') => wait_instructions,
      			    error : empty => fs				
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

